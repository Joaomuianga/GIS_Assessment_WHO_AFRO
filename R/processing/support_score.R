############################################################
# Support Score Methodology
#
# Higher scores indicate greater need for technical support.
#
# Components:
# 30% Outbreak burden
# 20% Reporting performance gap
# 15% Laboratory capacity gap
# 15% Workforce capacity gap
# 10% Funding gap
# 10% Detection delay gap
############################################################

############################################################
# Normalize Function
############################################################

normalize <- function(x){
  
  if(
    max(x, na.rm = TRUE) ==
    min(x, na.rm = TRUE)
  ){
    return(rep(0, length(x)))
  }
  
  (x - min(x, na.rm = TRUE)) /
    (max(x, na.rm = TRUE) -
       min(x, na.rm = TRUE))
  
}

############################################################
# Calculate Support Score
############################################################

calculate_support_score <- function(df){
  
  df %>%
    
    mutate(
      
      outbreak_score =
        normalize(outbreaks_count),
      
      reporting_gap = normalize(100 -(timeliness_pct + completeness_pct) / 2),
            lab_gap = normalize(100 - iso15189_accreditation_pct),
      workforce_gap = normalize(100 - feltp_trained_pct),
      funding_gap =
        normalize(
          
          max(
            funding_per_capita_usd,
            na.rm = TRUE
          ) -
            
            replace_na(
              funding_per_capita_usd,
              median(
                funding_per_capita_usd,
                na.rm = TRUE
              )
            )
          
        ),      detection_gap = normalize(avg_detection_delay)
     ) %>%

    mutate(
      outbreak_score = replace_na(outbreak_score, 0),
      reporting_gap  = replace_na(reporting_gap, 0),
      lab_gap = replace_na(lab_gap, 0),
      workforce_gap = replace_na(workforce_gap, 0),
      funding_gap = replace_na(funding_gap, 0),
      detection_gap = replace_na(detection_gap, 0)
    ) %>%
    
    mutate(
      support_score =
        0.30 * outbreak_score +
        0.20 * reporting_gap +
        0.15 * lab_gap +
        0.15 * workforce_gap +
        0.10 * funding_gap +
        0.10 * detection_gap) %>%
    
    arrange(
      desc(support_score)
    )
  
}
