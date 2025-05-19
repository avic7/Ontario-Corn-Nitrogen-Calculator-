server <- function(input, output, session) {
  
  output$soil_box <- renderValueBox({
    valueBox(
      value    = input$soil_type,
      subtitle = "Soil Type",
      icon     = icon("leaf"),
      color    = "green"  # valid
    )
  })
  
  output$yield_box <- renderValueBox({
    valueBox(
      value    = paste0(input$yield_goal, " bu/ac"),
      subtitle = "Yield Goal",
      icon     = icon("chart-line"),
      color    = "blue"  # valid
    )
  })
  
  output$heat_box <- renderValueBox({
    valueBox(
      value    = paste0(input$heat_units, " GDD"),
      subtitle = "Heat Units",
      icon     = icon("sun"),
      color    = "yellow"  # use valid option
    )
  })
  
  output$crop_box <- renderValueBox({
    valueBox(
      value    = input$previous_crop,  # FIXED input ID
      subtitle = "Previous Crop",
      icon     = icon("seedling"),
      color    = "teal"  # close to purple
    )
  })
}
