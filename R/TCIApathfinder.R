
#' Get the names of all TCIA collections
#'
#' @return
#' List containing elements:
#' \itemize{
#'   \item \code{collection_names}: character vector of TCIA collection names
#'   \item \code{content}: parsed API response content
#'   \item \code{response}: API response
#' }
#'
#' @examples
#' \dontrun{
#' get_collection_names()
#' }
#'
#' @seealso \href{https://wiki.cancerimagingarchive.net/display/Public/TCIA+Programmatic+Interface+\%28REST+API\%29+Usage+Guide}{TCIA REST API Usage Guide},
#' \href{https://wiki.cancerimagingarchive.net/display/Public/TCIA+API+Return+Values}{TCIA API object definitions}
#'
#' @export
get_collection_names <- function() {
  endpoint <- "/query/getCollectionValues"
  response <- get_response(endpoint, query = list(format = "json", api_key = get_api_key()))
  parsed <- process_json_response(response)
  collection_names <- sort(unname(unlist(parsed)))
  structure(list(
    collection_names = collection_names,
    content = parsed,
    response = response
  ), class = "tcia_api")
}

#' Get patient information
#'
#' @param collection TCIA collection name. If \code{collection} is \code{NULL},
#' patients from all collections will be returned. To get a list of available collection
#' names, call \code{\link{get_collection_names}}.
#'
#' @return
#' List containing elements:
#' \itemize{
#'   \item \code{patients}: Data frame of patient ID, name, sex, ethnic group, and collection name
#'   \item \code{content}: parsed API response content
#'   \item \code{response}: API response
#' }
#'
#' @examples
#' \dontrun{
#' get_patient_info()
#' get_patient_info("TCGA-BRCA")
#' }
#'
#' @seealso \code{\link{get_collection_names}},
#' \href{https://wiki.cancerimagingarchive.net/display/Public/TCIA+Programmatic+Interface+\%28REST+API\%29+Usage+Guide}{TCIA REST API Usage Guide},
#' \href{https://wiki.cancerimagingarchive.net/display/Public/TCIA+API+Return+Values}{TCIA API object definitions}
#'
#' @export
get_patient_info <- function(collection = NULL) {
  endpoint <- "/query/getPatient"
  response <- get_response(endpoint, query = list(format = "json", api_key = get_api_key(), Collection = collection))
  parsed <- process_json_response(response)
  if(length(parsed) == 0) warning(paste( "get_patient_info returned zero results for collection", collection))
  structure(list(
    patients = get_patient_objects(parsed),
    content = parsed,
    response = response
  ), class = "tcia_api")
}

#' Get body part names
#'
#' @param collection TCIA collection name. If \code{collection} is \code{NULL},
#' body part names from all collections will be returned. To get a list of available collection
#' names, call \code{\link{get_collection_names}}.
#'
#' @param modality Modality name. If \code{modality} is \code{NULL}, body part names
#' from all modalities will be returned. To get a list of available modality names, call
#' \code{\link{get_modality_names}} or see
#' \href{https://wiki.cancerimagingarchive.net/display/Public/DICOM+Modality+Abbreviations}{DICOM Modality Abbreviations}.
#'
#' @return
#' List containing elements:
#' \itemize{
#'   \item \code{body_parts}: character vector of body part names
#'   \item \code{content}: parsed API response content
#'   \item \code{response}: API response
#' }
#'
#' @examples
#' \dontrun{
#' get_body_part_names()
#' get_body_part_names(collection = "TCGA-BRCA")
#' get_body_part_names(modality = "MR")
#' get_body_part_names(collection = "TCGA-BRCA", modality = "MR")
#' }
#'
#' @seealso \code{\link{get_collection_names}},
#' \code{\link{get_modality_names}},
#' \href{https://wiki.cancerimagingarchive.net/display/Public/DICOM+Modality+Abbreviations}{DICOM Modality Abbreviations},
#' \href{https://wiki.cancerimagingarchive.net/display/Public/TCIA+Programmatic+Interface+\%28REST+API\%29+Usage+Guide}{TCIA REST API Usage Guide},
#' \href{https://wiki.cancerimagingarchive.net/display/Public/TCIA+API+Return+Values}{TCIA API object definitions}
#'
#' @export
get_body_part_names <- function(collection = NULL, modality = NULL) {
  endpoint <- "query/getBodyPartValues"
  response <- get_response(endpoint, query = list(format = "json", api_key = get_api_key(),
                                                  Collection = collection, Modality = modality))
  parsed <- process_json_response(response)
  if(length(parsed) == 0) warning(paste( "get_body_part_names returned zero results for collection", collection,
                                         "and modality", modality))
  body_parts <- sort(unlist(sapply(parsed, function(x) x$BodyPartExamined)))
  structure(list(
    body_parts = body_parts,
    content = parsed,
    response = response
  ), class = "tcia_api")
}

