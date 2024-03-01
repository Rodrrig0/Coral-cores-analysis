#######################################################
#Script SrCa Date proxi
#Romain Journaud - Coral Core analysis repository
#https://github.com/Rodrrig0/Coral-cores-analysis.git
#University CAU of Kiel
###########################################################

source("R/SrCa_date_proxi_functions.R")




choice1 = readline("Manual or Automatic: ")


if (choice1 == "Manual"){

    print("Manuel")
  find_nearest_index <- function(x, target) {
    abs_diff <- abs(x - target)
    return(which.min(abs_diff))
  }

  # Trouver les indices des valeurs de distance dans le deuxième tableau qui sont les plus proches des valeurs de distance dans le premier tableau
  nearest_indices <- sapply(min_points_data$x, function(x) find_nearest_index(data_srca$Distance.from.the.top..mm., x))

  # Ajouter une colonne avec des NA au deuxième tableau
  data_srca$minimumpic <- NA

  # Remplacer les valeurs NA aux indices correspondants avec les valeurs de srca du premier tableau
  data_srca$minimumpic[nearest_indices] <- min_points_data$y

  nearest_indices <- sapply(max_points_data$x, function(x) find_nearest_index(data_srca$Distance.from.the.top..mm., x))

  # Ajouter une colonne avec des NA au deuxième tableau
  data_srca$maximumpic <- NA

  # Remplacer les valeurs NA aux indices correspondants avec les valeurs de srca du premier tableau
  data_srca$maximumpic[nearest_indices] <- max_points_data$y
  samplingdate = as.character(samplingdate)
  data_srca$date = NA
  data_srca = peak_to_date(data = data_srca,top_date =  samplingdate, min_sst_month = min_SST_month, max_sst_month = max_SST_month, format = "%Y-%m-%d")
  data_srca = date_interpolation(data_srca)
  data_srca <- data_srca[data_srca$date != "0000-01-01",]
  file = paste0("modified_data/SrCa/dated_",strsplit(file_path, "/")[[1]][3])
  result = data.frame(distance = data_srca$Distance.from.the.top..mm.,
                      date = data_srca$date,
                      SrCa_ratio = data_srca$Sr407.Ca317,
                      row.names=NULL, check.rows = F)
  write.table(result, file = file, row.names=F)


  print(paste0("Date estimation dataset in : ",file))

}else if (choice1 == "Automatic"){

    print("Automatic")
    repeat {
      ws <- readline("Define window size: ")
      ws <- as.numeric(ws)

      # verification of the window size
      if (!is.na(ws) && ws > 0) {
        data_srca$minimumpic <- find_min_peaks(data_srca$Sr407.Ca317, window_size = ws)
        data_srca$maximumpic <- find_max_peaks(data_srca$Sr407.Ca317, window_size = ws)
        check_plot(x = data_srca$Distance.from.the.top..mm., y = data_srca$Sr407.Ca317, minpeak = data_srca$minimumpic, maxpeak = data_srca$maximumpic)

        # User validation
        confirm <- readline("Is the window size correct? (y/n): ")
        if (tolower(confirm) == "y") {
          break
        }
      } else {
        cat("Invalid window size")
      }
    }

    top_data = readline("Enter top date (dd/mm/yyyy) :")
    min_sst_month = readline("Enter max SST month (numerical) :")
    max_sst_month = readline("Enter min SST month (numerical) :")
    data_srca$date = NA

    data_srca = peak_to_date(data_srca, top_data, min_sst_month, max_sst_month, format = "%d/%m/%Y")

    data_srca = date_interpolation(data_srca)
    file = paste0("modified_data/SrCa/dated_",strsplit(file_path, "/")[[1]][3])
    result = data.frame(distance = data_srca$Distance.from.the.top..mm.,
                        date = data_srca$date,
                        SrCa_ratio = data_srca$Sr407.Ca317,
                        row.names=NULL, check.rows = F)
    write.table(result, file = file, row.names=F)

    print(paste0("Date estimation dataset in : ",file))

} else if (choice1=="flower") {
  runApp("script/system_filed.R")
}






