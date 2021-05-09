
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


