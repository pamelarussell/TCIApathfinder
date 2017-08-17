
TCIApathfinder
==============

TCIApathfinder is a wrapper for The Cancer Imaging Archive's REST API v3. The Cancer Imaging Archive (TCIA) hosts de-identified medical images of cancer available for public download, as well as rich metadata for each image series. TCIA provides a REST API for programmatic access to the data. This package provides simple functions to access each API endpoint. For more information about TCIA, see TCIA's [website](http://www.cancerimagingarchive.net/).

Installation
------------

You can install TCIApathfinder from github with:

``` r
# install.packages("devtools")
devtools::install_github("pamelarussell/TCIApathfinder")
```

Authentication
--------------

An API key is required to access data from TCIA. To obtain and correctly store your API key:

1.  Request a key from TCIA by following the instructions [here](https://wiki.cancerimagingarchive.net/display/Public/TCIA+Programmatic+Interface+%28REST+API%29+Usage+Guide).

2.  Create a text file in your home directory (`~/`) called `.Renviron`.

3.  Create the contents of the `.Renviron` file like this, making sure the last line in the file is empty. Otherwise, R will silently fail to load the file.

<!-- -->

    TCIA_API_KEY=xxx-xxx-xxx-xxx

1.  Restart R. `.Renviron` is only processed at the beginning of an R session.

Examples
--------

### Load the package:

``` r
library(TCIApathfinder)
```

### Get the names of all TCIA collections:

``` r
collections <- get_collection_names()
head(collections$collection_names)
#> [1] "4D-Lung"               "BREAST-DIAGNOSIS"      "Breast-MRI-NACT-Pilot"
#> [4] "CBIS-DDSM"             "CC-Radiomics-Phantom"  "CT COLONOGRAPHY"
```

### Get the names of all imaging modalities

``` r
modalities <- get_modality_names()
head(modalities$modalities)
#> [1] "CR"   "CT"   "CTPT" "DX"   "MG"   "MR"
```

Note: a collection or body part can be specified to narrow down results.

### Get the names of all body parts studied:

``` r
body_parts <- get_body_part_names()
head(body_parts$body_parts)
#> [1] "ABDOMEN" "BLADDER" "BRAIN"   "BREAST"  "CERVIX"  "CHEST"
```

Note: a collection or modality can be specified to narrow down results.

### Get information for all patients in a collection

``` r
patients_tcga_brca <- get_patient_info(collection = "TCGA-BRCA")
head(patients_tcga_brca$patients)
#>     patient_id patient_name patient_dob patient_sex patient_ethnic_group
#> 1 TCGA-AR-A1AQ TCGA-AR-A1AQ          NA           F                   NA
#> 2 TCGA-AR-A24S TCGA-AR-A24S          NA           F                   NA
#> 3 TCGA-AR-A1AX TCGA-AR-A1AX          NA           F                   NA
#> 4 TCGA-AR-A24M TCGA-AR-A24M          NA           F                   NA
#> 5 TCGA-AR-A24R TCGA-AR-A24R          NA           F                   NA
#> 6 TCGA-AR-A24U TCGA-AR-A24U          NA           F                   NA
#>   collection
#> 1  TCGA-BRCA
#> 2  TCGA-BRCA
#> 3  TCGA-BRCA
#> 4  TCGA-BRCA
#> 5  TCGA-BRCA
#> 6  TCGA-BRCA
```

Note: if no collection is passed, patients for all collections are returned.

### Get all image series based on criteria

``` r
series <- get_series_info(patient_id = "TCGA-AR-A1AQ")
head(series$series)
#>   patient_id collection
#> 1         NA  TCGA-BRCA
#> 2         NA  TCGA-BRCA
#> 3         NA  TCGA-BRCA
#> 4         NA  TCGA-BRCA
#> 5         NA  TCGA-BRCA
#> 6         NA  TCGA-BRCA
#>                                                 study_instance_uid
#> 1 1.3.6.1.4.1.14519.5.2.1.3344.4002.307747749278929226311301198628
#> 2 1.3.6.1.4.1.14519.5.2.1.3344.4002.307747749278929226311301198628
#> 3 1.3.6.1.4.1.14519.5.2.1.3344.4002.307747749278929226311301198628
#> 4 1.3.6.1.4.1.14519.5.2.1.3344.4002.307747749278929226311301198628
#> 5 1.3.6.1.4.1.14519.5.2.1.3344.4002.307747749278929226311301198628
#> 6 1.3.6.1.4.1.14519.5.2.1.3344.4002.307747749278929226311301198628
#>                                                series_instance_uid
#> 1 1.3.6.1.4.1.14519.5.2.1.3344.4002.298037359751562809791703106256
#> 2 1.3.6.1.4.1.14519.5.2.1.3344.4002.305595410232153079624627348508
#> 3 1.3.6.1.4.1.14519.5.2.1.3344.4002.142000486987125226950494153345
#> 4 1.3.6.1.4.1.14519.5.2.1.3344.4002.176672261446738229459423756538
#> 5 1.3.6.1.4.1.14519.5.2.1.3344.4002.211084519843030234592826223931
#> 6 1.3.6.1.4.1.14519.5.2.1.3344.4002.240461194127099406985978695670
#>   modality   protocol_name series_date          series_description
#> 1       MR VIBRANT BREAST/  2001-11-21 (16139/8/216)-(16139/8/100)
#> 2       MR VIBRANT BREAST/  2001-11-21 (16139/8/448)-(16139/8/100)
#> 3       MR VIBRANT BREAST/  2001-11-21               LT SAG FSE T2
#> 4       MR VIBRANT BREAST/  2001-11-21                     VIBRANT
#> 5       MR VIBRANT BREAST/  2001-11-21                       ax t1
#> 6       MR VIBRANT BREAST/  2001-11-21                   ASSET CAL
#>   body_part_examined series_number annotations_flag       manufacturer
#> 1             BREAST    102.000000               NA GE MEDICAL SYSTEMS
#> 2             BREAST    104.000000               NA GE MEDICAL SYSTEMS
#> 3             BREAST      4.000000               NA GE MEDICAL SYSTEMS
#> 4             BREAST      8.000000               NA GE MEDICAL SYSTEMS
#> 5             BREAST      2.000000               NA GE MEDICAL SYSTEMS
#> 6             BREAST      7.000000               NA GE MEDICAL SYSTEMS
#>   manufacturer_model_name software_versions image_count
#> 1            SIGNA EXCITE              <NA>         116
#> 2            SIGNA EXCITE              <NA>         116
#> 3            SIGNA EXCITE                11          36
#> 4            SIGNA EXCITE                11         464
#> 5            SIGNA EXCITE                11          40
#> 6            SIGNA EXCITE                11          64
```

Note: other ways to narrow down results include

-   collection
-   study instance UID
-   series instance UID
-   modality
-   body part
-   manufacturer
-   manufacturer model name

### Get detailed information on all imaging studies for a patient

``` r
studies <- get_patient_studies(patient_id = "TCGA-AR-A1AQ")
head(studies$patient_studies)
#>     patient_id patient_name patient_dob patient_age patient_sex
#> 1 TCGA-AR-A1AQ TCGA-AR-A1AQ          NA        049Y           F
#> 2 TCGA-AR-A1AQ TCGA-AR-A1AQ          NA        050Y           F
#>   patient_ethnic_group admitting_diagnoses_description collection study_id
#> 1                   NA                              NA  TCGA-BRCA       NA
#> 2                   NA                              NA  TCGA-BRCA       NA
#>                                                 study_instance_uid
#> 1 1.3.6.1.4.1.14519.5.2.1.3344.4002.307747749278929226311301198628
#> 2 1.3.6.1.4.1.14519.5.2.1.3344.4002.100294194044853718189419781050
#>   study_date     study_description series_count
#> 1 2001-11-21         *MRI - BREAST           11
#> 2 2003-05-07 MRI BREAST, BILATERAL           12
```

The variables in `studies$patient_studies` correspond to the fields of a PatientStudy object as described in the [API documentation](https://wiki.cancerimagingarchive.net/display/Public/TCIA+API+Return+Values).

Note: other ways to narrow down results include a collection or a study instance UID.

### Get all imaging studies for a collection

``` r
studies_tcga_brca <- get_studies_in_collection(collection = "TCGA-BRCA")
head(studies_tcga_brca$studies)
#>   Collection    PatientID
#> 1  TCGA-BRCA TCGA-AR-A1AQ
#> 2  TCGA-BRCA TCGA-AR-A1AQ
#> 3  TCGA-BRCA TCGA-AR-A24S
#> 4  TCGA-BRCA TCGA-AR-A24S
#> 5  TCGA-BRCA TCGA-AR-A1AX
#> 6  TCGA-BRCA TCGA-AR-A1AX
#>                                                   StudyInstanceUID
#> 1 1.3.6.1.4.1.14519.5.2.1.3344.4002.307747749278929226311301198628
#> 2 1.3.6.1.4.1.14519.5.2.1.3344.4002.100294194044853718189419781050
#> 3 1.3.6.1.4.1.14519.5.2.1.3344.4002.249354313922816279857767035077
#> 4 1.3.6.1.4.1.14519.5.2.1.3344.4002.291701067965044082231683003194
#> 5 1.3.6.1.4.1.14519.5.2.1.3344.4002.217739545055639726726312661364
#> 6 1.3.6.1.4.1.14519.5.2.1.3344.4002.654345798623259073784018355235
```

Note: a patient ID can be provided to further narrow down results.

### Get individual DICOM image IDs for an image series

``` r
sop_uids <- get_sop_instance_uids(
  series_instance_uid = "1.3.6.1.4.1.14519.5.2.1.3344.4002.298037359751562809791703106256")
head(sop_uids$sop_instance_uids)
#> [1] "1.3.6.1.4.1.14519.5.2.1.3344.4002.103833384819234677052128156490"
#> [2] "1.3.6.1.4.1.14519.5.2.1.3344.4002.107594813336758156477053115154"
#> [3] "1.3.6.1.4.1.14519.5.2.1.3344.4002.108961012724040858986707256483"
#> [4] "1.3.6.1.4.1.14519.5.2.1.3344.4002.113224119964450170072494597907"
#> [5] "1.3.6.1.4.1.14519.5.2.1.3344.4002.114239357229984807449733158209"
#> [6] "1.3.6.1.4.1.14519.5.2.1.3344.4002.114874592963584770107488944633"
```

### Download a single DICOM image

``` r
im <- save_single_image(series_instance_uid = "1.3.6.1.4.1.14519.5.2.1.3344.4002.298037359751562809791703106256",
                  sop_instance_uid = "1.3.6.1.4.1.14519.5.2.1.3344.4002.113224119964450170072494597907",
                  out_dir = "~/Desktop")
im$out_file
#> [1] "~/Desktop/150.dcm"
```

Note: a file name can be provided to override the original file name.

### Download an image series as a zip file

``` r
ser <- save_image_series(series_instance_uid = "1.3.6.1.4.1.14519.5.2.1.3344.4002.298037359751562809791703106256",
                         out_dir = "~/Desktop", out_file_name = "series.zip")
ser$out_file
#> [1] "~/Desktop/series.zip"
```

### Additional functions

See package documentation for further details:

-   get\_series\_size
-   get\_manufacturer\_names
-   get\_new\_patients\_in\_collection
-   get\_new\_studies\_in\_collection
-   get\_patients\_by\_modality

More information on the TCIA REST API
-------------------------------------

-   [API usage guide](https://wiki.cancerimagingarchive.net/display/Public/TCIA+Programmatic+Interface+%28REST+API%29+Usage+Guide)
-   [Object type definitions](https://wiki.cancerimagingarchive.net/display/Public/TCIA+API+Return+Values)
