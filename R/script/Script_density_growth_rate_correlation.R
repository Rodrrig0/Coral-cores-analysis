###############################################
#Script Correlation between density and growth rate
# Romain Journaud
###############################################

source("R/density_growth_rate_correlation_functions.R")

density_growth = get_csv("data/CT/csv/GLOM2_a.csv")

density_growth$data_density = get_density(density_growth$HU, lm_model)

fusion = fusion_frame(data = density_growth)

#Removing the 2018 data.
fusion = fusion[-16,]

#Creation of the linear model (see "Draft/CT_core_model_draft.R" for model selection method)
lm =lm(fusion$density~ fusion$growth)

#Result
print(summary(lm))

correlation_plot(x = fusion$density,fusion$growth, lm)
