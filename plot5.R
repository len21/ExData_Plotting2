# Question5 #How have emissions from motor vehicle sources changed from 1999-2008 in Baltimore City?
# Answer:

# Clean up workspace
rm(list=ls())

# set working directory to the location where the dataset was unzipped
setwd("C:\\Users\\Moira\\Documents\\DSClass\\DS4\\Course Project2")

# load package needed for plot
library(ggplot2) 

## check to see if directory exists if not create
if (!file.exists("data")){
  dir.create("data")
}

# save the URL into a variable 
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"

# check if the files exists if not download the file
if(!file.exists("data/FNEI_data.zip")) {
  download.file(fileUrl,"data/FNEI_data.zip")
}

# upzip the file into the data directory
unzip("data/FNEI_data.zip", exdir = "data")

# read in the data to dataframe
df_NEI <- readRDS("data/summarySCC_PM25.rds")
df_SCC <- readRDS("data/Source_Classification_Code.rds")

# conbime the two dataframe
df_NEISCC <- merge(df_NEI, df_SCC, by="SCC")

# Find all vehicles
VehicleList <- grepl("Highway Veh", df_NEISCC$Short.Name, ignore.case=TRUE)

# Get the subset bases on vehicles list and baltimore city
df_subsetNEISCC <- df_NEISCC[VehicleList & df_NEISCC$fips=="24510" , ] 

# sum the total emissions by year and type for the subset of data
df_TotEmissions <- aggregate(Emissions ~ year, df_subsetNEISCC, sum)


# save plot as a PNG file with a width of 480 pixels and a height of 480 pixels.
png(filename = "plot5.png", width = 480, height = 480, units = "px", bg = "white")

ggp <- ggplot(df_TotEmissions, aes(factor(year), Emissions)) + 
  geom_bar(stat="identity") +  
  xlab("year") +
  ylab(expression('Total PM'[2.5]*" Emissions")) +
  ggtitle('Total Emissions from motor vehicle from 1999 to 2008')

print(ggp)

dev.off()