#' Get modality names
#'
#' @param collection TCIA collection name. If \code{collection} is \code{NULL},
#' modality names from all collections will be returned. To get a list of available collection
#' names, call \code{\link{get_collection_names}}.
#'
#' @param body_part Body part name. If \code{body_part} is \code{NULL}, modality names
#' for all body parts will be returned. To get a list of available body part names, call
#' \code{\link{get_body_part_names}}.
#'
#' @return
#' List containing elements:
#' \itemize{
#'   \item \code{modalities}: character vector of modality names
#'   \item \code{content}: parsed API response content
#'   \item \code{response}: API response
#' }
#'
#' @examples
#' \dontrun{
#' get_modality_names()
#' get_modality_names(collection = "TCGA-BRCA")
#' get_modality_names(body_part = "BREAST")
#' get_modality_names(collection = "TCGA-BRCA", body_part = "BREAST")
#' }
#'
#' @seealso \code{\link{get_collection_names}},
#' \code{\link{get_body_part_names}},
#' \href{https://wiki.cancerimagingarchive.net/display/Public/TCIA+Programmatic+Interface+\%28REST+API\%29+Usage+Guide}{TCIA REST API Usage Guide},
#' \href{https://wiki.cancerimagingarchive.net/display/Public/TCIA+API+Return+Values}{TCIA API object definitions}
#'
#' @export
get_modality_names <- function(collection = NULL, body_part = NULL) {
  endpoint <- "query/getModalityValues"
  response <- get_response(endpoint, query = list(format = "json", api_key = get_api_key(),
                                                  Collection = collection, BodyPartExamined = body_part))
  parsed <- process_json_response(response)
  if(length(parsed) == 0) warning(paste( "get_modality_names returned zero results for collection", collection,
                                         "and body part", body_part))
  modalities <- sort(unlist(sapply(parsed, function(x) x$Modality)))
  structure(list(
    modalities = modalities,
    content = parsed,
    response = response
  ), class = "tcia_api")
}

#' Get manufacturer names
#'
#' @param collection TCIA collection name. If \code{collection} is \code{NULL},
#' manufacturer names from all collections will be returned. To get a list of available collection
#' names, call \code{\link{get_collection_names}}.
#'
#' @param modality Modality name. If \code{modality} is \code{NULL}, manufacturer names
#' for all modalities will be returned. To get a list of available modality names, call
#' \code{\link{get_modality_names}} or see \href{https://wiki.cancerimagingarchive.net/display/Public/DICOM+Modality+Abbreviations}{DICOM Modality Abbreviations}.
#'
#' @param body_part Body part name. If \code{body_part} is \code{NULL}, manufacturer names
#' for all body parts will be returned. To get a list of available body part names, call
#' \code{\link{get_body_part_names}}.
#'
#' @return
#' List containing elements:
#' \itemize{
#'   \item \code{manufacturer_names}: character vector of manufacturer names
#'   \item \code{content}: parsed API response content
#'   \item \code{response}: API response
#' }
#'
#' @examples
#' \dontrun{
#' get_manufacturer_names()
#' get_manufacturer_names(collection = "TCGA-BRCA")
#' get_manufacturer_names(collection = "TCGA-BRCA", modality = "MR", body_part = "BREAST")
#' }
#'
#' @seealso \code{\link{get_collection_names}},
#' \code{\link{get_modality_names}},
#' \code{\link{get_body_part_names}},
#' \href{https://wiki.cancerimagingarchive.net/display/Public/DICOM+Modality+Abbreviations}{DICOM Modality Abbreviations},
#' \href{https://wiki.cancerimagingarchive.net/display/Public/TCIA+Programmatic+Interface+\%28REST+API\%29+Usage+Guide}{TCIA REST API Usage Guide},
#' \href{https://wiki.cancerimagingarchive.net/display/Public/TCIA+API+Return+Values}{TCIA API object definitions}
#'
#' @export
get_manufacturer_names <- function(collection = NULL, modality = NULL, body_part = NULL) {
  endpoint <- "/query/getManufacturerValues"
  response <- get_response(endpoint, query = list(format = "json", api_key = get_api_key(),
                                                  Collection = collection, Modality = modality,
                                                  BodyPartExamined = body_part))
  parsed <- process_json_response(response)
  if(length(parsed) == 0) warning(paste("get_manufacturer_names returned zero results for collection ",
                                        collection, ", modality ", modality, ", and body part ", body_part))
  manufacturer_names <- sort(unlist(sapply(parsed, function(x) x$Manufacturer)))
  structure(list(
    manufacturer_names = manufacturer_names,
    content = parsed,
    response = response
  ), class = "tcia_api")
}

