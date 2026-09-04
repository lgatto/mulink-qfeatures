source("R/io_converter.R")
source("R/convert_dates.R")
library(waldo)
library(scpdata)

leduc <- leduc2022_pSCoPE()


leduc_processed <- convert_date_qfeatures(leduc)

writeLinkH5MU(leduc_processed, "data/leduc2022.h5mu", overwrite = TRUE)

leduc2 <- readLinkH5MU("data/leduc2022.h5mu")

identical(leduc_processed, leduc2)

compare(leduc_processed[[1]], leduc2[[1]])
