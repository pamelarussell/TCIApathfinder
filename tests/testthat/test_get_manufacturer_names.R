message("\nTesting get_manufacturer_names")

manufacturers_all <- get_manufacturer_names()
manufacturers_tcga <- get_manufacturer_names(collection = "TCGA-BRCA")
manufacturers_breast <- get_manufacturer_names(body_part = "BREAST")
manufacturers_mr <- get_manufacturer_names(modality = "MR")
manufacturers_tcga_breast <- get_manufacturer_names(collection = "TCGA-BRCA", body_part = "BREAST")
manufacturers_tcga_mr <- get_manufacturer_names(collection = "TCGA-BRCA", modality = "MR")
manufacturers_breast_mr <- get_manufacturer_names(body_part = "BREAST", modality = "MR")
manufacturers_tcga_breast_mr <- get_manufacturer_names(collection = "TCGA-BRCA", body_part = "BREAST", modality = "MR")

test_that("Structure of manufacturers value", {
  expect_equal(length(manufacturers_all), 3)
  expect_true(length(manufacturers_all$manufacturer_names) > 50)
  expect_true(length(manufacturers_all$content) > 50)
  expect_equal(class(manufacturers_all$response), "response")
})

test_that("Manufacturer names for TCGA-BRCA", {
  expect_true(length(manufacturers_tcga$manufacturer_names) > 3)
  expect_true("SIEMENS" %in% manufacturers_tcga$manufacturer_names)
})

test_that("Manufacturer names for breast", {
  expect_true(length(manufacturers_breast$manufacturer_names) > 3)
  expect_true("SIEMENS" %in% manufacturers_breast$manufacturer_names)
})

test_that("Manufacturer names for MR", {
  expect_true(length(manufacturers_mr$manufacturer_names) > 20)
  expect_true("GE MEDICAL SYSTEMS" %in% manufacturers_mr$manufacturer_names)
})

test_that("Manufacturer names for TCGA-BRCA and breast", {
  expect_true(length(manufacturers_tcga_breast$manufacturer_names) > 3)
  expect_true("SIEMENS" %in% manufacturers_tcga_breast$manufacturer_names)
})

test_that("Manufacturer names for TCGA-BRCA and MR", {
  expect_true(length(manufacturers_tcga_mr$manufacturer_names) > 3)
  expect_true("SIEMENS" %in% manufacturers_tcga_mr$manufacturer_names)
})

test_that("Manufacturer names for breast and MR", {
  expect_true(length(manufacturers_breast_mr$manufacturer_names) > 3)
  expect_true("SIEMENS" %in% manufacturers_breast_mr$manufacturer_names)
})

test_that("Manufacturer names for TCGA-BRCA, breast, and MR", {
  expect_true(length(manufacturers_tcga_breast_mr$manufacturer_names) > 3)
  expect_true("SIEMENS" %in% manufacturers_tcga_breast_mr$manufacturer_names)
})

test_that("Nonexistent collection and body part combination", {
  expect_warning(man <- get_manufacturer_names(collection = "TCGA-BRCA", body_part = "LIVER"))
  suppressWarnings(man <- get_manufacturer_names(collection = "TCGA-BRCA", body_part = "LIVER"))
  expect_equal(length(man$manufacturer_names), 0)
})

test_that("Nonexistent collection and modality combination", {
  expect_warning(man <- get_manufacturer_names(collection = "TCGA-BRCA", modality = "RTSTRUCT"))
  suppressWarnings(man <- get_manufacturer_names(collection = "TCGA-BRCA", modality = "RTSTRUCT"))
  expect_equal(length(man$manufacturer_names), 0)
})

test_that("Nonexistent body part and modality combination", {
  expect_warning(man <- get_manufacturer_names(body_part = "BREAST", modality = "RTSTRUCT"))
  suppressWarnings(man <- get_manufacturer_names(body_part = "BREAST", modality = "RTSTRUCT"))
  expect_equal(length(man$manufacturer_names), 0)
})

test_that("Nonexistent collection, body part, modality combination", {
  expect_warning(man <- get_manufacturer_names(collection = "TCGA-BRCA", body_part = "BREAST", modality = "RTSTRUCT"))
  suppressWarnings(man <- get_manufacturer_names(collection = "TCGA-BRCA", body_part = "BREAST", modality = "RTSTRUCT"))
  expect_equal(length(man$manufacturer_names), 0)
})

test_that("Invalid collection name", {
  expect_warning(man <- get_manufacturer_names(collection = "fake_collection"))
  suppressWarnings(man <- get_manufacturer_names(collection = "fake_collection"))
  expect_equal(length(man$manufacturer_names), 0)
})

test_that("Invalid body part", {
  expect_warning(man <- get_manufacturer_names(body_part = "fake_body_part"))
  suppressWarnings(man <- get_manufacturer_names(body_part = "fake_body_part"))
  expect_equal(length(man$manufacturer_names), 0)
})

test_that("Invalid modality", {
  expect_warning(man <- get_manufacturer_names(modality = "fake_modality"))
  suppressWarnings(man <- get_manufacturer_names(modality = "fake_modality"))
  expect_equal(length(man$manufacturer_names), 0)
})



