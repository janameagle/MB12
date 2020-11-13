
install.packages("rgdal")
library(rgdal)

#reading the data
data <-read.csv("data/day2_data_energy_prod_EU_2020-08-03_2020-08-09.csv")
head(data)
names(data)

countries <- readOGR(dsn= "C:/Users/jmaie/OneDrive/R/MB12/MB12-master/data/ne_10m_admin_0_countries", layer = "ne_10m_admin_0_countries")
#or: ctr <- sr_read()
head(countries)

unique(data$MapCode)


#create a new column
data$country <- data$MapCode

#get all columns which include 'DE_' and rename them to *DE*
data$country[grep("DE_", data$country)] <- "DE"
# or maybe: data$country[data$country %in% "DE"]
unique(data$country)


#aggregate by the column country and ignore NAs
data[c("ActualGenerationOutput", "ActualConsumption", "InstalledGenCapacity")]
aggregate(data$ActualGenerationOutput, by = list(country=data$country), FUN=sum, na.rm=T)

df_aggr_ctr <- aggregate(data[c("ActualGenerationOutput", 
                                  "ActualConsumption", 
                                  "InstalledGenCapacity")]
                          , by = list(country=data$country), FUN=sum, na.rm=T)


df_aggr_ctr
#
df_aggr_ctr[,2:ncol(df_aggr_ctr)] <- df_aggr_ctr[,2:ncol(df_aggr_ctr)] *0.001


#if all codes in the shapefile countries are in the Energyfile data
#Eliminate differences
unique(data$country) %in% countries$WB_A2
countries$WB_A2

#Create new collumns so both have the same name
countries$country <- countries$MB_A2

#in one line: shows codes that are in shapefile but not in energy file
unique(data$country)[!unique(data$country) %in% countries$WB_A2]

#NIE is Northern Ireland but represents great britain (checked in QGIS), to be corrected
data$country[data$country =="NIE"] <- "GB"

#Is Norway even in the energy dataset?
countries$country[data$country =="NO"]
countries$country[countries$NAME_LONG =="Norway"] <- "NO"
unique(data$country)[!unique(data$country) %in% countries$country]

#now write new dataset into new shapefile and open in QGIs


#now join the energy data with the spatial data
#Load new file in qgis, load energy file as delimited text -> no geoetry -> properties of shape -> join -> export new shapefile ->
#st_write (...spkg)