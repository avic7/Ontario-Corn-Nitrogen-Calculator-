server <- function(input, output, session) {
  
  soil_eo <- readxl::read_excel("SoilEO.xlsx")
  soil_wo <- readxl::read_excel("SoilWO.xlsx")
  crop_adj <- readxl::read_excel("PreviousCrop.xlsx")
  fertilizer_data <- readxl::read_excel("Fertilizers.xlsx")
  
  # Soil Selection Reactive
  selected_soil <- reactive({
    if (input$region == "Eastern Ontario") {
      soil_eo %>% filter(tolower(trimws(.data[["Soil Type"]])) == tolower(trimws(input$soil_type)))
    } else if (input$region == "Western Ontario") {
      soil_wo %>% filter(tolower(trimws(.data[["Soil Type"]])) == tolower(trimws(input$soil_type)))
    }
  })
  
  crop_adjustment <- reactive({
    crop_adj %>% filter(.data[["Previous Crop"]] == input$previous_crop)
  })
  
  # Yield Adjustment Calculation
  target_yield <- reactive({
    yield_imperial <- input$yield_adjustment * 0.77
    yield_metric <- yield_imperial * 1.12
    list(imperial = yield_imperial, metric = yield_metric)
  })
  
  # Heat Unit Adjustment Calculation
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
  
  # N content for selected fertilizer
  get_n_content <- reactive({
    req(input$fertilizer_product)
    selected_fertilizer <- fertilizer_data %>% 
      filter(`Fertilizer Type` == input$fertilizer_product)
    
    if(nrow(selected_fertilizer) > 0) {
      return(selected_fertilizer$`kg N/tonne`[1])
    } else {
      return(0)
    }
  })
  
  # Nitrogen price calculation
  output$nitrogen_price_output <- renderText({
    req(input$fertilizer_price_tonne, input$fertilizer_product, get_n_content())
    
    n_content_kg_per_tonne <- get_n_content()
    
    if(n_content_kg_per_tonne > 0) {
      # Converting price per tonne to price per kg of product
      price_per_kg_product <- input$fertilizer_price_tonne / 1000
      
      # Converting kg N/tonne to fraction
      n_fraction <- n_content_kg_per_tonne / 1000
      
      # Calculating price per kg of actual N
      price_per_kg_n <- price_per_kg_product / n_fraction
      
      # Converting to price per lb of actual N
      price_per_lb_n <- price_per_kg_n / 2.205
      
      paste0("$", round(price_per_lb_n, 2))
    } else {
      "$0.00"
    }
  })
  
  # Net corn price calculation
  output$net_corn_price_output <- renderText({
    req(input$corn_price)
    
    if (input$region == "Eastern Ontario") { 
      # Eastern Ontario
      drying <- ifelse(is.null(input$drying_charges), 0, input$drying_charges)
      transport <- ifelse(is.null(input$transport_marketing), 0, input$transport_marketing)
      net_price <- input$corn_price - drying - transport
    } else {
      # Western Ontario
      net_price <- input$corn_price
    }
    paste0("$", round(net_price, 2))
  })
  
  # Reactive expression for net corn price
  net_corn_price <- reactive({
    req(input$corn_price)
    
    if (input$region == "Eastern Ontario") { 
      drying <- ifelse(is.null(input$drying_charges), 0, input$drying_charges)
      transport <- ifelse(is.null(input$transport_marketing), 0, input$transport_marketing)
      return(input$corn_price - drying - transport)
    } else {
      return(input$corn_price)
    }
  })
  
  # Reactive expression for nitrogen price per lb
  nitrogen_price_per_lb <- reactive({
    req(input$fertilizer_price_tonne, input$fertilizer_product, get_n_content())
    
    n_content_kg_per_tonne <- get_n_content()
    
    if(n_content_kg_per_tonne > 0) {
      # Converting price per tonne to price per kg of product
      price_per_kg_product <- input$fertilizer_price_tonne / 1000
      
      # Convertoing kg N/tonne to fraction
      n_fraction <- n_content_kg_per_tonne / 1000
      
      # Calculating price per kg of actual N
      price_per_kg_n <- price_per_kg_product / n_fraction
      
      # Converting to price per lb of actual N 
      price_per_lb_n <- price_per_kg_n / 2.205
      
      return(price_per_lb_n)
    } else {
      return(0)
    }
  })
  
  # Price ratio calculation
  output$price_ratio_output <- renderText({
    req(nitrogen_price_per_lb(), net_corn_price())
    
    if(net_corn_price() > 0 && nitrogen_price_per_lb() > 0) {
      price_ratio <- nitrogen_price_per_lb() / net_corn_price()
      round(price_ratio, 1)
    } else {
      "0.0"
    }
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
  
  # Price Ratio Adjustment Calculation
  price_ratio <- reactive({
    req(nitrogen_price_per_lb(), net_corn_price())
    
    # C19/56
    corn_price_per_lb <- net_corn_price() / 56  
    ratio <- nitrogen_price_per_lb() / corn_price_per_lb
    
    return(ratio)
  })
  
  # Reactive Price Ratio Adjustment
  price_ratio_adjustment <- reactive({
    req(price_ratio())
    
    ratio <- price_ratio()
    
    # (C21-5)*6 (C21-5)*6.27
    imperial_adj <- -(ratio - 5) * 6
    metric_adj <- -(ratio - 5) * 6.7
    
    list(imperial = imperial_adj, metric = metric_adj)
  })
  
  # Price Ratio Adjustment outputs
  output$price_ratio_value <- renderText({
    req(price_ratio())
    round(price_ratio(), 2)  
  })
  
  output$price_ratio_imperial <- renderText({
    req(price_ratio_adjustment())
    paste0(round(price_ratio_adjustment()$imperial, 1), " lb/ac")
  })
  
  output$price_ratio_metric <- renderText({
    req(price_ratio_adjustment())
    paste0(round(price_ratio_adjustment()$metric, 1), " kg/ha")
  })
 
}
  
