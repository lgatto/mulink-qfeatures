library(scp)
library(scpdata)

source("R/io_converter.R")

scp <- woo2022_lung()

writeLinkH5MU(
  scp,
  "data/woo2022_lung.h5mu",
  feature_mapping_key = "Leading.razor.protein"
)
# Warning message:
# Cast NA-bearing integer/logical column(s) ... to double, which MuData encodes
# in a form Python can read. See cast_nullable_columns().

scp_from_h5mu <- readLinkH5MU(
  "data/woo2022_lung.h5mu",
  feature_mapping_key = "Leading.razor.protein"
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
# "Attributes: < Component “dimnames”: Component 1: 1243 string mismatches >"
waldo::compare(old_assay, new_assay, tolerance = validation_tolerance)
# "A0A096LP55;P07919" -> "proteins_LFQ:A0A096LP55;P07919", etc.

old_rowdata <- rowData(scp)[[length(scp)]]
new_rowdata <- rowData(scp_from_h5mu)[[length(scp_from_h5mu)]]
all.equal(old_rowdata, new_rowdata, check.attributes = TRUE)
# "Lengths: 37, 38"
# "Names: Lengths (37, 38) differ (string compare on first 37)"
# "Attributes: < Component “listData”: Length mismatch: comparison on first 37 components >"
# "Attributes: < Component “rownames”: 1243 string mismatches >"
waldo::compare(old_rowdata, new_rowdata, tolerance = validation_tolerance)
# "A0A096LP55;P07919" -> "proteins_LFQ:A0A096LP55;P07919", etc.
# `names(old@listData)[35:37]`: "Best.MS.MS" "Oxidation..M..site.IDs" "Oxidation..M..site.positions"
# `names(new@listData)[35:38]`: "Best.MS.MS" "Oxidation..M..site.IDs" "Oxidation..M..site.positions" "mulink_feature_id"
# `old@listData$mulink_feature_id` is absent
# `new@listData$mulink_feature_id` is a character vector ('A0A096LP55;P07919', 'P0DPI2;A0A0B4J2D5', 'A0FGR8', 'A2RUH7', 'A8K2U0', ...)

old_coldata <- colData(scp)
new_coldata <- colData(scp_from_h5mu)
all.equal(old_coldata, new_coldata, check.attributes = TRUE)
# TRUE
waldo::compare(old_coldata, new_coldata, tolerance = validation_tolerance)
# ✔ No differences
