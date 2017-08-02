
test_that("Structure of manufacturers value", {
  man <- get_manufacturer_names()
  expect_equal(length(man), 3)
  expect_true(length(man$manufacturer_names) > 50)
  expect_true(length(man$content) > 50)
  expect_equal(class(man$response), "response")
})

test_that("Manufacturer names for TCGA-BRCA", {
  man <- get_manufacturer_names(collection = "TCGA-BRCA")
  expect_true(length(man$manufacturer_names) > 3)
  expect_true("SIEMENS" %in% man$manufacturer_names)
})

test_that("Manufacturer names for breast", {
  man <- get_manufacturer_names(body_part = "BREAST")
  expect_true(length(man$manufacturer_names) > 3)
  expect_true("SIEMENS" %in% man$manufacturer_names)
})

test_that("Manufacturer names for MR", {
  man <- get_manufacturer_names(modality = "MR")
  expect_true(length(man$manufacturer_names) > 20)
  expect_true("GE MEDICAL SYSTEMS" %in% man$manufacturer_names)
})

test_that("Manufacturer names for TCGA-BRCA and breast", {
  man <- get_manufacturer_names(collection = "TCGA-BRCA", body_part = "BREAST")
  expect_true(length(man$manufacturer_names) > 3)
  expect_true("SIEMENS" %in% man$manufacturer_names)
})

test_that("Manufacturer names for TCGA-BRCA and MR", {
  man <- get_manufacturer_names(collection = "TCGA-BRCA", modality = "MR")
  expect_true(length(man$manufacturer_names) > 3)
  expect_true("SIEMENS" %in% man$manufacturer_names)
})

test_that("Manufacturer names for breast and MR", {
  man <- get_manufacturer_names(body_part = "BREAST", modality = "MR")
  expect_true(length(man$manufacturer_names) > 3)
  expect_true("SIEMENS" %in% man$manufacturer_names)
})

test_that("Manufacturer names for TCGA-BRCA, breast, and MR", {
  man <- get_manufacturer_names(collection = "TCGA-BRCA", body_part = "BREAST", modality = "MR")
  expect_true(length(man$manufacturer_names) > 3)
  expect_true("SIEMENS" %in% man$manufacturer_names)
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



