
'name:QC'

# QC
ch <- swishdbtools::connect2postgres2("ewedb_staging")
qc <- dbGetQuery(ch,
"select *
from bom_grids.rain_nsw_1890_2008_4
where year = 2000 and month = 1")

str(qc)
str(shpout@data)

qc2 <- merge(shpout@data, qc, by = "gid")
qc2$the_geom  <- NULL
head(qc2)
png("figures_and_tables/qc_awap_200001_vs_bomgrids.png")
plot(qc2$rain, qc2$e)
dev.off()

# QC2
qc2 <- read.csv(file.path("data_derived", outfile_main), as.is = T)
head(qc2)
qc2$date <- as.Date(paste(qc2$year, qc2$month, 1, sep = "-"))
head(table(qc2$gid))

qc3 <- dbGetQuery(ch,
"select *
from bom_grids.rain_nsw_1890_2008_4
where gid = 7568")
qc3$date <- as.Date(paste(qc3$year, qc3$month, 1, sep = "-"))

png("figures_and_tables/qc_awap_1900_1908_vs_bomgrids_west_wyalong.png")
with(qc2[qc2$gid == 7568,],
     plot(date, rain, type = "l")
     )
with(qc3[qc3$gid == 7568,],
     lines(date, rain, col = 'red')
     )
dev.off()

'name:QC'

# QC
ch <- swishdbtools::connect2postgres2("ewedb_staging")
qc <- dbGetQuery(ch,
"select *
from bom_grids.rain_nsw_1890_2008_4
where year = 1986 and month = 10")

str(qc)
str(shp@data)
outdata2 <- shp
outdata2@data <- data.frame(outdata2@data, qc[match(outdata2@data[,"gid"],
                                                    qc[,"gid"]),
                                              ])
dir("figures_and_tables")
writeOGR(outdata2, "figures_and_tables",
         "qc_drought_bom_grids_nsw_1986_10", driver = "ESRI Shapefile")
