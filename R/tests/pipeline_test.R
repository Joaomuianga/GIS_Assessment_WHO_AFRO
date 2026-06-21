############################################################
# PIPELINE VALIDATION SCRIPT
# Purpose:
# Validate the complete ETL and scoring pipeline
############################################################

message("Loading functions...")

source("R/database/load_from_db.R")
source("R/processing/data_cleaning.R")
source("R/processing/data_merge.R")
source("R/processing/support_score.R")

############################################################
# LOAD DATA
############################################################

message("Loading data...")

data <- load_data()

############################################################
# MERGE DATASETS
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
# BASIC VALIDATION
############################################################

latest_year <- max(
  analysis_data$year,
  na.rm = TRUE
)

message(
  paste(
    "Records:",
    nrow(analysis_data)
  )
)

stopifnot(
  nrow(analysis_data) > 0
)

############################################################
# CALCULATE SCORES
############################################################

priority_countries <-
  
  analysis_data %>%
  
  filter(
    year == latest_year
  ) %>%
  
  calculate_support_score()

############################################################
# VALIDATE SCORES
############################################################

stopifnot(
  "support_score" %in%
    names(priority_countries)
)

message(
  paste(
    "Countries with support score:",
    sum(
      !is.na(
        priority_countries$support_score
      )
    )
  )
)

############################################################
# COUNTRY SPOT CHECKS
############################################################

test_countries <- c(
  "Senegal",
  "Cote d'Ivoire",
  "Rwanda"
)

message("Country score validation")

priority_countries %>%
  
  filter(
    country_name %in%
      test_countries
  ) %>%
  
  select(
    country_name,
    outbreak_score,
    reporting_gap,
    lab_gap,
    workforce_gap,
    funding_gap,
    detection_gap,
    support_score
  ) %>%
  
  print()

message("Raw indicators validation")

analysis_data %>%
  
  filter(
    
    country_name %in%
      test_countries,
    
    year == latest_year
    
  ) %>%
  
  select(
    country_name,
    outbreaks_count,
    timeliness_pct,
    completeness_pct,
    iso15189_accreditation_pct,
    feltp_trained_pct,
    funding_per_capita_usd,
    avg_detection_delay
  ) %>%
  
  print()

############################################################
# MISSING VALUES
############################################################

missing_scores <-
  
  sum(
    is.na(
      priority_countries$support_score
    )
  )

message(
  paste(
    "Missing support scores:",
    missing_scores
  )
)

############################################################
# SUCCESS
############################################################

message("--------------------------------")
message("Pipeline validation successful")
message("--------------------------------")
