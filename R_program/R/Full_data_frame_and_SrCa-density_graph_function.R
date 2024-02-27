################################################
#Full data frame and SrCa/density graph function(dated)
#Romain Journaud - Coral Core analysis repository
#https://github.com/Rodrrig0/Coral-cores-analysis.git
#University CAU of Kiel
###########################################################
library(dplyr)

#As precision between Sr/Ca ratio and Density values are different,
#This function permit to reduce the precision of density value.
# Later, it will thanks to have a unique data.frame with corresponding density of Sr/Ca value
full_data_frame = function(data_srca, data_dens){

  interpolated <- approx(data_dens$distance, data_dens$dens, xout = data_srca$distance)$y
  dataset = data.frame(distance = data_srca$distance,
                       date = data_srca$date,
                       SrCa = data_srca$SrCa_ratio,
                       density = interpolated,
                       fix.empty.names = F)
  dataset$date = strptime(dataset$date, format = "%Y-%m-%d")
  test = inner_join(dataset, data_climate, by = "date")
  final_data = data.frame(distance =test$distance,
                          date = test$date,
                          SrCa = test$SrCa,
                          density = test$density,
                          SST = test$SST90th_HS)
}

#Creation of the Sr/Ca ratio, density and SST comparison line chart.
srca_SST_density_graph = function(){
  #sequence for having one year scale ticks
  seq = seq(from = min(final_data$date), to = max(final_data$date),
            by ="1 year")
  title = strsplit(data_dens_name, split = "/")[[1]][4]

  par(mar = c(5, 4, 4, 4)+0.3, mfrow= c(2,1),mai = c(0, 1, 1, 1))
  #Plot the density
  plot(as.POSIXct(final_data$date), final_data$density, type = "l",
       xlab = "", ylab = "Estimated density", main = title,
       axes = F)
  axis(side = 2)
  #Trace lines
  for (i in seq_along(seq)){
    abline(v = seq[as.POSIXct(i)], col = "gray", lty = 2)
  }

  par(new = TRUE)
  #Plot the Sr/Ca ratio at the same place than density chart
  plot(as.POSIXct(final_data$date), final_data$SrCa, type = "l", axes = FALSE, bty = "n", xlab = "", ylab = "", col ="red",
       ylim = c(max(final_data$SrCa), min(final_data$SrCa)))
  axis(side=4, at = pretty(range(final_data$SrCa)), col="red",col.axis = "red")
  mtext("SrCa Ratio",side=4,col="red",line=2)

  #Plot the SST below the density/Sr/Ca chart
  par(mai = c(1, 1, 0, 1))
  plot(as.POSIXct(data_climate$date), data_climate$SST90th_HS,
       type = "l", xlim = as.POSIXct(c(min(final_data$date), max(final_data$date))),
       axes = F, ylab = "SST (in°C)", xlab = "Year")

  axis.POSIXct(1, at = as.POSIXct(seq), labels = format(as.POSIXct(seq), "%Y"))
  axis(side = 2)
  for (i in seq_along(seq)){
    abline(v = seq[as.POSIXct(i)], col = "gray", lty = 2)
  }

  climate_crop = data_climate[data_climate$date >= min(final_data$date),]
  climate_crop = climate_crop[climate_crop$date <= max(final_data$date),]


}













