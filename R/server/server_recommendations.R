############################################################
# RECOMMENDATIONS SERVER
############################################################

recommendations_server <- function(
    input,
    output,
    session,
    analysis_data){
  
  ##########################################################
  # HIGH PRIORITY COUNTRIES
  ##########################################################
  
  output$priority_countries_table <- renderDT({
    
    analysis_data %>%
      calculate_support_score() %>%
      filter(
        support_score < 0.50
      ) %>%
      arrange(support_score) %>%
      select(
        country_name,
        support_score,
        timeliness_pct,
        completeness_pct,
        iso15189_accreditation_pct
      ) %>%
      
      datatable(
        rownames = FALSE,
        options = list(
          pageLength = 10
        )
      )
    
  })
  
  
  ##########################################################
  # SUPPORT AREA CHART
  ##########################################################
  
  output$support_area_chart <- renderPlotly({
    
    indicators <- tibble::tibble(
      
      area = c(
        "Timeliness",
        "Completeness",
        "Laboratory",
        "Workforce",
        "Funding"
      ),
      
      value = c(
        mean(
          analysis_data$timeliness_pct,
          na.rm = TRUE
        ),
        
        mean(
          analysis_data$completeness_pct,
          na.rm = TRUE
        ),
        
        mean(
          analysis_data$iso15189_accreditation_pct,
          na.rm = TRUE
        ),
        
        mean(
          analysis_data$epidemiologists_per_100k,
          na.rm = TRUE
        ),
        
        mean(
          analysis_data$funding_per_capita_usd,
          na.rm = TRUE
        )
      )
      
    )
    
    plot_ly(
      indicators,
      x = ~value,
      y = ~reorder(area, value),
      type = "bar",
      orientation = "h"
    )
    
  })
  
}