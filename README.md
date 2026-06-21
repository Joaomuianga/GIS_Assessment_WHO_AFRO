# WHO AFRO Surveillance Support Dashboard

## Overview

This project was developed by Joao Muianga as part of the technical assessment for the GIS Specialist position.

The dashboard supports evidence-based decision-making for strengthening disease surveillance systems across the WHO African Region.

## Features

- Interactive surveillance support map
- Country prioritization framework
- Regional surveillance indicators
- Disease outbreak analysis
- Country profile exploration
- Recommendations module
- Trend analysis over time

## Technologies

- R
- Shiny
- PostgreSQL
- Leaflet
- Plotly
- DT
- sf
- dplyr
- DBI
- RPostgres
- bslib

## Project Structure

```
GIS_Assessment/
│
├── app.R
├── global.R
├── R/
├── data/
├── sql/
├── www/
├── docs/
└── presentation/
```

## Dashboard Components

### Overview

- Key Performance Indicators
- Regional support map
- Indicator summaries
- Disease outbreak distribution
- Surveillance trends

### Country Profile

Detailed country-level analysis and performance metrics.

### Recommendations

Evidence-based recommendations for targeted support.

### About

Dashboard information and methodology.

## Running the application

Clone the repository:

```bash
git clone https://github.com/username/GIS_Assessment_WHO_AFRO.git
```

Open R:

```r
install.packages(c(
  "shiny",
  "bslib",
  "tidyverse",
  "leaflet",
  "plotly",
  "DT",
  "sf",
  "DBI",
  "RPostgres"
))

shiny::runApp()
```

## Author

Joao Constantino Muianga

GIS Specialist | Data Manager | Public Health Informatics