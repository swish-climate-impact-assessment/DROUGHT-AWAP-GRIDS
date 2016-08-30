
'name:QC'
library(swishdbtools)
projdir <- "~/projects/DROUGHT-AWAP-GRIDS"
setwd(projdir)
source("code/func.R")

# QC
ch <- swishdbtools::connect2postgres2("ewedb_staging")
qc <- dbGetQuery(ch,
"select *
from bom_grids.rain_act_1890_2008_4
where year > 1978
")

str(qc)

# QC2
dir("data_derived")
infile <- "rain_act_1900_2015_drought.csv"
qc2 <- read.csv(file.path("data_derived", infile), as.is = T)
head(qc2)
table(qc2$gid)
head(table(qc2$gid))

qc3 <- merge(qc, qc2, by = c("gid", "year", "month"))
str(qc3)
qc3$date <- as.Date(qc3$date)
qc3 <- qc3[order(qc3$date),]
#png("figures_and_tables/qc_awap_vs_bom_act.png")
par(mfrow=c(2,2))
with(qc3,
     plot(rain.x, rain.y, col = as.factor(qc3$gid), pch = 16, cex = .6,
          ylim = c(0,450), xlim = c(0,450)
          )
     )
for(gid_i in names(table(qc3$gid))){
#  gid_i  <- names(table(qc3$gid))[1]
with(qc3[qc3$gid == gid_i,],
     plot(date, count.x, type = "l", lwd = 2
          )
     )
with(qc3[qc3$gid == gid_i,],
     lines(date, count.y, col = 'red')
     )
segments(min(qc3$date), 5, max(qc3$date))
title(gid_i)
}

dev.off()
