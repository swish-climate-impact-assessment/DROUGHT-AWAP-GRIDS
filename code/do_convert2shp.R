
'name:do_convert2shp'
projdir <- "~/projects/DROUGHT-AWAP-GRIDS/DROUGHT_AWAP_GRIDS_1900_2015"
setwd(projdir)
source("code/func.R")
states  <- c("act",  "nt",  "qld", "sa",  "tas", "vic", "wa") # "nsw",
for(ste in states){
 # ste  <- "nsw"

  indir_shp <- "~/projects/DROUGHT-BOM-GRIDS/data_derived"
  #gsub("\\.shp","",gsub("grid_", "", dir(indir_shp, pattern = ".shp")))
  setwd(indir_shp)
  shp  <- readOGR(".", sprintf("grid_%s", ste))
  setwd(projdir)
  #plot(shp)
for(m_i in c(6, 12)){
  #m_i  <- 6
  infile <- paste("rain_",ste,"_1900_2015_drought",m_i,".csv", sep = "")
  indat <- read.csv(file.path("data_derived", infile), as.is = T)
  #str(indat)
  head(indat)
  # do loop
  for(y in c(1986:2001,2004:2012)){
    #y  <- 2015
    for(m in 1:12){
    # m  <- 12
    m2 <- sprintf("%02d", m)
  outfile_main  <- paste("drought_awap_grids_", ste, "_",y,"_",m2,"_roll",m_i, sep  = "")

  indat_i <- indat[indat$year == y & indat$month == m,]
  #indat_i$drought_count_5  <- ifelse(indat_i$count >= 5, 1, 0)
  #str(indat_i)
  outdat <- shp
  outdat@data <- data.frame(outdat@data, indat_i[match(outdat@data[,"gid"], indat_i[,"gid"]),])
  writeOGR(outdat, "data_derived_shapefiles",
   outfile_main
   , driver = "ESRI Shapefile", overwrite_layer=T)
    }
  }
}
}
