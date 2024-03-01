##################################################################
#Sr/Ca analysis - age proxi estimation fucntions
#Romain Journaud - Coral Core analysis repository
#https://github.com/Rodrrig0/Coral-cores-analysis.git
#University CAU of Kiel
###########################################################
library(ggplot2)
library(shiny)
library(lubridate)
#Identify stress band thanks to a defined window size

#Find the maximum peak of temperature (corresponding to minimum Sr/Ca ratios)
#Depend on the window size
find_min_peaks <- function(data, window_size) {
  n <- length(data)
  minpeaks <- rep(NA, n)


  min_val <- min(data[1:min(window_size, n)])
  min_index <- which.min(data[1:min(window_size, n)])
  minpeaks[min_index] <- min_val

#Define the minimum value for each i window
  for (i in seq(window_size + 1, n)) {
    if (i <= window_size || i >= n - window_size) {

      minpeaks[i] <- NA
    } else {
      window <- data[(i - window_size):(i + window_size)]
      if (data[i] == min(window)) {
        minpeaks[i] <- data[i]
      } else {
        minpeaks[i] <- NA
      }
    }
  }

  minpeaks
}

find_max_peaks <- function(data, window_size) {
  n <- length(data)
  maxpeaks <- rep(NA, n)


  max_val <- max(data[1:min(window_size, n)])
  max_index <- which.max(data[1:max(window_size, n)])
  maxpeaks[max_index] <- max_val

  #Define the minimum value for each i window
  for (i in seq(window_size + 1, n)) {
    if (i <= window_size || i >= n - window_size) {

      maxpeaks[i] <- NA
    } else {
      window <- data[(i - window_size):(i + window_size)]
      if (data[i] == max(window)) {
        maxpeaks[i] <- data[i]
      } else {
        maxpeaks[i] <- NA
      }
    }
  }

  maxpeaks
}

#Ploting the result for having an overview of the result (specially for validation)
check_plot = function(x, y, minpeak, maxpeak){
  plot(y ~ x, type = "l")
  points(minpeak ~ x, pch = 16, col ="blue")
  points(maxpeak ~ x, pch = 16, col ="red")
}


#Creation of date proxi in peak areas
#Here the sample date is placed as the first value of the data.frame (the only 100% sure date^^)
peak_to_date <- function(data, top_date, min_sst_month, max_sst_month, format) {

  data$date[1] <- decimal_date(as.POSIXct(strptime(top_date, format)))

  #Creation of the minimum peak dates (taking the sampling date and removing one year for each minimum peak)
  #Minimum peak date correspond to maximum SST date
  #If the minimum peak is not already past (like sampling date is on April and minimum month is on October),
  #removing one year on the first minimum peak and add the month time to year
  max_month <- decimal_date(strptime(paste0("01/", max_sst_month, "/0000"), "%d/%m/%Y"))
  min_month <- decimal_date(strptime(paste0("01/", min_sst_month, "/0000"), "%d/%m/%Y"))

  min_row = which(!is.na(data$minimumpic))[1]
  max_row = which(!is.na(data$maximumpic))[1]


  target_min_date <- floor(data$date[1]) + min_month
  target_max_date <- floor(data$date[1]) + max_month


  if(min_row < max_row){
    if (target_min_date > data$date[1]) {
      target_min_date <- target_min_date - 1
      target_max_date = target_max_date - 1
      }
  }else{
    if (target_max_date > data$date[1]) {
      target_max_date <- target_max_date - 1
      target_min_date = target_min_date - 1
      }
  }




  #Removing one year for each new minimum peak
  peaks_min_indices <- which(data$minimumpic != 0)
  for (i in peaks_min_indices) {
    data$date[i] <- target_min_date
    target_min_date <- target_min_date - 1
  }

  peaks_max_indices <- which(data$maximumpic != 0)
  for (i in peaks_max_indices) {
    data$date[i] <- target_max_date
    target_max_date <- target_max_date - 1
  }
  return(data)
}

#Complete the between two peaks values for having a complete datation
date_interpolation = function(data){
  row <- which(!is.na(data$date))
  interpolated_values <- numeric(length(data$date))

  for (i in 1:(length(row) - 1)) {
    start_index <- row[i]
    end_index <- row[i + 1]

    diff_value <- data$date[end_index] - data$date[start_index]
    step_value <- diff_value / (end_index - start_index)

    for (j in start_index:end_index) {
      interpolated_values[j] <- data$date[start_index] + step_value * (j - start_index)
    }
  }
  data$date <- ifelse(is.na(data$date), interpolated_values, data$date)

  data$date <- as.Date(paste0(floor(data$date), "-", floor((data$date - floor(data$date)) * 365) + 1), format = "%Y-%j")

  return(data)
}

