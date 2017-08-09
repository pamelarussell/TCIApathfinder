message("\nTesting get_series")

series_all <- get_series()
series_coll <- get_series(collection = "TCGA-BRCA")
series_pat <- get_series(patient_id = "TCGA-OL-A5DA")
series_study_uid <- get_series(study_instance_uid = "1.3.6.1.4.1.14519.5.2.1.5382.4002.104582989590517557856962159716")
series_series_id <- get_series(series_instance_uid = "1.3.6.1.4.1.14519.5.2.1.5382.4002.806935685832642465081499816867")
series_modality <- get_series(modality = "MR")
series_body_part <- get_series(body_part = "BREAST")
series_model <- get_series(manufacturer_model_name = "Symphony")
series_manufacturer <- get_series(manufacturer = "SIEMENS")
series_pat_series_id <- get_series(patient_id = "TCGA-OL-A5DA", series_instance_uid = "1.3.6.1.4.1.14519.5.2.1.5382.4002.806935685832642465081499816867")

test_that("Relative response sizes", {
  expect_true(nrow(series_pat$series) > nrow(series_series_id$series))
  expect_true(nrow(series_all$series) > nrow(series_coll$series))
  expect_true(nrow(series_coll$series) > nrow(series_pat$series))
  expect_true(nrow(series_manufacturer$series) > nrow(series_model$series))
  expect_equal(nrow(series_pat_series_id$series), nrow(series_series_id$series))
})

test_that("Response intersection", {
  expect_true(all(unique(series_study_uid$series$series_instance_uid) %in% unique(series_pat$series$series_instance_uid)))
  expect_true(all(unique(series_modality$series$series_instance_uid) %in% unique(series_all$series$series_instance_uid)))
  expect_true(all(unique(series_series_id$series$series_instance_uid) %in% unique(series_study_uid$series$series_instance_uid)))
  expect_true(all(unique(series_coll$series$patient_id) %in% unique(series_all$series$patient_id)))
})

test_that("Structure of series value", {
  expect_equal(length(series_all), 3)
  expect_equal(ncol(series_coll$series), 15)
  expect_true(length(series_all$content) > 1000)
  expect_equal(class(series_manufacturer$response), "response")
})

test_that("Collection", {
  expect_true(nrow(series_coll$series) > 100)
})

test_that("Patient ID", {
  expect_true(nrow(series_pat$series) > 5)
})

test_that("Study instance UID", {
  expect_true(nrow(series_study_uid$series) > 5)
})

test_that("Series instance UID", {
  expect_equal(nrow(series_series_id$series), 1)
  expect_equal(nrow(series_pat_series_id$series), 1)
})

test_that("Modality", {
  expect_true(nrow(series_modality$series) > 1000)
})

test_that("Manufacturer model name", {
  expect_true(nrow(series_model$series) > 100)
})

test_that("Manufacturer", {
  expect_true(nrow(series_manufacturer$series) > 100)
})

test_that("Particular series", {
  expect_identical(as.character(series_series_id$series[1, "study_instance_uid"]), "1.3.6.1.4.1.14519.5.2.1.5382.4002.104582989590517557856962159716")
  expect_identical(as.character(series_series_id$series[1, "series_instance_uid"]), "1.3.6.1.4.1.14519.5.2.1.5382.4002.806935685832642465081499816867")
  expect_identical(as.character(series_series_id$series[1, "modality"]), "MR")
  expect_identical(as.character(series_series_id$series[1, "body_part_examined"]), "BREAST")
})

test_that("Invalid collection", {
  expect_warning(s <- get_series(collection = "fake collection"))
  suppressWarnings(s <- get_series(collection = "fake collection"))
  expect_equal(length(s$content), 0)
})

test_that("Invalid patient ID", {
  expect_warning(s <- get_series(patient_id = "fake id"))
  suppressWarnings(s <- get_series(patient_id = "fake id"))
  expect_equal(length(s$content), 0)
})

test_that("Invalid study instance UID", {
  expect_warning(s <- get_series(study_instance_uid = "fake id"))
  suppressWarnings(s <- get_series(study_instance_uid = "fake id"))
  expect_equal(length(s$content), 0)
})

test_that("Invalid series instance UID", {
  expect_warning(s <- get_series(series_instance_uid = "fake id"))
  suppressWarnings(s <- get_series(series_instance_uid = "fake id"))
  expect_equal(length(s$content), 0)
})

test_that("Invalid modality", {
  expect_warning(s <- get_series(modality = "fake modality"))
  suppressWarnings(s <- get_series(modality = "fake modality"))
  expect_equal(length(s$content), 0)
})

test_that("Invalid body part", {
  expect_warning(s <- get_series(body_part_examined = "fake body part"))
  suppressWarnings(s <- get_series(body_part_examined = "fake body part"))
  expect_equal(length(s$content), 0)
})

test_that("Invalid manufacturer model name", {
  expect_warning(s <- get_series(manufacturer_model_name = "fake model name"))
  suppressWarnings(s <- get_series(manufacturer_model_name = "fake model name"))
  expect_equal(length(s$content), 0)
})

test_that("Invalid manufacturer", {
  expect_warning(s <- get_series(manufacturer = "fake manufacturer"))
  suppressWarnings(s <- get_series(manufacturer = "fake manufacturer"))
  expect_equal(length(s$content), 0)
})










