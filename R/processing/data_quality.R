############################################################

# Data Quality Assessment Functions
# Author: Joao Muianga
# Date: 19 June 2026
# Purpose: Perform data profiling and quality assessment prior to cleaning, integration and analysis.

############################################################

library(tidyverse)

############################################################
# 1. Missing Values Assessment
############################################################

check_missing <- function(df) {
  
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
# 2. Duplicate Records Assessment
############################################################

check_duplicates <- function(df) {
  
  duplicates <-
    nrow(df) -
    nrow(distinct(df))
  
  return(duplicates)
  
}

############################################################
# 3. Percentage Validation
# Rule:
# Percentage values must be between 0 and 100
############################################################
check_percentages <- function(df) {
  
  pct_cols <- names(df)[
    grepl(
      "pct|percentage",
      names(df),
      ignore.case = TRUE
    )
  ]
  
  results <- list()
  
  for (col in pct_cols) {
    
    invalid_rows <- df %>%
      filter(
        .data[[col]] < 0 |
          .data[[col]] > 100
      )
    
    results[[col]] <- nrow(invalid_rows)

    
  }
  
  return(results)
  
}

############################################################
# 4. Geographic Coordinate Validation
############################################################
check_coordinates <- function(df) {
  
  if (
    !all(
      c("latitude","longitude") %in%
      names(df)
    )
  ) {
    return(NULL)
  }
  
  invalid_coords <- df %>%
    filter(
      latitude < -90 |
        latitude > 90 |
        longitude < -180 |
        longitude > 180
    )
  
  return(invalid_coords)
  
}

############################################################
# 5. Negative Value Assessment
# Identifies numeric variables with negative values.
############################################################
check_negative_values <- function(df) {
  
  numeric_cols <- names(df)[
    sapply(df, is.numeric)
  ]
  
  numeric_cols <- setdiff(
    numeric_cols,
    c("latitude", "longitude")
  )
  
  results <- data.frame()
  
  for (col in numeric_cols) {
    negative_count <-
      sum(
        df[[col]] < 0,
        na.rm = TRUE
      )
    
    results <- rbind(
      results,
      data.frame(
        variable = col,
        negative_values = negative_count
      )
    )

  }
  
  return(results)
  
}

############################################################
# 6. Referential Integrity Check
# Ensures all ISO3 codes exist in countries table.
############################################################
check_referential_integrity <- function(
    df,
    countries_df
) {
  
  if (
    !("iso3" %in% names(df))
  ) {
    return(NULL)
  }
  
  invalid_iso3 <- anti_join(
    df,
    countries_df,
    by = "iso3"
  )
  
  return(invalid_iso3)
  
}

############################################################
# 7. Primary Key Assessment
# Example:
# population -> iso3 + year
############################################################
check_primary_key <- function(
    df,
    key_columns
) {
  
  df %>%
    count(
      across(
        all_of(key_columns)
      )
    ) %>%
    filter(n > 1)
  
}

############################################################
# 8. Dataset Summary
############################################################
dataset_summary <- function(df) {
  
  data.frame(
    rows = nrow(df),
    columns = ncol(df),
    missing_values =
      sum(is.na(df))
  )
  
}

############################################################
# 9. Full Data Quality Report
############################################################
run_quality_report <- function(
    df,
    dataset_name = "dataset"
) {
  
  cat("\n")
  cat("====================================\n")
  cat("DATA QUALITY REPORT\n")
  cat("Dataset:", dataset_name, "\n")
  cat("====================================\n")
  
  print(dataset_summary(df))
  
  cat("\nMissing Values\n")
  print(check_missing(df))
  
  cat("\nDuplicate Records\n")
  print(check_duplicates(df))
  
  cat("\nNegative Values\n")
  print(check_negative_values(df))
  
  cat("\nPercentage Validation\n")
  print(check_percentages(df))
  
  cat("\nCoordinate Validation\n")
  print(check_coordinates(df))
  
}

############################################################
# 10. Cases vs Deaths Validation
############################################################

check_cases_vs_deaths <- function(df){
  
  if(
    !all(
      c(
        "cases_reported",
        "deaths_reported"
      ) %in% names(df)
    )
  ){
    return(NULL)
  }
  
  df %>%
    filter(
      deaths_reported >
        cases_reported
    )
  
}

############################################################
# 11. Data Quality Score
############################################################

calculate_quality_score <- function(df){
  
  missing_pct <-
    sum(is.na(df)) /
    (nrow(df) * ncol(df))
  
  duplicate_pct <-
    check_duplicates(df) /
    nrow(df)
  
  score <-
    round(
      (1 -
         missing_pct -
         duplicate_pct) * 100,
      2
    )
  
  return(score)
  
}
