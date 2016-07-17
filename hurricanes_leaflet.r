

#packages
library(leaflet)
library(stringi)
library(htmltools)
library(RColorBrewer)

#read in dat file
#danny <- readLines("http://weather.unisys.com/hurricane/atlantic/2015/danny/track.dat")
sandy<- readLines("http://weather.unisys.com/hurricane/atlantic/2012H/SANDY/track.dat")

#skip first couple of lines
sandy_dat <- read.table(textConnection(gsub("TROPICAL ", "TROPICAL_", sandy[3:length(sandy)])),
           header=TRUE, stringsAsFactors=FALSE)
           

# take out "_" in storm names
sandy_dat$STAT <- stri_trans_totitle(gsub("_", " ", sandy_dat$STAT))
 
# assign columns
colnames(sandy_dat) <- c("advisory", "lat", "lon", "time", "wind_speed", "pressure", "status")

# use color gradient for different storm status labels
sandy_dat$color <- as.character(factor(sandy_dat$status,
                          levels=c("Tropical Depression", "Tropical Storm",
                                   "Hurricane-1", "Hurricane-2", "Hurricane-3",
                                   "Hurricane-4", "Hurricane-5"),
                          labels=rev(brewer.pal(7, "YlOrBr"))))
                          


#create the map with tiles, lines, circles, popup info
leaflet() %>%
  addTiles() %>%
  addPolylines(data=sandy_dat[sandy_dat$advisory<=9,], ~lon, ~lat, color=~color) %>%
  addCircles(data=sandy_dat[sandy_dat$advisory>9,], ~lon, ~lat, color=~color, fill=~color, radius=25000,
             popup=~sprintf("<b>Advisory forecast for +%dh (%s)</b><hr noshade size='1'/>
                           Position: %3.2f, %3.2f<br/>
                           Expected strength: <span style='color:%s'><strong>%s</strong></span><br/>
                           Forecast wind: %s (knots)<br/>Forecast pressure: %s",
                           htmlEscape(advisory), htmlEscape(time), htmlEscape(lon),
                           htmlEscape(lat), htmlEscape(color), htmlEscape(status),
                           htmlEscape(wind_speed), htmlEscape(pressure)))




