#' Glue Together Email Attachments Split by fyleSplitter()
#'
#' This function reconstructs emails that have been split by fyleSplitter() and deletes the individual splits.
#' @param attachment_folder Optional name of folder to save attachments to.  This folder will be created in your current directory.  Specifying a directory with a full path may work but is untested.
#' @keywords email, attachment
#' @export

fyleGluer <- function(attachment_folder = "saved_attachment_fyles") {

  list.files(attachment_folder)

  # Identify broken files.  They start with 'split_' and contain at least 4 '-' and 3 '_'
  all_files <- list.files(attachment_folder)
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

    # Reac each split of each broken file, then write/append to the broken file's original name
    for (j in 1:split_counts$split_count[i]) {
      split_file_location <- paste0(attachment_folder, "/",
                                broken_files$filename[broken_files$glued_filename == split_counts$glued_filename[i] &
                                                        broken_files$split_number == j ])
      split_data <- readr::read_file_raw(split_file_location)
      readr::write_file(split_data, paste0(attachment_folder, "/", split_counts$glued_filename[i]), append = TRUE)

      # delete the split
      unlink(split_file_location)
    }
  }
}




