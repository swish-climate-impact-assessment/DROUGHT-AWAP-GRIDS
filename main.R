
'name:main'
# Project: DROUGHT-AWAP-GRIDS
# Author: Your Name
# Maintainer: Who to complain to <yourfault@somewhere.net>

# This is the main file for the project
# It should do very little except call the other files

### Set the working directory
projdir <- "~/projects/DROUGHT-AWAP-GRIDS"
setwd(projdir)

'name:extract from awapgrids'

indir  <- "~/data/AWAP_GRIDS/data"
infilelist <- dir(indir, pattern = ".tif$", full.names=T)
infilelist <- infilelist[grep("total", infilelist)]
infilelist[grep("200001", infilelist)]

for(ste in c("act", "nsw", "nt",  "qld", "sa",  "tas", "vic", "wa")){
#  ste  <- "act"
  outfile_main  <- paste("rain_", ste, "1900_2015.csv", sep  = "")
  indir_shp <- "~/projects/DROUGHT-BOM-GRIDS/data_derived"
  #gsub("\\.shp","",gsub("grid_", "", dir(indir_shp, pattern = ".shp")))
  setwd(indir_shp)
  shp  <- readOGR(".", sprintf("grid_%s", ste))
  setwd(projdir)
  
  
  #str(shp)
  shp2 <- rgeos::gCentroid(shp, byid = T)
#  plot(shp)
#  plot(shp2, add = T, pch = 16)


    
for(i in 1:100){ # length(infilelist)){
  #i = 1
  infile <- infilelist[i]
  outfile <- gsub(".tif", "", basename(infile))
  y  <- substr(basename(infile), 8, 8 +3)
  m  <- substr(basename(infile), 8 +4, 8+5)
  
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
