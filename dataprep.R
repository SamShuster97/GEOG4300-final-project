#Final project data prep
library(tidyverse)
library(sf)

dollars<-st_read("data/dollars_all.gpkg", stringsAsFactors=FALSE) %>%
  filter(str_detect(msa_name,"Chicago"))
tracts<-st_read("data/cbsa75_tract_demographic.gpkg",stringsAsFactors=FALSE)

tracts_chi<-tracts %>%
  filter(str_detect(CBSA,"Chicago"))

tract_points<-tracts_chi %>%
  st_centroid() %>%
  st_distance(dollars) %>%
  as_tibble() 

names(tract_points)<-dollars$store_id
tract_points$gisjn_tct<-tracts_chi$gisjn_tct 
tract_points_min<-tract_points %>%
  gather(st_002700:st_461859,key=store_id,value=dist) %>%
  left_join(dollars %>% select(store_id,store)) %>%
  group_by(gisjn_tct,store) %>%
  summarise(mindist=min(dist)) %>%
  group_by(gisjn_tct) %>%
  mutate(allstore_dist=as.numeric(min(mindist))) %>%
  spread(store,mindist) %>%
  rename(dg_dist=`Dollar General`,
         dt_dist=`Dollar Tree`,
         fd_dist=`Family Dollar`)
tracts_dollar<-tracts_chi %>%
  left_join(tract_points_min)

library(tmap) 
tm_shape(tracts_dollar) +
  tm_polygons("dg_dist")

#Add pop density and supermarket dist
racepop<-read_csv("C:/Users/jshannon/Dropbox/Jschool/GIS data/Census/ACS 2013_2017 data/nhgis0105_2017_tract_racepov.csv") %>%
  select(GISJOIN,AHZAE001) %>%
  rename(gisjn_tct=GISJOIN,totpop=AHZAE001) 

tracts_dollarpop<-tracts_dollar %>%
  left_join(racepop) %>%
  select(gisjn_tct,totpop,white_pct:fd_dist,geom)
area<-st_area(tracts_dollarpop) %>%
  as_tibble() %>%
  rename(area=value) %>%
#  mutate(areakm=area/1000000) %>%
  bind_cols(tracts_dollarpop%>% 
              st_set_geometry(NULL) %>%
              select(gisjn_tct))

tracts_dollararea<-tracts_dollarpop %>%
  left_join(area) %>%
  mutate(areakm=as.numeric(area)/1000000) %>%
  mutate(popdens=totpop/areakm)
  
tm_shape(tracts_dollararea) +
  tm_polygons("popdens",lwd=0)

spmkt<-st_read("C:/Users/jshannon/Dropbox/Jschool/Research/SNAP_and_SNAP_Ed/Data_Projects/Stores_natl/snap_retailers/analysis_NO_UPLOAD/data/snap_retailers_full.gpkg") %>%
  filter(str_detect(msa_name,"Chicago") & store_group=="Supermarket")

spmkt_dist<-tracts_chi %>%
  st_centroid() %>%
  st_distance(spmkt) %>%
  as_tibble() %>%
  bind_cols(tracts_chi %>% st_set_geometry(NULL) %>% select(gisjn_tct)) %>%
  gather(V1:V1501,key=var,value=dist) %>%
  group_by(gisjn_tct) %>%
  summarise(spmkt_dist=as.numeric(min(dist))) 

tracts_dolareaspmkt<-tracts_dollararea %>%
  left_join(spmkt_dist) %>%
  select(gisjn_tct,totpop,areakm,popdens,white_pct:medinc,spmkt_dist,
         allstore_dist:fd_dist) %>%
  filter(totpop>0)
plot(tracts_dolareaspmkt$allstore_dist,tracts_dolareaspmkt$spmkt_dist)
names(tracts_dolareaspmkt)
st_write(tracts_dolareaspmkt,"geog4300_dollarstoredata.gpkg")

