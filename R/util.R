
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
  tryCatch({
    httr::GET(add_endpoint(endpoint), ua, query = query)
  }, error = function(e) {
    stop("API request failed. Is your API key valid and up to date?")
  })
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

# Get vector of values for a key from a parsed API response
get_vals <- function(parsed_response, key) {
  unlist(sapply(parsed_response, function(x) get_or_else(x, key)))
}

# Get Patient objects from a parsed API response
get_patient_objects <- function(parsed_response) {
  data.frame(patient_id = get_vals(parsed_response, "PatientID"),
             patient_name = get_vals(parsed_response, "PatientName"),
             patient_dob = get_vals(parsed_response, "PatientBirthDate"),
             patient_sex = get_vals(parsed_response, "PatientSex"),
             patient_ethnic_group = get_vals(parsed_response, "EthnicGroup"),
             collection = get_vals(parsed_response, "Collection"))
}

# Get Patient/Study objects from a parsed API response
get_patient_study_objects <- function(parsed_response) {
  data.frame(patient_id = get_vals(parsed_response, "PatientID"),
             patient_name = get_vals(parsed_response, "PatientName"),
             patient_dob = get_vals(parsed_response, "PatientBirthDate"),
             patient_age = get_vals(parsed_response, "PatientAge"),
             patient_sex = get_vals(parsed_response, "PatientSex"),
             patient_ethnic_group = get_vals(parsed_response, "EthnicGroup"),
             admitting_diagnoses_description = get_vals(parsed_response, "AdmittingDiagnosesDescription"),
             collection = get_vals(parsed_response, "Collection"),
             study_id = get_vals(parsed_response, "StudyID"),
             study_instance_uid = get_vals(parsed_response, "StudyInstanceUID"),
             study_date = get_vals(parsed_response, "StudyDate"),
             study_description = get_vals(parsed_response, "StudyDescription"),
             series_count = get_vals(parsed_response, "SeriesCount"))
}

# Get Series objects from a parsed API response
get_series_objects <- function(parsed_response) {
  data.frame(patient_id = get_vals(parsed_response, "PatientID"),
             collection = get_vals(parsed_response, "Collection"),
             study_instance_uid = get_vals(parsed_response, "StudyInstanceUID"),
             series_instance_uid = get_vals(parsed_response, "SeriesInstanceUID"),
             modality = get_vals(parsed_response, "Modality"),
             protocol_name = get_vals(parsed_response, "ProtocolName"),
             series_date = get_vals(parsed_response, "SeriesDate"),
             series_description = get_vals(parsed_response, "SeriesDescription"),
             body_part_examined = get_vals(parsed_response, "BodyPartExamined"),
             series_number = get_vals(parsed_response, "SeriesNumber"),
             annotations_flag = get_vals(parsed_response, "AnnotationsFlag"),
             manufacturer = get_vals(parsed_response, "Manufacturer"),
             manufacturer_model_name = get_vals(parsed_response, "ManufacturerModelName"),
             software_versions = get_vals(parsed_response, "SoftwareVersions"),
             image_count = get_vals(parsed_response, "ImageCount"))
}