#' Get patient IDs given a collection name and modality
#'
#' @param collection TCIA collection name. To get a list of available collection
#' names, call \code{\link{get_collection_names}}.
#'
#' @param modality Modality name. To get a list of available modality names, call
#' \code{\link{get_modality_names}} or see \href{https://wiki.cancerimagingarchive.net/display/Public/DICOM+Modality+Abbreviations}{DICOM Modality Abbreviations}.
#'
#' @return
#' List containing elements:
#' \itemize{
#'   \item \code{patient_ids}: Patient IDs
#'   \item \code{content}: parsed API response content
#'   \item \code{response}: API response
#' }
#'
#' @examples
#' \dontrun{
#' get_patients_by_modality("TCGA-BRCA", "MR")
#' }
#'
#' @seealso \code{\link{get_collection_names}},
#' \code{\link{get_modality_names}},
#' \href{https://wiki.cancerimagingarchive.net/display/Public/DICOM+Modality+Abbreviations}{DICOM Modality Abbreviations},
#' \href{https://wiki.cancerimagingarchive.net/display/Public/TCIA+Programmatic+Interface+\%28REST+API\%29+Usage+Guide}{TCIA REST API Usage Guide},
#' \href{https://wiki.cancerimagingarchive.net/display/Public/TCIA+API+Return+Values}{TCIA API object definitions}
#'
#' @export
get_patients_by_modality <- function(collection, modality) {
  endpoint <- "/query/PatientsByModality"
  response <- get_response(endpoint, query = list(format = "json", api_key = get_api_key(),
                                                  Collection = collection, Modality = modality))
  parsed <- process_json_response(response)
  if(length(parsed) == 0) warning(paste("get_patients_by_modality returned zero results for collection",
                                        collection, "and modality", modality))
  patient_ids <- sort(unlist(sapply(parsed, function(x) x$PatientID)))
  structure(list(
    patient_ids = patient_ids,
    content = parsed,
    response = response
  ), class = "tcia_api")
}

#' Get IDs of patients that have been added to a collection since a specified date
#'
#' @param collection TCIA collection name. To get a list of available collection
#' names, call \code{\link{get_collection_names}}.
#'
#' @param date Date in format "YYYY-MM-DD"
#'
#' @return
#' List containing elements:
#' \itemize{
#'   \item \code{patient_ids}: Patient IDs
#'   \item \code{content}: parsed API response content
#'   \item \code{response}: API response
#' }
#'
#' @examples
#' \dontrun{
#' get_new_patients_in_collection("TCGA-BRCA", "2014-01-01")
#' }
#'
#' @seealso \code{\link{get_collection_names}},
#' \href{https://wiki.cancerimagingarchive.net/display/Public/TCIA+Programmatic+Interface+\%28REST+API\%29+Usage+Guide}{TCIA REST API Usage Guide},
#' \href{https://wiki.cancerimagingarchive.net/display/Public/TCIA+API+Return+Values}{TCIA API object definitions}
#'
#' @export
get_new_patients_in_collection <- function(collection, date) {
  validate_date(date)
  endpoint <- "/query/NewPatientsInCollection"
  response <- get_response(endpoint, query = list(format = "json", api_key = get_api_key(),
                                                  Collection = collection, Date = date))
  parsed <- process_json_response(response)
  if(length(parsed) == 0) warning(paste("get_new_patients_in_collection returned zero results for collection",
                                        collection, "and date", date))
  patient_ids <- unlist(sapply(parsed, function(x) x$PatientID))
  structure(list(
    patient_ids = patient_ids,
    content = parsed,
    response = response
  ), class = "tcia_api")
}

