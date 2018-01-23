library(tidyverse)
library(readxl)

dat <- read_excel('ignore/Sed_chem_tox.xlsx') %>% 
  .[-1, ] %>% 
  select(-`Amphipod survival (n =20)`, -`X__2`) %>% 
  rename(
    station = `Station Identity`, 
    toc = `%TOC`,
    tn = `%TN`,
    fine = `%Fine`,
    amph_surv = X__1, 
    embr_surv = `%M.Emb.Surv.`
  ) %>% 
  mutate(
    fine = as.numeric(fine), 
    amph_surv = as.numeric(amph_surv),
    embr_surv = as.numeric(embr_surv)
  )

save(dat, file = 'data/dat.RData', compress = 'xz')
