
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
#' get_collection_names()
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
#' names, call \code{get_collection_names()}.
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
#' get_patients()
#' get_patients("TCGA-BRCA")
#'
#' @export
get_patients <- function(collection = NULL) {
  endpoint <- "/query/getPatient"
  response <- get_response(endpoint, query = list(format = "json", api_key = get_api_key(), Collection = collection))
  parsed <- process_json_response(response)
  if(length(parsed) == 0) warning(paste( "get_patients returned zero results for collection", collection))
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
#' names, call \code{get_collection_names()}.
#'
#' @param modality Modality name. If \code{modality} is \code{NULL}, body part names
#' from all modalities will be returned. To get a list of available modality names, call
#' \code{get_modality_names()}.
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
#' get_body_part_names()
#' get_body_part_names(collection = "TCGA-BRCA")
#' get_body_part_names(modality = "MR")
#' get_body_part_names(collection = "TCGA-BRCA", modality = "MR")
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
#' names, call \code{get_collection_names()}.
#'
#' @param body_part Body part name. If \code{body_part} is \code{NULL}, modality names
#' for all body parts will be returned. To get a list of available body part names, call
#' \code{get_body_part_names()}.
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
#' get_modality_names()
#' get_modality_names(collection = "TCGA-BRCA")
#' get_modality_names(body_part = "BREAST")
#' get_modality_names(collection = "TCGA-BRCA", body_part = "BREAST")
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
#' names, call \code{get_collection_names()}.
#'
#' @param modality Modality name. If \code{modality} is \code{NULL}, manufacturer names
#' for all modalities will be returned. To get a list of available modality names, call
#' \code{get_modality_names()}.
#'
#' @param body_part Body part name. If \code{body_part} is \code{NULL}, manufacturer names
#' for all body parts will be returned. To get a list of available body part names, call
#' \code{get_body_part_names()}.
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
#' get_manufacturer_names()
#' get_manufacturer_names(collection = "TCGA-BRCA")
#' get_manufacturer_names(collection = "TCGA-BRCA", modality = "MR", body_part = "BREAST")
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
#' names, call \code{get_collection_names()}.
#'
#' @param modality Modality name. To get a list of available modality names, call
#' \code{get_modality_names()}.
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
#' get_patients_by_modality("TCGA-BRCA", "MR")
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
#' names, call \code{get_collection_names()}.
#'
#' @param date Date in format YYYY-MM-DD
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
#' get_new_patients_in_collection("TCGA-BRCA", "2014-01-01")
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
#' names, call \code{get_collection_names()}.
#'
#' @param date Date in format YYYY-MM-DD
#'
#' @param patient_id Patient ID. To get a list of available patient IDs, call \code{get_patients()}.
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
#' get_new_studies_in_collection("TCGA-BRCA", "2014-01-01")
#' get_new_studies_in_collection("TCGA-BRCA", "2014-01-01", "TCGA-OL-A66O")
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
#' names, call \code{get_collection_names()}.
#'
#' @param patient_id Patient ID. To get a list of available patient IDs, call \code{get_patients()}.
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
#' get_studies_in_collection("TCGA-BRCA")
#' get_studies_in_collection("TCGA-BRCA", "TCGA-OL-A66O")
#'
#' @export
get_studies_in_collection <- function(collection, patient_id = NULL) {
  get_new_studies_in_collection(collection = collection, date = "0001-01-01", patient_id = patient_id)
}

