############################################################
# HELPER FUNCTIONS
# WHO AFRO Surveillance Support Dashboard
# Author: Joao Muianga
############################################################


############################################################
# PRIORITY LEVEL CLASSIFICATION
############################################################

get_priority_level <- function(score){
  
  case_when(
    
    is.na(score) ~ "No Data",
    score >= 0.90 ~
      "Very High (≥ 0.90)",
    score >= 0.80 ~
      "High (0.80 - 0.89)",
    score >= 0.50 ~
      "Medium (0.50 - 0.79)",
    score >= 0.20 ~
      "Low (0.20 - 0.49)",
    TRUE ~
      "Very Low (0.00 - 0.19)"
    
  )
  
}


############################################################
# RECODE COUNTRY NAMES FOR MAP LABELS
############################################################

recode_country_name <- function(country){
  
  case_when(
    
    country == "Democratic Republic Of The Congo" ~
      "DR Congo",
    
    country == "Central African Republic" ~
      "CAR",
    
    country == "Equatorial Guinea" ~
      "Eq. Guinea",
    
    country == "South Sudan" ~
      "S. Sudan",
    
    country == "United Republic Of Tanzania" ~
      "Tanzania",
    
    country == "Sao Tome And Principe" ~
      "STP",
    
    country == "Côte D’ivoire" ~
      "Côte d'Iv.",
    
    country == "Sierra Leone" ~
      "S. Leone",
    
    country == "Guinea-Bissau" ~
      "G. Bissau",
    
    country == "Burkina Faso" ~
      "Burkina",
    
    country == "Western Sahara" ~
      "W. Sahara",
    
    TRUE ~ country
    
  )
  
}


############################################################
# FORMAT CURRENCY
############################################################

format_currency <- function(x){
  
  ifelse(
    is.na(x),
    "No Data",
    paste0(
      "$",
      scales::comma(
        round(x, 2)
      )
    )
  )
  
}


############################################################
# FORMAT PERCENTAGES
############################################################

format_percent <- function(x, digits = 0){
  
  ifelse(
    is.na(x),
    "No Data",
    paste0(
      round(x, digits),
      "%"
    )
  )
  
}



############################################################
# SAFE MEAN
############################################################

safe_mean <- function(x){
  
  if(all(is.na(x)))
    return(NA_real_)
  
  mean(
    x,
    na.rm = TRUE
  )
  
}


############################################################
# SAFE SUM
############################################################

safe_sum <- function(x){
  
  if(all(is.na(x)))
    return(NA_real_)
  
  sum(
    x,
    na.rm = TRUE
  )
  
}


############################################################
# COUNTRY FLAG PATH
############################################################

get_flag_path <- function(iso3){
  
  paste0(
    "flags/",
    tolower(iso3),
    ".png"
  )
  
}


############################################################
# GENERIC KPI CARD
############################################################

create_kpi_card <- function(
    title,
    value,
    subtitle = NULL,
    icon = NULL,
    card_class = "card-blue"
){
  
  div(
    
    class = paste(
      "kpi-card",
      card_class
    ),
    
    fluidRow(
      
      if(!is.null(icon)){
        
        column(
          3,
          
          div(
            class = "kpi-icon",
            bs_icon(icon)
          )
        )
        
      },
      
      column(
        
        if(is.null(icon)) 12 else 9,
        
        div(
          class = "kpi-title",
          title
        ),
        
        div(
          class = "kpi-value",
          value
        ),
        
        if(!is.null(subtitle))
          
          div(
            class = "kpi-subtitle",
            subtitle
          )
        
      )
      
    )
    
  )
  
}

##########################################################
# SCORE BADGE
##########################################################

create_score_badge <- function(score){
  
  color <- case_when(
    is.na(score) ~ "#D9D9D9",
    score >= 0.90 ~ "#B10026",
    score >= 0.80 ~ "#FC4E2A",
    score >= 0.50 ~ "#FEB24C",
    score >= 0.20 ~ "#FED976",
    TRUE ~ "#FFF7BC"
  )
  
  text_color <- ifelse(score < 0.20, "#333333", "white")
  
  paste0(
    "<div style='
    background:", color, ";
    color:", text_color, ";
    font-weight:bold;
    border-radius:6px;
    text-align:center;
    padding:6px;
    width:70px;'>",
    round(score, 2),
    "</div>"
  )
}
##########################################################
# PRIORITY BADGE
##########################################################

create_priority_badge <- function(priority){
  color <- case_when(
    str_detect(priority,"Very High") ~ "#B10026",
    str_detect(priority,"High") ~ "#FC4E2A",
    str_detect(priority,"Medium") ~ "#FEB24C",
    str_detect(priority,"Low") ~ "#FED976",
    str_detect(priority, "Very Low") ~ "#FFF7BC",
    TRUE ~ "#6c757d"
    
  )
  
  paste0(
    
    "<span style='
    font-weight:600;
    color:", color, ";'>",
    
    priority,
    
    "</span>"
    
  )
  
}


##########################################################
# PROGRESS BAR
##########################################################

create_progress_bar <- function(value){
  
  if(is.na(value))
    return("No Data")
  
  color <- case_when(
    
    value >= 80 ~ "#28a745",
    
    value >= 50 ~ "#f0ad4e",
    
    TRUE ~ "#dc3545"
    
  )
  
  paste0(
    
    "<div style='display:flex;
    align-items:center;'>",
    
    "<span style='width:40px;'>",
    round(value), "%</span>",
    
    "<div style='width:90px;
                height:8px;
                background:#eeeeee;
                border-radius:5px;
                margin-left:8px;'>",
    
    "<div style='width:", value, "%;
          height:8px;
          background:", color, ";
          border-radius:5px;'></div>",
    
    "</div></div>"
    
  )
  
}

##########################################################
# INDICATOR CHART COLORS
##########################################################

indicator_colors <- function(){
  
  c(
    "Reporting Completeness (%)" = "#00B050",
    "Reporting Timeliness (%)" = "#18B7BC",
    "Support Score (%)" = "#5E8FE3",
    "Laboratory Capacity (%)" = "#B79F00",
    "Funding Per Capita (USD)" = "#F07167",
    "Workforce Density" = "#E056D1"
  )
  
}