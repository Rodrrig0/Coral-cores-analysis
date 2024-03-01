###########################################################
#Script estimation of the IOD Index (DMI)
#Romain Journaud - Coral Core analysis repository
#https://github.com/Rodrrig0/Coral-cores-analysis.git
#University CAU of Kiel
###########################################################
source("R/IOD_index_function.R")

#Get DMI data from data/climate_data
dataDMI = data_DMI("data/climate_data/IOD_index.csv")

#Change the date column in date (character to date)
dataDMI$Time = character_to_date(dataDMI$Time, "%d/%m/%Y")

#Estimation of the DMI index (West SST minus Est SST)
dataDMI$DMI = DMI(dataDMI$SST_W, dataDMI$SST_E)

#Printing the resulting plot
plot_DMI(dataDMI$Time,dataDMI$DMI)
