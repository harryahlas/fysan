# This function saves all attachments from emails containing specific text in the subject

# https://stackoverflow.com/questions/45577698/download-attachment-from-an-outlook-email-using-r
# https://stackoverflow.com/questions/45577698/download-attachment-from-an-outlook-email-using-r

fyleAttachmentGrabber <- function(subject_keyword,
                                  max_recent_emails = 1000,
                                  attachment_folder = "saved_attachment_fyles") {

  # # Parameters for function
  # subject_keyword <- "test 12 split" # Keyword in subject to search for
  # max_recent_emails <- 2000 # The number of emails in inbox to search through, starting with most recent
  # attachment_folder <- "saved_attachments"

  # Create attachment folder if it does not exist
  dir.create(attachment_folder)

  # Set up RDCOMClient with email
  library(RDCOMClient)
  outlook_app <- COMCreate("Outlook.Application", existing = FALSE)
  outlookNameSpace <- outlook_app$GetNameSpace("MAPI")
  folder <- outlookNameSpace$GetDefaultFolder(6)
  emails <- folder$Items

  # Get count of emails in inbox
  email_count <- emails()$Count()

  # Create an empty list to populate with email subjects
  email_list <- data.frame()

  # Populate list of email subjects. Read through first 'max_recent_emails' or total number of emails in inbox, whichever is less
  for (i in (1:min(max_recent_emails, email_count))) {
    temp_email_list <- data.frame(subject = emails(i)[['Subject']])
    email_list <- dplyr::bind_rows(email_list,temp_email_list)
  }

  # Identify emails containing the subject_keyword
  email_list <- tibble::rownames_to_column(email_list,var = "email_number")
  email_list <- dplyr::filter(email_list, stringr::str_detect(subject, subject_keyword))
  email_list$email_number <- as.numeric(email_list$email_number)

  # For each email, count the number of attachments. For each attachment, save it to 'attachment_folder'

  for (i in email_list$email_number) {
    attachment_count <- emails(i)[['Attachments']]$Count()
    # if there are no attachments then go to next email
    if(attachment_count == 0) {next}

    for (j in (1:attachment_count)) {
      attachment_name <- emails(i)$Attachments(j)$FileName()
      attachment_file <- tempfile()
      emails(i)$Attachments(j)$SaveAsFile(attachment_file)
      file.copy(attachment_file, paste0(attachment_folder, "/", attachment_name))
    }
  }
}

