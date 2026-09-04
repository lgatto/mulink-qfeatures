library(scp)
library(scpdata)

source("R/io_converter.R")

scp <- brunner2022()

writeLinkH5MU(scp, "brunner.h5mu")
