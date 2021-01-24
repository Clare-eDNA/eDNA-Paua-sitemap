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

library(ggmap)
library(mapproj)
map <- get_map(location = "New Zealand", zoom = 16)

