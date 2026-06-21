############################################################
# APP
############################################################

source("global.R")

ui <- page_sidebar(
  
  title = NULL,
  
  tags$head(
    tags$link(
      rel = "stylesheet",
      type = "text/css",
      href = "styles.css"
    ),
    
    tags$script(
      src = "script.js"
    )
  ),
  
  ############################################################
  # LEFT SIDEBAR
  ############################################################
  
  sidebar = sidebar(
    
    width = 240,
    
    div(
      class = "custom-sidebar-content",
      
      tags$img(
        src = "logotipo.png",
        width = "180px",
        class = "sidebar-logo"
      )
    ),
    
    actionLink(
      "goto_overview",
      tagList(
        bs_icon("speedometer2"),
        span("Overview")
      ),
      class = "sidebar-link active-menu"
    ),
    
    actionLink(
      "goto_profile",
      tagList(
        bs_icon("person-badge"),
        span("Country Profile")
      ),
      class = "sidebar-link"
    ),
    
    actionLink(
      "goto_recommendations",
      tagList(
        bs_icon("lightbulb"),
        span("Recommendations")
      ),
      class = "sidebar-link"
    ),
    
    actionLink(
      "goto_about",
      tagList(
        bs_icon("info-circle"),
        span("About")
      ),
      class = "sidebar-link"
    )
  ),
  
  ############################################################
  # HIDDEN NAVIGATION PAGES
  ############################################################
  
  navset_hidden(
    
    id = "main_nav",
    
    overview_ui(),
    country_profile_ui(),
    recommendations_ui(),
    about_ui()
  )
)

server <- function(input, output, session){
  
  selected_priority <- reactiveVal(NULL)
  
  ############################################################
  # PAGE NAVIGATION
  ############################################################
  
  observeEvent(input$goto_overview, {
    updateTabsetPanel(
      session,
      "main_nav",
      selected = "Overview"
    )
  })
  
  observeEvent(input$goto_profile, {
    updateTabsetPanel(
      session,
      "main_nav",
      selected = "Country Profile"
    )
  })
  
  observeEvent(input$goto_recommendations, {
    updateTabsetPanel(
      session,
      "main_nav",
      selected = "Recommendations"
    )
  })
  
  observeEvent(input$goto_about, {
    updateTabsetPanel(
      session,
      "main_nav",
      selected = "About"
    )
  })
  
  ############################################################
  # SERVER MODULES
  ############################################################
  
  overview_server(
    input,
    output,
    session,
    analysis_data,
    africa_sf,
    disease_summary,
    priority_palette,
    trend_data,
    selected_priority
  )
  
  profile_server(
    input,
    output,
    session,
    analysis_data,
    disease_summary
  )
  
  recommendations_server(
    input,
    output,
    session,
    analysis_data
  )
}

shinyApp(ui, server)
