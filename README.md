# **New v-2.0 version released!**



**New functionalities:** Sr/Ca core analysis

- Estimation of the date thanks to maximum and minimum peaks of Sr/Ca Ratio
- Creation of a full dataset whith distance from the top, estimated date, Sr/Ca ratio, density and SST
- Creation of a comparison plot with density, Sr/Ca ratio and SST

# Coral Cores Analysis
Repository made by Romain Journaud

Institute of Geosciences, Christian-Albretch University Kiel, 24106 Germany 


# For what?
1) This code permits the study of coral skeleton variation, and compares them with satellite data (NOAA)
Density and growth rate are represented during time. Relation between density and growth rate is observed
2) Create a summary of the trends and results of your core's observations. 
3) The method to analyse the Sr/Ca ratio in the coral is in development ^^


# What do you need? 
In order to study the coral skeletons, we used the CT scanning method to visualise and estimate the density of coral cores. 

For CT scan settings, see in the report M&M.

If you have other CT settings, you must change the HU_calibration_data.csv file in data folder. **Keep the same structure (specially the column)!!**


# Guide to proper operations
- Download all the repository folder and unzipp it for be able to use it
- Only use the script make.R for operate analysis. 
- Import your core data in **data/CT/csv** in csv file.
- Please respect the structure of cores data (e.g. with GLOM2_a.csv) with the correct column names
- Regional satellite climate data can be import in the make script
- Result report will be created in output folder

  **Problems and questions have to be report in issues section**
