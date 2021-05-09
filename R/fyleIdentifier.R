
fyleIdentifier <- function(fyle_location = ".",
                           fyle_extension = NULL,
                           fyle_exclusions = NULL,
                           list_recursive = TRUE,
                           list_full_names = TRUE) {

  # Create regex expression for extension
  fyle_extension_regex <- paste0("\\.", fyle_extension, "$")

  # Find files
  files <- list.files(path = fyle_location,
                      pattern = fyle_extension_regex,
                      recursive = list_recursive,
                      full.names = list_full_names)

  # Exclude files that contain exclusions, if applicable
  for (exclusion in fyle_exclusions) {
    files <- files[!stringr::str_detect(files, exclusion)]
  }

  return(files)
}

