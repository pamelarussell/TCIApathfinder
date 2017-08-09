
# Get API key
get_api_key <- function() {
  api_key <- Sys.getenv("TCIA_API_KEY")
  if(identical(api_key, "")) {
    stop("Please request and store a valid API key (instructions: https://github.com/pamelarussell/TCIApathfinder)")
  }
  api_key
}

# The base URL and resource
base_url <- "https://services.cancerimagingarchive.net/services/v3"
resource <- "TCIA"
ua <- httr::user_agent("https://github.com/pamelarussell/TCIApathfinder")

# Construct URL from base URL, resource, and endpoint
add_endpoint <- function(endpoint) {
  p <- paste(base_url, resource, endpoint, sep = "/")
  gsub("/+", "/", p)
}

# Send the request and get the response
get_response <- function(endpoint, query) {
  httr::GET(add_endpoint(endpoint), ua, query = query)
}

# Make sure response is JSON
check_json <- function(response) {
  if(httr::http_type(response) != "application/json") {
    stop("API did not return JSON", call. = FALSE)
  }
}

# Turn API error into R error
parse_error <- function(response) {
  if (httr::http_error(response)) {
    stop(
      sprintf(
        "API request failed [%s]: %s",
        response$status_code,
        response$url
      ),
      call. = FALSE
    )
  }
}

# Perform checks of validity and parse the response
process_json_response <- function(response) {
  parse_error(response)
  check_json(response)
  jsonlite::fromJSON(httr::content(response, as = "text", encoding = "UTF-8"), simplifyVector = F)
}

# Validate date format
validate_date <- function(date) {
  date_fmt <- as.Date(date, format = "%Y-%m-%d")
  if(is.na(date_fmt) || nchar(date) != 10 || substr(date, 5, 5) != "-" || substr(date, 8, 8) != "-") {
    stop(paste("Invalid date format: ", date, ". Use YYYY-MM-DD.", sep = ""))
  }
}

# Get a list element if it exists, or an alternative value otherwise
get_or_else <- function(list, key, na_val = NA) {
  if(key %in% names(list)) list[[key]]
  else na_val
}

# Get Patient objects from a parsed API response
get_patient_objects <- function(parsed_response) {
  patient_ids <- unlist(sapply(parsed_response, function(x) get_or_else(x, "PatientID")))
  patient_name <- unlist(sapply(parsed_response, function(x) get_or_else(x, "PatientName")))
  patient_sex <- unlist(sapply(parsed_response, function(x) get_or_else(x, "PatientSex")))
  patient_ethnic_group <- unlist(sapply(parsed_response, function(x) get_or_else(x, "EthnicGroup")))
  collection <- unlist(sapply(parsed_response, function(x) get_or_else(x, "Collection")))
  data.frame(patient_id = patient_ids,
             patient_name = patient_name,
             patient_sex = patient_sex,
             patient_ethnic_group = patient_ethnic_group,
             collection = collection)
}





