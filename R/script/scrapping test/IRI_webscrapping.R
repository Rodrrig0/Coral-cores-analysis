library(RSelenium)
library(netstat)
library(wdman)

wait_downloading <- function(chemin_dossier, nom_fichier) {
  while (!file.exists(file.path(chemin_dossier, nom_fichier))) {
    Sys.sleep(1)  # Attendre 1 seconde avant de vérifier à nouveau
  }
}
get_IRI_data = function(){
  remote_driver = rsDriver(browser="chrome",
                           chromever = "121.0.6167.184",
                           port= free_port(),
                           check=F)

  remDr = remote_driver$client
  remDr$navigate(url = "https://iridl.ldeo.columbia.edu/SOURCES/#expert")

  search_box = remDr$findElement(using="css selector", "textarea")

  using = c("xpath", "css selector", "id", "name", "tag name", "class name", "link text", "partial link text")

  ok_button = remDr$findElement(using = "css selector", "input[type='submit'][value='OK']")


  close_button = remDr$findElement(using = "css selector", "button")
  close_button$clickElement()
  value = "sst"
  min_date = "Sep 2018"
  max_date = "Jan 2019"
  min_lat = "5"
  max_lat = "10"
  min_lon = "60"
  max_lon = "70"
  transfo = "rmsaover"
  expert = paste0(" .NOAA .NCDC .OISST .version2p1 .AVHRR_monthly .", value,
                  " lat(",min_lat,") (",max_lat,") RANGEEDGES
                  T (",min_date,") (",max_date,") RANGEEDGES
                  lon (",min_lon,") (", max_lon,") RANGEEDGES
                  [lon lat]",transfo)
  search_box$sendKeysToElement(list(expert))
  ok_button$clickElement()
  data_table = remDr$findElement(using = "link text", "Data Tables")
  data_table$clickElement()
  column_bar = remDr$findElement(using = "link text", "columnar tables with options")
  column_bar$clickElement()

  select_element = remDr$findElement(using = "css selector", "select[name='tabtype']")
  select_element$clickElement()  # Pour ouvrir le menu déroulant
  option_csv = remDr$findElement(using = "xpath", "//option[text()=' csv']")
  option_csv$clickElement()  # Pour sélectionner l'option "csv"
  submit_button = remDr$findElement(using = "css selector", "input[type='submit'][value='Get Table']")
  submit_button$clickElement()

  wait_downloading("C:/Users/journ/Downloads/","datafile.csv")
  new_name = paste0("C:/Users/journ/OneDrive/Bureau/Stages/Sclerochronology kiel internship/R/data/climate_data/IRI_data/",
                    transfo,value,
                    "_lon", min_lon,max_lon,
                    "_lat",min_lat,max_lat,
                    "_dates",min_date,max_date,".csv")
  file.rename("C:/Users/journ/Downloads/datafile.csv", new_name)

  test = read.csv(new_name)
  return(test)
}
climate_sd = get_IRI_data()







