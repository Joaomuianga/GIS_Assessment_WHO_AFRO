############################################################
# Data Integration Functions
# Author: Joao Muianga
# Date: 19 June 2026
#
# Purpose:
#      Merge cleaned datasets into a single analytical dataset for dashboarding and support scoring.
############################################################

library(tidyverse)

# Merge Datasets

merge_datasets <- function(
    countries,
    population,
    funding,
    reporting_metrics,
    laboratory_capacity,
    workforce,
    outbreaks
){
  
  # Aggregate outbreak event data
  outbreak_summary <-
    aggregate_outbreaks(outbreaks)
  
  analysis_data <- population %>%
    left_join(countries,by = "iso3") %>%
    left_join(funding,by = c("iso3","year")) %>%
    left_join(reporting_metrics,by = c("iso3","year")) %>%
    left_join(laboratory_capacity,by = c("iso3","year")) %>%
    left_join(workforce,by = c("iso3","year")) %>%
    left_join(outbreak_summary,by = c("iso3","year")) %>%
    mutate(
      outbreaks_count     = replace_na(outbreaks_count, 0),
      outbreak_cases      = replace_na(outbreak_cases, 0),
      outbreak_deaths     = replace_na(outbreak_deaths, 0),
      avg_detection_delay = replace_na(avg_detection_delay, median(outbreak_summary$avg_detection_delay, na.rm = TRUE))
    )
  
  return(analysis_data)
  
}

############################################################
# Outbreak Aggregation
############################################################

aggregate_outbreaks <- function(outbreaks){
  
  outbreaks %>%
    
    group_by(iso3,year) %>%
    summarise(outbreaks_count = n(),
               outbreak_cases = sum(cases, na.rm = TRUE),
              outbreak_deaths = sum(deaths, na.rm = TRUE),
          avg_detection_delay = mean(time_to_detection_days,na.rm = TRUE), .groups = "drop"
             )
  
}

