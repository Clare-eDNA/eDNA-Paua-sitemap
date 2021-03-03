## doing a lil R project to make a map of my sampling site! 

library(maps)
library(mapdata)
library(mapproj)
library(maptools)

map('nzHires', xlim=c(165,179), ylim=c(-50,-35))
nz<-map('nzHires')
visual <- ggplotly(nz, height = 1.2 * 600, width = 600, tooltip=c("text"), 
                   hoverinfo='hide', dynamicTicks = FALSE) 

samps <- read.csv("SamplingSite.csv", header=TRUE, stringsAsFactors=T)

#plot all city names of NZ onto
#map.cities(country="New Zealand", label=TRUE, cex=1,xlim=c(165,179), ylim=c(-50,-35), pch=20)

map('nzHires', xlim=c(164,179), ylim=c(-50,-35))
points(samps$Long, samps$Lat, pch=19, col="red",cex=1)
pointLabel(samps$Long, samps$Lat, samps$Sampling_site)



### 
##alternatively, ggmap

library(ggmap)

map.nz <- map_data(map = "nz")
p1 <- ggplot(map.nz, aes(x = long, y = lat, group=group))
p1 <- p1 + geom_polygon()
p1 <- p1 + labs(title = "New Zealand")
p1


p2=p1+geom_point(data = samps, aes(x = Longitude, y = Latitude,shape = Sampling_site, colour = Sampling_site), size = 7,inherit.aes = FALSE)+theme_bw()

p2

p2+ geom_text(data = samps, aes(x = Longitude, y = Latitude, label = Sampling_site), hjust = -0.2, colour = "black", size = 3,inherit.aes = FALSE)

library(ggplot2)
library(ggmap)
library(mapproj)
map <- get_map(location = "New Zealand", zoom = 16)

map.world <- map_data("world")
map.world

par(mar=c(0, 0, 0, 0))
par(mfrow=c(1,1))
world<-map('world')
map(col = 1)



###

#=====
# PLOT
#=====

# BASIC (this is a first draft)

ggplot(world, aes( x = long, y = lat, group = group )) +
  geom_polygon(aes())



world <- map_data(map = "world")
p1 <- ggplot(world, aes(x = long, y = lat, group=group))
p1 <- p1 + geom_polygon()
p1 <- p1 + labs(title = "New Zealand")
p1


map('world', fill = TRUE, col = 1:20)

library(rworldmap)
#get coarse resolution world from rworldmap
sPDF <- getMap()  
mapCountryData(sPDF, nameColumnToPlot='REGION',colourPalette = "black2White", addLegend = FALSE, mapTitle = "")
#mapCountries using the 'continent' attribute  
mapCountryData(sPDF, nameColumnToPlot='continent',colourPalette = "black2White", addLegend = FALSE, mapTitle = "", lwd = 3)


library(rworldmap)
library(rgeos)
library(maptools)
library(cleangeo)  ## For clgeo_Clean()

sPDF <- getMap()
sPDF <- clgeo_Clean(sPDF)  ## Needed to fix up some non-closed polygons 
mapCountryData(sPDF, nameColumnToPlot='REGION')
cont <-
  sapply(levels(sPDF$continent),
         FUN = function(i) {
           ## Merge polygons within a continent
           poly <- gUnionCascaded(subset(sPDF, continent==i))
           ## Give each polygon a unique ID
           poly <- spChFIDs(poly, i)
           ## Make SPDF from SpatialPolygons object
           SpatialPolygonsDataFrame(poly,
                                    data.frame(continent=i, row.names=i))
         },
         USE.NAMES=TRUE)

## Bind the 6 continent-level SPDFs into a single SPDF
cont <- Reduce(spRbind, cont)

## Plot to check that it worked
plot(cont, col=pretty.colors(nrow(cont)))
plot(cont, col=(nrow(cont)))

## Check that it worked by looking at the SPDF's data.frame
## (to which you can add attributes you really want to plot on)
data.frame(cont)
