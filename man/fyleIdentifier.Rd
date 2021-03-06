% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/fyleIdentifier - orig.R, R/fyleIdentifier.R
\name{fyleIdentifier}
\alias{fyleIdentifier}
\title{Find Files in a Directory}
\usage{
fyleIdentifier(
  fyle_location = ".",
  fyle_extension = NULL,
  fyle_exclusions = NULL,
  list_recursive = TRUE,
  list_full_names = TRUE
)

fyleIdentifier(
  fyle_location = ".",
  fyle_extension = NULL,
  fyle_exclusions = NULL,
  list_recursive = TRUE,
  list_full_names = TRUE
)
}
\arguments{
\item{fyle_location}{Location of directory to search. Will default to search recursively. Required.}

\item{fyle_extension}{The extension(s) you want to search for, e.g. \emph{c("txt", "R")} will send files that end in .txt or .R}

\item{fyle_exclusions}{Files with this string anywhere in the file name or location will not be sent.  Optional.}

\item{list_recursive}{Set to FALSE if you do not want to search through children of \emph{fyle_location}. Generally keep TRUE.}

\item{list_full_names}{List the full names of the location. Generally keep TRUE}
}
\description{
Enhanced version of \emph{list.files()} that allows you to exclude files containing specific strings.

Enhanced version of \emph{list.files()} that allows you to exclude files containing specific strings.
}
\keyword{extension}
\keyword{files,}
\keyword{filesearch,}
\keyword{find,}
