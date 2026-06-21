CREATE TABLE countries (
iso3 VARCHAR(3) PRIMARY KEY,
country_name VARCHAR(100),
afro_subregion VARCHAR(50),
latitude NUMERIC,
longitude NUMERIC,
priority_country INTEGER
);

CREATE TABLE population (
iso3 VARCHAR(3) REFERENCES countries(iso3),
year INTEGER,
total_population BIGINT,
under5_population BIGINT,
urban_population_pct NUMERIC
);

CREATE TABLE disease_surveillance (
iso3 VARCHAR(3) REFERENCES countries(iso3),
year INTEGER,
disease VARCHAR(100),
cases_reported INTEGER,
deaths_reported INTEGER,
attack_rate_per_100k NUMERIC,
case_fatality_ratio_pct NUMERIC
);

CREATE TABLE outbreaks (
outbreak_id VARCHAR(20) PRIMARY KEY,
iso3 VARCHAR(3) REFERENCES countries(iso3),
year INTEGER,
disease VARCHAR(100),
start_date DATE,
duration_days INTEGER,
time_to_detection_days INTEGER,
cases INTEGER,
deaths INTEGER
);

CREATE TABLE funding (
iso3 VARCHAR(3) REFERENCES countries(iso3),
year INTEGER,
total_funding_usd NUMERIC,
domestic_funding_usd NUMERIC,
external_funding_usd NUMERIC,
funding_per_capita_usd NUMERIC,
domestic_funding_share_pct NUMERIC
);

CREATE TABLE reporting_metrics (
iso3 VARCHAR(3) REFERENCES countries(iso3),
year INTEGER,
timeliness_pct NUMERIC,
completeness_pct NUMERIC,
idsr_weekly_compliance_pct NUMERIC
);

CREATE TABLE laboratory_capacity (
iso3 VARCHAR(3) REFERENCES countries(iso3),
year INTEGER,
total_public_labs INTEGER,
labs_iso15189_accredited INTEGER,
iso15189_accreditation_pct NUMERIC,
avg_turnaround_time_days NUMERIC,
diagnostic_tests_per_100k NUMERIC
);

CREATE TABLE workforce (
iso3 VARCHAR(3) REFERENCES countries(iso3),
year INTEGER,
epidemiologists_total INTEGER,
epidemiologists_per_100k NUMERIC,
feltp_trained_total INTEGER,
feltp_trained_pct NUMERIC,
lab_technicians_total INTEGER,
lab_technicians_per_100k NUMERIC
);

