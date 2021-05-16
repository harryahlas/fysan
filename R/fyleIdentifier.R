#' Find Files in a Directory
#'
#' Enhanced version of *list.files()* that allows you to exclude files containing specific strings.
#' @param fyle_location Location of directory to search. Will default to search recursively. Required.
#' @param fyle_extension The extension(s) you want to search for, e.g. *c("txt", "R")* will send files that end in .txt or .R
#' @param fyle_exclusions Files with this string anywhere in the file name or location will not be sent.  Optional.
#' @param list_recursive Set to FALSE if you do not want to search through children of *fyle_location*. Generally keep TRUE.
#' @param list_full_names List the full names of the location. Generally keep TRUE
#' @keywords filesearch, find, files, extension
#' @export

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

  # To data frame
  files <- data.frame(file = files)

  # Get file sizes
  files$size <- file.info(files$file)[['size']]

  return(files)
}

