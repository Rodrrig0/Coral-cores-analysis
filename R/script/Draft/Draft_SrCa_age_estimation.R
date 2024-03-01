##################################################################
#Sr/Ca analysis - age proxi estimation fucntions
#Romain Journaud
###################################################################
#Fucntion for identify minimum peaks by windows_size
data_test = read.csv("data/SrCa/TROM2_SrCaForRomain.csv", header=T,skip=1)

find_min_peaks <- function(data, window_size) {
  n <- length(data)
  peaks <- rep(NA, n)


  min_val <- min(data[1:min(window_size, n)])
  min_index <- which.min(data[1:min(window_size, n)])
  peaks[min_index] <- min_val


  for (i in seq(window_size + 1, n)) {
    if (i <= window_size || i >= n - window_size) {

      peaks[i] <- NA
    } else {
      window <- data[(i - window_size):(i + window_size)]
      if (data[i] == min(window)) {
        peaks[i] <- data[i]
      } else {
        peaks[i] <- NA
      }
    }
  }

  peaks
}

check_plot = function(){
  plot(data$SrCa ~ data_test$distance, type = "l")
  points(data$minimumpic ~ data$distance, pch = 16, col ="red")
}
data_test$minimumpic = find_min_peaks(data_test$Sr407.Ca317, 10)

data_test$date = NA
data_test$date[1] = 2019.321
last_date = 2019
n_year <- length(subset(data_test, minimumpic != 0)$minimumpic)
min_year = subset(data_test, minimumpic != 0)
row = rownames(min_year)
row = as.numeric(row)

for (i in seq_along(row)){
  data_test$date[row[i]] = last_date + 0.20499657769
  last_date <- last_date - 1
}

# Trouver les indices des pics dans la colonne 'date'
row <- which(!is.na(data_test$date))

# Initialiser une variable pour stocker les valeurs interpolées
interpolated_values <- numeric(length(data_test$date))

# Parcourir les paires de pics pour remplir les valeurs intermédiaires
for (i in 1:(length(row) - 1)) {
  start_index <- row[i]
  end_index <- row[i + 1]

  # Calculer la différence entre les valeurs des pics
  diff_value <- data_test$date[end_index] - data_test$date[start_index]

  # Calculer le pas de valeur entre les pics
  step_value <- diff_value / (end_index - start_index)

  # Remplir les valeurs intermédiaires linéaires
  for (j in start_index:end_index) {
    interpolated_values[j] <- data_test$date[start_index] + step_value * (j - start_index)
  }
}

# Remplacer les valeurs dans la colonne 'date' avec les valeurs interpolées
data_test$date <- ifelse(is.na(data_test$date), interpolated_values, data_test$date)

# Afficher le dataframe mis à jour
print(data_test)






# Convertir les années décimales en dates
data_test$date <- as.Date(paste0(floor(data_test$date), "-", floor((data_test$date - floor(data_test$date)) * 365) + 1), format = "%Y-%j")

# Afficher le dataframe mis à jour
print(data_test)




