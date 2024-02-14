#############################################
#All CT analysis script
#Romain Journaud
#############################################

source("script/Script_CT_calibration.R", echo = FALSE)
source("R/CT_core_analysis_function.R")

data$data_density = get_density(data$HU, lm_model)

year_pos = Year_pos(data)

plot_CT(x= data$distance, data$data_density)

density_per_year(data)

mean_growth(data)

data_temp = read.table(temp_path, header=T, sep="")

SST_CT_comparison(data$distance, data$data_density)
