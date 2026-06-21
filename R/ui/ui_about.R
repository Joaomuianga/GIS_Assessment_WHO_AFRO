############################################################
# ABOUT PAGE UI
# Author: Joao Muianga
############################################################

about_ui <- function() {
  
  nav_panel(
    
    title = "About",
    
    fluidRow(
      
      column(
        width = 12,
        
        div(
          class = "dashboard-title",
          "About the Dashboard"
        ),
        
        div(
          class = "dashboard-subtitle",
          "Overview of the WHO AFRO Surveillance Support Dashboard"
        )
        
      )
      
    ),
    
    br(),
    
    card(
      
      card_header(
        "Dashboard Overview"
      ),
      
      card_body(
        
        p(
          paste(
            "This dashboard supports evidence-based decision-making",
            "for strengthening disease surveillance systems across",
            "the WHO African Region."
          )
        ),
        
        p(
          paste(
            "It brings together surveillance performance, laboratory",
            "capacity, workforce availability, financing, and outbreak",
            "indicators to identify countries requiring technical support."
          )
        )
        
      )
      
    ),
    
    br(),
    
    fluidRow(
      
      column(
        width = 6,
        
        card(
          
          card_header(
            "Data Sources"
          ),
          
          card_body(
            
            tags$ul(
              tags$li("Country reference data"),
              tags$li("Population data"),
              tags$li("Funding data"),
              tags$li("Reporting metrics"),
              tags$li("Laboratory capacity data"),
              tags$li("Workforce data"),
              tags$li("Outbreak surveillance data")
            )
            
          )
          
        )
        
      ),
      
      column(
        width = 6,
        
        card(
          
          card_header(
            "Key Indicators"
          ),
          
          card_body(
            
            tags$ul(
              tags$li("Reporting Timeliness (%)"),
              tags$li("Reporting Completeness (%)"),
              tags$li("ISO 15189 Laboratory Accreditation (%)"),
              tags$li("Epidemiologists per 100,000 population"),
              tags$li("Funding per Capita (USD)"),
              tags$li("Outbreak counts and detection delays")
            )
            
          )
          
        )
        
      )
      
    ),
    
    br(),
    
    card(
      
      card_header(
        "Support Score Methodology"
      ),
      
      card_body(
        
        p(
          paste(
            "The Surveillance Support Score is a composite measure",
            "used to summarize country-level needs for surveillance",
            "strengthening."
          )
        ),
        
        tags$table(
          
          `class` = "table table-striped table-bordered",
          
          tags$thead(
            tags$tr(
              tags$th("Component"),
              tags$th("Description")
            )
          ),
          
          tags$tbody(
            
            tags$tr(
              tags$td("Reporting performance"),
              tags$td("Timeliness and completeness of surveillance reporting")
            ),
            
            tags$tr(
              tags$td("Laboratory capacity"),
              tags$td("ISO 15189 accreditation and diagnostic capacity")
            ),
            
            tags$tr(
              tags$td("Workforce capacity"),
              tags$td("Availability of epidemiologists and trained staff")
            ),
            
            tags$tr(
              tags$td("Financing"),
              tags$td("Funding available for surveillance activities")
            ),
            
            tags$tr(
              tags$td("Outbreak burden"),
              tags$td("Frequency and severity of reported outbreaks")
            )
            
          )
          
        )
        
      )
      
    ),
    
    br(),
    
    card(
      
      card_header(
        "Priority Interpretation"
      ),
      
      card_body(
        
        tags$table(
          
          `class` = "table table-bordered",
          
          tags$thead(
            tags$tr(
              tags$th("Score Range"),
              tags$th("Priority Level"),
              tags$th("Interpretation")
            )
          ),
          
          tags$tbody(
            
            tags$tr(
              tags$td("0.90 - 1.00"),
              tags$td("Very High"),
              tags$td("Very strong surveillance performance")
            ),
            
            tags$tr(
              tags$td("0.80 - 0.89"),
              tags$td("High"),
              tags$td("Strong performance with limited support needs")
            ),
            
            tags$tr(
              tags$td("0.50 - 0.79"),
              tags$td("Medium"),
              tags$td("Moderate performance requiring targeted support")
            ),
            
            tags$tr(
              tags$td("0.20 - 0.49"),
              tags$td("Low"),
              tags$td("Significant surveillance strengthening needed")
            ),
            
            tags$tr(
              tags$td("0.00 - 0.19"),
              tags$td("Very Low"),
              tags$td("Urgent technical assistance required")
            ),
            
            tags$tr(
              tags$td("No Data"),
              tags$td("No Data"),
              tags$td("WHO AFRO country without sufficient data for scoring")
            )
            
          )
          
        )
        
      )
      
    )
    
  )
  
}