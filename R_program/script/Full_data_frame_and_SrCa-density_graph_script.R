################################################
#Full data frame and SrCa/density graph script(dated)
#Romain Journaud - Coral Core analysis repository
#https://github.com/Rodrrig0/Coral-cores-analysis.git
#University CAU of Kiel
###########################################################

source("script/Script_CT_calibration.R")
source("R/Full_data_frame_and_SrCa-density_graph_function.R")

#You have to run the SrCa date proxi script
#Climate dat are from NOAA
##################################################################
################MODIFICATION AREA#################################
data_srca = "modified_data/SrCa/dated_TROM2_SrCaForRomain.csv"
data_climate = "data/climate_data/tromelin_reunion.txt"
data_dens_name = "data/CT/csv/TROM2-v2.csv"
##################################################################

#Import dataset
data_srca = read.csv(data_srca, header=T,sep=" ")
data_climate = read.table(data_climate, header=T)
data_dens = read.table(data_dens_name, header=T, sep = ",")

#Delete wrong-dates lines and make date values (from character to date type)
data_srca = data_srca[data_srca$date!="0-01-01",]
data_climate$date = strptime(data_climate$date, format = "%Y-%m-%d")

#Get density from CT-calibration linear model
data_dens$dens = get_density(data_dens$HU, lm_model = lm_model)

#Creation of the full dataset with:
#- Distance from the top of the core
#- Estimated date
#- Sr/Ca ratio values
#- Density
#- SST from NOAA
final_data = full_data_frame(data_srca, data_dens)

#Print a graph which compare variation of Sr/Ca ratio, density and SST depending to the date
srca_SST_density_graph()

#Saving the result in modified_data/full_data folder
title = strsplit(data_dens_name, split = "/")[[1]][4]
file = paste0("modified_data/full_dated/",title)
write.table(final_data, file = file, row.names = F)

print(paste0("Full dataset saved in :",file))
