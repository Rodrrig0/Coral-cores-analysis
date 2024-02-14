############################################
#Script link between ENSO and SST global anomaly
#Romain Journaud - Inspired by SSPP 2299 report
############################################
source("R/CT_calibration_function.R")
source("R/IOD_index_function.R")

data_SSTa = get_csv("data/climate_data/HadCRUT_annal_SST_A.csv")

p =ggplot_impactENSO(data_SSTa, x = data_SSTa$Time, y=data_SSTa$Anomaly..deg.C., ymax=data_SSTa$Upper.confidence.limit..97.5.., ymin = data_SSTa$Lower.confidence.limit..2.5..)

print(p)
