
# Test 1 ------------------------------------------------------------------

library(fysan)
test_directory <- "C:\\Users\\hahla\\Desktop\\Toss\\fysan_tests\\" #needs to be full location
dir.create(test_directory)
dir.create(paste0(test_directory, "/test_directory_1"))
dir.create(paste0(test_directory, "/test_directory_2"))
writeLines("hello 0", paste0(test_directory, "hi0.txt"))
writeLines("don't send this file", paste0(test_directory, "/DontSendThis.R"))
writeLines("hello 1", paste0(test_directory, "/test_directory_1/hi1.txt"))
writeLines("hello 2", paste0(test_directory, "/test_directory_1/hi2.txt"))

fyleSender("hahlas@hotmail.com",
           fyleIdentifier(fyle_location = test_directory, fyle_extension = "txt", fyle_exclusions = "hi0")$file,
           "test email 01", "here is the body")


# Remove directories
unlink(test_directory, recursive = TRUE, force = TRUE)


# Test 2 ------------------------------------------------------------------


test_directory <- "C:/Users/hahla/Desktop/Toss/fysan_tests"
dir.create(test_directory)

sampleDirectoryBuilder <- function(new_directory_tag) {#print(new_directory_tag)}
  new_directory_name = paste0(test_directory, "/test_directory_", new_directory_tag)
  dir.create(new_directory_name)
  writeLines(paste("Sample text", new_directory_tag), paste0(new_directory_name, "/text_file_", new_directory_tag, ".txt"))
  writeLines(paste("Sample script", new_directory_tag), paste0(new_directory_name, "/script_file_", new_directory_tag, ".R"))
  writeLines(paste("ksfjew989j", new_directory_tag), paste0(new_directory_name, "/image_", new_directory_tag, ".jpg"))
  dir.create(paste0(new_directory_name, "/logs"))
  writeLines(paste("Log for ", new_directory_tag), paste0(new_directory_name, "/logs/logs_", new_directory_tag, ".txt"))
}

# Directory names
set.seed(123)
sample_directory_list <- sample(colors(), 10)

# Build directories
lapply(sample_directory_list, sampleDirectoryBuilder)

# Mail files
fyleSender("hahlas@hotmail.com",
           fyleIdentifier(fyle_location = test_directory, fyle_extension = "jpg", fyle_exclusions = "red")$file,
           "test email 02", "here is the body")



# Test 3 ------------------------------------------------------------------

# delete log
unlink("fysanlog.csv")

fysan(batch = 3,
      interval = 2, #seconds
      email_to = "hahlas@hotmail.com",
      email_subject = "test email 03",
      email_body = "more tests",
      email_cc = "",
      email_bcc = "",
      fyle_location = "C:\\Users\\hahla\\Desktop\\Toss\\fysan_tests",
      fyle_extension = c("R", "md"),
      fyle_exclusions = "red")


# Remove directories
unlink(test_directory, recursive = TRUE, force = TRUE)



# Test 4 - multiple extensions --------------------------------------------

fyleIdentifier(fyle_extension = c("md", "R"))
fyleIdentifier(fyle_extension = c("md", "sldkfjsld", "R"))


# Test 5 ------------------------------------------------------------------
# Send split attachments

unlink("fysanlog.csv")

fysan(batch = 4,
      interval = 2, #seconds
      email_to = "hahlas@hotmail.com",
      email_subject = "test email 05",
      email_body = "",
      email_cc = "",
      email_bcc = "",
      fyle_location = "C:\\Users\\hahla\\Desktop\\github\\fysan\\R", #"C:\\Users\\hahla\\Desktop\\Toss\\fysan_tests",
      fyle_extension = c("R", "md"),
      fyle_exclusions = "red",
      max_bytes = 3000)


# Test 6 fyleAttachmentGrabber() ------------------------------------------
# Retrieve and glue split attachments

fyleAttachmentGrabber("test email 05")
fyleGluer()

unlink("fysanlog.csv")

