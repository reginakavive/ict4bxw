# install.packages("ccafs")
# install.packages(ccafs_0.3.0.tar.gz, repos = NULL, type =‘‘source’’)


install.packages("C:/Users/dell/Downloads/ccafs_0.3.0.tar.gz", repos = NULL, type="source")

library(ccafs)
help("ccafs-search")

key <- "ccafs/ccafs-climate/data/ipcc_5ar_ciat_downscaled/rcp8_5/2050s/nimr_hadgem2_ao/30s/nimr_hadgem2_ao_rcp8_5_2050s_tmin_30s_r1i1p1_no_tile_asc.zip"

(res <- cc_data_fetch(key = key))
