
'name:do_convert2shp'
projdir <- "~/projects/DROUGHT-AWAP-GRIDS/DROUGHT_AWAP_GRIDS_1900_2015"
setwd(projdir)
source("code/func.R")

indir_data <- "/home/ResearchData/DROUGHT-AWAP-GRIDS/DROUGHT_AWAP_GRIDS_1900_2015/data_derived"
dir.create("data_derived_shapefiles")


states  <- c("act",  "nt",  "qld", "sa",  "tas", "vic", "wa") # "nsw",
# do one at a time so can do 7zip before mv and chmod
for(ste in states[1]){
  #ste  <- "vic"

  indir_shp <- "~/ResearchData/DROUGHT-BOM-GRIDS/data_derived"
  #gsub("\\.shp","",gsub("grid_", "", dir(indir_shp, pattern = ".shp")))
  setwd(indir_shp)
  shp  <- readOGR(".", sprintf("grid_%s", ste))
  setwd(projdir)
  #plot(shp)
#for(m_i in c(6, 12)){
  m_i  <- 6
  infile <- paste("rain_",ste,"_1900_2015_drought",m_i,".csv", sep = "")
  indat <- read.csv(file.path(indir_data, infile), as.is = T)
  #str(indat)
  head(indat)
  # do loop
  for(y in c(1900:2015)){
    #y  <- 2015
    for(m in 1:12){
    # m  <- 1
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
#}
}
dir("data_derived_shapefiles")
source("~/tools/disentangle/R/checkout7z.R")
cmd  <- checkout7z(dirlist = "data_derived_shapefiles/"
                   ,
                   archive_id = "drought_awap_grids_1900_2015_act_roll6",
                   loc_7z = "7z")
cat(cmd)
dir()
system(cmd)

# and then from shell, as sudo
"
mv /home/ivan_hanigan/projects/DROUGHT-AWAP-GRIDS/DROUGHT_AWAP_GRIDS_1900_2015/data_derived_shapefiles/* /home/ResearchData/DROUGHT-AWAP-GRIDS/DROUGHT_AWAP_GRIDS_1900_2015/data_derived_shapefiles/

chown -R root:researchdata /home/ResearchData/DROUGHT-AWAP-GRIDS/DROUGHT_AWAP_GRIDS_1900_2015/data_derived_shapefiles/

"
