################################################
#CT Calibration functions
#Romain Journaud - Coral Core analysis repository
#https://github.com/Rodrrig0/Coral-cores-analysis.git
#University CAU of Kiel
###########################################################
library(ggplot2)

#Get calibaration data from Dr. Watanabe
get_csv = function(file){
  read.csv(file, header=T, sep=",")
}

#Calcul of the linear calibration model
lm_model = function(formula){
  lm(formula=formula)
}

#Calibration model vizualisation and projection of validation points
CTcal_plot = function(x, y, model, xvalidation, yvalidation){
  plot(x,y, main="CT Calibration", xlab="HU unit", ylab="Estimated density", pch = 18)
  abline(model, col="blue")
  points(xvalidation, yvalidation, col="red", pch = 16)
}
