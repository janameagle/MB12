library(readr)
library(car)

#file1 <-  read_csv("data/day2_data_energy_prod_EU_2020-08-03_2020-08-09.csv")
data <-read.csv("data/day2_data_energy_prod_EU_2020-08-03_2020-08-09.csv")

#head(file1)
names(data)  
str(data)
dim(data)
class(data)
levels(data)
head(data)
head(data$AreaName)
summary(data$AreaName)
#order(data)
str(data)
unique(data$AreaName)
table(data$AreaName)


#What can we analyse the data? What can we do with the dataset?
# barplot generation per day / per powerplant
#

summary(data)
#plot(data)

data[,14]
data[,16]

plot(table(data$AreaName))

meanOutput <- aggregate(data$ActualGenerationOutput, by = list(data$Day),FUN=mean, na.rm=T)
meanOutput
plot(meanOutput)
barplot(meanOutput[,2], 1)

capacity <- aggregate(data$ActualGenerationOutput, by = list(data$Day),FUN=mean, na.rm=T)
plot(capacity[,2])

oneday <- data[data$Day == 3 & data$AreaName=="Energinet CA",]

oneday
dim(oneday)
dim(data)
plot(oneday$ActualGenerationOutput)

#skinny <- data[data[,14] > 1 & data[,4] == 3,c(4, 5, 14, 16, 17)]
#skinny

#scatterplot(skinny[,2], skinny[,3], ylim=c(0,100))
#summary(skinny)

install.packages("skimr")
library(skimr)
skim(data)

install.packages("DataExplorer")
library(DataExplorer)
DataExplorer::create_report(data)

skinny <- data[data[,14] > 1 & data[,4] == 3 & data[,12] == "Northwind",c(4, 5, 14, 16, 17)]
skinny[,2]
scatterplot(skinny[,2], skinny[,3])
skinny




# Jakobs Analysis
# load data

# summary
summary(data)
dim(data)
colnames(data)

# categorical variables
unique(data$MapCode)
length(unique(data$GenerationUnitEIC))

# actual vs. installed capacity
x11()
plot(x = data$InstalledGenCapacity, y = data$ActualGenerationOutput)

data[which.max(data$ActualGenerationOutput),]
data <- data[-which.max(data$ActualGenerationOutput),]

plot(x=data$InstalledGenCapacity, y= data$ActualGenerationOutput)
data <- data[-which.max(data$ActualGenerationOutput),]

plot(x = data$InstalledGenCapacity, y = data$ActualGenerationOutput)

# create counts of Production Type
counts <- table(data$ProductionTypeName)
counts

# aggregate Generation by day
prod_by_day <- aggregate(data$ActualGenerationOutput,
          by = list(Day = data$Day), FUN = sum,
          na.rm = T)

prod_by_day$x <- prod_by_day$x * 0.001 #gigawatt

plot(x=prod_by_day$Day, y=prod_by_day$x)

# aggregate installed capacity by day
cap_by_day <- aggregate(data$InstalledGenCapacity,
                         by = list(Day = data$Day), FUN = sum,
                         na.rm = T)

cap_by_day$x <- cap_by_day$x * 0.001 #gigawatt

plot(x=cap_by_day$Day, y=cap_by_day$x)

