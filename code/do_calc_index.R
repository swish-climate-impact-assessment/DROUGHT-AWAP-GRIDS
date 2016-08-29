
'name:step 3 calculate drought index'
projdir <- "~/projects/DROUGHT-AWAP-GRIDS"
setwd(projdir)
source("code/func.R")
library(HutchinsonDroughtIndex)
indir <- "data_derived"

states  <- c("act", "nsw", "nt",  "qld", "sa",  "tas", "vic", "wa")

for(ste in states){
#  ste  <- "act"
infile <- paste("rain_",ste,"_1900_2015.csv", sep = "")
outfile_main  <- paste("rain_",ste,"_1900_2015_drought.csv", sep = "")
dat <- read.csv(file.path(indir, infile), as.is = T)
#str(dat)

dat$date  <- as.Date(paste(dat$year, dat$month, 1, sep = "-"))
dat <- dat[,c("gid", "date","year","month","rain")]
#tail(dat)
#head(dat)

  ##############################################
  # do the drought algorithm
  gids <- names(table(dat$gid))
  #gids
  for(i in 1:length(gids)){
  #  gid_i  <- gids[1]
    gid_i <- gids[i]
    dat_i <- dat[dat$gid == gid_i,c("date", "year", "month", "rain")]
  #str(dat_i)
  drt <- drought_index_stations(
    data=dat_i
    ,
    years=length(names(table(dat$year)))
    ,
    M = 6
    ,
    droughtThreshold = 0.375
    )
  #head(drt)
  drt$gid  <- gid_i
  write.table(drt,
            file.path("data_derived", outfile_main)
            , sep = ",", append = i != 1,
            col.names = i == 1, row.names = F)
   
  }

}
