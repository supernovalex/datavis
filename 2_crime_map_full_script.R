
# data import function
importdata = function(d) {
    all = NULL
    retain = c("Month", "Longitude", "Latitude", "LSOA.code", "LSOA.name", "Crime.type")
    
    currdir = dir(d)
    
    for(i in currdir) {
        currdirfile = dir(paste0(d, "/", i))
        for(j in currdirfile) {
            filename = j
            currfilepath = paste0(d, "/", i, "/", filename)
            currfile = read.csv(currfilepath)
            
            currfilesub = currfile[retain]
            currfilesub = currfilesub[which(complete.cases(currfilesub)), ]
            currfilesub = currfilesub[which(currfilesub$Latitude > 51.275), ]
            currfilesub = currfilesub[which(currfilesub$Latitude < 51.7), ]
            currfilesub = currfilesub[which(currfilesub$Longitude > -0.53), ]
            currfilesub = currfilesub[which(currfilesub$Longitude < 0.35), ]
            
            print(filename)
            print(dim(currfilesub))
            all = rbind(all, currfilesub)
        }
    }
    return(all)
}

# don't go alone
library(dplyr)
library(rgdal)
library(ggplot2)

######
# Change this to the extracted zip folder (or path). I renamed mine to "police"

folder = "police"

######

# load data using the function created earlier 
crimes = importdata(folder)
crimeType = distinct(crimes, Crime.type)
crimeType
crimesNoArea = crimes[, c("Month", "Longitude", "Latitude", "Crime.type")]

# save the extracted data for later
write.csv(crimes, file = paste0(folder, "/allcrimes.csv", row.names = F))
write.csv(crimesNoArea, file = paste0(folder, "/allcrimesnoarea.csv"), row.names = F)
write.csv(crimeType, file = paste0(folder, "/crimetypes.csv"), row.names = F)

# funky geolocation information system stuff (GIS)
shapefilepath = "London Map/London-wards-2018_ESRI"
shapefile = readOGR(file.path(shapefilepath), layer = "London_Ward")
proj4string(shapefile) = CRS("+init=epsg:27700")
shapefile.wgs84 = spTransform(shapefile, CRS("+init=epsg:4326"))

# save GIS data to ggplot object
gg = ggplot(shapefile.wgs84) + 
    geom_polygon(aes(x = long, 
                     y = lat, 
                     group = group), 
                 fill = "white", 
                 colour = "black") + 
    labs(x = "Longitude", 
         y = "Latitude", 
         title = "Map of Greater London with borough boundaries")

# print crime location data with ggplot (make take a while to draw to screen)
gg + geom_point(data = crimes, 
                aes(x = Longitude, 
                    y = Latitude, 
                    colour = Crime.type)) + 
    scale_color_manual(values = rainbow(14)) + 
    labs(x = "Longitude", 
         y = "Latitude", 
         title = "Crime map of London with borough boundaries")