## Vignettes require authentication
This package wraps a REST API that requires an API key. The vignettes
require a key in order to build. If possible, please do not rebuild the
vignettes. (The same is true of tests and examples, but I have removed
these from the CRAN check. These have not changed since version 1.0.0.)

## Test environments
* local OS X install, R 3.4.1
* win-builder

## R CMD check results
There were no ERRORs, WARNINGs, or NOTEs. 

## Downstream dependencies
There are no downstream dependencies.

## A note on tests and examples
Tests and examples are passing locally, but are not run as part of the
check because a key is required to access the wrapped API. 
