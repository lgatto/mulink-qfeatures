
library(scp)
library(scpdata)

## Get the QFeatures data
scp <- woo2022_macrophage()

source("R/io_converter.R")

writeLinkH5MU(scp, "data/woo2022_macrophage.h5mu")

scp_test <- readLinkH5MU("data/woo2022_macrophage.h5mu")

## Differences between objects before and after write/read
## 1. NA vs NaN
head(rowData(scp[[1]])$Fraction.1)
head(rowData(scp_test[[1]])$Fraction.1)

## 2. feature ids
head(rownames(scp[[1]]))
head(rownames(scp_test[[1]]))

## 3. new column in rowData named "mulink_feature_id"
tail(names(rowData(scp_test[[1]])))
tail(names(rowData(scp[[1]])))

## 4. integer/double
typeof(rowData(scp[[1]])$Fraction.1)
typeof(rowData(scp_test[[1]])$Fraction.1)

## Making the assays identical (to be sure nothing else is different)
## NaN --> NA, in this case missing values only in rowData but can be 
## also in assay or colData
rd <- rowData(scp_test[[1]])
for (col in colnames(rd)) {
  if (is.numeric(rd[[col]])) {
    rd[[col]][!is.finite(rd[[col]])] <- NA 
  }
}
rowData(scp_test[[1]]) <- rd

## Change feature ids 
rownames(scp_test[[1]]) <- sub(".*:", "", rownames(scp_test[[1]]))

## Drop additional column
rowData(scp_test[[1]])$mulink_feature_id <- NULL

## solve integer/double issue
rd_orig <- rowData(scp[[1]])
rd_new <- rowData(scp_test[[1]])
for (col in colnames(rd_new)) {
  if (col %in% colnames(rd_orig) && is.integer(rd_orig[[col]]) && 
      is.numeric(rd_new[[col]])) {
    rd_new[[col]] <- as.integer(rd_new[[col]])
  }
}
rowData(scp_test[[1]]) <- rd_new

## Update dimension names
mat <- assay(scp_test[[1]], withDimnames = FALSE)
dimnames(mat) <- dimnames(assay(scp[[1]], withDimnames = FALSE))
assay(scp_test[[1]], withDimnames = FALSE) <- mat

## verify
library(waldo)
compare(assay(scp[[1]]), assay(scp_test[[1]]))
compare(colData(scp[[1]]), colData(scp_test[[1]]))
compare(rowData(scp[[1]]), rowData(scp_test[[1]]))
compare(scp[[1]], scp_test[[1]])

