############################################################
# COUNTRY PROFILE SERVER
# Author: Joao Muianga
############################################################

profile_server <- function(
    input,
    output,
    session,
    analysis_data,
    disease_summary
){
  
  ##########################################################
  # COUNTRY PROFILE DATA
  ##########################################################
  
  country_profile <- reactive({
    
    req(
      input$profile_country,
      input$profile_year
    )
    
    df <- analysis_data %>%
      calculate_support_score() %>%
      filter(
        country_name == input$profile_country,
        year == input$profile_year
      )
    
    validate(
      need(
        nrow(df) > 0,
        "No data available for selected country."
      )
    )
    
    df
    
  })
  
  
  ##########################################################
  # COUNTRY HEADER INFORMATION
  ##########################################################
  
  output$country_name <- renderText({
    
    req(country_profile())
    
    country_profile()$country_name
    
  })
  
  
  output$country_info <- renderText({
    
    req(country_profile())
    
    paste(
      "ISO3:",
      country_profile()$iso3,
      "| WHO African Region"
    )
    
  })
  
  
  ##########################################################
  # COUNTRY FLAG
  ##########################################################
  
  output$country_flag <- renderUI({
    
    req(country_profile())
    
    iso3 <- tolower(country_profile()$iso3)
    
    flag_path <- paste0(
      "flags/",
      iso3,
      ".png"
    )
    
    tags$img(
      src = flag_path,
      width = "60px",
      style = "
        border-radius:4px;
      "
    )
    
  })
  
  
  ##########################################################
  # KPI CARDS
  ##########################################################
  
  output$country_support_box <- renderUI({
    
    req(country_profile())
    
    div(
      
      class = "kpi-card card-blue",
      
      div(
        class = "kpi-title",
        "Support Score"
      ),
      
      div(
        class = "kpi-value",
        
        round(
          country_profile()$support_score,
          2
        )
        
      )
      
    )
    
  })
  
  
  output$country_priority_box <- renderUI({
    
    req(country_profile())
    
    div(
      
      class = "kpi-card card-orange",
      
      div(
        class = "kpi-title",
        "Priority Level"
      ),
      
      div(
        class = "kpi-value",
        
        country_profile()$priority_level
      )
      
    )
    
  })
  
  
  output$country_outbreak_box <- renderUI({
    
    req(country_profile())
    
    div(
      
      class = "kpi-card card-red",
      
      div(
        class = "kpi-title",
        "Outbreaks"
      ),
      
      div(
        class = "kpi-value",
        
        scales::comma(
          country_profile()$outbreaks_count
        )
        
      )
      
    )
    
  })
  
  
  output$country_timeliness_box <- renderUI({
    
    req(country_profile())
    
    div(
      
      class = "kpi-card card-green",
      
      div(
        class = "kpi-title",
        "Timeliness"
      ),
      
      div(
        class = "kpi-value",
        
        paste0(
          round(
            country_profile()$timeliness_pct
          ),
          "%"
        )
        
      )
      
    )
    
  })
  
  
  output$country_completeness_box <- renderUI({
    
    req(country_profile())
    
    div(
      
      class = "kpi-card card-green",
      
      div(
        class = "kpi-title",
        "Completeness"
      ),
      
      div(
        class = "kpi-value",
        
        paste0(
          round(
            country_profile()$completeness_pct
          ),
          "%"
        )
        
      )
      
    )
    
  })
  
  
  output$country_funding_box <- renderUI({
    
    req(country_profile())
    
    div(
      
      class = "kpi-card card-green",
      
      div(
        class = "kpi-title",
        "Funding per Capita"
      ),
      
      div(
        class = "kpi-value",
        
        paste0(
          "$",
          round(
            country_profile()$
              funding_per_capita_usd,
            2
          )
        )
        
      )
      
    )
    
  })
  
  
  ##########################################################
  # RADAR CHART
  ##########################################################
  
  output$country_radar <- renderPlotly({
    
    req(country_profile())
    
    df <- country_profile()
    
    funding_scaled <- scales::rescale(
      
      df$funding_per_capita_usd,
      
      to = c(0,100),
      
      from = range(
        analysis_data$
          funding_per_capita_usd,
        na.rm = TRUE
      )
      
    )
    
    workforce_scaled <- scales::rescale(
      
      df$epidemiologists_per_100k,
      
      to = c(0,100),
      
      from = range(
        analysis_data$
          epidemiologists_per_100k,
        na.rm = TRUE
      )
      
    )
    
    radar_data <- tibble(
      
      indicator = c(
        "Timeliness",
        "Completeness",
        "Laboratory",
        "Funding",
        "Workforce"
      ),
      
      value = c(
        
        df$timeliness_pct,
        
        df$completeness_pct,
        
        df$iso15189_accreditation_pct,
        
        funding_scaled,
        
        workforce_scaled
        
      )
      
    )
    
    plot_ly(
      
      type = "scatterpolar",
      
      mode = "lines+markers",
      
      r = radar_data$value,
      
      theta = radar_data$indicator,
      
      fill = "toself",
      
      line = list(
        color = "#2E86C1",
        width = 3
      )
      
    ) %>%
      
      layout(
        
        polar = list(
          
          radialaxis = list(
            visible = TRUE,
            range = c(0,100)
          )
          
        ),
        
        showlegend = FALSE
        
      ) %>%
      
      config(
        displayModeBar = FALSE
      )
    
  })
  
  
  ##########################################################
  # BENCHMARK CHART
  ##########################################################
  
  output$benchmark_chart <- renderPlotly({
    
    req(country_profile())
    
    country <- country_profile()
    
    afro_avg <- analysis_data %>%
      filter(
        year == input$profile_year
      ) %>%
      summarise(
        
        Timeliness =
          mean(
            timeliness_pct,
            na.rm = TRUE
          ),
        
        Completeness =
          mean(
            completeness_pct,
            na.rm = TRUE
          ),
        
        Laboratory =
          mean(
            iso15189_accreditation_pct,
            na.rm = TRUE
          )
        
      )
    
    benchmark <- tibble(
      
      indicator = c(
        "Timeliness",
        "Completeness",
        "Laboratory"
      ),
      
      Country = c(
        country$timeliness_pct,
        country$completeness_pct,
        country$iso15189_accreditation_pct
      ),
      
      AFRO = c(
        afro_avg$Timeliness,
        afro_avg$Completeness,
        afro_avg$Laboratory
      )
      
    )
    
    benchmark_long <- benchmark %>%
      pivot_longer(
        -indicator,
        names_to = "group",
        values_to = "value"
      )
    
    plot_ly(
      
      benchmark_long,
      
      x = ~indicator,
      
      y = ~value,
      
      color = ~group,
      
      type = "bar"
      
    ) %>%
      
      layout(
        barmode = "group"
      ) %>%
      
      config(
        displayModeBar = FALSE
      )
    
  })
  
  
  ##########################################################
  # COUNTRY TRENDS
  ##########################################################
  
  output$country_trends <- renderPlotly({
    
    req(input$profile_country)
    
    trend <- analysis_data %>%
      
      filter(
        country_name ==
          input$profile_country
      ) %>%
      
      arrange(year)
    
    validate(
      need(
        nrow(trend) > 0,
        "No trend data available."
      )
    )
    
    p <- ggplot(
      
      trend,
      
      aes(
        x = year,
        y = timeliness_pct
      )
      
    ) +
      
      geom_line(
        color = "#2E86C1",
        linewidth = 1.3
      ) +
      
      geom_point(
        color = "#2E86C1",
        size = 3
      ) +
      
      labs(
        x = NULL,
        y = "Timeliness (%)"
      ) +
      
      theme_minimal()
    
    ggplotly(p) %>%
      config(
        displayModeBar = FALSE
      )
    
  })
  
  
  ##########################################################
  # COUNTRY DISEASE CHART
  ##########################################################
  
  output$country_disease_chart <- renderPlotly({
    
    validate(
      need(
        nrow(disease_summary) > 0,
        "No disease data available."
      )
    )
    
    plot_ly(
      
      disease_summary,
      
      x = ~cases,
      
      y = ~reorder(
        disease,
        cases
      ),
      
      type = "bar",
      
      orientation = "h"
      
    ) %>%
      
      layout(
        showlegend = FALSE
      )
    
  })
  
  
  ##########################################################
  # TARGET PERFORMANCE TABLE
  ##########################################################
  
  output$country_target_table <- renderUI({
    
    req(country_profile())
    
    df <- country_profile()
    
    indicators <- tibble(
      
      indicator = c(
        "Reporting Timeliness",
        "Reporting Completeness",
        "Laboratory Capacity",
        "Workforce Density",
        "Funding Per Capita (USD)"
      ),
      
      country = c(
        round(df$timeliness_pct),
        round(df$completeness_pct),
        round(df$iso15189_accreditation_pct),
        round(df$epidemiologists_per_100k),
        round(df$funding_per_capita_usd, 2)
      ),
      
      target = c(
        80,
        80,
        50,
        30,
        5
      )
      
    ) %>%
      
      mutate(
        
        gap = round(
          country - target,
          1
        ),
        
        gap_label = ifelse(
          gap > 0,
          paste0("+", gap),
          as.character(gap)
        ),
        
        bar_width = pmin(
          (country / target) * 100,
          100
        ),
        
        color = case_when(
          country >= target ~ "#34A853",
          country >= target * 0.75 ~ "#F39C12",
          TRUE ~ "#E74C3C"
        )
        
      )
    
    tagList(
      
      tags$table(
        
        class = "indicator-table",
        
        tags$thead(
          tags$tr(
            tags$th("Indicator"),
            tags$th("Country"),
            tags$th("Target"),
            tags$th("Gap")
          )
        ),
        
        tags$tbody(
          
          lapply(
            seq_len(nrow(indicators)),
            function(i){
              
              tags$tr(
                
                tags$td(
                  indicators$indicator[i]
                ),
                
                tags$td(
                  
                  div(
                    class =
                      "indicator-bar-wrapper",
                    
                    span(
                      class =
                        "indicator-value",
                      
                      indicators$country[i]
                    ),
                    
                    div(
                      class =
                        "indicator-bar-bg",
                      
                      div(
                        class =
                          "indicator-bar-fill",
                        
                        style = paste0(
                          "width:",
                          indicators$bar_width[i],
                          "%;",
                          "background:",
                          indicators$color[i]
                        )
                      )
                    )
                  )
                  
                ),
                
                tags$td(
                  indicators$target[i]
                ),
                
                tags$td(
                  
                  style = paste0(
                    "color:",
                    ifelse(
                      indicators$gap[i] < 0,
                      "#E74C3C",
                      "#34A853"
                    ),
                    ";font-weight:700;"
                  ),
                  
                  indicators$gap_label[i]
                  
                )
                
              )
              
            }
          )
          
        )
        
      )
      
    )
    
  })
  
  
  ##########################################################
  # RECOMMENDATIONS
  ##########################################################
  
  output$country_recommendations <- renderUI({
    
    req(country_profile())
    
    df <- country_profile()
    
    recommendations <- list()
    
    if(df$timeliness_pct < 80){
      
      recommendations[[length(recommendations)+1]] <-
        
        div(
          class = "recommend-card",
          
          bs_icon("clock-history"),
          
          div(
            h5(
              "Improve Reporting Timeliness"
            ),
            
            p(
              "Strengthen electronic reporting and supportive supervision."
            )
          )
        )
      
    }
    
    if(df$completeness_pct < 80){
      
      recommendations[[length(recommendations)+1]] <-
        
        div(
          class = "recommend-card",
          
          bs_icon("clipboard-check"),
          
          div(
            h5(
              "Enhance Reporting Completeness"
            ),
            
            p(
              "Improve reporting compliance and active follow-up."
            )
          )
        )
      
    }
    
    if(df$iso15189_accreditation_pct < 50){
      
      recommendations[[length(recommendations)+1]] <-
        
        div(
          class = "recommend-card",
          
          bs_icon("clipboard2-pulse"),
          
          div(
            h5(
              "Strengthen Laboratory Capacity"
            ),
            
            p(
              "Expand laboratory accreditation and diagnostic services."
            )
          )
        )
      
    }
    
    if(df$funding_per_capita_usd < 5){
      
      recommendations[[length(recommendations)+1]] <-
        
        div(
          class = "recommend-card",
          
          bs_icon("currency-dollar"),
          
          div(
            h5(
              "Increase Sustainable Financing"
            ),
            
            p(
              "Mobilize domestic resources and partner support."
            )
          )
        )
      
    }
    
    if(length(recommendations) == 0){
      
      recommendations[[1]] <-
        
        div(
          class = "recommend-card",
          
          bs_icon("check-circle"),
          
          div(
            h5(
              "Strong Surveillance Capacity"
            ),
            
            p(
              "Country indicators are performing above recommended targets."
            )
          )
        )
      
    }
    
    tagList(recommendations)
    
  })
  
}