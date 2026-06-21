############################################################
# Load Data From PostgreSQL
# Author: Joao Muianga
# Date: 19 June 2026
############################################################

library(pacman)
pacman::p_load(DBI, RPostgres)

source("R/database/database.R")
load_data <- function() {
  
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
  
  return(data)
  
}
