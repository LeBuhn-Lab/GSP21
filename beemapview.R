#This program basically uses a spatial join to get the counties from the points. 
#The script then uses mapview to make a interactive map, which you can add layers 
#to like openstreetmap and zoom in, etc.  You’ll need to install sf, tidyverse, and mapview.



# install.packages('sf')
# install.packages('tidyverse')
library(sf)
library(tidyverse)

coAlldata <- st_read("US_Counties_WGS84.shp")  # from National Atlas, then projected
co <- coAlldata %>%         
  select(STATE_NAME, COUNTY_NAM, STCO_FIPSC, POPULATION, AREASQKM, geometry)


beedata <- read_csv("All.data.old.csv")
beedata_sp <- st_as_sf(beedata, coords = c("long_esri_wgs84_1","lat_esri_wgs84_1"), crs=4326) %>%
  st_join(co) #This spatial join will put the above state and county data into the data frame.

#Bee data summarized
beesum <- beedata_sp %>%
  filter(!is.na(locationID)) %>%
  group_by(locationID, na.rm=TRUE) %>%
  summarize(
    last_pollinator = last(pollinatorName),
    state = first(STATE_NAME),
    county = first(COUNTY_NAM),
    population = first(POPULATION),
    areasqkm = first(AREASQKM))

# mapview (turn on OpenStreetMap or imagery in layers)
#install.packages("mapview")
library(mapview)
mapview(beesum["state"])

# beewest <- beesum %>%
#   filter(state %in% c("California", "Oregon", "Washington", "Idaho", "Montana",
#                       "Wyoming", "Colorado", "New Mexico", "Arizona", "Utah", "Nevada"))
# westco <- co %>%
#   filter(STATE_NAME %in% c("California", "Oregon", "Washington", "Idaho", "Montana",
#                       "Wyoming", "Colorado", "New Mexico", "Arizona", "Utah", "Nevada"))
# 
# ggplot() +
#   geom_sf(data = westco, fill = NA) +
#   geom_sf(data = beewest, aes(color = "state")) +
#   labs(x='',y='')
# 
# ggplot() +
#   #geom_sf(data = westco, fill = NA) +
#   geom_sf(data = beewest, aes(color = state))
# 
#           
#           (data = beewest, mapping = aes(color=state))
# 
# BayAreaBasemapNohill <- ggplot() +
#   geom_sf(data = co, fill = NA) +
#   coord_sf(xlim = c(bnd[1], bnd[3]), ylim = c(bnd[2], bnd[4])) +
#   labs(x='',y='')
# 
# 
#       
# coord_sf(xlim = c(bnd[1], bnd[3]), ylim = c(bnd[2], bnd[4])) +
# ggplot(data = beewest) +
#   geom_sf(westco)
#   

