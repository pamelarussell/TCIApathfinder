
test_that("Structure of patients by modality value", {
  pat <- get_patients_by_modality("TCGA-BRCA", "MR")
  expect_equal(length(pat), 3)
  expect_true(length(pat$patient_ids) > 100)
  expect_true(length(pat$content) > 100)
  expect_equal(class(pat$response), "response")
})

test_that("Patient values for TCGA-BRCA and MR", {
  pat <- get_patients_by_modality(collection = "TCGA-BRCA", modality = "MR")
  expect_true("TCGA-E2-A1B5" %in% pat$patient_ids)
})

test_that("Nonexistent collection and modality combination", {
  expect_warning(pat <- get_patients_by_modality(collection = "TCGA-BRCA", modality = "RTSTRUCT"))
  suppressWarnings(pat <- get_patients_by_modality(collection = "TCGA-BRCA", modality = "RTSTRUCT"))
  expect_equal(length(pat$body_parts), 0)
})

test_that("Invalid collection name", {
  expect_warning(pat <- get_patients_by_modality(collection = "fake_collection", modality = "MR"))
  suppressWarnings(pat <- get_patients_by_modality(collection = "fake_collection", modality = "MR"))
  expect_equal(length(pat$body_parts), 0)
})

test_that("Invalid modality", {
  expect_warning(pat <- get_patients_by_modality(collection = "TCGA-BRCA", modality = "fake_modality"))
  suppressWarnings(pat <- get_patients_by_modality(collection = "TCGA-BRCA", modality = "fake_modality"))
  expect_equal(length(pat$body_parts), 0)
})


