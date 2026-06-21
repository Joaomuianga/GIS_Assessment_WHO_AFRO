############################################################
# Run Data Quality Assessment
############################################################

source("R/processing/data_quality.R")
source("R/database/load_from_db.R")

data <- load_data()

run_quality_report(data$countries,"Countries")
run_quality_report(data$population,"Population")
run_quality_report(data$disease_surveillance,"Disease Surveillance")
run_quality_report(data$outbreaks,"Outbreaks")
run_quality_report(data$funding,"Funding")
run_quality_report(data$reporting_metrics,"Reporting Metrics")
run_quality_report(data$laboratory_capacity,"Laboratory Capacity")
run_quality_report(data$workforce,"Workforce")
