# fysan: Batch send filetypes via Outlook email <img src="inst/figures/imgfile.png" align="right" height = 150/>

**Author:** [Harry Ahlas](http://harry.ahlas.com)

**License:** [MIT](https://opensource.org/licenses/MIT)

This R package should be handy for anyone who needs to email a large number of files via Outlook.  For example, if you need to send 500 images from one computer to another but cannot use a flash drive, ftp, etc. due to some sort of archaic restriction, *fysan* may save you some time.


## Installation

```r
devtools::install_github("harryahlas/fysan")
```

### RDCOMClient
The *RDCOMClient* package is also required.  *RDCOMClient* may not be available on CRAN for your version of R. You can install it from [https://github.com/dkyleward/RDCOMClient](https://github.com/dkyleward/RDCOMClient) as noted here: [https://github.com/omegahat/RDCOMClient/issues/19](https://github.com/omegahat/RDCOMClient/issues/19).

We are assuming your machine already has a COM email client, such as Outlook, already set up.

## Functions

- [x] *fyleIdentifier()* - list files in a directory of a certain type
- [x] *fyleSender()* - email files with multiple attachments
- [x] *fysan()* - email files in batches with patient iterations and create log

## Example

First, for this example, let's build an example directory with some dummy files that we can toy with. We'll delete the folders and files later.  

The folder names and file names are based on 10 random colors.  The files all end either *.txt*, *.jpg*, or *.R*.  

```r
test_directory <- "fysan_tests"
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
```

For our example, let's say we want to email all the *.txt* and *.R* files from these folders, unless they have the word 'red' in them. 

``` r
library(fysan)

fysan(batch = 3,                       # How many attachments to send per email
      interval = 2,                    # How many seconds to wait after sending each email
      email_to = "email@address.com",  # Email to send to
      email_subject = "Test",          # Email subject
      email_body = "This is a test",   # Email body
      email_cc = "",                   # cc
      email_bcc = "",                  # bcc
      fyle_location = test_directory,  # Directory to search 
      fyle_extension = c("txt", "R"),  # What file extensions to search for
      fyle_exclusions = "red")         # Exclude this text if it appears anywhere in the filename

```

Remove example directory.

``` r
unlink(test_directory, recursive = TRUE, force = TRUE)
```
