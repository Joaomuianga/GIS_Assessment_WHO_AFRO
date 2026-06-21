############################################################
# Load Data From PostgreSQL or RDS Cache
# Author: Joao Muianga
############################################################

library(pacman)
library(DBI) 
library(RPostgres)

source("R/database/database.R")
load_data <- function(use_cache = TRUE) {
  
  cache_file <- "data/cache_data.rds"
  
  if (use_cache && file.exists(cache_file)) {
    
    message("Loading data from RDS cache...")
    return(readRDS(cache_file))
    
  }
  
  message("Loading data from PostgreSQL...")
  
  con <- get_connection()
  
  data <- list(
    countries = dbReadTable(con, "countries"),
    population = dbReadTable(con, "population"),
    disease_surveillance = dbReadTable(con, "disease_surveillance"),
    outbreaks = dbReadTable(con, "outbreaks"),
    funding = dbReadTable(con, "funding"),
    reporting_metrics = dbReadTable(con, "reporting_metrics"),
    laboratory_capacity = dbReadTable(con, "laboratory_capacity"),
    workforce = dbReadTable(con, "workforce")
  )
  
  dbDisconnect(con)
  
  saveRDS(data, cache_file)
  
  message("RDS cache saved to ", cache_file)
  
  return(data)
}
