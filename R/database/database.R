############################################################
# Database Connection
############################################################

library(pacman)
pacman::p_load(DBI, RPostgres)

get_connection <- function() {
  
  dbConnect(
    RPostgres::Postgres(),
    dbname = "surveillance",
    host = "localhost",
    port = 5432
  )
  
}