#' Get studies that have been added to a collection and optionally to a patient since a specified date
#'
#' @param collection TCIA collection name. To get a list of available collection
#' names, call \code{\link{get_collection_names}}.
#'
#' @param date Date in format "YYYY-MM-DD"
#'
#' @param patient_id Patient ID. To get a list of available patient IDs, call \code{\link{get_patient_info}}.
#' If \code{patient_id} is \code{NULL}, relevant studies for all patients in the collection will be returned.
#'
#' @return
#' List containing elements:
#' \itemize{
#'   \item \code{studies}: Data frame of collection, patient ID, and study instance UID
#'   \item \code{content}: parsed API response content
#'   \item \code{response}: API response
#' }
#'
#' @examples
#' \dontrun{
#' get_new_studies_in_collection("TCGA-BRCA", "2014-01-01")
#' get_new_studies_in_collection("TCGA-BRCA", "2014-01-01", "TCGA-OL-A66O")
#' }
#'
#' @seealso \code{\link{get_collection_names}},
#' \code{\link{get_patient_info}},
#' \href{https://wiki.cancerimagingarchive.net/display/Public/TCIA+Programmatic+Interface+\%28REST+API\%29+Usage+Guide}{TCIA REST API Usage Guide},
#' \href{https://wiki.cancerimagingarchive.net/display/Public/TCIA+API+Return+Values}{TCIA API object definitions}
#'
#' @export
get_new_studies_in_collection <- function(collection, date, patient_id = NULL) {
  validate_date(date)
  endpoint <- "/query/NewStudiesInPatientCollection"
  response <- get_response(endpoint, query = list(format = "json", api_key = get_api_key(),
                                                  Collection = collection, Date = date,
                                                  PatientID = patient_id))
  parsed <- process_json_response(response)
  if(length(parsed) == 0) warning(paste("get_new_studies_in_collection returned zero results for collection ",
                                        collection, ", date ", date, " and patient ID ", patient_id, sep = ""))
  collection_vals <- unlist(sapply(parsed, function(x) x$Collection))
  patient_id_vals <- unlist(sapply(parsed, function(x) x$PatientID))
  study_uid_vals <- unlist(sapply(parsed, function(x) x$StudyInstanceUID))
  structure(list(
    studies = data.frame(Collection = collection_vals,
                         PatientID = patient_id_vals,
                         StudyInstanceUID = study_uid_vals),
    content = parsed,
    response = response
  ), class = "tcia_api")
}

#' Get studies in a collection and optionally for a specific patient
#'
#' @param collection TCIA collection name. To get a list of available collection
#' names, call \code{\link{get_collection_names}}.
#'
#' @param patient_id Patient ID. To get a list of available patient IDs, call \code{\link{get_patient_info}}.
#' If \code{patient_id} is \code{NULL}, studies for all patients in the collection will be returned.
#'
#' @return
#' List containing elements:
#' \itemize{
#'   \item \code{studies}: Data frame of collection, patient ID, and study instance UID
#'   \item \code{content}: parsed API response content
#'   \item \code{response}: API response
#' }
#'
#' @examples
#' \dontrun{
#' get_studies_in_collection("TCGA-BRCA")
#' get_studies_in_collection("TCGA-BRCA", "TCGA-OL-A66O")
#' }
#'
#' @seealso \code{\link{get_collection_names}},
#' \code{\link{get_patient_info}},
#' \href{https://wiki.cancerimagingarchive.net/display/Public/TCIA+Programmatic+Interface+\%28REST+API\%29+Usage+Guide}{TCIA REST API Usage Guide},
#' \href{https://wiki.cancerimagingarchive.net/display/Public/TCIA+API+Return+Values}{TCIA API object definitions}
#'
#' @export
get_studies_in_collection <- function(collection, patient_id = NULL) {
  get_new_studies_in_collection(collection = collection, date = "0001-01-01", patient_id = patient_id)
}

