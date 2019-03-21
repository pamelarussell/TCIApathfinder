
# TCIApathfinder

<!-- badges: start -->

[![](https://www.r-pkg.org/badges/version/TCIApathfinder)](https://cran.r-project.org/package=TCIApathfinder)
[![](http://cranlogs.r-pkg.org/badges/grand-total/TCIApathfinder?color=brightgreen)](https://cran.r-project.org/package=TCIApathfinder)
[![Travis build
status](https://travis-ci.com/pamelarussell/TCIApathfinder.svg?branch=master)](https://travis-ci.com/pamelarussell/TCIApathfinder)
<!-- badges: end -->

TCIApathfinder is a wrapper for The Cancer Imaging Archive’s REST API
v3. The Cancer Imaging Archive (TCIA) hosts de-identified medical images
of cancer available for public download, as well as rich metadata for
each image series. TCIA provides a REST API for programmatic access to
the data. This package provides simple functions to access each API
endpoint. For more information about TCIA, see TCIA’s
[website](http://www.cancerimagingarchive.net/).

TCIApathfinder is on
[CRAN](https://cran.r-project.org/package=TCIApathfinder).

## Installation

From within R:

``` r
install.packages("TCIApathfinder")
```

From GitHub:

``` r
# install.packages("devtools")
devtools::install_github("pamelarussell/TCIApathfinder")
```

## Authentication

An API key is required to access data from TCIA. To obtain and correctly
store your API key:

1.  Request a key from TCIA by following the instructions
    [here](https://wiki.cancerimagingarchive.net/display/Public/TCIA+Programmatic+Interface+%28REST+API%29+Usage+Guide).

2.  Create a text file in your home directory (`~/`) called `.Renviron`.

3.  Create the contents of the `.Renviron` file like this, making sure
    the last line in the file is empty. Otherwise, R will silently fail
    to load the file.
    
        TCIA_API_KEY=xxx-xxx-xxx-xxx

4.  Restart R. `.Renviron` is only processed at the beginning of an R
    session.

## Package usage

Detailed vignettes on package usage and downstream image analysis can be
viewed on [CRAN](https://CRAN.R-project.org/package=TCIApathfinder) or
from within an R session with `browseVignettes("TCIApathfinder")`.

## Citation

From within R:

``` r
citation("TCIApathfinder")
```

[TCIApathfinder: An R Client for the Cancer Imaging Archive REST
API](https://doi.org/10.1158/0008-5472.CAN-18-0678). Pamela Russell,
Kelly Fountain, Dulcy Wolverton and Debashis Ghosh. Cancer Res August 1
2018 (78) (15) 4424-4426; DOI: 10.1158/0008-5472.CAN-18-0678.

## More information on the TCIA REST API

  - [API usage
    guide](https://wiki.cancerimagingarchive.net/display/Public/TCIA+Programmatic+Interface+%28REST+API%29+Usage+Guide)
  - [Object type
    definitions](https://wiki.cancerimagingarchive.net/display/Public/TCIA+API+Return+Values)
