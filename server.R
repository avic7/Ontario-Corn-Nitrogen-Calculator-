server <- function(input, output, session) {
  
  output$soil_box <- renderValueBox({
    valueBox(
      value    = input$soil_type,
      subtitle = "Soil Type",
      icon     = icon("leaf"),
      color    = "green"
    )
  })
  
  output$yield_box <- renderValueBox({
    valueBox(
      value    = paste0(input$yield_goal, " bu/ac"),
      subtitle = "Yield Goal",
      icon     = icon("chart-line"),
      color    = "blue"
    )
  })
  
  output$heat_box <- renderValueBox({
    valueBox(
      value    = paste0(input$heat_units, " GDD"),
      subtitle = "Heat Units",
      icon     = icon("sun"),
      color    = "orange"
    )
  })
  
  output$crop_box <- renderValueBox({
    valueBox(
      value    = input$prev_crop,
      subtitle = "Previous Crop",
      icon     = icon("seedling"),
      color    = "purple"
    )
  })
  
  # …your other server logic…
}