#' Get patient study information
#'
#' @param collection TCIA collection name. To get a list of available collection
#' names, call \code{\link{get_collection_names}}. If \code{collection} is \code{NULL}, information
#' for all relevant collections will be returned.
#'
#' @param patient_id Patient ID. To get a list of available patient IDs, call \code{\link{get_patient_info}}.
#' If \code{patient_id} is \code{NULL}, information for all relevant patients will be returned.
#'
#' @param study_instance_uid Study instance UID. If \code{study_instance_uid} is \code{NULL}, information
#' for all relevant study instance UIDs will be returned. To get available study instance UIDs, call \code{\link{get_studies_in_collection}},
#' \code{\link{get_patient_studies}}, or \code{\link{get_new_studies_in_collection}}.
#'
#' @return
#' List containing elements:
#' \itemize{
#'   \item \code{patient_studies}: Data frame with columns representing the contents of a PatientStudy object
#'   as described in \href{https://wiki.cancerimagingarchive.net/display/Public/TCIA+API+Return+Values}{TCIA API Return Values}
#'   \item \code{content}: parsed API response content
#'   \item \code{response}: API response
#' }
#'
#' @examples
#' \dontrun{
#' get_patient_studies()
#' get_patient_studies(collection = "TCGA-BRCA")
#' get_patient_studies(patient_id = "TCGA-OL-A6VO")
#' get_patient_studies(patient_id = "TCGA-OL-A5DA",
#'      study_instance_uid = "1.3.6.1.4.1.14519.5.2.1.5382.4002.104582989590517557856962159716")
#' }
#'
#' @seealso \code{\link{get_collection_names}},
#' \code{\link{get_patient_info}},
#' \code{\link{get_studies_in_collection}},
#' \code{\link{get_patient_studies}},
#' \code{\link{get_new_studies_in_collection}},
#' \href{https://wiki.cancerimagingarchive.net/display/Public/TCIA+Programmatic+Interface+\%28REST+API\%29+Usage+Guide}{TCIA REST API Usage Guide},
#' \href{https://wiki.cancerimagingarchive.net/display/Public/TCIA+API+Return+Values}{TCIA API object definitions}
#'
#' @export
get_patient_studies <- function(collection = NULL, patient_id = NULL, study_instance_uid = NULL) {
  endpoint <- "/query/getPatientStudy"
  response <- get_response(endpoint, query = list(format = "json", api_key = get_api_key(),
                                                  Collection = collection, PatientID = patient_id,
                                                  StudyInstanceUID = study_instance_uid))
  parsed <- process_json_response(response)
  if(length(parsed) == 0) warning(paste("get_patient_studies returned zero results for collection ",
                                        collection, ", patient ID ", patient_id, ", and study instance UID ",
                                        study_instance_uid, sep = ""))
  structure(list(
    patient_studies = get_patient_study_objects(parsed),
    content = parsed,
    response = response
  ), class = "tcia_api")
}

