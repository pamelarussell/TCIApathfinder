message("\nTesting get_sop_instance_uids")

patients_tcga_mr <- get_patients_by_modality(collection = "TCGA-BRCA", modality = "MR")
uids <- get_sop_instance_uids("1.3.6.1.4.1.14519.5.2.1.5382.4002.806935685832642465081499816867")

test_that("Structure of SOPInstanceUIDs value", {
  expect_equal(length(uids), 3)
  expect_true(length(uids$sop_instance_uids) > 10)
  expect_true(length(uids$content) > 10)
  expect_equal(class(uids$response), "response")
})

test_that("Patient values for TCGA-BRCA and MR", {
  expect_true("1.3.6.1.4.1.14519.5.2.1.5382.4002.257663256941568276393774062283" %in% uids$sop_instance_uids)
})

test_that("Invalid series", {
  expect_warning(u <- get_sop_instance_uids("fake_series"))
  suppressWarnings(u <- get_sop_instance_uids("fake_series"))
  expect_equal(length(u$sop_instance_uids), 0)
})

