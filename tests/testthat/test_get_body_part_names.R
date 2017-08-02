
test_that("Structure of body parts value", {
  bp <- get_body_part_names()
  expect_equal(length(bp), 3)
  expect_true(length(bp$body_parts) > 20)
  expect_true(length(bp$content) > 20)
  expect_equal(class(bp$response), "response")
})

test_that("Body part values for TCGA-BRCA", {
  bp <- get_body_part_names(collection = "TCGA-BRCA")
  expect_identical(bp$body_parts, c("BREAST"))
})

test_that("Body part values for MR", {
  bp <- get_body_part_names(modality = "MR")
  expect_true(length(bp$body_parts) > 10)
  expect_true("BREAST" %in% bp$body_parts)
})

test_that("Body part values for TCGA-BRCA and MR", {
  bp <- get_body_part_names(collection = "TCGA-BRCA", modality = "MR")
  expect_identical(bp$body_parts, c("BREAST"))
})

test_that("Nonexistent collection and modality combination", {
  expect_warning(bp <- get_body_part_names(collection = "TCGA-BRCA", modality = "RTSTRUCT"))
  suppressWarnings(bp <- get_body_part_names(collection = "TCGA-BRCA", modality = "RTSTRUCT"))
  expect_equal(length(bp$body_parts), 0)
})

test_that("Invalid collection name", {
  expect_warning(bp <- get_body_part_names(collection = "fake_collection"))
  suppressWarnings(bp <- get_body_part_names(collection = "fake_collection"))
  expect_equal(length(bp$body_parts), 0)
})

test_that("Invalid modality", {
  expect_warning(bp <- get_body_part_names(modality = "fake_modality"))
  suppressWarnings(bp <- get_body_part_names(modality = "fake_modality"))
  expect_equal(length(bp$body_parts), 0)
})


