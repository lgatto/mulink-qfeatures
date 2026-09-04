library(scp)
library(scpdata)

source("R/io_converter.R")

scp <- brunner2022()

writeLinkH5MU(
  scp,
  "brunner2022.h5mu",
  feature_mapping_key = "Protein.Group"
)

scp_from_h5mu <- readLinkH5MU(
  "brunner2022.h5mu",
  feature_mapping_key = "Protein.Group"
)
# Warning message:
# sampleMap[['assay']] coerced with as.factor()

## some validation
library(waldo)
validation_tolerance <- 0.000001

waldo::compare(scp, scp_from_h5mu, tolerance = validation_tolerance)
length(scp) == length(scp_from_h5mu)

old_assay <- assay(scp, length(scp))
new_assay <- assay(scp_from_h5mu, length(scp_from_h5mu))
all.equal(old_assay, new_assay, check.attributes = TRUE)
# TRUE
waldo::compare(old_assay, new_assay, tolerance = validation_tolerance)
# ✔ No differences

old_rowdata <- rowData(scp)[[length(scp)]]
new_rowdata <- rowData(scp_from_h5mu)[[length(scp_from_h5mu)]]
all.equal(old_rowdata, new_rowdata, check.attributes = TRUE)
# TRUE
waldo::compare(old_rowdata, new_rowdata, tolerance = validation_tolerance)
# ✔ No differences

old_coldata <- colData(scp)
new_coldata <- colData(scp_from_h5mu)
all.equal(old_coldata, new_coldata, check.attributes = TRUE)
# TRUE
waldo::compare(old_coldata, new_coldata, tolerance = validation_tolerance)
# ✔ No differences
