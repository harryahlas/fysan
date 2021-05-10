#' Batch Send Filetypes via Outlook Email
#'
#' Uses RDCOMClient package.  Will send email from default Outlook email address.
#' @param batch How many attachments per email. Defaults to 3.
#' @param interval How many seconds to wait between each email send. Defaults to 1.  Can be handy to keep from overloading.
#' @param fyle_location Location of directory to search. Will default to search recursively. Required.
#' @param fyle_extension The extension(s) you want to search for, e.g. <code>c("txt", "R")</code> will send files that end in .txt or .R
#' @param fyle_exclusions Files with this string anywhere in the file name or location will not be sent.  Optional.
#' @param list_recursive Set to FALSE if you do not want to search through children of *fyle_location*. Generally keep TRUE.
#' @param list_full_names List the full names of the location. Generally keep TRUE
#' @param email_to Email address to send the files to
#' @param email_subject Optional email subject
#' @param email_body Optional email body
#' @param email_cc Optional email cc
#' @param email_bcc Optional email bcc
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
                  email_subject = "subject",
                  email_body = "body",
                  email_cc = "",
                  email_bcc = "") {


  # Import log or create if it doesn't exist
  if (file.exists("fysanlog.csv"))  {
    files_sent_log <- readr::read_csv("fysanlog.csv")
  } else {
    writeLines("file,send_date", "fysanlog.csv")
    files_sent_log <- data.frame(file = as.character(NULL), send_date = NULL)
  }

  # Identify files
  files_to_send <- as.character()
  for (extension in fyle_extension) { # append for each extension
    files_to_send <- c(files_to_send,
                       fyleIdentifier(fyle_location = fyle_location,
                                      fyle_extension = extension,
                                      fyle_exclusions = fyle_exclusions)
    )
  }

  # If no files found, then end
  if(length(files_to_send) == 0) {warning("No matching files found"); return()}

  # Create data frame
  files_to_send <- data.frame(file = files_to_send,
                              send_date = Sys.Date())

  # Remove files that were already sent
  files_to_send <- dplyr::anti_join(files_to_send, files_sent_log, by = "file")

  # If there are no files left to send then end
  if(nrow(files_to_send) == 0) {warning("No Files Left to Send");return()}

  # split into batches
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
      email_body = email_body,
      email_cc = email_cc,
      email_bcc = email_bcc
      )
    Sys.sleep(interval)
  }

  # update log
  write.table(files_to_send, "fysanlog.csv", sep = ",", col.names = !file.exists("fysanlog.csv"), append = T, row.names = FALSE)

  return(batches)
}
