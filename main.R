
'name:main'
# Project: DROUGHT-AWAP-GRIDS
# Author: Your Name
# Maintainer: Who to complain to <yourfault@somewhere.net>

# This is the main file for the project
# It should do very little except call the other files

### Set the working directory
projdir <- "~/projects/DROUGHT-AWAP-GRIDS/DROUGHT_AWAP_GRIDS_1900_2015"
setwd(projdir)
source("code/func.R")

'name:extract from awapgrids'

indir  <- "~/ResearchData/AWAP_GRIDS/AWAP_GRIDS_1900_2015/data"
dir(indir)
infilelist <- dir(indir, pattern = ".tif$", full.names=T)
infilelist <- infilelist[grep("total", infilelist)]
infilelist[grep("200001", infilelist)]
states  <- c("act", "nsw", "nt",  "qld", "sa",  "tas", "vic", "wa")
for(ste in states[1:4]){
#  ste  <- "act"
  outfile_main  <- paste("rain_", ste, "_1900_2015.csv", sep  = "")
  indir_shp <- "~/ResearchData/DROUGHT-BOM-GRIDS/data_derived"
  #gsub("\\.shp","",gsub("grid_", "", dir(indir_shp, pattern = ".shp")))
  setwd(indir_shp)
  shp  <- readOGR(".", sprintf("grid_%s", ste))
  setwd(projdir)


  #str(shp)
  shp2 <- rgeos::gCentroid(shp, byid = T)
#  plot(shp)
#  plot(shp2, add = T, pch = 16)



for(i in 1:length(infilelist)){
  #i = 1
  infile <- infilelist[i]
  outfile <- gsub("GTif_", "", gsub(".tif", "", basename(infile)))
  y  <- substr(outfile, 8, 8 +3)
  m  <- substr(outfile, 8 +4, 8+5)

  #print(infile)
  r  <- raster(infile)
  shpout <- shp
  #plot(r)
  #plot(shp2, add = T)
  #shp2 <- shp
  e <- extract(r, shp2)
  #str(e)
  #e[1]
  shpout@data <- data.frame(shp@data, e)
  #str(shpout@data)
  #dir()
  #writeOGR(shpout, "data_derived",
  #  outfile
  #  , driver = "ESRI Shapefile", overwrite_layer=T)
  csvout <- shpout@data
  csvout$the_geom  <- NULL
  csvout$the_geom_p  <- NULL
  csvout$wronglatit  <- NULL
  csvout$admin_name  <- NULL
  names(csvout) <- gsub("^e$", "rain", names(csvout))
  csvout$year <- as.numeric(y)
  csvout$month <- as.numeric(m)
#  str(csvout)
  write.table(csvout,
            file.path("data_derived", outfile_main)
            , sep = ",", append = i != 1,
            col.names = i == 1, row.names = F)
}
}
