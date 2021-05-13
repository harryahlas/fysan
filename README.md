# fysan: Batch send filetypes via Outlook email <img src="inst/figures/imgfile.png" align="right" height = 150/>

**Author:** [Harry Ahlas](http://harry.ahlas.com)

**License:** [MIT](https://opensource.org/licenses/MIT)

This R package should be handy for anyone who needs to email a large number of files via Outlook.  For example, if you need to send 500 images from one computer to another but cannot use a flash drive, ftp, etc. due to some sort of archaic restriction, *fysan* may save you some time.


## Installation

```r
devtools::install_github("harryahlas/fysan")
```

### RDCOMClient
*fysan* requires the *RDCOMClient* package, which may not be available on CRAN for your version of R. You can install it from [https://github.com/dkyleward/RDCOMClient](https://github.com/dkyleward/RDCOMClient) as noted here: [https://github.com/omegahat/RDCOMClient/issues/19](https://github.com/omegahat/RDCOMClient/issues/19).

We are assuming your machine has a COM email client, such as Outlook, already set up.

## Functions

- *fyleIdentifier()* - list files in a directory that contain specific extensions
- *fyleSender()* - email files with multiple attachments in batches
- *fysan()* 
  - runs *fyleIdentifier()* to identify files for sending. 
  - compares list to files previously sent to make sure files are not sent more than once.  This may occur if you do this over long periods of time.
  - runs *fyleSender()* in batches

## Example

First, for this example, let's build an example directory called 'fysan_tests' with some dummy files that we can toy with. We'll delete the folders and files later.  

The folder names and file names are based on 10 random colors.  The files all end either *.txt*, *.jpg*, or *.R*.  

```r
example_directory <- "fysan_tests" # Be sure this directory does not already exist!
dir.create(example_directory)
example_directory <- paste(getwd(), example_directory, sep = "/")

sampleDirectoryBuilder <- function(new_directory_tag) {#print(new_directory_tag)}
  new_directory_name = paste0(example_directory, "/example_directory_", new_directory_tag)
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

For our example, let's say we want to email all the *.txt* and *.R* files from these folders, unless they have the word 'gray' in them. This code should do the trick.

``` r
library(fysan)

fysan(batch = 3,                         # How many attachments to send per email
      interval = 2,                      # How many seconds to wait after sending each email
      email_to = "email@address.com",    # Email to send to
      email_subject = "Test",            # Email subject
      email_body = "This is a test",     # Email body
      email_cc = "",                     # cc
      email_bcc = "",                    # bcc
      fyle_location = example_directory, # Directory to search 
      fyle_extension = c("txt", "R"),    # What file extensions to search for
      fyle_exclusions = "gray")          # Exclude this text if it appears anywhere in the filename

```

Please note that there is also *fysanlog.csv* file saved to your working directory (not the example directory) which tracks the files you have sent. The files listed in *fysanlog.csv* will not get sent as long as you run <code>fysan()</code> from that directory.

After the exercise is complete, remove the example directory using the code below. 

``` r
unlink(example_directory, recursive = TRUE, force = TRUE)
```

Link to my blog containing some additional information:
[http://harry.ahlas.com/post/2021-05-13-email-attachments-in-batches-using-r-fysan/](http://harry.ahlas.com/post/2021-05-13-email-attachments-in-batches-using-r-fysan/)
