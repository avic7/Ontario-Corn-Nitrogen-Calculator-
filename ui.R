library(shiny)
library(shinydashboard)
library(dplyr)
library(ggplot2)
library(leaflet)
library(DT)
library(lubridate)
library(plotly)
library(readxl)
library(shinythemes)
library(fontawesome)
library(shinyWidgets)

#UI 
ui <- navbarPage(
  theme = shinytheme("flatly"),
  title = div(style = "font-size: 24px;", "Corn Nitrogen Calculator"),
  
  
  header = tagList(
    tags$head(
      tags$style(HTML("
  .small-box {
    height: 85px !important;
    padding: 10px;
  }

  .small-box .icon {
    top: 10px !important;
    font-size: 30px !important;
    opacity: 0.3;
  }

  .small-box h3 {
    font-size: 24px !important;
    font-weight: bold;
  }

  .small-box p {
    font-size: 14px;
    margin: 0;
  }
")),
      
      tags$link(rel = "stylesheet", href = "https://cdn.jsdelivr.net/npm/admin-lte@2.4.18/dist/css/AdminLTE.min.css"),
      tags$link(rel = "stylesheet", href = "https://cdn.jsdelivr.net/gh/trestletech/shinydashboard@gh-pages/shinydashboard.min.css")
    )
  ),
  
  tabPanel("Calculator",
           fluidPage(
             fluidRow(
               column(width = 8, offset = 2, align = "center",
                      h2("OMAFRA General Recommended Nitrogen Rates for Corn: Corn N Calculator")
               )
             ),
             fluidRow(
               column(width = 12,
                      div(style = "display: flex; justify-content: flex-end; padding-right: 40px;",
                          selectInput("region_select",
                                      label = strong("Select Region"),
                                      choices = c("Western Ontario", "Eastern Ontario"),
                                      selected = "Western Ontario",
                                      width = "300px")
                      )
               )
             )
           ),

           fluidRow(
             # Region Select
             column(
             width = 3,
             selectInput(
               inputId = "soil_type",
               label = "Select Soil type",
               choices  = c("Clay", "Loam", "Sandy Loam", "Sand"),
               selected = "Loam"
             )
           ),
            #–– Yield Goal slider ––
           column(
             width = 3,
             sliderInput(
               inputId = "yield_goal",
               label   = "Yield Goal (bu/ac)",
               min     = 70,
               max     = 200,
               value   = 150,
               step    = 5
             )
           ),
           column(
             width = 3,
             sliderInput(
               inputId = "heat_units",
               label   = "Heat Units (GDD °C)",
               min     = 1200,
               max     = 2400,
               value   = 1800,
               step    = 50
              )
           ),
           column(
             width = 3,
             selectInput(
               inputId = "previous_crop",
               label = "Select Previous Crop",
               choices = c("Grain Corn", "Silage Corn", "Cereals (straw removed)", "Cereals (straw not removed)",
                           "Soybeans","Edible Beans","Red Clover underseeded (plowed)","Red Clover underseeded (no-till corn)",
                           "Perennial Forages 0 to 1/3 legume", "Perennial Forages  1/3 to 1/2 legume", "Perennial Forages  Over 1/2 legume"),
               selected = "Grain Corn"
             )
           )),
           # ——— four value-boxes in a row ———
           fluidRow(
             valueBoxOutput("soil_box",  width = 3),
             valueBoxOutput("yield_box", width = 3),
             valueBoxOutput("heat_box",  width = 3),
             valueBoxOutput("crop_box",  width = 3)
           )
  ),
  
  tabPanel("Dashboard",
           h2("Dashboard content here")
  ),
  
  tabPanel("Data",
           h2("Data content here")
  ),
  
  tabPanel("About",
           h2("About the app")
  )
)



