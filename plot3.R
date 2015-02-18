# Question3: Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, 
# 3.1 Which of these four sources have seen decreases in emissions from 1999-2008 for Baltimore City? 
# 3.2 Which have seen increases in emissions from 1999-2008? 
# Plot3: 3.1 There are 3 types which have decreased: nonroad, nonpoint, onroad
# Plot3: 3.2 There is 1 type which have increased: point


# Clean up workspace
rm(list=ls())

# load package needed for plot
library(ggplot2) 

# set working directory to the location where the dataset will be unzipped
setwd("C:\\Users\\Moira\\Documents\\DSClass\\DS4\\Course Project2")

# check to see if directory exists if not create the directory
if (!file.exists("data")){
  dir.create("data")
}

# save the dataset URL into a variable 
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"

# check if the files exists if not download the file
if(!file.exists("data/FNEI_data.zip")) {
  download.file(fileUrl,"data/FNEI_data.zip")
}

# upzip the file(s) into the data directory
unzip("data/FNEI_data.zip", exdir = "data")

# read in the data to dataframe
df_NEI <- readRDS("data/summarySCC_PM25.rds")

# Subsets data for only Baltimore City, Maryland (fips == "24510")
df_SubNEI <- subset(df_NEI, fips == '24510')

# sum the total emissions by year and type for the subset of data
df_TotEmissions <- aggregate(Emissions ~ year+type, df_SubNEI, sum)

# save plot as a PNG file with a width of 480 pixels and a height of 480 pixels.
png(filename = "plot3.png", width = 640, height = 480, units = "px", bg = "white")


# 4 bar plots for each type with color
ggp <- ggplot(df_TotEmissions,aes(factor(year),Emissions,fill=type)) +
  geom_bar(stat="identity") +
  theme_bw() + guides(fill=FALSE)+
  facet_grid(.~type,scales = "free",space="free") + 
  labs(x="year", y=expression("Total PM"[2.5]*" Emission (Tons)")) + 
  labs(title=expression("Total PM"[2.5]*" Emissions,for Baltimore City by Year, by Source Type"))
print(ggp)


dev.off()
