
test_that("Structure of patients value", {
  patients <- get_patient_ids("TCGA-BRCA")
  expect_equal(length(patients), 3)
  expect_true(length(patients$patient_ids) > 50)
  expect_true(length(patients$content) > 50)
  expect_equal(class(patients$response), "response")
})

test_that("Number of all patients", {
  patients <- get_patient_ids()
  expect_true(length(patients$patient_ids) > 5000)
  expect_true("TCGA-OL-A6VO" %in% patients$patient_ids)
})

test_that("Number of BRCA patients", {
  patients <- get_patient_ids("TCGA-BRCA")
  expect_true(length(patients$patient_ids) > 50)
  expect_true("TCGA-OL-A6VO" %in% patients$patient_ids)
})

test_that("Invalid collection name", {
  expect_warning(patients <- get_patient_ids("fake collection"))
  suppressWarnings(patients <- get_patient_ids("fake collection"))
  expect_equal(length(patients$content), 0)
})

