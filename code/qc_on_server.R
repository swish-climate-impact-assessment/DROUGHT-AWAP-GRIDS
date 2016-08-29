
'name:qc_on_server'
# with GID = 6378
write.csv(drt, file.path('data_derived/act_drought_1900_2015_20160829.csv'), row.names = F)
png("figures_and_tables/qc_act_drought.png")
par(mfrow = c(2,1))
plot(drt$date, drt$rain, type = "l")
plot(drt$date, drt$count2, type = "l")
segments(min(drt$date), 5, max(drt$date), 5)
dev.off()
  


# QC
# http://www.cbsnews.com/news/droughts-the-next-great-threat-to-iraq/
# this says drought from 2007 to 2010
qc <- drt[drt$year>=2000 & drt$year < 2016,]
head(qc, 12)
57.5+30.8+67.9+50.6+62.9+43.3

png(file.path('figures_and_tables','qc_act_drought_2000_2015.png'),res=200,width = 2100, height = 1000)
par(mfrow=c(4,1),mar=c(2.5,2,1.5,1))
plot(qc$date,qc$rain,type='l',main='ACT: raw monthly rainfall')
#points(qc$date,qc$rain)

lines(qc$date,qc$sixmnthtot/6, lwd = 2) #,type='l',main='6-monthly total rainfall')
points(qc$date,qc$sixmnthtot/6)

plot(qc$date,qc$index,type='l',main='Rescaled percentiles -4 to +4, -1 is Palmer Index Mild Drought',ylim=c(-4,4))
points(qc$date,qc$index)
segments(min(qc$date),-1,max(qc$date),-1)
segments(min(qc$date),0,max(qc$date),0,lty=2)
plot(qc$date,qc$count,type='l',main='Counts below -1 threshold, count of 5 or more is a drought')
points(qc$date,qc$count)
segments(min(qc$date),5,max(qc$date),5)

plot(qc$date,qc$count2,type='l',main='Enhanced counts of months if already passed count of 5 and percentiles less than 50%')
points(qc$date,qc$count2)
segments(min(qc$date),5,max(qc$date),5)
dev.off()


dir()
