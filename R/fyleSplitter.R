# file_to_split <- "C:\\Users\\hahla\\Desktop\\github\\fysan\\R\\fysan.R"
# file_size <- file.info(file_to_split)[['size']]
# max_bytes <- 1000
# split_number <- ceiling(file_size / max_bytes)

fyleSplitter <- function(file_to_split, file_size, uuid, split_number, max_bytes, temp_folder = "split_file_temp") {

  file_to_split_import <- readr::read_file_raw(file_to_split)


  # Starting point
  start_cursor <- 1

  for (file_split in (1:split_number)) {
    print(file_split)

    end_cursor <- start_cursor + max_bytes - 1
    split_temp <- file_to_split_import[start_cursor:end_cursor]

    readr::write_file(split_temp, paste0(temp_folder, "/split_", uuid, "_", file_split, "_", basename(file_to_split)))

    start_cursor <- start_cursor + max_bytes

  }

}

# fyleSplitter(file_to_split, file_size, uuid = "ttt", split_number, max_bytes,)
#
# tools::file_path_sans_ext(file_to_split)
# ## [1] "ABCD"
#
# x1 <- readr::read_file_raw("split_file_temp\\split_1_ttt_fysan.R")
# x2 <- readr::read_file_raw("split_file_temp\\split_2_ttt_fysan.R")
# x3 <- readr::read_file_raw("split_file_temp\\split_3_ttt_fysan.R")
# x4 <- readr::read_file_raw("split_file_temp\\split_4_ttt_fysan.R")
# x5 <- readr::read_file_raw("split_file_temp\\split_5_ttt_fysan.R")
# x6 <- readr::read_file_raw("split_file_temp\\split_6_ttt_fysan.R")
#
# readr::write_file(c(x1,x2,x3,x4,x5,x6), "split_file_temp/j.R")
