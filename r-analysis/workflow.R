# Setting my working directory
setwd("~/Desktop/Learning/mass-protest-analysis/")

library(tidyverse)
library(arrow)

# Reading in the data
world_protests <- read_parquet("mass_protest.parquet")
world_protests <- as.data.frame(world_protests)


# Unique regions in the dataset
unique(world_protests$region)

# Some of the regions in MENA should be in Africa
mena_africa <- c("Algeria", "Djibouti", "Egypt", "Libya", "Mauritania", 
                  "Morocco", "Somalia", "Sudan", "Tunisia")

# Getting regions in MENA
mena_countries <- world_protests %>%
  filter(region == "MENA") %>%
  distinct(country) %>%
  pull()

# Check if there are regions that should be in Africa
north_africa <- intersect(mena_africa, mena_countries)

# Convert them to Africa
world_protests <- world_protests %>%
  mutate(region = if_else(country %in% north_africa, "Africa", region))

# Get only data for African countries
africa_protest <- world_protests %>%
  filter(region == "Africa")
  
# Save to folder (don't include in write-up)
write_parquet(africa_protest, "../mass-protest-analysis/africa_protest.parquet")


