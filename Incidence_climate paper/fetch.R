#install.packages("ccafs")
#install.packages(ccafs_0.3.0.tar.gz, repos = NULL, type =‘‘source’’)


#install.packages("C:/Users/dell/Downloads/ccafs_0.3.0.tar.gz", repos = NULL, type="source")

library(ccafs)
#help("ccafs-search")


key <- "ccafs/ccafs-climate/data/ipcc_5ar_ciat_tiled/rcp6_0/2050s/ncc_noresm1_m/30s/ncc_noresm1_m_rcp6_0_2050s_tmin_30s_r1i1p1_b4_asc.zip"

(res <- cc_data_fetch(key = key))

