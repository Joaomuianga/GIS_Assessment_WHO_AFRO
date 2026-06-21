# WHO AFRO Surveillance Support Dashboard

## Author

**João Constantino Muianga**
Consultant – GIS Specialist Technical Assessment
June 2026

GitHub: https://github.com/Joaomuianga/GIS_Assessment_WHO_AFRO
Live Dashboard: https://joaomuianga.shinyapps.io/gis_assessment/

---

# 1. Project Overview

The WHO AFRO Surveillance Support Dashboard is an interactive decision-support platform developed to assist WHO Regional Office for Africa in identifying countries requiring enhanced surveillance support and prioritizing resource allocation.

The dashboard integrates surveillance, laboratory, workforce, funding, and outbreak indicators to generate a composite Surveillance Support Score and identify countries requiring targeted interventions.

---

# 2. Objectives

The dashboard was developed to support:

* Surveillance system performance assessment.
* Identification of countries requiring urgent support.
* Evidence-based decision making.
* Resource prioritization across countries.
* Regional monitoring of surveillance trends.

---

# 3. Key Questions

The application addresses the following questions:

1. Which countries require urgent support?
2. Which surveillance indicators are performing poorly?
3. Where should WHO prioritize interventions?
4. How have surveillance indicators evolved over time?
5. Which countries have the highest surveillance support needs?

---

# 4. Data Sources

The application uses synthetic datasets representing surveillance information from 20 African countries between 2021 and 2025.

Datasets include:

| Dataset              | Description                                   |
| -------------------- | --------------------------------------------- |
| Countries            | Country reference information and coordinates |
| Population           | Annual population estimates                   |
| Disease Surveillance | Core surveillance indicators                  |
| Outbreaks            | Event-level outbreak information              |
| Laboratory Capacity  | Laboratory performance indicators             |
| Reporting Metrics    | Timeliness and completeness indicators        |
| Workforce            | Epidemiology workforce indicators             |
| Funding              | Annual surveillance funding levels            |

---

# 5. Technology Stack

## Programming Languages

* R

## Database

* PostgreSQL

## Packages

* shiny
* bslib
* tidyverse
* leaflet
* plotly
* DT
* sf
* DBI
* RPostgres
* scales

## Version Control

* Git
* GitHub

---

# 6. System Architecture

CSV Files

↓

PostgreSQL Database

↓

ETL and Data Processing

↓

Data Quality Assessment

↓

Composite Surveillance Support Score

↓

Analytical Cache (.rds)

↓

Interactive Shiny Dashboard

---

# 7. Project Structure

```text
GIS_Assessment/
│
├── app.R
├── global.R
├── data/
├── docs/
├── R/
│   ├── database/
│   ├── processing/
│   ├── server/
│   ├── ui/
│   └── utils/
│
├── sql/
├── www/
│   ├── styles.css
│   ├── script.js
│   └── logo.png
│
└── README.md
```

---

# 8. Data Processing Workflow

The application follows the steps below:

1. Load surveillance data from PostgreSQL.
2. Perform data cleaning and validation.
3. Merge all datasets.
4. Calculate derived indicators.
5. Compute Surveillance Support Score.
6. Classify countries into priority categories.
7. Save processed analytical datasets as RDS cache files.
8. Visualize results through the dashboard.

---

# 9. Surveillance Support Score

A composite score was developed using multiple surveillance dimensions:

* Reporting timeliness.
* Reporting completeness.
* Laboratory capacity.
* Workforce density.
* Funding per capita.
* Outbreak burden.

Countries are classified into:

| Category  | Threshold |
| --------- | --------- |
| Very High | ≥ 0.90    |
| High      | 0.80–0.89 |
| Medium    | 0.50–0.79 |
| Low       | 0.20–0.49 |
| Very Low  | < 0.20    |

---

# 10. Dashboard Components

## Overview

* Regional KPIs.
* Priority country ranking.
* Interactive map.
* Indicator summaries.
* Outbreak distributions.
* Regional trends.

## Country Profile

Provides detailed country-level information.

## Recommendations

Generates tailored recommendations based on surveillance performance.

## About

Project information and methodology.

---

# 11. Deployment

The application was developed locally using PostgreSQL.

For cloud deployment, processed analytical datasets are stored as RDS files to avoid dependency on external database connections.

Deployment platform:

* shinyapps.io

---

# 12. Installation

Clone repository:

```bash
git clone https://github.com/Joaomuianga/GIS_Assessment_WHO_AFRO.git
```

Install packages:

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
  "RPostgres",
  "scales"
))
```

Run application:

```r
shiny::runApp()
```

---

# 13. Outputs

<<<<<<< HEAD
GIS Specialist | Data Manager | Public Health Informatics
=======
The dashboard supports:

* Country prioritization.
* Regional surveillance monitoring.
* Resource allocation.
* Programmatic decision-making.
* Strategic planning.

---

# 14. Disclaimer

This assessment uses synthetic data for demonstration purposes only.

---

# 15. Repository

GitHub Repository:

https://github.com/Joaomuianga/GIS_Assessment_WHO_AFRO

Live Dashboard:

<INSERT SHINYAPPS URL HERE>
>>>>>>> 3d849b9 (Update dashboard design, documentation and architeture)
