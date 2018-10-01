## Create dataset of PM and O3 for all US taking year 2013 (annual
## data from EPA)

## This uses data from
## http://aqsdr1.epa.gov/aqsweb/aqstmp/airdata/download_files.html

## Read in the 2013 Annual Data
setwd("C:/Users/jroberti/Git/courses/09_DevelopingDataProducts/yhat")

#read dataset
d <- read.csv("annual_all_2013.csv", nrow = 68210)

#subset data 
sub <- subset(d, Parameter.Name %in% c("PM2.5 - Local Conditions", "Ozone")
              & Pullutant.Standard %in% c("Ozone 8-Hour 2008", "PM25 Annual 2006"),
              c(Longitude, Latitude, Parameter.Name, Arithmetic.Mean))

#take the average of measurements at places with multiple measuring systems
pollavg <- aggregate(sub[, "Arithmetic.Mean"],
                     sub[, c("Longitude", "Latitude", "Parameter.Name")],
                     mean, na.rm = TRUE)

#convert the Parameter.Name to a factor so that it has 2 levels and not 491 levels
pollavg$Parameter.Name <- factor(pollavg$Parameter.Name, labels = c("ozone", "pm25"))

#rename column 4 
names(pollavg)[4] <- "level"

## Remove unneeded objects **we only want to upload the necessary info to yhat
rm(d, sub)

## Write function
monitors <- data.matrix(pollavg[, c("Longitude", "Latitude")])

library(fields)

#Input is data frame with:
#lat: latitude of station
#lon: longitude of station
#rad: radius from station for finding other stations

pollutant <- function(df) {
        x <- data.matrix(df[, c("lon", "lat")])
        r <- df$radius
        #make a matrix that has dimensions of # of stations and # of points that we want to make predictions at.
        d <- rdist.earth(monitors, x)
        #loop over all the prediction points and see which monitors fall into that area
        use <- lapply(seq_len(ncol(d)), function(i) {
                which(d[, i] < r[i])
        })
        #produce a vector of 2 levels, ozone and pm2.5, and calculate the average of those values at each point
        levels <- sapply(use, function(idx) {
                with(pollavg[idx, ], tapply(level, Parameter.Name, mean))
        })
        #convert it to a data frame
        dlevel <- as.data.frame(t(levels))
        #return a data frame with input data along with input values
        data.frame(df, dlevel)
}

## Send to yhat

library(yhatr)

model.require <- function() {
        library(fields)
}

model.transform <- function(df) {
        df
}

model.predict <- function(df) {
        pollutant(df)
}

yhat.config  <- c(
        username="rdpeng@gmail.com",
        apikey="90d2a80bb532cabb2387aa51ac4553cc",
        env="http://sandbox.yhathq.com/"
)

yhat.deploy("pollutant")



################################################################################
## Client side

library(yhatr)
yhat.config  <- c(
        username="rdpeng@gmail.com",
        apikey="90d2a80bb532cabb2387aa51ac4553cc",
        env="http://sandbox.yhathq.com/"
)
df <- data.frame(lon = c(-76.6167, -118.25), lat = c(39.2833, 34.05),
                 radius = 20)
yhat.predict("pollutant", df)
