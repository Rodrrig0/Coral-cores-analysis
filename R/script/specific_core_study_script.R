#############################################
#GLOM2 CT analysis script
#Romain Journaud
#############################################

#Explication of the script in all_CT_analysis functions
source("script/Script_CT_calibration.R", echo = FALSE)


get_CT_transect = function(file){
  read.csv(file, header=T, sep=",")
}

get_density = function(HU, lm_model){
  data_CT_density = HU*lm_model[["coefficients"]][[2]]+lm_model[["coefficients"]][[1]]
}

Year_pos = function(data){
  year_pos = data.frame(distance = tapply(data$distance, data$Year, min))
  year_pos$Year = row.names(year_pos)
  return(year_pos)
}

plot_CT = function(x,y){
  plot(x, y, type="l", main = name, xlab="Distance", ylab="Estimated density")
  for(i in seq(1:length(year_pos$Year))){
    abline(v=year_pos[i, 1], lty=2, lwd=0.5, col="blue")
    text(x = year_pos[i, 1]+1.9, y = 1.02, labels = year_pos[i, 2], col = "blue",srt = -90, cex = 1)
  }
}

density_per_year = function(data){
  mean = tapply(data$data_density, data$Year, mean)
  sd = tapply(data$data_density, data$Year, sd)
  n = tapply(data$data_density, data$Year, length)
  es = sqrt(sd/n)

  table = data.frame(n,mean,sd, es)
  table$Year = rownames(table)

  name_csv = paste0("modified_data/CT/Skeleton_param/Density/",name)
  write.csv(table,name_csv)
  plot(table$Year, table$mean, type = "l",
       main = paste0("Density average of : ", name))
  return(table)
}

mean_growth = function(data){
  growth = tapply(data$relative_distance, data$Year, max)
  mean_growth = mean(growth)
  data_growth = data.frame(growth)
  data_growth$Year = row.names(data_growth)
  plot(data_growth$Year, data_growth$growth, type="l",
       main = paste0("Growth rate per year of : ",name))
  print(paste0("Average Growth : ",mean_growth,"mm.y-1"))

  return(print(data_growth))
}
#######################################################################
#creating the acces path of your asked file
chemin_dossier <- "data/CT/csv"
#Define the file
name = readline("Name of the file :")
file = file.path(chemin_dossier, name)

data = get_CT_transect(file)

data$data_density = get_density(data$HU, lm_model)

year_pos = Year_pos(data)

plot_CT(x= data$distance, data$data_density)

density_per_year(data)

mean_growth(data)
