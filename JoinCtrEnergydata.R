library(sf)
library(ggplot2)

# load
df_aggr <- read.csv("data/day4_data_energy_prod_EU_2020-08-03_2020-08-09_ctr_code_aggr_ctr.csv")
ctr <- st_read("data/ne_10m_admin_0_countries/ne_10m_admin_0_countries_ctr_code.gpkg")

ctr_df <- merge(ctr, df_aggr, by= "ctr_code")
ggplot(ctr_df) + geom_sf()

#crop (or otherwise use xlim to crop the plot without cropping the data)
box <- st_bbox(c(xmin = -30, ymin =35, xmax = 33, ymax=81),
               crs = st_crs(ctr_df))

# error due to map projection 
ctr_df_eur <- st_crop(ctr_df, box)
ggplot(ctr_df_eur) + geom_sf()

#use nice projection, use epsg codes
#st_crs(ctr_df) #shows us projection of the map
ctr_df_eur_laea <- st_transform(ctr_df_eur,st_crs(3035))
ggplot(ctr_df_eur_laea) + geom_sf()

#plot production output
#aesthetics are in the legend, things outside aes are not
ggplot() + geom_sf(data = ctr_df_eur_laea, 
                   aes(fill = ActualGenerationOutput), alpha = 0.75) +
  scale_fill_gradientn(colours = viridis::magma(8))

