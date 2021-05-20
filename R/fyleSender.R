#' Send Email with Attachments via Outlook
#'
#' Uses RDCOMClient package.
#' @param email_to Email address to send the files to
#' @param email_attachments character vector of location of attachments to send. *fyleIdentifier()* provides suitable input.
#' @param email_subject Optional email subject. Should have something unique about it so you can search through it later using fyleAttachmentGrabber()'s *subject_keyword* argument.
#' @param email_body Optional email body
#' @param email_cc Optional email cc
#' @param email_bcc Optional email bcc
#' @keywords email, attachments, outlook
#' @export

fyleSender <- function(email_to,
                       email_attachments = NULL,
                       email_subject = "subject here",
                       email_body = "body here",
                       email_cc = "",
                       email_bcc = "") {

  # From http://www.seancarney.ca/2020/10/07/sending-email-from-outlook-in-r/

  library (RDCOMClient)

  # Open Outlook
  Outlook <- COMCreate("Outlook.Application")

  # Create a new message
  Email = Outlook$CreateItem(0)

  # Set the recipient, subject, and body
  Email[["to"]] = email_to # recipient2@test.com; recipient3@test.com"
  Email[["cc"]] = email_cc
  Email[["bcc"]] = email_bcc
  Email[["subject"]] = email_subject
  Email[["body"]] = email_body

  for (attch in email_attachments) {
    Email[["attachments"]]$Add(attch)
  }

  # Email[["attachments"]]$Add("C:\\Users\\hahla\\Desktop\\github\\fysan\\R\\fyleSender.R")
  # Email[["attachments"]]$Add("C:\\Users\\hahla\\Desktop\\github\\fysan\\README.md")

  # Send the message
  Email$Send()

  # Close Outlook, clear the message
  rm(Outlook, Email)

}
