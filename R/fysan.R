fysan <- function(batch = 3,
                  interval = 15, #seconds
                  fyle_location = ".",
                  fyle_extension = NULL,
                  fyle_exclusions = NULL,
                  list_recursive = TRUE,
                  list_full_names = TRUE,
                  email_to,
                  #email_attachments = NULL,
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
  files_to_send <- fyleIdentifier(fyle_location = fyle_location,
                                  fyle_extension = fyle_extension,
                                  fyle_exclusions = fyle_exclusions)

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


  return(batches) #files_to_send)
}
