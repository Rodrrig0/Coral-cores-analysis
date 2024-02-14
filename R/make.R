##################################################
#R Compendium
#R Main Script - Internship in Kiel
#Romain Journaud
#################################################

library(targets)
#Intall all packages
remotes::install_deps(upgrade = "never")

#Load all the functions
devtools::load_all()

#Global organisation
source("_targets.R")
tar_visnetwork()


## Climatic analysis

#IOD Index estimation (DMI)
source("script/Script_IOD_index.R")
#ENSO variation
source("script/Script_ENSO_variation.R")
#ENSO impact on global SST anomalies
source("script/Script_link_between_ENSO_and_SST_global_anomaly.R")

### CT Scan analysis

##CT Calibration
source("script/Script_CT_calibration.R")

## Correlation between Density and growth rate
source("script/Script_density_growth_rate_correlation.R")

##CT Analysis
#CT scan data are in "data/CT.csv/" folder
#If you want to analyse your cores, please respect the same structure and column name for data.frame

#Analysis of all cores, an reaction of a unique report for each analyse core
#Comparison made with NOAA 5km Regional Virtual Stations website
#=> https://coralreefwatch.noaa.gov/product/vs/map.php
#Select a place > Time Series Graphs & Data > Time Series Data
download_NOAA_SST() #For import dataset from url (/!\ end in .txt)

#If you want to change SST data localisation
source("script/Script_all_core_analysis.R")


# Specific core analysis
source("script/specific_core_study_script.R")
