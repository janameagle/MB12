
install.packages("rgdal")
library(sf)
library(rgdal)

#reading the data
data <-read.csv("data/day2_data_energy_prod_EU_2020-08-03_2020-08-09.csv")
head(data)
names(data)

countries <- readOGR(dsn= "C:/Users/jmaie/OneDrive/R/MB12/data/ne_10m_admin_0_countries", layer = "ne_10m_admin_0_countries")
#or: ctr <- st_read()
head(countries)

unique(data$MapCode)


#create a new column
data$ctr_code <- data$MapCode

#get all columns which include 'DE_' and rename them to *DE*
data$ctr_code[grep("DE_", data$ctr_code)] <- "DE"
# or maybe: data$country[data$country %in% "DE"]
unique(data$ctr_code)


#aggregate by the column country and ignore NAs
data[c("ActualGenerationOutput", "ActualConsumption", "InstalledGenCapacity")]
aggregate(data$ActualGenerationOutput, by = list(country=data$ctr_code), FUN=sum, na.rm=T)

df_aggr_ctr <- aggregate(data[c("ActualGenerationOutput", 
                                  "ActualConsumption", 
                                  "InstalledGenCapacity")]
                          , by = list(country=data$ctr_code), FUN=sum, na.rm=T)


df_aggr_ctr
#gigawatt
df_aggr_ctr[,2:ncol(df_aggr_ctr)] <- df_aggr_ctr[,2:ncol(df_aggr_ctr)] *0.001


#if all codes in the shapefile countries are in the Energyfile data
#Eliminate differences
unique(data$ctr_code) %in% countries$WB_A2
countries$WB_A2

#Create new collumns so both have the same name
countries$ctr_code <- countries$MB_A2

#in one line: shows codes that are in shapefile but not in energy file
unique(data$ctr_code)[!unique(data$ctr_code) %in% countries$WB_A2]

#NIE is Northern Ireland but represents great britain (checked in QGIS), to be corrected
data$ctr_code[data$ctr_code =="NIE"] <- "GB"

#Is Norway even in the energy dataset?
countries$ctr_code[data$ctr_code =="NO"]
countries$ctr_code[countries$NAME_LONG =="Norway"] <- "NO"
unique(data$ctr_code)[!unique(data$ctr_code) %in% countries$ctr_code]

#now write new dataset into new shapefile and open in QGIs
st_write(df_aggr_ctr, dsn = "C:/Users/jmaie/OneDrive/R/MB12/data/3day4_data_energy_prod_EU_2020-08-03_2020-08-09_ctr_code_aggr_ctr.csv", layer = "3day4_data_energy_prod_EU_2020-08-03_2020-08-09_ctr_code_aggr_ctr.csv", driver = "csv")
st_write(countries, dsn = "C:/Users/jmaie/OneDrive/R/MB12/data/ne_10m_admin_0_countries/2ne_10m_admin_0_countries.gpkg", layer = "2ne_10m_admin_0_countries.gpkg", driver = "GPKG")
class(countries)
#now join the energy data with the spatial data -> see other file
#in QGIS: Load new file in qgis, load energy file as delimited text -> no geoetry -> properties of shape -> join -> export new shapefile ->
#st_write (...spkg)