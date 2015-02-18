# Question2:  Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == "24510") from 1999 to 2008?
# Plot2: Yes the total emissions have decreased


# Clean up workspace
rm(list=ls())

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

# sum the total emissions by year for the subset of data which is Baltimore
df_TotEmissions <- aggregate(Emissions ~ year, df_SubNEI, sum)

# save plot as a PNG file with a width of 480 pixels and a height of 480 pixels.
png(filename = "plot2.png", width = 480, height = 480, units = "px", bg = "white")

# create a bar plot show the data
barplot(df_TotEmissions$Emissions,
        names.arg=df_TotEmissions$year,
        xlab='Year',
        ylab=expression('Sum of PM'[2.5]*' Emissions in Tons'),
        main=expression('Total PM'[2.5]*' Emissions for Baltimore City By Year.')
)

dev.off()