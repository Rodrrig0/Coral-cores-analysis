##############################################
# Density - growth rate correlation functions
# Romain Journaud
###############################################

mean_growth = function(data){
  growth = tapply(data$relative_distance, data$Year, max)
  mean_growth = mean(growth)
  data_growth = data.frame(growth)
  data_growth$Year = row.names(data_growth)
  plot(data_growth$Year, data_growth$growth, type="l",
       main = paste0("Growth rate per year of : "),
       xlab="Time", ylab = "Annual growth rate")
  print(paste0("Average Growth : ",mean_growth,"mm.y-1"))
  write.csv(data_growth, paste0("modified_data/CT/Skeleton_param/Growth_rate/Growth_"))
  return(print(data_growth))
}

fusion_frame = function(data){
  growth = mean_growth(data = data)
  density = density_per_year(data = data)
  density_growth = data.frame(year = density$Year, density = density$mean, growth = growth$growth)
}

density_per_year = function(data){
  mean = tapply(data$data_density, data$Year, mean)
  sd = tapply(data$data_density, data$Year, sd)
  n = tapply(data$data_density, data$Year, length)
  es = sqrt(sd/n)

  table = data.frame(n,mean,sd, es)
  table$Year = rownames(table)

  name_csv = paste0("modified_data/CT/Skeleton_param/Density/Dens_")
  write.csv(table,name_csv)
  plot(table$Year, table$mean, type = "l",
       main = paste0("Density average of : "),
       xlab="Time", ylab="Year average density")
  return(table)
}

correlation_plot = function(x,y, model){
  plot(x~ y,
       main = "Correlation between density and growth rate",
       xlab= "Growth rate", ylab = "Estimated density")
  abline(model$coefficients, col = "red")
  text(x = 12, y=1.36,
       labels = paste0("Y = ",round(model[["coefficients"]][[2]], digits=5),"x + ",round(model[["coefficients"]][[1]], digits=3)),
       cex=1)

}
