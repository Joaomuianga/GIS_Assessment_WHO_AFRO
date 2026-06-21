###################################################################################
# GIS Specialist technical assessment 
# Author: Joao Muianga
# Purpose:
#    Load surveillance datasets from CSV files into 
#    PostgreSQL/PostGIS database
# Data: 19 June 2026
###################################################################################


# Load libraries
library(pacman)
pacman::p_load(DBI, RPostgres, readr)

 # connect to  PostgreSQL database
con <- dbConnect(
  Postgres(),
  dbname = "surveillance",
  host = "localhost",
  port = 5432
)

# named list linking database table to CSV files
tables <- list(
  countries = "data/countries.csv",
  population = "data/population.csv",
  disease_surveillance = "data/disease_surveillance.csv",
  outbreaks = "data/outbreaks.csv",
  funding = "data/funding.csv",
  reporting_metrics = "data/reporting_metrics.csv",
  laboratory_capacity = "data/laboratory_capacity.csv",
  workforce = "data/workforce.csv"
)

# load data into PostgreSQL 
for(tbl in names(tables)) {
  
  cat("Loading:", tbl, "\n")
  
  df <- read_csv(
    tables[[tbl]],
    show_col_types = FALSE
  )
  
  # Empty existing records
  dbExecute(
    con,
    paste0(
      "TRUNCATE TABLE ",
      tbl,
      " CASCADE"
    )
  )
  
  # Reload fresh data
  dbWriteTable(
    con,
    tbl,
    df,
    append = TRUE,
    row.names = FALSE
  )
  
}

cat("All tables loaded successfully!\n")

dbDisconnect(con)
