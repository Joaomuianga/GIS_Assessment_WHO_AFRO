############################################################
# RECOMMENDATIONS PAGE UI
# Author: Joao Muianga
############################################################

recommendations_ui <- function() {
  
  nav_panel(
    
    title = "Recommendations",
    
    ########################################################
    # PAGE HEADER
    ########################################################
    
    fluidRow(
      
      column(
        width = 12,
        
        div(
          class = "dashboard-title",
          "Regional Recommendations"
        ),
        
        div(
          class = "dashboard-subtitle",
          paste(
            "Evidence-based recommendations to strengthen",
            "disease surveillance systems in the WHO",
            "African Region."
          )
        )
        
      )
      
    ),
    
    br(),
    
    ########################################################
    # OVERALL REGIONAL RECOMMENDATIONS
    ########################################################
    
    fluidRow(
      
      column(
        width = 12,
        
        card(
          
          card_header(
            "Strategic Recommendations"
          ),
          
          card_body(
            
            div(
              class = "recommend-card",
              
              bs_icon("clipboard2-pulse"),
              
              div(
                
                h5(
                  "Strengthen Laboratory Capacity"
                ),
                
                p(
                  paste(
                    "Expand laboratory accreditation",
                    "programmes, improve specimen",
                    "transport systems, and increase",
                    "availability of diagnostic testing."
                  )
                )
                
              )
              
            ),
            
            div(
              class = "recommend-card",
              
              bs_icon("clock-history"),
              
              div(
                
                h5(
                  "Improve Reporting Timeliness"
                ),
                
                p(
                  paste(
                    "Strengthen electronic reporting",
                    "systems and conduct supportive",
                    "supervision to ensure timely",
                    "submission of surveillance reports."
                  )
                )
                
              )
              
            ),
            
            div(
              class = "recommend-card",
              
              bs_icon("people-fill"),
              
              div(
                
                h5(
                  "Increase Workforce Capacity"
                ),
                
                p(
                  paste(
                    "Invest in Field Epidemiology",
                    "Training Programmes (FETP),",
                    "recruit surveillance officers,",
                    "and strengthen workforce retention."
                  )
                )
                
              )
              
            ),
            
            div(
              class = "recommend-card",
              
              bs_icon("currency-dollar"),
              
              div(
                
                h5(
                  "Increase Sustainable Financing"
                ),
                
                p(
                  paste(
                    "Mobilize domestic resources and",
                    "strengthen partner coordination",
                    "to ensure sustainable financing",
                    "for surveillance activities."
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
    # PRIORITY COUNTRIES TABLE
    ########################################################
    
    fluidRow(
      
      column(
        width = 12,
        
        card(
          
          card_header(
            "High Priority Countries Requiring Support"
          ),
          
          DTOutput(
            "priority_countries_table"
          )
          
        )
        
      )
      
    ),
    
    br(),
    
    ########################################################
    # RECOMMENDED SUPPORT AREAS
    ########################################################
    
    fluidRow(
      
      column(
        
        width = 6,
        
        card(
          
          card_header(
            "Priority Support Areas"
          ),
          
          plotlyOutput(
            "support_area_chart",
            height = "350px"
          )
          
        )
        
      ),
      
      column(
        
        width = 6,
        
        card(
          
          card_header(
            "Suggested WHO AFRO Actions"
          ),
          
          tags$ul(
            
            tags$li(
              "Conduct targeted country missions."
            ),
            
            tags$li(
              "Provide technical assistance to low-performing countries."
            ),
            
            tags$li(
              "Strengthen integrated disease surveillance systems."
            ),
            
            tags$li(
              "Expand laboratory accreditation coverage."
            ),
            
            tags$li(
              "Increase regional training initiatives."
            ),
            
            tags$li(
              "Strengthen digital surveillance platforms."
            )
            
          )
          
        )
        
      )
      
    )
    
  )
  
}