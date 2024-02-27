##########################################################
#Script for load all cores analysis
#Romain Journaud - Coral Core analysis repository
#https://github.com/Rodrrig0/Coral-cores-analysis.git
#University CAU of Kiel
###########################################################
# data path until the last folder
chemin_dossier <- "data/CT/csv"

# Getting all name of data
core_data <- list.files(chemin_dossier)

# Path ot the script
script_path <- "script/Script_all_CT_analysis.R"


temp = readline("Name of the location (climate data): ")

temp_path = paste0("data/climate_data/",temp)
# Selection of the climate data

# Loop wich apply the core analysis for each file
for (i in seq_along(core_data)) {
  fichier <- file.path(chemin_dossier, core_data[i])
  data = get_CT_transect(fichier)
  source(script_path)
  rmarkdown::render("output/markdown_test.Rmd", output_file = paste0("Result Report ",core_data[i],".html"))
}