#' Get image series information
#'
#' @param collection TCIA collection name. To get a list of available collection
#' names, call \code{\link{get_collection_names}}. If \code{collection} is \code{NULL}, information
#' for all relevant collections will be returned.
#'
#' @param patient_id Patient ID. To get a list of available patient IDs, call \code{\link{get_patient_info}}.
#' If \code{patient_id} is \code{NULL}, information for all relevant patients will be returned.
#'
#' @param study_instance_uid Study instance UID. If \code{study_instance_uid} is \code{NULL}, information
#' for all relevant study instance UIDs will be returned. To get available study instance UIDs, call \code{\link{get_studies_in_collection}},
#' \code{\link{get_patient_studies}}, or \code{\link{get_new_studies_in_collection}}.
#'
#' @param series_instance_uid Series instance UID. To get a list of available series instance UIDs, call
#' this function leaving out parameter \code{series_instance_uid}. If \code{series_instance_uid} is \code{NULL},
#' information for all relevant series will be returned.
#'
#' @param modality Modality name. To get a list of available modality names, call \code{\link{get_modality_names}}
#' or see \href{https://wiki.cancerimagingarchive.net/display/Public/DICOM+Modality+Abbreviations}{DICOM Modality Abbreviations}.
#' If \code{modality} is \code{NULL}, information for all relevant modalities will be returned.
#'
#' @param body_part_examined Body part name. To get a list of available body part names, call
#' \code{\link{get_body_part_names}}. If \code{body_part_examined} is \code{NULL}, information
#' for all relevant body parts will be returned. IMPORTANT: a bug in this query key has been observed in the TCIA API.
#' If queries using this key return zero results, try removing this parameter.
#'
#' @param manufacturer_model_name Manufacturer model name. To get a list of available model names, call
#' this function leaving out parameter \code{manufacturer_model_name}. If \code{manufacturer_model_name} is \code{NULL},
#' information for all relevant model names will be returned.
#'
#' @param manufacturer Manufacturer name. To get a list of available manufacturer names, call
#' \code{\link{get_manufacturer_names}}. If \code{manufacturer} is \code{NULL},
#' information for all relevant manufacturers will be returned.
#'
#' @return
#' List containing elements:
#' \itemize{
#'   \item \code{series}: Data frame with columns representing the contents of a Series object
#'   as described in \href{https://wiki.cancerimagingarchive.net/display/Public/TCIA+API+Return+Values}{TCIA API Return Values}
#'   \item \code{content}: parsed API response content
#'   \item \code{response}: API response
#' }
#'
#' @examples
#' \dontrun{
#' get_series_info()
#' get_series_info(collection = "TCGA-BRCA")
#' get_series_info(patient_id = "TCGA-OL-A6VO")
#' get_series_info(modality = "MR", manufacturer = "GE MEDICAL SYSTEMS")
#' }
#'
#' @seealso \code{\link{get_collection_names}},
#' \code{\link{get_patient_info}},
#' \code{\link{get_studies_in_collection}},
#' \code{\link{get_patient_studies}},
#' \code{\link{get_new_studies_in_collection}},
#' \code{\link{get_modality_names}},
#' \code{\link{get_body_part_names}},
#' \code{\link{get_manufacturer_names}},
#' \href{https://wiki.cancerimagingarchive.net/display/Public/TCIA+Programmatic+Interface+\%28REST+API\%29+Usage+Guide}{TCIA REST API Usage Guide},
#' \href{https://wiki.cancerimagingarchive.net/display/Public/TCIA+API+Return+Values}{TCIA API object definitions}
#'
#' @export
get_series_info <- function(collection = NULL,
                       patient_id = NULL,
                       study_instance_uid = NULL,
                       series_instance_uid = NULL,
                       modality = NULL,
                       body_part_examined = NULL,
                       manufacturer_model_name = NULL,
                       manufacturer = NULL) {
  endpoint <- "/query/getSeries"
  response <- get_response(endpoint, query = list(format = "json", api_key = get_api_key(),
                                                  Collection = collection,
                                                  StudyInstanceUID = study_instance_uid,
                                                  PatientID = patient_id,
                                                  SeriesInstanceUID = series_instance_uid,
                                                  Modality = modality,
                                                  BodyPartExamined = body_part_examined,
                                                  ManufacturerModelName = manufacturer_model_name,
                                                  Manufacturer = manufacturer))
  parsed <- process_json_response(response)
  if(length(parsed) == 0) warning(paste(c("get_series_info returned zero results for collection ",
                                          collection, ", study instance UID ", study_instance_uid,
                                          ", patient ID ", patient_id, ", series instance UID ",
                                          series_instance_uid, ", modality ", modality,
                                          ", body part ", body_part_examined, ", manufacturer model name ",
                                          manufacturer_model_name, ", manufacturer ", manufacturer),
                                        collapse = ''))
  structure(list(
    series = get_series_objects(parsed),
    content = parsed,
    response = response
  ), class = "tcia_api")
}

