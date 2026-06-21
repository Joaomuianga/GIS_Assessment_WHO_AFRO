############################################################
# OVERVIEW SERVER
# Author: Joao Muianga
############################################################

overview_server <- function(
    input,
    output,
    session,
    analysis_data,
    africa_sf,
    disease_summary,
    priority_palette,
    trend_data,
    selected_priority = reactiveVal(NULL)
){

  ##########################################################
  # FILTERED DATA
  ##########################################################

  filtered_priority <- reactive({

    req(input$year)

    df <- analysis_data %>%
      filter(year == input$year)

    if (!is.null(input$country_filter) &&
        input$country_filter != "All") {

      df <- df %>%
        filter(
          country_name ==
            input$country_filter
        )

    }

    df <- df %>%
      calculate_support_score() %>%
      mutate(
        priority_level =
          get_priority_level(
            support_score
          )
      )

    # Optional filtering from donut clicks
    if (!is.null(selected_priority())) {

      df <- df %>%
        filter(
          priority_level ==
            selected_priority()
        )

    }

    df

  })


  ##########################################################
  # SUMMARY METRICS
  ##########################################################

  summary_reactive <- reactive({

    filtered_priority() %>%

      summarise(

        countries_assessed =
          n(),

        avg_support_score =
          safe_mean(
            support_score
          ),

        high_priority =
          sum(
            support_score >= 0.80,
            na.rm = TRUE
          ),

        total_outbreaks =
          safe_sum(
            outbreaks_count
          )

      )

  })


  ##########################################################
  # INDICATOR DATA
  ##########################################################

  indicator_data <- reactive({

    filtered_priority() %>%

      summarise(

        "Reporting Timeliness (%)" =
          safe_mean(
            timeliness_pct
          ),

        "Reporting Completeness (%)" =
          safe_mean(
            completeness_pct
          ),

        "Laboratory Capacity (%)" =
          safe_mean(
            iso15189_accreditation_pct
          ),

        "Workforce Density" =
          safe_mean(
            epidemiologists_per_100k
          ),

        "Funding Per Capita (USD)" =
          safe_mean(
            funding_per_capita_usd
          ),

        "Support Score (%)" =
          safe_mean(
            support_score
          ) * 100

      ) %>%

      pivot_longer(
        everything(),
        names_to = "indicator",
        values_to = "value"
      )

  })


  ##########################################################
  # MAP DATA
  ##########################################################
  filtered_map <- reactive({
    
    who_afro <- c(
      "ANGOLA","BENIN","BOTSWANA","BURKINA FASO",
      "BURUNDI","CABO VERDE","CAMEROON",
      "CENTRAL AFRICAN REPUBLIC","CHAD","COMOROS",
      "CONGO","CÔTE D’IVOIRE",
      "DEMOCRATIC REPUBLIC OF THE CONGO",
      "EQUATORIAL GUINEA","ERITREA","ESWATINI",
      "ETHIOPIA","GABON","GAMBIA","GHANA",
      "GUINEA","GUINEA-BISSAU","KENYA","LESOTHO",
      "LIBERIA","MADAGASCAR","MALAWI","MALI",
      "MAURITANIA","MAURITIUS","MOZAMBIQUE",
      "NAMIBIA","NIGER","NIGERIA","RWANDA",
      "SAO TOME AND PRINCIPE","SENEGAL",
      "SEYCHELLES","SIERRA LEONE","SOUTH AFRICA",
      "SOUTH SUDAN","TOGO","UGANDA",
      "UNITED REPUBLIC OF TANZANIA",
      "ZAMBIA","ZIMBABWE"
    )
    
    africa_sf %>%
      
      left_join(
        filtered_priority(),
        by = c("ISO_3_CODE" = "iso3")
      ) %>%
      
      mutate(
        
        is_who_afro =
          ADM0_NAME %in% who_afro,
        
        priority_level = case_when(
          
          !is_who_afro ~ NA_character_,
          
          is.na(priority_level) ~ "No Data",
          
          TRUE ~ priority_level
        ),
        
        short_name = case_when(
          
          !is_who_afro ~ NA_character_,
          
          ADM0_NAME == "DEMOCRATIC REPUBLIC OF THE CONGO" ~ "DR Congo",
          ADM0_NAME == "CENTRAL AFRICAN REPUBLIC" ~ "CAR",
          ADM0_NAME == "UNITED REPUBLIC OF TANZANIA" ~ "Tanzania",
          ADM0_NAME == "EQUATORIAL GUINEA" ~ "Eq. Guinea",
          ADM0_NAME == "SAO TOME AND PRINCIPE" ~ "STP",
          ADM0_NAME == "SOUTH SUDAN" ~ "S. Sudan",
          
          TRUE ~ str_to_title(ADM0_NAME)
          
        )
        
      )
    
  })


  ##########################################################
  # UPDATE COUNTRY FILTER
  ##########################################################

  observe({

    countries <-

      analysis_data %>%

      filter(
        year == input$year
      ) %>%

      distinct(
        country_name
      ) %>%

      arrange(
        country_name
      ) %>%

      pull()

    updateSelectInput(
      session,
      "country_filter",
      choices = c(
        "All",
        countries
      )
    )

  })


  ##########################################################
  # KPI CARDS
  ##########################################################

  output$countries_box <- renderUI({

    create_kpi_card(
      title = "Countries Assessed",
      value = summary_reactive()$countries_assessed,
      subtitle = "WHO African Region",
      icon = "people-fill",
      card_class = "card-blue"
    )

  })


  output$support_box <- renderUI({

    create_kpi_card(
      title = "Average Support Score",
      value = round(
        summary_reactive()$avg_support_score,
        2
      ),
      subtitle = "Scale: 0 - 1",
      icon = "graph-up-arrow",
      card_class = "card-green"
    )

  })


  output$priority_box <- renderUI({

    create_kpi_card(
      title = "High Priority Countries",
      value = summary_reactive()$high_priority,
      subtitle = "Score ≥ 0.80",
      icon = "exclamation-triangle-fill",
      card_class = "card-orange"
    )

  })


  output$outbreaks_box <- renderUI({

    create_kpi_card(
      title = "Total Outbreaks",
      value = scales::comma(
        summary_reactive()$total_outbreaks
      ),
      subtitle = "Reported outbreaks",
      icon = "shield-fill-exclamation",
      card_class = "card-red"
    )

  })


  ##########################################################
  # MAP
  ##########################################################
  
  output$map <- renderLeaflet({
    
    validate(
      need(
        nrow(filtered_map()) > 0,
        "No map data available."
      )
    )
    
    ########################################################
    # LABEL POSITIONS
    ########################################################
    
    label_points <- label_points <- filtered_map() %>%
      filter(!is.na(short_name))
    
    st_geometry(label_points) <-
      st_geometry(label_points) %>%
      st_transform(3857) %>%
      st_point_on_surface() %>%
      st_transform(4326)
    
    coords <- st_coordinates(label_points)
    
    label_points$label_lng <- coords[, 1]
    label_points$label_lat <- coords[, 2]
    
    ########################################################
    # LEAFLET MAP
    ########################################################
    
    leaflet(
      filtered_map(),
      options = leafletOptions(
        zoomControl = TRUE,
        minZoom = 3,
        maxZoom = 8
      )
    ) %>%
      
      ######################################################
    # BASEMAP
    ######################################################
    
    addProviderTiles(
      providers$CartoDB.PositronNoLabels
    ) %>%
      
      ######################################################
    # COUNTRY POLYGONS
    ######################################################
    
    addPolygons(
      
      fillColor = ~case_when(
        
        !is_who_afro ~ "#F5F5F5",           # non-AFRO countries
        
        priority_level == "No Data" ~ "#D9D9D9",  # AFRO countries without data
        
        TRUE ~ priority_palette(priority_level)
        
      ),
      
      fillOpacity = ~ifelse(
        !is_who_afro,
        0,      # hide countries outside WHO AFRO
        0.85
      ),
      
      color = "white",
      
      weight = 1,
      
      smoothFactor = 0.5,
      
      popup = ~ifelse(
        
        !is_who_afro,
        
        NA,
        
        paste0(
          "<b>", ADM0_NAME, "</b><br>",
          "Priority Level: ", priority_level, "<br>",
          "Support Score: ",
          ifelse(
            is.na(support_score),
            "No Data",
            round(support_score, 2)
          ),
          "<br>",
          "Outbreaks: ",
          ifelse(
            is.na(outbreaks_count),
            "No Data",
            outbreaks_count
          )
        )
        
      )
      
    ) %>%
      
      ######################################################
    # COUNTRY LABELS
    ######################################################
    
    addLabelOnlyMarkers(
      
      data = label_points,
      
      lng = ~label_lng,
      lat = ~label_lat,
      
      label = ~short_name,
      
      labelOptions = labelOptions(
        noHide = FALSE,
        textOnly = TRUE,
        style = list(
          "font-size" = "9px",
          "font-weight" = "normal",
          "color" = "#222222",
          "text-shadow" = "none"
        )
      )
      
    ) %>%
      
      ######################################################
    # LEGEND
    ######################################################
    
    addLegend(
      position = "bottomleft",
      
      colors = c(
        "#B10026",
        "#FC4E2A",
        "#FEB24C",
        "#FED976",
        "#FFF7BC",
        "#D9D9D9"
      ),
      
      labels = c(
        "Very High (0.90 - 1.00)",
        "High (0.80 - 0.89)",
        "Medium (0.50 - 0.79)",
        "Low (0.20 - 0.49)",
        "Very Low (0.00 - 0.19)",
        "No Data"
      ),
      
      title = HTML("<strong>Priority Level</strong>"),
      opacity = 1
    ) %>%
      
      ######################################################
    # ZOOM TO AFRICA
    ######################################################
    
    setView(
      lng = 20,
      lat = 2,
      zoom = 3.2
    )
    
  })
  ##########################################################
  # INDICATOR BAR CHART
  ##########################################################
  
  output$indicator_chart <- renderPlotly({
    
    validate(
      need(
        nrow(indicator_data()) > 0,
        "No indicator data available."
      )
    )
    
    df <- indicator_data() %>%
      mutate(
        label = ifelse(
          indicator %in% c(
            "Funding Per Capita (USD)",
            "Workforce Density"
          ),
          round(value, 1),
          paste0(round(value, 0), "%")
        ),
        indicator = factor(
          indicator,
          levels = rev(c(
            "Reporting Completeness (%)",
            "Reporting Timeliness (%)",
            "Support Score (%)",
            "Laboratory Capacity (%)",
            "Funding Per Capita (USD)",
            "Workforce Density"
          ))
        )
      )
    
    p <- ggplot(
      df,
      aes(
        x = value,
        y = indicator,
        fill = indicator
      )
    ) +
      
      geom_col(
        width = 0.85
      ) +
      
      geom_text(
        aes(
          label = label
        ),
        hjust = 0.75,
        color = "white",
        fontface = "bold",
        size = 3
      ) +
      
      scale_fill_manual(
        values = indicator_colors()
      ) +
      
      labs(
        x = NULL,
        y = NULL
      ) +
      
      theme_minimal() +
      
      theme(
        legend.position = "none",
        
        axis.title = element_blank(),
        
        axis.text.y = element_text(
          size = 9,
          face = "bold",
          color = "#333333"
        ),
        
        axis.text.x = element_text(
          size = 11,
          face = "bold",
          color = "#555555"
        ),
        
        panel.grid.major.y = element_blank(),
        panel.grid.minor = element_blank()
      )
    
    ggplotly(p) %>%
      config(
        displayModeBar = FALSE,
        displaylogo = FALSE
      )
    
  })

  ##########################################################
  # PRIORITY DONUT
  ##########################################################

  output$priority_donut <- renderPlotly({
    
    df <- filtered_priority() %>%
      count(priority_level) %>%
      filter(!is.na(priority_level))
    
    plot_ly(
      data = df,
      labels = ~priority_level,
      values = ~n,
      type = "pie",
      hole = 0.65,
      
      textinfo = "percent",
      
      textposition = "outside",
      
      marker = list(
        colors = c(
          "#B10026",
          "#FC4E2A",
          "#FEB24C",
          "#FED976",
          "#FFF7BC",
          "#D9D9D9"
        )
      )
    ) %>%
      
      layout(
        showlegend = TRUE,
        
        legend = list(
          orientation = "h",
          x = 0,
          y = -0.2
        ),
        
        margin = list(
          l = 20,
          r = 20,
          b = 80,
          t = 20
        )
      ) %>%
      
      config(
        displayModeBar = FALSE,
        displaylogo = FALSE
      )
    
  })


  ##########################################################
  # DISEASE BAR CHART
  ##########################################################
  output$disease_bar <- renderPlotly({
    
    df <- disease_summary %>%
      mutate(
        pct = round(cases / sum(cases) * 100, 1),
        
        disease_short = case_when(
          disease == "Viral haemorrhagic fever" ~ "VHF",
          disease == "Polio (cVDPV)" ~ "Polio",
          TRUE ~ disease
        ),
        
        hover_text = paste0(
          "<b>", disease, "</b><br>",
          "Cases: ", scales::comma(cases), "<br>",
          "Percentage: ", pct, "%"
        ),
        
        label = paste0(pct, "%")
      )
    
    plot_ly(
      data = df,
      x = ~cases,
      y = ~reorder(disease_short, cases),
      type = "bar",
      orientation = "h",
      
      text = ~label,
      textposition = "outside",
      
      hoverinfo = "text",
      hovertext = ~hover_text,
      
      marker = list(
        color = "#2E86C1"
      )
    ) %>%
      
      layout(
        
        margin = list(
          l = 80,
          r = 50,
          t = 10,
          b = 40
        ),
        
        xaxis = list(
          title = "",
          tickformat = "~s"
        ),
        
        yaxis = list(
          title = ""
        ),
        
        showlegend = FALSE
        
      ) %>%
      
      config(
        displayModeBar = FALSE
      )
    
  })
  ##########################################################
  # TREND CHART
  ##########################################################

  output$trend_chart <- renderPlotly({

    trend_long <-

      trend_data %>%

      pivot_longer(

        -year,

        names_to = "indicator",

        values_to = "value"

      )

    p <- ggplot(

      trend_long,

      aes(
        x = year,
        y = value,
        color = indicator
      )

    ) +

      geom_line(
        linewidth = 1.2
      ) +

      geom_point(
        size = 3
      ) +

      theme_minimal()

    ggplotly(p) %>%

      config(
        displayModeBar = FALSE,
        displaylogo = FALSE
      )

  })


  ##########################################################
  # RANKING TABLE
  ##########################################################
  
  output$ranking <- renderDT({
    
    df <- filtered_priority() %>%
      arrange(desc(support_score)) %>%
      #slice_head(n = 10) %>%
      mutate(
        Rank = row_number(),
        Country = country_name,
        `Support Score` =
          create_score_badge(
            support_score
          ),
        
        `Priority Level` =
          create_priority_badge(
            priority_level
          ),
        
        Timeliness =
          sapply(
            timeliness_pct,
            create_progress_bar
          ),
        
        Completeness =
          sapply(
            completeness_pct,
            create_progress_bar
          ),
        
        Laboratory =
          sapply(
            iso15189_accreditation_pct,
            create_progress_bar
          ),
        
        Workforce =
          round(
            epidemiologists_per_100k,
            1
          ),
        
        Funding =
          paste0(
            "$",
            round(
              funding_per_capita_usd,
              2
            )
          )
        
      ) %>%
      
      select(
        
        Rank,
        Country,
        `Support Score`,
        `Priority Level`,
        Outbreaks = outbreaks_count,
        Timeliness,
        Completeness,
        Laboratory,
        Workforce,
        Funding
        
      )
    
    datatable(
      
      df,
      escape = FALSE,
      rownames = FALSE,
      class = "compact stripe hover",
      options = list(
        pageLength = 15,
        paging = TRUE,
        searching = FALSE,
        lengthChange = FALSE,
        info = TRUE,
        scrollX = TRUE,
        autoWidth = TRUE,
        ordering = FALSE,
        dom = "tip",
        columnDefs = list(
          list(
            className = "dt-center",
            targets = "_all"
          )
        )
        
      )
      
    )
    
  })
}

