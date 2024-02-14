#IOD index function

#IOD index data import
data_DMI = function(file){
  read.csv(file, header=T, sep=",")

}

#Transformation character type date in date
character_to_date = function(col, format){
  time = strptime(col, format)
}

#Estimation of the Index, based on West and Est pole temperature
DMI = function(West, Est){
  dmi = West - Est
}

# Graphic vizualisation
plot_DMI = function(x, y){
  plot(x,y, type = "l", main="DMI index past few decade", xlab = "Time", ylab="DMI index")
  abline(h=0, lwd=1, lty = 2, col="red")
}
