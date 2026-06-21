############################################################
# COUNTRY PROFILE UI
# Author: Joao Muianga
############################################################

country_profile_ui <- function() {
  
  nav_panel(
    
    title = "Country Profile",
    
    ########################################################
    # PAGE HEADER
    ########################################################
    
    fluidRow(
      
      column(
        width = 8,
        
        div(
          class = "dashboard-title",
          "Country Profile"
        ),
        
        div(
          class = "dashboard-subtitle",
          "Detailed surveillance support analysis for the selected country"
        )
        
      ),
      
      column(
        width = 2,
        
        selectInput(
          inputId = "profile_year",
          label = "Year",
          choices = sort(
            unique(analysis_data$year),
            decreasing = TRUE
          ),
          selected = latest_year
        )
        
      ),
      
      column(
        width = 2,
        
        selectInput(
          inputId = "profile_country",
          label = "Country",
          choices = sort(
            unique(analysis_data$country_name)
          ),
          selected = "Mozambique"
        )
        
      )
      
    ),
    
    br(),
    
    ########################################################
    # COUNTRY HEADER CARD
    ########################################################
    
    fluidRow(
      
      column(
        width = 12,
        
        card(
          
          card_body(
            
            fluidRow(
              
              column(
                width = 1,
                
                uiOutput("country_flag")
                
              ),
              
              column(
                width = 11,
                
                h2(
                  textOutput(
                    "country_name",
                    inline = TRUE
                  )
                ),
                
                tags$small(
                  textOutput(
                    "country_info",
                    inline = TRUE
                  )
                )
                
              )
              
            )
            
          )
          
        )
        
      )
      
    ),
    
    br(),
    
    ########################################################
    # COUNTRY KPI CARDS
    ########################################################
    
    fluidRow(
      
      column(2, uiOutput("country_support_box")),
      column(2, uiOutput("country_priority_box")),
      column(2, uiOutput("country_outbreak_box")),
      column(2, uiOutput("country_timeliness_box")),
      column(2, uiOutput("country_completeness_box")),
      column(2, uiOutput("country_funding_box"))
      
    ),
    
    br(),
    
    ########################################################
    # FIRST ROW OF CHARTS
    ########################################################
    
    fluidRow(
      
      column(
        width = 4,
        
        card(
          
          card_header(
            "Surveillance Capacity Profile"
          ),
          
          plotlyOutput(
            "country_radar",
            height = "330px"
          )
          
        )
        
      ),
      
      column(
        width = 4,
        
        card(
          
          card_header(
            "Country vs AFRO Average"
          ),
          
          plotlyOutput(
            "benchmark_chart",
            height = "330px"
          )
          
        )
        
      ),
      
      column(
        width = 4,
        
        card(
          
          card_header(
            "Trends Over Time"
          ),
          
          plotlyOutput(
            "country_trends",
            height = "330px"
          )
          
        )
        
      )
      
    ),
    
    br(),
    
    ########################################################
    # SECOND ROW OF CHARTS
    ########################################################
    
    fluidRow(
      
      column(
        width = 4,
        
        card(
          
          card_header(
            "Top Diseases by Outbreaks"
          ),
          
          plotlyOutput(
            "country_disease_chart",
            height = "300px"
          )
          
        )
        
      ),
      
      column(
        width = 4,
        
        card(
          
          card_header(
            "Indicator Performance vs WHO Target"
          ),
          
          uiOutput(
            "country_target_table"
          )
          
        )
        
      ),
      
      column(
        width = 4,
        
        card(
          
          card_header(
            "Key Recommendations"
          ),
          
          uiOutput(
            "country_recommendations"
          )
          
        )
        
      )
      
    )
    
  )
  
}