##############################################
#CT core models draft
#Based on GLOM2_a core
#Romain Journaud
#############################################
library(MASS)
library(nlme)
#Density growth rate correlation
data = read.csv("data/CT/csv/GLOM2_a.csv", header = T)

#Preparation of the data frame
data$data_density = get_density(HU = data$HU, lm_model = lm_model)
growth = mean_growth(data = data)
density = density_per_year(data = data)
density_growth = data.frame(year = density$Year, density = density$mean, growth = growth$growth)

# Preliminary analysis
#Data  vizualisation
str(data)
summary(data)

# Univariate analysis
hist(density_growth$density)
hist(density_growth$growth)

#Bivariate analysis
plot(density_growth$density~ density_growth$growth)
text(x=density_growth$growth, y = density_growth$density,labels = density_growth$year )

# Model calibration

#Removing the 2018 data because seems to be an outlier value
density_growth_T = density_growth[-16,]
lm =lm(density_growth$density~ density_growth$growth)
lm.1 = lm(density_growth_T$density~ density_growth_T$growth)
# AIC comparison
AIC(lm)
AIC(lm.1)# lm.1 is better <3

#Try with Year random effect
lmm = lme(density~ growth, data = density_growth_T, random = ~1|year, method = "ML")

lm.2 = gls(density~ growth, data = density_growth_T, method = "ML")

anova(lm.2, lmm, test = "F") #lm.2 is better

###############################
#I choose the lineare model without random effect.

# Model validation
#Homogeneity of variance
plot(residuals(lm.2), fitted(lm.2)) #ok ^^

#Normal distribution of residuals
hist(residuals(lm.2)) #ok

#Result
summary(lm.2)

#Graphical vizualisation of the model
plot(density~ growth, data = density_growth_T)
abline(lm.2$coefficients, col = "red")
text(x = 12, y=1.36,
     labels = paste0("Y = ",round(lm.2[["coefficients"]][[2]], digits=5),"x + ",round(lm.2[["coefficients"]][[1]], digits=3)),
     cex=1)

