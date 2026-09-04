
library(scp)
library(scpdata)

## Get the QFeatures data
scp <- derks2022()

source("R/io_converter.R")

writeLinkH5MU(scp, "data/derks2022.h5mu")

