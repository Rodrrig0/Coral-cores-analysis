#####################################
#Script ENSO variation
#Romain Journaud
#####################################

source("R/ENSO_variation_function.R")

data_enso = get_data_enso("data/climate_data/SST_ENSO_indice.txt")

month = get_month_enso()

data_enso$date = enso_date(data_enso$YR, month)

enso_plot(x=data_enso$date, y = data_enso$ANOM)
