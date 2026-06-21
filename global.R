############################################################
# WHO AFRO Surveillance Support Dashboard
# GLOBAL CONFIGURATION
# Author: Joao Muianga
############################################################

############################################################
# LOAD LIBRARIES
############################################################

# Shiny Framework
library(shiny)
library(bslib)
library(bsicons)
library(shinyWidgets)

# Data Manipulation
library(tidyverse)

# Spatial Analysis
library(sf)
library(leaflet)

# Interactive Charts
library(plotly)

# Interactive Tables
library(DT)

# Optional
library(scales)
library(glue)

############################################################
# SOURCE R SCRIPTS
############################################################

message("Loading application scripts...")

source("R/utils/helpers.R")
# Database and ETL
source("R/database/database.R")
source("R/database/load_from_db.R")

# Data processing
source("R/processing/data_cleaning.R")
source("R/processing/data_merge.R")
source("R/processing/support_score.R")
source("R/processing/data_quality.R")

# UI components
source("R/ui/ui_overview.R")
source("R/ui/ui_profile.R")
source("R/ui/ui_recommendations.R")
source("R/ui/ui_about.R")

# Server components
source("R/server/server_overview.R")
source("R/server/server_profile.R")
source("R/server/server_recommendations.R")

message("Scripts successfully loaded.")

############################################################
# LOAD DATA
############################################################

message("Loading surveillance datasets...")

data <- load_data(use_cache = TRUE)

############################################################
# DATA CLEANING + MERGING
############################################################

analysis_data <- merge_datasets(
  
  countries =
    clean_dataset(
      data$countries,
      "Countries"
    ),
  
  population =
    clean_dataset(
      data$population,
      "Population"
    ),
  
  funding =
    clean_dataset(
      data$funding,
      "Funding"
    ),
  
  reporting_metrics =
    clean_dataset(
      data$reporting_metrics,
      "Reporting"
    ),
  
  laboratory_capacity =
    clean_dataset(
      data$laboratory_capacity,
      "Laboratory"
    ),
  
  workforce =
    clean_dataset(
      data$workforce,
      "Workforce"
    ),
  
  outbreaks =
    clean_dataset(
      data$outbreaks,
      "Outbreaks"
    )
  
)

############################################################
# DATA QUALITY CHECKS
############################################################

message("Running data quality checks...")

# Optional
# quality_report <- run_data_quality(analysis_data)

############################################################
# GLOBAL PARAMETERS
############################################################

latest_year <- max(
  analysis_data$year,
  na.rm = TRUE
)

available_years <- sort(
  unique(analysis_data$year),
  decreasing = TRUE
)

available_countries <- sort(
  unique(analysis_data$country_name)
)

############################################################
# LOAD SPATIAL DATA
############################################################

message("Loading shapefiles...")

africa_sf <- st_read(
  "data/shapefiles/AFRICAN CONTINENT.shp",
  quiet = TRUE
)

############################################################
# DISEASE SUMMARY
############################################################

disease_summary <-
  data$disease_surveillance %>%
  
  group_by(disease) %>%
  
  summarise(
    
    cases =
      sum(
        cases_reported,
        na.rm = TRUE
      ),
    
    .groups = "drop"
    
  )

############################################################
# SUPPORT SCORE TREND DATA
############################################################

trend_data <-
  
  analysis_data %>%
  
  calculate_support_score() %>%
  
  group_by(year) %>%
  
  summarise(
    
    timeliness =
      mean(
        timeliness_pct,
        na.rm = TRUE
      ),
    
    completeness =
      mean(
        completeness_pct,
        na.rm = TRUE
      ),
    
    laboratory =
      mean(
        iso15189_accreditation_pct,
        na.rm = TRUE
      ),
    
    support_score =
      mean(
        support_score,
        na.rm = TRUE
      ) * 100,
    
    .groups = "drop"
    
  )

############################################################
# COLOR PALETTES
############################################################
priority_palette <- colorFactor(
  palette = c(
    "#B10026",
    "#FC4E2A",
    "#FEB24C",
    "#FED976",
    "#FFF7BC",
    "#D9D9D9"
  ),
  
  domain = c(
    "Very High (≥ 0.90)",
    "High (0.80 - 0.89)",
    "Medium (0.50 - 0.79)",
    "Low (0.20 - 0.49)",
    "Very Low (0.00 - 0.19)",
    "No Data"
  ),
  
  ordered = TRUE
)

priority_colors <- c(
  
  "Very High (≥ 0.90)" = "#B10026",
  "High (0.80 - 0.89)" = "#FC4E2A",
  "Medium (0.50 - 0.79)" = "#FEB24C",
  "Low (0.20 - 0.49)" = "#FED976",
  "Very Low (0.00 - 0.19)" = "#FFF7BC",
  "No Data" = "#D9D9D9"
  
)

############################################################
# DASHBOARD CONSTANTS
############################################################

SUPPORT_THRESHOLDS <- list(
  
  very_high = 0.90,
  high = 0.80,
  medium = 0.50,
  low = 0.20
  
)

WHO_TARGETS <- list(
  
  timeliness = 80,
  completeness = 80,
  laboratory = 50,
  workforce = 30,
  funding = 5
  
)

###########################################################
# PostgreSQL connection 
###########################################################


############################################################
# APPLICATION STARTUP MESSAGE
############################################################

message("---------------------------------------")
message("WHO AFRO Dashboard Initialized")
message(
  paste(
    "Records loaded:",
    nrow(analysis_data)
  )
)

message(
  paste(
    "Countries:",
    length(available_countries)
  )
)

message(
  paste(
    "Years:",
    min(available_years),
    "-",
    max(available_years)
  )
)

message("---------------------------------------")

