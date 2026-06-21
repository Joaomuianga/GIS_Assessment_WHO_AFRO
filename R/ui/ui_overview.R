############################################################
# OVERVIEW PAGE UI
# Author: Joao Muianga
############################################################

overview_ui <- function() {
  
  nav_panel(
    
    title = "Overview",
    
    ########################################################
    # PAGE HEADER
    ########################################################
    
    fluidRow(
      
      column(
        width = 8,
        div(
          class = "dashboard-title",
          "WHO AFRO Surveillance Support Dashboard"
        ),
        div(
          class = "dashboard-subtitle",
          "Strengthening disease surveillance systems across the African Region"
        )
      ),
      
      column(
        width = 2,
        selectInput(
          inputId = "year",
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
          inputId = "country_filter",
          label = "Country",
          choices = "All"
        )
      )
    ),
    
    br(),
    
    ########################################################
    # KPI CARDS
    ########################################################
    
    fluidRow(
      column(width = 3, uiOutput("countries_box")),
      column(width = 3, uiOutput("support_box")),
      column(width = 3, uiOutput("priority_box")),
      column(width = 3, uiOutput("outbreaks_box"))
    ),
    
    br(),
    

    ########################################################
    # MAP + REGIONAL INDICATORS
    ########################################################
    
    fluidRow(
      
      column(
        width = 6,
        card(
          card_header(
            "Surveillance Support Score by Country"
          ),
          leafletOutput(
            outputId = "map",
            height = "600px"
          )
        )
      ),
      
      column(
        width = 6,
        
        card(
          card_header(
            "Summary of Surveillance Indicators (Regional Average)"
          ),
          plotlyOutput(
            outputId = "indicator_chart",
            height = "220px"
          )
        ),
        
        br(),
        
        fluidRow(
          
          column(
            width = 6,
            card(
              card_header(
                "Distribution of Priority Levels"
              ),
              plotlyOutput(
                outputId = "priority_donut",
                height = "250px"
              )
            )
          ),
          
          column(
            width = 6,
            card(
              card_header(
                "Outbreaks by Disease Type"
              ),
              plotlyOutput(
                outputId = "disease_bar",
                height = "250px"
              )
            )
          )
        )
      )
    ),
    
    br(),
    
    ########################################################
    # KEY MESSAGE BOX
    ########################################################
    
    fluidRow(
      column(
        width = 12,
        div(
          class = "key-message-box",
          
          div(
            class = "key-message-icon",
            bs_icon("lightbulb-fill")
          ),
          
          div(
            class = "key-message-content",
            
            div(
              class = "key-message-title",
              "Key Message"
            ),
            
            div(
              class = "key-message-text",
              "Countries with lower surveillance performance require targeted support in reporting timeliness, completeness, laboratory capacity, workforce strengthening, and sustainable financing."
            )
          )
        )
      )
    ),
    
    br(),
    
    ########################################################
    # TOP 10 PRIORITY COUNTRIES
    ########################################################
    
    fluidRow(
      column(
        width = 12,
        card(
          card_header(
            "Top 10 Priority Countries Requiring Support"
          ),
          DTOutput(
            outputId = "ranking"
          )
        )
      )
    ),
    
    br(),
    
    ########################################################
    # REGIONAL SURVEILLANCE TRENDS
    ########################################################
    
    fluidRow(
      column(
        width = 12,
        card(
          card_header(
            "Regional Surveillance Trends"
          ),
          plotlyOutput(
            outputId = "trend_chart",
            height = "350px"
          )
        )
      )
    )
  )
}