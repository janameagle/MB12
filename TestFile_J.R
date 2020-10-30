#This is a test file

install.packages("raster")
library(raster)
install.packages("rgdal")
library(rgdal)

germany <- readOGR("C:/Users/jmaie/OneDrive/R")
plot(germany)
setwd("C:/Users/jmaie/OneDrive/R")
prec <- getData("worldclim" , var="prec" , res=10)
