#####################################
#Script ENSO variation
#Romain Journaud - Coral Core analysis repository
#https://github.com/Rodrrig0/Coral-cores-analysis.git
#University CAU of Kiel
###########################################################

source("R/ENSO_variation_function.R")

#Get enso data
data_enso = get_data_enso("data/climate_data/SST_ENSO_indice.txt")

#Creation of month values for improve precision
month = get_month_enso()

#Creation of date column
data_enso$date = enso_date(data_enso$YR, month)

#Plot result for analyse variation
enso_plot(x=data_enso$date, y = data_enso$ANOM)
