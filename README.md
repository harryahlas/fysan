# fysan: Batch send filetypes via Outlook email <img src="inst/figures/imgfile.png" align="right" height = 150/>

**Author:** [Harry Ahlas](http://harry.ahlas.com)

**License:** [MIT](https://opensource.org/licenses/MIT)

This package should be handy for anyone who needs to email a large number of files via Outlook.  For example, if you need to send 500 images from one computer to another but cannot use a flash drive, ftp, etc. due to some sort of archaic restriction, *fysan* may save you some time.


## Installation

### fysan
```r
devtools::install_github("harryahlas/fysan")
```

### RDCOMClient
The *RDCOMClient* package is also required.  *RDCOMClient* may not be available on CRAN for your version of R. You can install it from [https://github.com/dkyleward/RDCOMClient](https://github.com/dkyleward/RDCOMClient) as noted here: [https://github.com/omegahat/RDCOMClient/issues/19](https://github.com/omegahat/RDCOMClient/issues/19).

## Functions

- [x] *fyleIdentifier()* - list files in a directory of a certain type
- [x] *fyleSender()* - email files with multiple attachments
- [x] *fysan()* - email files in batches with patient iterations and create log

## Examples

*TBD*
