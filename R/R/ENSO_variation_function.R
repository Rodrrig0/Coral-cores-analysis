##############################################
#ENSO Variation function
#Romain Journaud
##############################################

#Get ENSO climate data variation
get_data_enso = function(ensofile){
  read.table(ensofile, header=T)
}

#Creation of month vector because not present in the original data table
get_month_enso = function(){
  month = rep(c("01","02","03","04","05","06","07","08","09","10","11","12"),74)
  month = month[-length(month)]
}

#Change the type of date information (character type to date type)
##I'm adding a day for the well functioning of the strptime() function
enso_date = function(datecol, month){
  strptime(paste0( month, datecol, "01"), format = "%m%Y%d")
}

#Data graphic vizualisation with positive threshold in red and negative threshold in blue
enso_plot = function(x,y){
  plot(x,y, type = "l", main = "ENSO index variation",xlab = "Time", ylab = "ENSO index")
  abline(h=0.5, col = "red")
  abline(h=0, lwd=2)
  abline(h=-0.5, col = "blue")
  abline(v = as.POSIXct("2016-01-01"), col = "red", lty = 2)
  abline(v = as.POSIXct("2019-01-01"), col = "red", lty = 2)
  abline(v = as.POSIXct("2010-01-01"), col = "red", lty = 2)

}
