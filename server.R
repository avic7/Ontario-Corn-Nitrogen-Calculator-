server <- function(input, output, session) {
  
  soil_eo <- readxl::read_excel("SoilEO.xlsx")
  soil_wo <- readxl::read_excel("SoilWO.xlsx")
  crop_adj <- readxl::read_excel("PreviousCrop.xlsx")
  
  selected_soil <- reactive({
    if (input$region == "Eastern Ontario") {
      soil_eo %>% filter(tolower(trimws(`Soil Type`)) == tolower(trimws(input$soil_type)))
    } else if (input$region == "Western Ontario") {
      soil_wo %>% filter(tolower(trimws(`Soil Type`)) == tolower(trimws(input$soil_type)))
    }
  })
  
  # Yield Adjustment Calculations
  target_yield <- reactive({
    yield_imperial <- input$yield_adjustment * 0.77
    yield_metric <- yield_imperial * 1.12
    list(imperial = yield_imperial, metric = yield_metric)
  })
  
  # Heat Unit Adjustment Calculations
  heat_unit_adj <- reactive({
    chu <- input$heat_units
    hu_imperial <- (chu - 2800) * 0.036
    hu_metric <- (chu - 2800) * 0.041
    list(imperial = hu_imperial, metric = hu_metric)
  })
  
  # Previous Crop Adjustment
  crop_adjustment <- reactive({
    crop_adj %>% filter(`Previous Crop` == input$previous_crop)
  })
  
  # Soil Base N (Imperial)
  output$vb_soil_1 <- renderUI({
    req(selected_soil())
    div(class = "small-box bg-soil",
        div(class = "main-text", selected_soil()[[2]]),
        div(class = "subtext", "Base N (lb/ac)"),
        div(class = "icon", icon("seedling"))
    )
  })
  
  # Soil Base N (Metric)
  output$vb_soil_2 <- renderUI({
    req(selected_soil())
    div(class = "small-box bg-soil",
        div(class = "main-text", selected_soil()[[3]]),
        div(class = "subtext", "Base N (kg/ha)"),
        div(class = "icon", icon("seedling"))
    )
  })
  
  # Yield Adjustment (Imperial)
  output$vb_yield_1 <- renderUI({
    req(target_yield())
    div(class = "small-box bg-yield",
        div(class = "main-text", paste0(round(target_yield()$imperial, 1), " bu/ac")),
        div(class = "subtext", "Target Yield (Imperial)"),
        div(class = "icon", icon("chart-line"))
    )
  })
  
  # Yield Adjustment (Metric)
  output$vb_yield_2 <- renderUI({
    req(target_yield())
    div(class = "small-box bg-yield",
        div(class = "main-text", paste0(round(target_yield()$metric, 1), " kg/ha")),
        div(class = "subtext", "Target Yield (Metric)"),
        div(class = "icon", icon("chart-line"))
    )
  })
  
  # Heat Unit Adjustment (Imperial)
  output$vb_heat_1 <- renderUI({
    req(heat_unit_adj())
    div(class = "small-box bg-heat",
        div(class = "main-text", paste0(round(heat_unit_adj()$imperial, 1), " HU")),
        div(class = "subtext", "CHU Adjustment (Imperial)"),
        div(class = "icon", icon("temperature-high"))
    )
  })
  
  # Heat Unit Adjustment (Metric)
  output$vb_heat_2 <- renderUI({
    req(heat_unit_adj())
    div(class = "small-box bg-heat",
        div(class = "main-text", paste0(round(heat_unit_adj()$metric, 1), " HU")),
        div(class = "subtext", "CHU Adjustment (Metric)"),
        div(class = "icon", icon("temperature-high"))
    )
  })
  
  # Crop Adjustment (Imperial)
  output$vb_crop_1 <- renderUI({
    req(crop_adjustment())
    div(class = "small-box bg-crop",
        div(class = "main-text", crop_adjustment()[[2]]),
        div(class = "subtext", "Crop Adjustment (lb/ac)"),
        div(class = "icon", icon("leaf"))
    )
  })
  
  # Crop Adjustment (Metric)
  output$vb_crop_2 <- renderUI({
    req(crop_adjustment())
    div(class = "small-box bg-crop",
        div(class = "main-text", crop_adjustment()[[3]]),
        div(class = "subtext", "Crop Adjustment (kg/ha)"),
        div(class = "icon", icon("leaf"))
    )
  })

  
  # nitrogen price
  output$nitrogen_price_output <- renderText({
    if (!is.null(input$fertilizer_price_tonne) && !is.null(input$fertilizer_product)) {
      # Conversion factors for different fertilizers (% N content)
      n_content <- switch(input$fertilizer_product,
                          "Urea" = 0.46,
                          "Anhydrous Ammonia" = 0.82,
                          "UAN Solution" = 0.28)
      
      
      # Converting tonne to lbs and calculate price per lb of actual N
      price_per_lb_product <- input$fertilizer_price_tonne / 2204.62  # tonne to lbs
      price_per_lb_n <- price_per_lb_product / n_content
      
      paste0("$", round(price_per_lb_n, 2))
    } else {
      "$0.00"
    }
  })
  
  output$net_corn_price_output <- renderText({
    if (!is.null(input$corn_price)) {
      if (input$region == "Eastern Ontario") { 
        
        # For Eastern Ontario, subtracting drying charges and transportation/marketing
        drying <- ifelse(is.null(input$drying_charges), 0, input$drying_charges)
        transport <- ifelse(is.null(input$transport_marketing), 0, input$transport_marketing)
        net_price <- input$corn_price - drying - transport
      } else {
        
        # For Western Ontario, using corn price as it is
        net_price <- input$corn_price
      }
      paste0("$", round(net_price, 2))
    } else {
      "$0.00"
    }
  })
  
  
  net_corn_price <- reactive({
    if (!is.null(input$corn_price)) {
      if (input$region == "Eastern Ontario") { 
        drying <- ifelse(is.null(input$drying_charges), 0, input$drying_charges)
        transport <- ifelse(is.null(input$transport_marketing), 0, input$transport_marketing)
        return(input$corn_price - drying - transport)
      } else {
        return(input$corn_price)
      }
    }
    return(0)
  })
  
  # Update price ratio calculation to use the reactive expression:
  output$price_ratio_output <- renderText({
    if (!is.null(input$fertilizer_price_tonne) && !is.null(input$fertilizer_product) && net_corn_price() > 0) {
      n_content <- switch(input$fertilizer_product,
                          "Urea" = 0.46,
                          "Anhydrous Ammonia" = 0.82,
                          "UAN Solution" = 0.28)
      
      price_per_lb_product <- input$fertilizer_price_tonne / 2204.62
      price_per_lb_n <- price_per_lb_product / n_content
      
      
      
      # Calculate price ratio
      price_ratio <- price_per_lb_n / net_corn_price()
      
      round(price_ratio, 1)
    } else {
      "0.0"
    }
  })
  
  # Calculate lb/ac adjustment
  output$adjustment_lb_ac_output <- renderText({
    "-38"  # Placeholder 
  })
  
  # Calculate kg/ha adjustment
  output$adjustment_kg_ha_output <- renderText({
    "-42"  # Placeholder 
  })
  
  # Total Nitrogen Recommendation (Imperial)
  output$total_n_imperial <- renderText({
    req(selected_soil(), target_yield(), heat_unit_adj(), crop_adjustment())
    
    total <- as.numeric(selected_soil()[[2]]) +
      as.numeric(target_yield()$imperial) +
      as.numeric(heat_unit_adj()$imperial) +
      as.numeric(crop_adjustment()[[2]])
    
    paste0(round(total, 1), " lb/ac")
  })
  
  
  # Total Nitrogen Recommendation (Metric)
  output$total_n_metric <- renderText({
    req(selected_soil(), target_yield(), heat_unit_adj(), crop_adjustment())
    
    total <- as.numeric(selected_soil()[[3]]) +
      as.numeric(target_yield()$metric) +
      as.numeric(heat_unit_adj()$metric) +
      as.numeric(crop_adjustment()[[3]])
    
    paste0(round(total, 1), " kg/ha")
  })
  
  
  # Calculation of  preplant additional N
  output$preplant_additional_n_imperial <- renderText({
    "22" # Placeholder 
  })
  
  output$preplant_additional_n_metric <- renderText({
    "25" # Placeholder 
  })
  
  # Calculation of sidedress additional N
  output$sidedress_additional_n_imperial <- renderText({
    "22" # Placeholder 
  })
  
  output$sidedress_additional_n_metric <- renderText({
    "25" # Placeholder 
  })
  
  # Nitrogen Credit Calculations
  output$starter_n_credit <- renderText({
    req(input$starter_n_imperial)
    paste0(round(input$starter_n_imperial * 1.12, 1), " kg/ha")
  })
  
  output$manure_n_credit <- renderText({
    req(input$manure_credit_imperial)
    paste0(round(input$manure_credit_imperial * 1.13, 1), " kg/ha")
  })
}
