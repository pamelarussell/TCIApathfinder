# TCIApathfinder

R client for The Cancer Imaging Archive REST API v3

## TCIA REST API version

TCIApathfinder supports v3 of the TCIA REST API.

## Authentication

An API key is required to access the TCIA REST API. To obtain and correctly store your API key:

1. Request a key from TCIA by following the instructions [here](https://wiki.cancerimagingarchive.net/display/Public/TCIA+Programmatic+Interface+%28REST+API%29+Usage+Guide).

2. Create a text file in your home directory (`~/`) called `.Renviron`. 

3. Create the contents of the `.Renviron` file like this, making sure the last line in the file is empty. Otherwise, R will silently fail to load the file.

```
TCIA_API_KEY=xxx-xxx-xxx-xxx

```

4. Restart R. `.Renviron` is only processed at the beginning of an R session.