#' Get size of image series
#'
#' @param series_instance_uid Series instance UID. To get a list of available series instance UIDs, call \code{\link{get_series_info}}.
#'
#' @return
#' List containing elements:
#' \itemize{
#'   \item \code{size_bytes}: Total size of image series in bytes
#'   \item \code{object_count}: Number of objects in image series
#'   \item \code{content}: parsed API response content
#'   \item \code{response}: API response
#' }
#'
#' @examples
#' \dontrun{
#' get_series_size("1.3.6.1.4.1.14519.5.2.1.5382.4002.272234209223992578700978260744")
#' }
#'
#' @seealso \code{\link{get_series_info}},
#' \href{https://wiki.cancerimagingarchive.net/display/Public/TCIA+Programmatic+Interface+\%28REST+API\%29+Usage+Guide}{TCIA REST API Usage Guide},
#' \href{https://wiki.cancerimagingarchive.net/display/Public/TCIA+API+Return+Values}{TCIA API object definitions}
#'
#' @export
get_series_size <- function(series_instance_uid) {
  endpoint <- "/query/getSeriesSize"
  response <- get_response(endpoint, query = list(format = "json", api_key = get_api_key(), SeriesInstanceUID = series_instance_uid))
  parsed <- process_json_response(response)
  if(length(parsed) != 1) stop("Length of response list should be 1")
  data <- parsed[[1]]
  if(length(data$TotalSizeInBytes) == 0) {
    warning(paste("get_series_size returned no results for series instance UID", series_instance_uid))
    structure(list(
      size_bytes = NA,
      object_count = NA,
      content = parsed,
      response = response
    ), class = "tcia_api")
  }
  else structure(list(
    size_bytes = as.integer(data$TotalSizeInBytes),
    object_count = as.integer(data$ObjectCount),
    content = parsed,
    response = response
  ), class = "tcia_api")
}

#' Get SOP instance UIDs (individual DICOM image IDs) for an image series
#'
#' @param series_instance_uid Series instance UID. To get a list of available series instance UIDs, call \code{\link{get_series_info}}.
#'
#' @return
#' List containing elements:
#' \itemize{
#'   \item \code{sop_instance_uids}: character vector of SOP instance UIDs (individual DICOM image IDs)
#'   \item \code{content}: parsed API response content
#'   \item \code{response}: API response
#' }
#'
#' @examples
#' \dontrun{
#' get_sop_instance_uids("1.3.6.1.4.1.14519.5.2.1.5382.4002.272234209223992578700978260744")
#' }
#'
#' @seealso \code{\link{get_series_info}},
#' \href{https://wiki.cancerimagingarchive.net/display/Public/TCIA+Programmatic+Interface+\%28REST+API\%29+Usage+Guide}{TCIA REST API Usage Guide},
#' \href{https://wiki.cancerimagingarchive.net/display/Public/TCIA+API+Return+Values}{TCIA API object definitions}
#'
#' @export
get_sop_instance_uids <- function(series_instance_uid) {
  endpoint <- "/query/getSOPInstanceUIDs"
  response <- get_response(endpoint, query = list(format = "json", api_key = get_api_key(), SeriesInstanceUID = series_instance_uid))
  parsed <- process_json_response(response)
  if(length(parsed) == 0) warning(paste( "get_sop_instance_uids returned zero results for series", series_instance_uid))
  sop_instance_uids <- sort(unname(unlist(parsed)))
  structure(list(
    sop_instance_uids = sop_instance_uids,
    content = parsed,
    response = response
  ), class = "tcia_api")

}

