library(dplyr)

source("script/Script_CT_calibration.R")
source("script/Script_SrCa_date_proxi.R")
#Removing the last values because they was not working (to modifie)
data_srca = read.csv("modified_data/SrCa/dated_TROM2_SrCaForRomain.csv", header=T,sep=" ")
data_srca = data_srca[data_srca$date!="0-01-01",]
data_climate = read.table("data/climate_data/tromelin_reunion.txt", header=T)
data_climate$date = strptime(data_climate$date, format = "%Y-%m-%d")

plot(as.POSIXct(data_srca$date), data_srca$SrCa_ratio, type = "l")

#Import and get density from TROM2 CT scans
data_dens = read.csv("data/CT/csv/TROM2.csv", header=T)
data_dens$dens = get_density(data_dens$HU, lm_model = lm_model)


#Creation of data interval because the density-distance was evaluated each 0.1mm
#and Sr/Ca interval is 0.5mm (for exemple, but it will adapt on your dataset interval)
intervalle = unique(diff(data_srca$distance))
donnees_reduites <- aggregate(dens ~ cut(distance, breaks = seq(0, max(data_dens$distance) + intervalle, by = intervalle)),
                              data = data_dens, FUN = function(x) c(mean = mean(x)))
donnees_reduites = donnees_reduites$dens
diff = abs(length(data_srca$date)-length(donnees_reduites))
diff = rep(NA, diff)

donnees_reduites = c(donnees_reduites,diff)
dataset = data.frame(distance = data_srca$distance,
                     date = data_srca$date,
                     SrCa = data_srca$SrCa_ratio,
                     density = donnees_reduites,
                     fix.empty.names = F)
test = inner_join(dataset, data_climate, by = "date")
final_data = data.frame(distance =test$distance,
                        date = test$date,
                        SrCa = test$SrCa,
                        density = test$density,
                        SST = test$SST90th_HS)

plot(as.POSIXct(dataset$date), dataset$density, type = "l")
points(as.POSIXct(dataset$date), dataset$SrCa, type = "l")

seq = seq(from = min(data_climate$date), to = max(data_climate$date),
          by =30000000)

par(mar = c(5, 4, 4, 4)+0.3, mfrow= c(2,1),mai = c(0, 1, 1, 1))
plot(as.POSIXct(dataset$date), dataset$density, type = "l", xlab = "", ylab = "Estimated density", axes = F)
axis(side = 2)
for (i in seq_along(seq)){
  abline(v = seq[as.POSIXct(i)], col = "gray", lty = 2)
}

par(new = TRUE)

plot(as.POSIXct(dataset$date), dataset$SrCa, type = "l", axes = FALSE, bty = "n", xlab = "", ylab = "", col ="red")
axis(side=4, at = pretty(range(dataset$SrCa)), col="red",col.axis = "red")
mtext("SrCa Ratio",side=4,col="red",line=2)

par(mai = c(1, 1, 0, 1))
plot(as.POSIXct(data_climate$date), data_climate$SST90th_HS,
     type = "l", xlim = as.POSIXct(c(min(dataset$date), max(dataset$date))),
     axes = F, ylab = "SST (in°C)", xlab = "Year")

axis.POSIXct(1, data_climate$date, format = "%Y",
             at = seq)
axis(side = 2)
for (i in seq_along(seq)){
  abline(v = seq[as.POSIXct(i)], col = "gray", lty = 2)
}

climate_crop = data_climate[data_climate$date >= min(dataset$date),]
climate_crop = climate_crop[climate_crop$date <= max(dataset$date),]

dataset$date = strptime(dataset$date, format = "%Y-%m-%d")
test = inner_join(dataset, data_climate, by = "date")
final_data = data.frame(distance =test$distance, date = test$date, SrCa = test$SrCa, density = test$density, SST = test$SST90th_HS)

dev.off()

library(nlme)

#Stat model creation. Evidence of relationship between SrCa Ratio and SST
spherique_model = gls(SST ~ SrCa, data = final_data, correlation = corSpher(form = ~ 1, nugget = TRUE))
lm_model = gls(SST ~ SrCa, data = final_data)
hist(spherique_model$residuals)
plot(spherique_model$fitted, spherique_model$residuals)
AIC(spherique_model)
AIC(lm_model)

#Spheric model better but lm model respect more AC
#/!\ So I take lm model ^^
hist(spherique_model$residuals)
hist(lm_model$residuals)

plot(lm_model$fitted, lm_model$residuals)
plot(spherique_model$fitted, spherique_model$residuals)


plot( final_data$SST,final_data$SrCa)
abline(lm(final_data$SrCa~final_data$SST))
text(final_data$SST,final_data$SrCa, label = final_data$date)
anova(lm(final_data$SST~ final_data$SrCa))

