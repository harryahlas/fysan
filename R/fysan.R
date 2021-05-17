#' Batch Send Filetypes via Outlook Email
#'
#' Uses RDCOMClient package.  Will send email from default Outlook email address.
#' @param batch How many attachments per email. Defaults to 3.
#' @param interval How many seconds to wait between each email send. Defaults to 1.  Can be handy to keep from overloading.
#' @param fyle_location Location of directory to search. Will default to search recursively. Required.
#' @param fyle_extension The extension(s) you want to search for, e.g. *c("txt", "R")* will send files that end in .txt or .R
#' @param fyle_exclusions Files with this string anywhere in the file name or location will not be sent.  Optional.
#' @param list_recursive Set to FALSE if you do not want to search through children of *fyle_location*. Generally keep TRUE.
#' @param list_full_names List the full names of the location. Generally keep TRUE
#' @param email_to Email address to send the files to
#' @param email_subject Optional email subject
#' @param email_body Optional email body
#' @param email_cc Optional email cc
#' @param email_bcc Optional email bcc
#' @param max_bytes Maximum byte size. Emails with attachments exceeding this size will have the attachments split up. Those files will need to be glued together by TBD function.
#' @keywords email, attachments, outlook
#' @export
#' @examples
#' fysan(batch = 3,
#'          email_to = "noone@nowhere.com",
#'          fyle_location = getwd(),
#'          fyle_extension = c("R", "md"))

fysan <- function(batch = 3,
                  interval = 1, # seconds delay
                  fyle_location = ".",
                  fyle_extension = NULL,
                  fyle_exclusions = NULL,
                  list_recursive = TRUE,
                  list_full_names = TRUE,
                  email_to,
                  email_subject = "fysan subject",
                  email_body = "fysan send",
                  email_cc = "",
                  email_bcc = "",
                  max_bytes = 5e+7) {

  # Import log or create if it doesn't exist
  if (file.exists("fysanlog.csv"))  {
    files_sent_log <- readr::read_csv("fysanlog.csv")
  } else {
    writeLines("file,send_date", "fysanlog.csv")
    files_sent_log <- data.frame(file = as.character(NULL), send_date = NULL)
  }

  # Identify files and file sizes
  files_to_send <- data.frame(file = as.character(), size = as.numeric(), uuid = as.character())
  for (extension in fyle_extension) { # append for each extension
    files_to_send <- dplyr::bind_rows(files_to_send,
                               fyleIdentifier(fyle_location = fyle_location,
                                              fyle_extension = extension,
                                              fyle_exclusions = fyle_exclusions))
  }

  # If no files found, then end
  if(nrow(files_to_send) == 0) {warning("No matching files found"); return()}

  # Add send date
  files_to_send$send_date <- Sys.Date()

  # Remove files that were already sent
  files_to_send <<- dplyr::anti_join(files_to_send, files_sent_log, by = "file")

  # If there are no files left to send then end
  if(nrow(files_to_send) == 0) {warning("No Files Left to Send");return()}

  # Identify files that are greater than max_bytes.  These will get split later
  files_to_split <- files_to_send[files_to_send$size > max_bytes,]

  # Remove large files that are greater than max_bytes from files_to_send
  files_to_send <- dplyr::anti_join(files_to_send, files_to_split)


  # split files not exceeding limit into batches
  number_of_batches <- ceiling(nrow(files_to_send) / batch)
  batches <- split(files_to_send, factor(sort(rank(row.names(files_to_send))%%number_of_batches)))

  # loop through batches
  for (df in batches) {
    print(paste("Emailing batch", names(df), "of", length(batches)))
    print(df$file)
    fyleSender(
      email_to = email_to,
      email_attachments = as.character(df$file),
      email_subject = email_subject,
      email_body = c(email_body, df$uuid),
      email_cc = email_cc,
      email_bcc = email_bcc
      )
    Sys.sleep(interval)
  }

  # Now that files smaller than max_bytes have been sent, start working on larger files.

  #### IF THERE are files larger than max_bytes then split them and email the pieces individuallyTHEN DO THE BATCHES BASED ON BATCH AND FILE SIZE.

  # determine if there are any larger files
  if (nrow(files_to_split) > 0) {
    print("working on files exceeding max_bytes")

    ######## CREATE SPECIAL SPLITTER FOLDER
    dir.create("split_file_temp")

    for (i in (1:nrow(files_to_split))){
      # determine number of splits needed
      number_of_splits <- ceiling(files_to_split$size[i] / max_bytes)

      # split files and write them to temp folder
      fyleSplitter(file_to_split = file_to_split$file[i],
                   file_size = file_to_split$size[i],
                   uuid = file_to_split$uuid[i],
                   split_number = number_of_splits,
                   max_bytes = max_bytes,
                   temp_folder = "split_file_temp")
    }

    # get list of files in temp folder !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

    # email all split files !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

    # update fysanlog.csv with split files full name !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

  }


  #### FOR EACH FILE GREATER THAN MAX_FILE_SIZE:

  #### CREATE NEW FUNCTION FOR RECEIVING EMAIL TO COMBINE THE FILES BACK.

  ######## DELETE SPECIAL SPLITTER FOLDER

  # update log
  write.table(files_to_send, "fysanlog.csv", sep = ",", col.names = !file.exists("fysanlog.csv"), append = T, row.names = FALSE)

  return(batches)
}
