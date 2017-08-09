message("\nTesting get_patients")

suppressPackageStartupMessages(library(dplyr))

patients_all <- get_patients()
patients_tcga <- get_patients("TCGA-BRCA")

test_that("Structure of patients value", {
  expect_equal(length(patients_tcga), 3)
  expect_equal(ncol(patients_tcga$patients), 6)
  expect_true(nrow(patients_tcga$patients) > 50)
  expect_true(length(patients_tcga$content) > 50)
  expect_equal(class(patients_tcga$response), "response")
})

test_that("Number of all patients", {
  expect_true(nrow(patients_all$patients) > 5000)
  expect_true("TCGA-OL-A6VO" %in% patients_all$patients$patient_id)
  expect_true("TCGA-OL-A6VO" %in% patients_all$patients$patient_name)
  expect_true("F" %in% patients_all$patients$patient_sex)
  expect_true("TCGA-BRCA" %in% patients_all$patients$collection)
})

test_that("Number of BRCA patients", {
  expect_true(nrow(patients_tcga$patients) > 50)
  expect_true("TCGA-OL-A6VO" %in% patients_tcga$patients$patient_id)
})

test_that("Individual BRCA patient", {
  pid <- "TCGA-OL-A6VO"
  one_patient <- patients_all$patients %>% dplyr::filter(patient_id == pid)
  expect_identical(pid, as.character(one_patient[1, "patient_name"]))
  expect_identical("F", as.character(one_patient[1, "patient_sex"]))
  expect_identical("TCGA-BRCA", as.character(one_patient[1, "collection"]))
  expect_equal(NA, one_patient[1, "patient_dob"])
  expect_equal(NA, one_patient[1, "patient_ethnic_group"])
})

test_that("Invalid collection name", {
  expect_warning(patients <- get_patients("fake collection"))
  suppressWarnings(patients <- get_patients("fake collection"))
  expect_equal(length(patients$content), 0)
})

