# Question6: Compare emissions from motor vehicle sources in Baltimore City with emissions 
# from motor vehicle sources in Los Angeles County, California (fips == "06037"). 
# Which city has seen greater changes over time in motor vehicle emissions? Los Angeles
# Answer6: Los Angeles County has had the greatest change.

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

# Get the subset bases on vehicles list and baltimore city or Los Angelas
df_subsetNEISCC <- df_NEISCC[ (VehicleList & df_NEISCC$fips=="24510") |  (VehicleList & df_NEISCC$fips == "06037"), ] 

# sum the total emissions by year and type for the subset of data
df_TotEmissions <- aggregate(Emissions ~ year + fips, df_subsetNEISCC, sum)

# make column fips a factor with a lable
df_TotEmissions$fips <- factor(df_TotEmissions$fips,
                            levels = c("24510","06037"),
                            labels = c("Baltimore City", "Los Angeles County"))

# save plot as a PNG file with a width of 480 pixels and a height of 480 pixels.
png(filename = "plot6.png", width = 480, height = 480, units = "px", bg = "white")

# create the 2 plots showing Baltimore and Los Angeles
ggp <- ggplot(df_TotEmissions,aes(factor(year),Emissions,fill=fips)) +
  geom_bar(stat="identity") +
  theme_bw() + guides(fill=FALSE)+
  facet_grid(.~fips,scales = "free",space="free") + 
  labs(x="Year", y=expression("Total PM"[2.5]*" Motor Vehicle Sources Emission (Tons)")) + 
  labs(title=expression("Total Emissions for Baltimore City and Los Angeles County"))

print(ggp)

dev.off()
