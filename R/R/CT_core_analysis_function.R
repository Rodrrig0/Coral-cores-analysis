###############################################
#CT core analysis functions
#Romain Journaud
###############################################

#Read the core CSV file
get_CT_transect = function(file){
  read.csv(file, header=T, sep=",")
}

#Estimation of the density using calibration lineare model
get_density = function(HU, lm_model){
  data_CT_density = HU*lm_model[["coefficients"]][[2]]+lm_model[["coefficients"]][[1]]
}

#Creation of the x position of each year for plot
Year_pos = function(data){
  year_pos = data.frame(distance = tapply(data$distance, data$Year, min))
  year_pos$Year = row.names(year_pos)
  return(year_pos)
}

#Graphic visualization of the estimated density and distance from the top (with year)
plot_CT = function(x,y){
  plot(x, y, type="l", main = core_data[i], xlab="Distance", ylab="Estimated density")
  for(i in seq(1:length(year_pos$Year))){
    abline(v=year_pos[i, 1], lty=2, lwd=0.5, col="blue")
    text(x = year_pos[i, 1]+1.9, y = 1.02, labels = year_pos[i, 2], col = "blue",srt = -90, cex = 1)
  }
}

#Calcul of the average year density, and graphic vizualisation
##Here, average data table is save in modified_data
density_per_year = function(data){
  mean = tapply(data$data_density, data$Year, mean)
  sd = tapply(data$data_density, data$Year, sd)
  n = tapply(data$data_density, data$Year, length)
  es = sqrt(sd/n)

  table = data.frame(n,mean,sd, es)
  table$Year = rownames(table)

  name_csv = paste0("modified_data/CT/Skeleton_param/Density/Dens_",core_data[i])
  write.csv(table,name_csv)
  plot(table$Year, table$mean, type = "l",
       main = paste0("Density average of : ", core_data[i]),
       xlab="Time", ylab="Year average density")
  return(table)
}

#Calcul of core average growth and per year, with plot visualization
mean_growth = function(data){
  growth = tapply(data$relative_distance, data$Year, max)
  mean_growth = mean(growth)
  data_growth = data.frame(growth)
  data_growth$Year = row.names(data_growth)
  plot(data_growth$Year, data_growth$growth, type="l",
       main = paste0("Growth rate per year of : ",core_data[i]),
       xlab="Time", ylab = "Annual growth rate")
  print(paste0("Average Growth : ",mean_growth,"mm.y-1"))
  write.csv(data_growth, paste0("modified_data/CT/Skeleton_param/Growth_rate/Growth_"))
  return(print(data_growth))
}

SST_CT_comparison = function(x,y){
  par(mar = c(5, 4, 4, 4) + 0.3)
  plot(x,y, type = "l", main = paste0(core_data[i]," Skeleton density and SST temperature comparison"), axes=F, xlab="", ylab="Estimated density")
  axis(side = 2, at = pretty(range(data$data_density)) )
  par(new = TRUE)
  data_temp$date = strptime(paste0(data_temp$YYYY,"-",data_temp$MM,"-", data_temp$DD), "%Y-%m-%d")
  xlim = c(strptime(paste0(max(data$Year),"-01","-01"), "%Y-%m-%d"),
           strptime(paste0(min(data$Year),"-01","-01"), "%Y-%m-%d"))
  plot(data_temp$date, data_temp$SST90th_HS, type = "l", axes = FALSE, bty = "n", xlab = "Year", ylab = "", xlim = as.POSIXct(xlim), col ="red")
  axis(side=4, at = pretty(range(data_temp$SST90th_HS)), col="red",col.axis = "red")
  axis(side=1,at = range(data$Year) )
  mtext("SST Temperature",side=4,col="red",line=2)
  axis(side = 4, at = pretty(range(data_temp$SST90th_HS)), col = "red", col.axis = "red")
  axis.POSIXct(side = 1, at = seq(min(data_temp$date), max(data_temp$date), by = "1 year"), format = "%Y", las = 2)
}

