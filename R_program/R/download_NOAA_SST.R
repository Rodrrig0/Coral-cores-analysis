################################################
#Import of the satellite climate data
#Romain Journaud - Coral Core analysis repository
#https://github.com/Rodrrig0/Coral-cores-analysis.git
#University CAU of Kiel
###########################################################

download_NOAA_SST = function(){

  url = readline("Past climate url: ")

  climate = read.table(url,header=T, skip = 21)
  colnames(climate) = c("YYYY", "MM", "DD", "SST_MIN", "SST_MAX", "SST90th_HS", "SSTA90th_HS", "90th_HS>0", "DHW_from_90th_HS>1", "BAA_7day_max")
  climate$date = paste0(climate$DD,"/",climate$MM,"/",climate$YYYY)
  climate$date = strptime(climate$date, format = "%d/%m/%Y")

  split = strsplit(url, split = "/")
  name= split[[1]][length(split[[1]])]
  path = paste0("data/climate_data/",name)

  write.table(climate, file = path)
  return(paste0(name," upload in: data/climate_data/"))
}
