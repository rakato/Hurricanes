

#libraries
library(maps)
library(maptools)
library(rgdal)

#read in dat files
sandy<- read.table(file="http://weather.unisys.com/hurricane/atlantic/2012H/SANDY/track.dat", skip=3, fill=TRUE, stringsAsFactors = FALSE)

colnames(sandy)<-c("advisory","Latitude","Longitude", "Time", "WindSpeed", "Pressure", "Status")

sandy$WindSpeedColor <- 'blue'
sandy$WindSpeedColor[sandy$WindSpeed>=75]<-'red'

#set graphical limits for mapspace

xlim<- c(-110, -65)
ylim<- c(22,52)

#list the states in the map
state.list<- c('new york', 'new jersey', 'virginia', 'massachusetts', 'connecticut', 'delaware', 'pennsylvania', 'maryland', 'south carolina',
'north carolina', 'georgia', 'louisiana', 'texas', 'mississippi', 'alabama', 'tennessee', 'arkansas', 'missouri', 'kentucky', 'illinois', 'indiana',
'ohio', 'oklahoma', 'kansas', 'michigan', 'nebraska', 'south dakota', 'north dakota', 'iowa', 'minnesota')
my.map<- map("state", region = state.list, interior=FALSE, xlim=xlim, ylim=ylim)
map("state", region = state.list, boundary = FALSE, col = "gray", add = TRUE, xlim=xlim)

#lines, points, and text
lines(x=sandy$Longitude, y=sandy$Latitude)
points(x=sandy$Longitude, y=sandy$Latitude, col= sandy$WindSpeedColor, pch=16, cex=0.9)
#text(x=sandy$Longitude, y=sandy$Latitude, col='red', labels=andy$Pressure, adj=c(-0.9), cex=0.5)

title("(l to r) Paths of Hurricane Andrew (1992), Irene (2011), and Sandy (2012)")
#  "\n with Wind Speed and Pressure")
legend('topright', c('Tropical Storm Wind Speeds< 75mph', 'Hurricane Wind Speeds > 75mph'), pch=15, col=c('blue', 'red'))

#Andrew 8/16/92 to 8/28/92
#Irene 8/21/11 to 8/28/11
#Sandy 10/22/12 to 11/2/12