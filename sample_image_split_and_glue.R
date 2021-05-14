library(tidyverse)

max_size <- 1000000
image_location <- "D:/Pictures/pictures_2020_and_earlier/DSCN2955.JPG"
image_size <- file.info(image_location)[['size']]

image_import <- read_file_raw(image_location)

i1 <- image_import[1:1000000]
i2 <- image_import[1000001:2000000]
i3 <- image_import[2000001:3000000]
i4 <- image_import[3000001:3143402]

write_file(i1, "i1.jpg")
write_file(i2, "i2.jpg")
write_file(i3, "i3.jpg")
write_file(i4, "i4.jpg")

j1 <- read_file_raw("i1.jpg")
j2 <- read_file_raw("i2.jpg")
j3 <- read_file_raw("i3.jpg")
j4 <- read_file_raw("i4.jpg")

image_output <- c(j1,j2,j3,j4)
write_file(image_output, "j.jpg")
