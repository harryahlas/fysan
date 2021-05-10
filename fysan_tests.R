
# Test 1 ------------------------------------------------------------------


test_directory <- "C:\\Users\\hahla\\Desktop\\Toss\\fysan_tests\\"
dir.create(test_directory)
dir.create(paste0(test_directory, "/test_directory_1"))
dir.create(paste0(test_directory, "/test_directory_2"))
writeLines("hello 0", paste0(test_directory, "hi0.txt"))
writeLines("don't send this file", paste0(test_directory, "/DontSendThis.R"))
writeLines("hello 1", paste0(test_directory, "test_directory_1/hi1.txt"))
writeLines("hello 2", paste0(test_directory, "test_directory_1/hi2.txt"))

fyleSender("hahlas@hotmail.com",
           fyleIdentifier(fyle_location = test_directory, fyle_extension = "txt", fyle_exclusions = "hi0"),
           "test emailxxx", "here is the body")

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
sample_directory_list <- sample(colors(), 10)

# Build directories
lapply(sample_directory_list, sampleDirectoryBuilder)

# Mail files
fyleSender("hahlas@hotmail.com",
           fyleIdentifier(fyle_location = test_directory, fyle_extension = "jpg", fyle_exclusions = "red"),
           "test emailxxx", "here is the body")



# Test 3 ------------------------------------------------------------------

### delete log
unlink("fysanlog.csv")

fysan(batch = 3,
      interval = 2, #seconds
      email_to = "hahlas@hotmail.com",
      email_subject = "try5",
      email_body = "mert mert",
      email_cc = "",
      email_bcc = "",
      fyle_location = getwd(), #"C:\\Users\\hahla\\Desktop\\Toss\\fysan_tests",
      fyle_extension = c("R", "md"),
      fyle_exclusions = "red")


# Remove directories
unlink(test_directory, recursive = TRUE, force = TRUE)



# Test 4 - multiple extensions --------------------------------------------

zz <- list()
zz <- c(zz, fyleIdentifier(fyle_extension = "md"))
zz <- c(zz, fyleIdentifier(fyle_extension = "R"))
zzz <-  data.frame(file = zz,
                   send_date = Sys.Date())
fyleIdentifier(fyle_extension = c("md", "R"))
fyleIdentifier(fyle_extension = c("md", "sldkfjsld", "R"))
