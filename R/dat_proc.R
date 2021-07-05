library(tidyverse)
library(readxl)
library(here)

# initial data processing
dat <- read_excel(here('data-raw/Sed_chem_tox - expanded.xlsx')) %>% 
  .[-1, ] %>% 
  select(-`Amphipod survival (n =20)`, -`X__2`) %>% 
  rename(
    station = `Station ID`, 
    depth = `Depth\r\n(m)`,
    toc = `%TOC`,
    tn = `%TN`,
    fine = `%Fine`,
    amph_surv = X__1, 
    embr_surv = `%M.Emb.Surv.`
  ) %>% 
  mutate_all(function(x){ x[x %in% '?'] <- NA; return(x)} ) %>% 
  mutate_if(is.character, as.numeric)

# add station lat/lon
locs <- read.csv(here('data-raw/AllBightStationLocations.csv'), stringsAsFactors = F) %>% 
  filter(Bight %in% 2008) %>% 
  rename(station = StationID) %>% 
  select(station, Latitude, Longitude) %>% 
  mutate(station = as.numeric(station))
dat <- dat %>% 
  left_join(locs, by = 'station') %>% 
  rename(
    lat = Latitude, 
    lon = Longitude
  )

save(dat, file = here('data/dat.RData'), compress = 'xz')