#' Save a single DICOM image file
#'
#' @param series_instance_uid Series instance UID. To get a list of available series instance UIDs, call \code{\link{get_series_info}}.
#' @param sop_instance_uid SOP instance UID. To get a list of SOP instance UIDs for an image series, call \code{\link{get_sop_instance_uids}}.
#' @param out_dir Directory to write DICOM file to
#' @param out_file_name Name of DICOM file to write, with .dcm extension. If \code{out_file_name} is \code{NULL}, the original file name will be used.
#'
#' @return
#' List containing elements:
#' \itemize{
#'   \item \code{out_file}: The output file that was written
#'   \item \code{response}: API response
#' }
#'
#' @examples
#' \dontrun{
#' save_single_image(
#'      series_instance_uid = "1.3.6.1.4.1.14519.5.2.1.5382.4002.806935685832642465081499816867",
#'      sop_instance_uid = "1.3.6.1.4.1.14519.5.2.1.5382.4002.257663256941568276393774062283",
#'      out_dir = "~/Desktop")
#' save_single_image(
#'      series_instance_uid = "1.3.6.1.4.1.14519.5.2.1.5382.4002.806935685832642465081499816867",
#'      sop_instance_uid = "1.3.6.1.4.1.14519.5.2.1.5382.4002.257663256941568276393774062283",
#'      out_dir = "~/Desktop", out_file_name = "file.dcm")
#' }
#'
#' @seealso \code{\link{get_series_info}},
#' \code{\link{get_sop_instance_uids}},
#' \href{https://wiki.cancerimagingarchive.net/display/Public/TCIA+Programmatic+Interface+\%28REST+API\%29+Usage+Guide}{TCIA REST API Usage Guide},
#' \href{https://wiki.cancerimagingarchive.net/display/Public/TCIA+API+Return+Values}{TCIA API object definitions}
#'
#' @export
save_single_image <- function(series_instance_uid, sop_instance_uid, out_dir, out_file_name = NULL) {
  endpoint <- "/query/getSingleImage"
  response <- get_response(endpoint, query = list(format = "json",
                                                  api_key = get_api_key(),
                                                  SeriesInstanceUID = series_instance_uid,
                                                  SOPInstanceUID = sop_instance_uid))
  if(response$status_code != 200) {
    warning(paste("An error occurred in save_single_image for series instance UID ",
            series_instance_uid, " and SOP instance UID ", sop_instance_uid, ". Not saving DICOM file. ",
            "Status code: ", response$status_code, sep=""))
    structure(list(
      out_file = NULL,
      response = response
    ))
  } else {
    # If no file name was provided, get it from the response
    if(is.null(out_file_name)) out_file_name <- unlist(strsplit(gsub("\"", "", response$headers$`content-disposition`), "="))[2]
    out_file <- paste(out_dir, out_file_name, sep = "/")
    if(file.exists(out_file)) {
      stop(paste("File exists:", out_file))
    }
    writeBin(response$content, out_file)
    structure(list(
      out_file = out_file,
      response = response
    ), class = "tcia_api")
  }
}


#' Save a series of DICOM image files as a zip file
#'
#' @param series_instance_uid Series instance UID. To get a list of available series instance UIDs, call \code{\link{get_series_info}}.
#' Note: if \code{series_instance_uid} is invalid, the API may still successfully return an empty zip file.
#' @param out_dir Directory to write zip file to
#' @param out_file_name Name of zip file to write. If \code{out_file_name} is \code{NULL}, the original file name will be used.
#'
#' @return
#' List containing elements:
#' \itemize{
#'   \item \code{out_file}: The output zip file that was written
#'   \item \code{response}: API response
#' }
#'
#' @examples
#' \dontrun{
#' save_image_series(
#'      series_instance_uid = "1.3.6.1.4.1.14519.5.2.1.5382.4002.806935685832642465081499816867",
#'      out_dir = "~/Desktop")
#' save_image_series(
#'      series_instance_uid = "1.3.6.1.4.1.14519.5.2.1.5382.4002.806935685832642465081499816867",
#'      out_dir = "~/Desktop", out_file_name = "file.zip")
#' }
#'
#' @seealso \code{\link{get_series_info}},
#' \href{https://wiki.cancerimagingarchive.net/display/Public/TCIA+Programmatic+Interface+\%28REST+API\%29+Usage+Guide}{TCIA REST API Usage Guide},
#' \href{https://wiki.cancerimagingarchive.net/display/Public/TCIA+API+Return+Values}{TCIA API object definitions}
#'
#' @export
save_image_series <- function(series_instance_uid, out_dir, out_file_name = NULL) {
  endpoint <- "/query/getImage"
  response <- get_response(endpoint, query = list(format = "json",
                                                  api_key = get_api_key(),
                                                  SeriesInstanceUID = series_instance_uid))
  if(response$status_code != 200) {
    warning(paste("An error occurred in save_image_series for series instance UID ",
                  series_instance_uid, ". Not saving zip file. ",
                  "Status code: ", response$status_code, sep=""))
    structure(list(
      out_file = NULL,
      response = response
    ))
  } else {
    # If no file name was provided, get it from the response
    if(is.null(out_file_name)) out_file_name <- unlist(strsplit(gsub("\"", "", response$headers$`content-disposition`), "="))[2]
    out_file <- paste(out_dir, out_file_name, sep = "/")
    if(file.exists(out_file)) {
      stop(paste("File exists:", out_file))
    }
    writeBin(response$content, out_file)
    structure(list(
      out_file = out_file,
      response = response
    ), class = "tcia_api")
  }
}





