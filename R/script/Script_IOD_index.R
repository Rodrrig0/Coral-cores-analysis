###########################################################
#Script estimation of the IOD Index (DMI)
#Romain Journaud
###########################################################
source("R/IOD_index_function.R")

dataDMI = data_DMI("data/climate_data/IOD_index.csv")

dataDMI$Time = character_to_date(dataDMI$Time, "%d/%m/%Y")

dataDMI$DMI = DMI(dataDMI$SST_W, dataDMI$SST_E)

plot_DMI(dataDMI$Time,dataDMI$DMI)
