########################################
#Script CT calibration
#Romain Journaud
#######################################

source("R/CT_calibration_function.R")

data_CTcal = get_csv("data/HU_calibration_data.csv")

lm_model = lm_model(data_CTcal[data_CTcal$Type=="Calibration",]$Estimate_Density~
                      data_CTcal[data_CTcal$Type=="Calibration",]$Mean_HU_unit)
CTcal_plot(data_CTcal[data_CTcal$Type=="Calibration",]$Mean_HU_unit,
           data_CTcal[data_CTcal$Type=="Calibration",]$Estimate_Density,
           lm_model,
           data_CTcal[data_CTcal$Type=="Validation",]$Mean_HU_unit,
           data_CTcal[data_CTcal$Type=="Validation",]$Estimate_Density)
print(lm_model)
