##########################################
#IRI IDEO web scrapping
#Romain Journaud - Coral Core analysis repository
#https://github.com/Rodrrig0/Coral-cores-analysis.git
#University CAU of Kiel
###########################################################


library(RSelenium)
library(netstat)
library(wdman)

wait_downloading <- function(chemin_dossier, nom_fichier) {
  while (!file.exists(file.path(chemin_dossier, nom_fichier))) {
    Sys.sleep(1)
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
  ######################################################################################################
  ##################################MODIFICATION AREA###################################################
  ######################################################################################################
  value = "sst" # Choose sst or anom (SST anomaly)
  precision = "_monthly" #_monthly or _weekly, put " " for daily
  min_date = "Sep 2018" #Minimum is Sep 1981
  max_date = "Jan 2019"
  min_lat = "-7"
  max_lat = "-5"
  min_lon = "104"
  max_lon = "106"
  transfo = "average" #choose average or rmsaover (standard deviation)
  ###################################################################################################
  expert = paste0(" .NOAA .NCDC .OISST .version2p1 .AVHRR",precision," .", value,
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
  select_element$clickElement()
  option_csv = remDr$findElement(using = "xpath", "//option[text()=' csv']")
  option_csv$clickElement()
  submit_button = remDr$findElement(using = "css selector", "input[type='submit'][value='Get Table']")
  submit_button$clickElement()

  wait_downloading("C:/Users/journ/Downloads/","datafile.csv")
  new_name = paste0("C:/Users/journ/OneDrive/Bureau/Stages/Sclerochronology kiel internship/R/data/climate_data/IRI_data/",
                    precision,"_",transfo,"_",value,
                    "_lon", min_lon,max_lon,
                    "_lat",min_lat,max_lat,
                    "_dates",min_date,max_date,".csv")
  file.rename("C:/Users/journ/Downloads/datafile.csv", new_name)

  test = read.csv(new_name)
  return(test)
}







