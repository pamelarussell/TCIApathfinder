## ----cache = T-----------------------------------------------------------
library(TCIApathfinder)

# Pick a patient of interest
patient <- "TCGA-AR-A1AQ"

# Get information on all image series for this patient
series <- get_series_info(patient_id = patient)

# Pick an image series to download
series_instance_uid <- as.character(series$series[1, "series_instance_uid"])

# Download and unzip the image series
ser <- save_image_series(series_instance_uid = series_instance_uid, out_dir = "~/Desktop", out_file_name = "series1.zip")
dicom_dir <- "~/Desktop/series1/"
unzip("~/Desktop/series1.zip", exdir = dicom_dir)

## ------------------------------------------------------------------------
suppressPackageStartupMessages(library(radiomics))

# Pick one of the image slices
img_array <- img_array_3d[, , 1]
img_matrix <- matrix(img_array, dim(img_array))

# Calculate basic image features
calc_features(img_matrix)

# Analyze the grey level co-occurrence matrix
glcm <- glcm(img_matrix)
calc_features(glcm)

