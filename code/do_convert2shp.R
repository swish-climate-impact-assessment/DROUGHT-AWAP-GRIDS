
'name:do_convert2shp'
projdir <- "~/projects/DROUGHT-AWAP-GRIDS"
setwd(projdir)
source("code/func.R")
states  <- c("act", "nsw", "nt",  "qld", "sa",  "tas", "vic", "wa")
#for(ste in states[1:4]){
  ste  <- "nsw"

  indir_shp <- "~/projects/DROUGHT-BOM-GRIDS/data_derived"
  #gsub("\\.shp","",gsub("grid_", "", dir(indir_shp, pattern = ".shp")))
  setwd(indir_shp)
  shp  <- readOGR(".", sprintf("grid_%s", ste))
  setwd(projdir)
  #plot(shp)
  infile <- paste("rain_",ste,"_1900_2015_drought.csv", sep = "")
  indat <- read.csv(file.path("data_derived", infile), as.is = T)
  #str(indat)
  head(indat)
  # do loop
  for(y in c(2002:2003)){
   # y  <- 2004
    for(m in 1:12){
    #  m  <- 4
    m2 <- sprintf("%02d", m)
  outfile_main  <- paste("drought_awap_grids_", ste, "_",y,"_",m2, sep  = "")

  indat_i <- indat[indat$year == y & indat$month == m,]
  indat_i$drought_count_5  <- ifelse(indat_i$count >= 5, 1, 0)
  #str(indat_i)
  outdat <- shp
  outdat@data <- data.frame(outdat@data, indat_i[match(outdat@data[,"gid"], indat_i[,"gid"]),])
  writeOGR(outdat, "data_derived_shapefiles",
   outfile_main
   , driver = "ESRI Shapefile", overwrite_layer=T)
    }
  }
#}
