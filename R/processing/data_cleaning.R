############################################################
# Data Cleaning Functions
# Author: Joao Muianga
# Date: 19 June 2026
# Purpose:
# Clean and standardize data before merging and analysis.
############################################################

library(tidyverse)
library(stringr)

############################################################
# 1. Standardize ISO3 country codes
############################################################

clean_iso3 <- function(df) {
  
  if ("iso3" %in% names(df)) {
    df <- df %>%
      mutate(
        iso3 = str_trim(iso3),
        iso3 = str_to_upper(iso3)
      )
  }
  
  return(df)
}

############################################################
# 2. Remove exact duplicate rows
############################################################

remove_duplicate_rows <- function(df) {
  
  before_rows <- nrow(df)
  
  df <- df %>%
    distinct()
  
  after_rows <- nrow(df)
  
  cat(
    "Duplicates removed:",
    before_rows - after_rows,
    "\n"
  )
  
  return(df)
  
}

############################################################
# 3. Clean percentage columns
# Rule:
# Percentages must be between 0 and 100.
# Values outside this range are converted to NA.
############################################################

clean_percentages <- function(df) {
  
  pct_cols <- names(df)[
    str_detect(
      names(df),
      "pct|percentage"
    )
  ]
  
  if (length(pct_cols) > 0) {
    
    df <- df %>%
      mutate(
        across(
          all_of(pct_cols),
          ~ ifelse(
            .x < 0 | .x > 100,
            NA,
            .x
          )
        )
      )
    
  }
  
  return(df)
  
}

############################################################
# 4. Validate Geographic coordinates
# Rule:
# Latitude = -90 to 90
# Longitude = -180 to 180
############################################################

clean_coordinates <- function(df) {
  
  if (
    all(
      c("latitude","longitude") %in%
      names(df)
    )
  ) {
    
    df <- df %>%
      mutate(
        latitude =
          ifelse(
            latitude < -90 |
              latitude > 90,
            NA,
            latitude
          ),
        
        longitude =
          ifelse(
            longitude < -180 |
              longitude > 180,
            NA,
            longitude
          )
      )
    
  }
  
  return(df)
  
}

############################################################
# 5. Clean Non-Negative variable
# Only variable that logically cannot be negative are checked
############################################################

clean_non_negative_fields <- function(df) {
  
  non_negative_cols <- intersect(
    
    c(
      
      "cases",
      "deaths",
      
      "cases_reported",
      "deaths_reported",
      
      "total_population",
      "under5_population",
      
      "epidemiologists_total",
      "feltp_trained_total",
      
      "lab_technicians_total",
      
      "total_public_labs",
      "labs_iso15189_accredited",
      
      "total_funding_usd",
      "domestic_funding_usd",
      "external_funding_usd"
      
    ),
    
    names(df)
    
  )
  
  if (length(non_negative_cols) > 0) {
    
    df <- df %>%
      mutate(
        across(
          all_of(non_negative_cols),
          ~ ifelse(
            .x < 0,
            NA,
            .x
          )
        )
      )
    
  }
  
  return(df)
  
}

############################################################
# 6. Missing Value summary
############################################################

summarize_missing <- function(df) {
  
  data.frame(
    variable = names(df),
    missing_values = colSums(is.na(df)),
    percent_missing =
      round(
        colSums(is.na(df)) /
          nrow(df) * 100,
        2
      )
  )
  
}

############################################################
# 7. Master cleaning pipeline
############################################################
clean_dataset <- function(df,
                          dataset_name = "dataset") {
  
  cat("\n")
  cat("=============================\n")
  cat("Cleaning:", dataset_name, "\n")
  cat("=============================\n")
  
  df <- df %>%
    clean_iso3() %>%
    remove_duplicate_rows() %>%
    clean_percentages() %>%
    clean_coordinates() %>%
    clean_non_negative_fields()
  
  cat("Rows:", nrow(df), "\n")
  
  return(df)
  
}


##########################################################
# 8. Cleaning log
##########################################################
clean_dataset <- function(df,
dataset_name = "dataset") {
  
  cat("\n")
  cat("=================================\n")
  cat("CLEANING DATASET:", dataset_name, "\n")
  cat("=================================\n")
  
  before_rows <- nrow(df)
  
  df <- df %>%
    clean_iso3() %>%
    remove_duplicate_rows() %>%
    clean_percentages() %>%
    clean_coordinates() %>%
    clean_non_negative_fields()
  
  after_rows <- nrow(df)
  
  cat("Rows before:", before_rows, "\n")
  cat("Rows after :", after_rows, "\n")
  
  return(df)
  
}
