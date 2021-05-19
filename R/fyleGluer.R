
############NEXT: COPY HARD CODE BELOW TO FUNCTION
fyleGluer <- function(temp_folder = "saved_attachment_fyles") {

  list.files(temp_folder)

  # identify broken files into data frame

  # identify the name of what the glued file will be

  # For each broken file

    # put the splits in order

    # Identify how many splits there were

    # for each split (minus 1) get the contents of the attachment

    # write/append the contents of the attachment

    # delete the splits

}



temp_folder = "saved_attachment_fyles"

# Identify broken files.  They start with 'split_' and contain at least 4 '-' and 3 '_'
all_files <- list.files(temp_folder)
broken_files <- data.frame(filename = all_files[startsWith(all_files,"split_") &
                                                  stringr::str_count(all_files,"-") >= 4 &
                                                  stringr::str_count(all_files,"_") >= 3])

broken_files$piece <- strex::str_after_nth(broken_files$filename, "-", 4)
broken_files$piece <- strex::str_after_nth(broken_files$piece, "_", 1)
broken_files$split_number <- as.numeric(strex::str_before_first(broken_files$piece, "_"))

# identify the name of what the glued file will be
broken_files$glued_filename <- strex::str_after_first(broken_files$piece, "_")

split_counts <- dplyr::group_by(broken_files, glued_filename)
split_counts <- dplyr::summarize(split_counts, split_count = max(split_number))

# For each broken file
for (i in 1:nrow(split_counts)) {
  temp_list = list()

  # put the splits in order
  for (j in 1:split_counts$split_count[i]) {
    split_data <- readr::read_file_raw(paste0(temp_folder, "/",
                                              broken_files$filename[broken_files$glued_filename == split_counts$glued_filename[i] &
                                                                      broken_files$split_number == j ]))
    readr::write_file(split_data, paste0(temp_folder, "/", split_counts$glued_filename[i]), append = TRUE)
  }

  #readr::write_file(paste0(temp_list, collapse = ""), paste0(temp_folder, "/", split_counts$glued_filename[i]), append = TRUE)

  # Identify how many splits there were

  # for each split (minus 1) get the contents of the attachment

  # write/append the contents of the attachment

  # delete the splits

}

