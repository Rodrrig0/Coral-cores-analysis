# Created by use_targets().
# Follow the comments below to fill in this target script.
# Then follow the manual to check and run the pipeline:
#   https://books.ropensci.org/targets/walkthrough.html#inspect-the-pipeline

# Load packages required to define the pipeline:
library(targets)
# library(tarchetypes) # Load other packages as needed.

# Set target options:
tar_option_set(
  packages = c("tibble", "ggplot2") # packages that your targets need to run
  # format = "qs", # Optionally set the default storage format. qs is fast.
  #
  # For distributed computing in tar_make(), supply a {crew} controller
  # as discussed at https://books.ropensci.org/targets/crew.html.
  # Choose a controller that suits your needs. For example, the following
  # sets a controller with 2 workers which will run as local R processes:
  #
  #   controller = crew::crew_controller_local(workers = 2)
  #
  # Alternatively, if you want workers to run on a high-performance computing
  # cluster, select a controller from the {crew.cluster} package. The following
  # example is a controller for Sun Grid Engine (SGE).
  #
  #   controller = crew.cluster::crew_controller_sge(
  #     workers = 50,
  #     # Many clusters install R as an environment module, and you can load it
  #     # with the script_lines argument. To select a specific verison of R,
  #     # you may need to include a version string, e.g. "module load R/4.3.0".
  #     # Check with your system administrator if you are unsure.
  #     script_lines = "module load R"
  #   )
  #
  # Set other options as needed.
)

# tar_make_clustermq() is an older (pre-{crew}) way to do distributed computing
# in {targets}, and its configuration for your machine is below.
options(clustermq.scheduler = "multiprocess")

# tar_make_future() is an older (pre-{crew}) way to do distributed computing
# in {targets}, and its configuration for your machine is below.
# Install packages {{future}}, {{future.callr}}, and {{future.batchtools}} to allow use_targets() to configure tar_make_future() options.

# Run the R scripts in the R/ folder with your custom functions:
tar_source(c("R/IOD_index_function.R",
             "R/CT_calibration_function.R",
             "R/Plot_link_elnino_SST_function.R",
             "R/ENSO_variation_function.R",
             "R/CT_core_analysis_function.R"
             ))
# source("other_functions.R") # Source other scripts as needed.

# Replace the target list below with your own:
CT_cal_target = c(tar_target(CT_cal_data, "data/HU_calibration_data.csv", format="file"),
                  tar_target(data_CTcal, get_csv(CT_cal_data)),
                  tar_target(LM_model, lm_model(data_CTcal)),
                  tar_target(plot_CTcal,CTcal_plot(data_CTcal, LM_model)))
DMI_index_target = c(tar_target(E_W_IO_SST_data, "data/climate_data/IOD_index.csv", format = "file"),
                     tar_target(dataDMI, data_DMI(E_W_IO_SST_data)),
                     tar_target(dataDMI_T, character_to_date(dataDMI)),
                     tar_target(DMI_index, DMI(dataDMI_T)),
                     tar_target(plot_dmi, plot_DMI(DMI_index)))
ENSO_variation_target = c(tar_target(data_enso, "data/climate_data/SST_ENSO_indice.txt", format="file"),
                          tar_target(data_ENSO, get_data_enso(data_enso)),
                          tar_target(month, get_month_enso()),
                          tar_target(data_ENSO_T, enso_date(month, data_ENSO)),
                          tar_target(ENSO_plot, enso_plot(data_ENSO_T))
                          )
ENSO_impact_SST_target = c(tar_target(data_SST, "data/climate_data/HadCRUT_annal_SST_A.csv", format = "file"),
                           tar_target(data_SSTa, get_csv(data_SST)),
                           tar_target(plot_ENSO_impact, ggplot_impactENSO(data_SSTa))
                           )
CT_analysis = c(tar_target(data_core, "data/GLOM2/GLOM2_a.csv", format = "file"),
                tar_target(CT_density, get_density(data_core, LM_model)),
                tar_target(year_pos, Year_pos(CT_density)),
                tar_target(plot_ct, plot_CT(CT_density, year_pos)),
                tar_target(year_density, density_per_year(CT_density)),
                tar_target(growth, mean_growth(CT_density) ),
                tar_target(data_local_temp,"data/climate_data/glorieuse_geyser.txt", format = "file" ),
                tar_target(SST_density_comparison, SST_CT_comparison(CT_density,data_local_temp))
                )
density_growth_tar = c(tar_target(density_growth, fusion_frame(growth,year_density) ),
                       tar_target(LM, lm(density_growth)),
                       tar_target(density_growth_plot, correlation_plot(density_growth, LM)))
list(density_growth_tar,CT_analysis, CT_cal_target, DMI_index_target, ENSO_variation_target,ENSO_impact_SST_target)

