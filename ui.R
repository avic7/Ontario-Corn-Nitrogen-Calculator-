library(shiny)
library(shinydashboard)
library(DT)
library(dplyr)
library(readxl)
library(shinythemes)
library(fontawesome)
library(shinyWidgets)



# UI 
ui <- navbarPage(
  title = div(
    span("OCNC", style = "margin-right: auto; color: white; font-weight: bold;"),
    div(style = "position: absolute; right: 15px; top: 50%; transform: translateY(-50%); display: flex; align-items: center;",
        tags$a(href = "https://github.com/adriancorrendo/", target = "_blank", 
               style = "color: white; font-size: 18px; margin: 0 8px; text-decoration: none;",
               tags$i(class = "fab fa-github")
        ),
        tags$a(href = "https://x.com/aacorrendo/", target = "_blank",
               style = "color: white; font-size: 18px; margin: 0 8px; text-decoration: none;", 
               tags$i(class = "fab fa-twitter")
        ),
        tags$a(href = "https://www.linkedin.com/in/adriancorrendo/", target = "_blank",
               style = "color: white; font-size: 18px; margin: 0 8px; text-decoration: none;",
               tags$i(class = "fab fa-linkedin")
        )
    )
  ),
  fluid = TRUE,
  header = tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "style.css"),
    tags$link(rel = "stylesheet", href = "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css")
  ),
  
  tabPanel("Calculator",
           fluidPage(
             # Header
             fluidRow(
               column(width = 12,
                      div(
                        style = "display: flex;",
                        tags$img(src = "corn-cob.png", 
                                 height = "100px", 
                                 style = "margin-right: 5px; vertical-align: middle;"),
                        div(
                          tags$h1(
                            "Ontario Corn Nitrogen Calculator",
                            style = "
                            font-size:5rem; 
                            font-weight:700; 
                            line-height:1.2; 
                            margin-bottom:0.2rem; 
                            text-align:left;"
                          ),
                          tags$h4(
                            "OMAFA General Recommended Nitrogen Rates for Corn", 
                            
                            style = "color:#6c757d; 
                            font-size:2rem; 
                            font-weight:400; 
                            margin-top:0; 
                            margin-bottom:2rem; 
                            text-align:left;"
                          )
                        )
                      )
               )
             ),
             
             # Region Selection
             fluidRow(
               column(width = 12,
                      div(style = "display: flex; justify-content: flex-end; padding-right: 40px;",
                          selectInput(
                            inputId = "region",
                            label = strong("Select Region"),
                            choices = c("Eastern Ontario", "Western Ontario"),
                            selected = "Eastern Ontario",
                            width = "300px")
                      )
               )
             ),
             
             # Base Nitrogen Requirement
             h2("Base N Requirement"),
             fluidRow(
               column(width = 12,
                      div(class = "input-card",
                          fluidRow(
                            column(3,
                                   div(class ="card-input-title", "Select Soil type"),
                                   selectInput("soil_type", NULL,
                                               choices = c("Clay", "Heavy Clay","Clay Loam","Loam",
                                                           "Loamy Sand","Sandy Loam","Sand",
                                                           "Sandy Clay","Sandy Clay Loam","Silt Loam",
                                                           "Silty Clay Loam","Silty Clay"),
                                               selected = "Loam"),
                                   uiOutput("vb_soil_1"),
                                   uiOutput("vb_soil_2")
                            ),
                            column(3,
                                   div(class = "card-input-title", "Select Previous Crop"),
                                   selectInput("previous_crop", NULL,
                                               choices = c("Grain Corn", "Silage Corn", "Cereals (straw removed)",
                                                           "Cereals (straw not removed)", "Soybeans", "Edible Beans",
                                                           "Red Clover underseeded (plowed)", "Red Clover underseeded (no-till corn)",
                                                           "Perennial Forages 0 to 1/3 legume", "Perennial Forages 1/3 to 1/2 legume",
                                                           "Perennial Forages Over 1/2 legume"),
                                               selected = "Grain Corn"),
                                   uiOutput("vb_crop_1"),
                                   uiOutput("vb_crop_2")
                            ),
                            column(3,
                                   div(class = "card-input-title", "Yield (bu/ac)"),
                                   numericInput("yield_adjustment", NULL,
                                                value = 180, min = 70, max = 200, step = 10),
                                   uiOutput("vb_yield_1"),
                                   uiOutput("vb_yield_2")
                            ), 
                            column(3,
                                   div(class = "card-input-title", "Heat Units (CHU)"),
                                   numericInput("heat_units", NULL,
                                                value = 1800, min = 1200, max = 2400, step = 100),
                                   uiOutput("vb_heat_1"),
                                   uiOutput("vb_heat_2")
                            )
                          )
                      )
               )
             ),
      
             # Precipitation V5 - V12 Section
             conditionalPanel(
               condition = "input.soil_type == 'Silt Loam'",
               tagList(
                 h2("Precipitation"),
                 fluidRow(
                   column(width = 12,
                          div(class = "input-card",
                              fluidRow(
                                column(4,
                                       div(class = "card-input-title", "Precipitation V5 - V12 (mm)"),
                                       numericInput("precipitation", NULL, value = 100, min = 0, step = 1)
                                ),
                                column(4,
                                       uiOutput("vb_precip_1")
                                ),
                                column(4,
                                       uiOutput("vb_precip_2")
                                )
                              )
                          )
                   )
                 )
               )
             ),
             
             # Price Ratio 
             h2("Price Ratio Calculations"),
             fluidRow(
               column(width = 12,
                      div(class = "input-card",
                          # Western Ontario
                          conditionalPanel(
                            condition = "input.region == 'Western Ontario'",  
                            fluidRow(
                              column(4,
                                     div(class = "card-input-title", "Expected corn price"),
                                     numericInput("corn_price", NULL, value = 2.80, min = 0, step = 0.01)
                              ),
                              column(4,
                                     div(class = "card-input-title", "Fertilizer product"),
                                     selectInput("fertilizer_product", NULL,
                                                 choices = c("Ammonium Nitrate","Ammonium Sulphate","Anhydrous Ammonia",
                                                             "Calcium Ammonium Nitrate","UAN (28-0-0)","Urea"),
                                                 selected = "Urea")
                              ),
                              column(4,
                                     div(class = "card-input-title", "Price per tonne of product"),
                                     numericInput("fertilizer_price_tonne", NULL, value = 450, min = 0, step = 1)
                              )
                            )
                          ),
                          # Eastern Ontario
                          conditionalPanel(
                            condition = "input.region == 'Eastern Ontario'",
                            fluidRow(
                              column(2,
                                     div(class = "card-input-title", "Expected corn price"),
                                     numericInput("corn_price", NULL, value = 2.80, min = 0, step = 0.01)
                              ),
                              column(2,
                                     div(class = "card-input-title", "Drying charges ($/bu)"),
                                     numericInput("drying_charges", NULL, value = 0.35, min = 0, step = 0.01)
                              ),
                              column(3,
                                     div(class = "card-input-title", "Transportation and marketing ($/bu)"),
                                     numericInput("transport_marketing", NULL, value = 0.25, min = 0, step = 0.01)
                              ),
                              column(2,
                                     div(class = "card-input-title", "Fertilizer product"),
                                     selectInput("fertilizer_product", NULL,
                                                 choices = c("Ammonium Nitrate","Ammonium Sulphate","Anhydrous Ammonia",
                                                             "Calcium Ammonium Nitrate","UAN (28-0-0)","Urea"),
                                                 selected = "Urea",
                                                 width = "100%")
                              ),
                              column(3,
                                     div(class = "card-input-title", "Price per tonne of product"),
                                     numericInput("fertilizer_price_tonne", NULL, value = 450, min = 0, step = 1)
                              )
                            )
                          ),
                          fluidRow(
                            column(6,
                                   div(class = "card-input-title", style = "font-weight: bold; font-size: 16px;", "Net Corn Price"),
                                   div(style = "background: linear-gradient(135deg, var(--corn-gold), var(--corn-mature)); color: white; border: none; border-radius: 8px; padding: 15px; text-align: center; font-weight: bold; font-size: 18px; box-shadow: 0 4px 12px rgba(0,0,0,0.15);",
                                       textOutput("net_corn_price_output")
                                   )
                            ),
                            column(6,
                                   div(class = "card-input-title", style = "font-weight: bold; font-size: 16px;", "Nitrogen Price ($/lb actual N)"),
                                   div(style = "background: linear-gradient(135deg, var(--healthy-crop), var(--spring-green)); color: white; border: none; border-radius: 8px; padding: 15px; text-align: center; font-weight: bold; font-size: 18px; box-shadow: 0 4px 12px rgba(0,0,0,0.15);",
                                       textOutput("nitrogen_price_output")
                                   )
                            )
                          )))),
             
             # Price Ratio Adjustment 
             h2("Price Ratio Adjustment"),
             fluidRow(
               column(width = 12,
                      div(class = "input-card",
                          fluidRow(
                            column(4,
                                   div(class = "card-input-title", "Price Ratio ($N:$corn)"),
                                   div(style = "background-color: white; color: black; border: 2px solid #ddd; border-radius: 8px; padding: 15px; text-align: center; font-weight: bold; font-size: 18px; box-shadow: 0 4px 12px rgba(0,0,0,0.15);",
                                       textOutput("price_ratio_value")
                                   )
                            ),
                            column(4,
                                   div(class = "card-input-title", "Imperial Adjustment"),
                                   div(style = "background-color: white; color: black; border: 2px solid #ddd; border-radius: 8px; padding: 15px; text-align: center; font-weight: bold; font-size: 18px; box-shadow: 0 4px 12px rgba(0,0,0,0.15);",
                                       textOutput("price_ratio_imperial")
                                   )
                            ),
                            column(4,
                                   div(class = "card-input-title", "Metric Adjustment"),
                                   div(style = "background-color: white; color: black; border: 2px solid #ddd; border-radius: 8px; padding: 15px; text-align: center; font-weight: bold; font-size: 18px; box-shadow: 0 4px 12px rgba(0,0,0,0.15);",
                                       textOutput("price_ratio_metric")
                                   )
                            )
                          )
                      )
               )
             )),
             
             # Total Nitrogen Recommendation  
             h2("Total N Recommendation"),
             fluidRow(
               column(width = 12,
                      div(class = "input-card",
                          fluidRow(
                            column(6,
                                   uiOutput("vb_total_1"),
                                   div(class = "card-input-title", "Imperial"),
                                   div(style = "background-color: white; color: black; border: 2px solid #ddd; border-radius: 8px; padding: 15px; text-align: center; font-weight: bold; font-size: 18px; box-shadow: 0 4px 12px rgba(0,0,0,0.15);",
                                       textOutput("total_n_imperial")
                                   )
                            ),
                            column(6,
                                   uiOutput("vb_total_2"),
                                   div(class = "card-input-title", "Metric"),
                                   div(style = "background-color: white; color: black; border: 2px solid #ddd; border-radius: 8px; padding: 15px; text-align: center; font-weight: bold; font-size: 18px; box-shadow: 0 4px 12px rgba(0,0,0,0.15);",
                                       textOutput("total_n_metric")
                                   )
                            )
                          )
                      )
               )
             ),
             # Recommendation Guide Section
             fluidRow(
               column(width = 12,
                      div(style = "background-color: #e8f5e9; border-radius: 12px; padding: 25px; margin-top: 20px;",
                          h3("Recommended Nitrogen Rate", style = "color: var(--forest-green); margin-bottom: 15px;"),
                          p(style = "font-size: 16px; line-height: 1.6; color: #2c3e50;",
                            span(style = "font-weight: bold; color: var(--forest-green); font-size: 18px;"), 
                            "This recommendation considers your soil type, previous crop,yield goal and heat units. For more detailed information and adjustment factors, please consult the ",
                            a("OMAFA Guide", href = "https://fieldcropnews.com/2024/05/ontario-corn-nitrogen-calculator/", style = "color: var(--spring-green); text-decoration: underline;"),
                            " or visit the Resources section."
                          )
                      )
               )
             ),
             
             # Fertilizer Management 
             h2("Fertilizer Management"),
             fluidRow(
               column(width = 12,
                      div(class = "input-card",
                          fluidRow(
                            # Input boxes
                            column(6,
                                   # Starter N row
                                   fluidRow(
                                     column(8,
                                            div(class = "card-input-title", "Starter N (lb-N/ac)")
                                     ),
                                     column(4,
                                            numericInput("starter_n_imperial", NULL, value = 10, min = 0, step = 1,
                                                         width = "100%")
                                     )
                                   ),
                                   # Manure Credit row  
                                   fluidRow(
                                     column(8,
                                            div(class = "card-input-title", "Manure Credit (lb-N/ac)")
                                     ),
                                     column(4,
                                            numericInput("manure_credit_imperial", NULL, value = 20, min = 0, step = 1,
                                                         width = "100%")
                                     )
                                   )
                            ),
                            column(6,
                                   # Starter N output
                                   div(style = "background-color: white; color: black; border: 2px solid #ddd; border-radius: 8px; padding: 15px; text-align: center; font-weight: bold; font-size: 18px; box-shadow: 0 4px 12px rgba(0,0,0,0.15); margin-bottom: 15px;",
                                       textOutput("starter_n_credit")
                                   ),
                                   # Manure Credit output
                                   div(style = "background-color: white; color: black; border: 2px solid #ddd; border-radius: 8px; padding: 15px; text-align: center; font-weight: bold; font-size: 18px; box-shadow: 0 4px 12px rgba(0,0,0,0.15);",
                                       textOutput("manure_n_credit")
                                   )
                            )
                          )
                      )
               )
             ), 
  
             #Fertilizer Management Split
             h2("Fertilizer Split"),
             fluidRow(
               column(width = 12,
                      div(class = "input-card",
                          
                          # Add Split Slider
                          fluidRow(
                            column(12,
                                   div(class = "card-input-title", "Split (% Pre-Plant)"),
                                   div(style = "padding: 0 20px;",
                                       sliderInput("split_percentage", 
                                                   label = NULL,
                                                   min = 0, 
                                                   max = 100, 
                                                   value = 50, 
                                                   step = 5,
                                                   post = "%",
                                                   width = "100%")
                                   ),
                                   div(style = "text-align: center; color: #666; font-size: 14px; margin-top: 10px;",
                                       "Move slider to adjust split between Preplant and Sidedress application")
                            )
                          ),
                          
                          # Spacing
                          br(),
                          
                          # Preplant Additional N outputs
                          fluidRow(
                            column(6,
                                   div(class = "card-input-title", style = "font-weight: bold; font-size: 16px;", "Preplant Additional N"),
                                   div(style = "background-color: #90EE90; color: black; border: 2px solid #32CD32; border-radius: 8px; padding: 15px; text-align: center; font-weight: bold; font-size: 18px; box-shadow: 0 4px 12px rgba(0,0,0,0.15);",
                                       textOutput("preplant_additional_n_imperial")
                                   )
                            ),
                            column(6,
                                   div(style = "margin-top: 32px;",
                                       div(style = "background-color: #90EE90; color: black; border: 2px solid #32CD32; border-radius: 8px; padding: 15px; text-align: center; font-weight: bold; font-size: 18px; box-shadow: 0 4px 12px rgba(0,0,0,0.15);",
                                           textOutput("preplant_additional_n_metric")
                                       )
                                   )
                            )
                          ),

                                      
                          # "or" text
                          fluidRow(
                            column(12,
                                   div(style = "text-align: center; font-size: 18px; font-weight: bold; margin: 15px 0;", "or")
                            )
                          ),
                          
                          # Timing Adjustment text
                          fluidRow(
                            column(12,
                                   div(style = "background-color: #f8f9fa; padding: 10px; border-radius: 8px; text-align: center; font-weight: bold; margin-bottom: 15px;",
                                       "Timing Adjustment (if Sidedress) - does not apply to Eastern Ontario"
                                   )
                            )
                          ),
                          
                          # SideDress Additional N outputs 
                          fluidRow(
                            column(6,
                                   div(class = "card-input-title", style = "font-weight: bold; font-size: 16px;", "SideDress Additional N"),
                                   div(style = "background-color: #90EE90; color: black; border: 2px solid #32CD32; border-radius: 8px; padding: 15px; text-align: center; font-weight: bold; font-size: 18px; box-shadow: 0 4px 12px rgba(0,0,0,0.15);",
                                       textOutput("sidedress_additional_n_imperial")
                                   )
                            ),
                            column(6,
                                   div(style = "margin-top: 32px;",
                                       div(style = "background-color: #90EE90; color: black; border: 2px solid #32CD32; border-radius: 8px; padding: 15px; text-align: center; font-weight: bold; font-size: 18px; box-shadow: 0 4px 12px rgba(0,0,0,0.15);",
                                           textOutput("sidedress_additional_n_metric")
                                       )
                                   )
                            )
                          )
                      )
               )
             )),

  
  # About section 
  tabPanel("About",
           fluidPage(
             style = "padding: 40px;",
             
             # Logo
             fluidRow(
               column(width = 12,
                      div(style = "display: flex; align-items: center; margin-bottom: 30px; padding: 0 20px;",
                          div(style = "flex: 1; text-align: center;",
                              tags$img(src = "uog.png", 
                                       style = "max-width: 500px; height: 150px; object-fit: contain;",
                                       alt = "University of Guelph - Ontario Agricultural College")
                          ),
                          div(style = "flex: 1; text-align: center;",
                              tags$img(src = "OMAFA.png", 
                                       style = "max-width: 1500px; height: 150px; object-fit: contain;",
                                       alt = "Ontario")
                          ),
                          div(style = "flex: 1; text-align: center;",
                              tags$img(src = "GFO.png", 
                                       style = "max-width: 1500px; height: 150px; object-fit: contain;",
                                       alt = "Grain Farmers of Ontario")
                          )
                      )
               )
             ),
             # Description 
             fluidRow(
               column(width = 12,
                      h2("Description", style = "color: #333; font-size: 4rem; margin-bottom: 20px; font-weight: 600;"),
                      
                      p(style = "font-size: 20px; line-height: 1.7; color: #555; margin-bottom: 20px;",
                        "This RShiny application is a modern adaptation of the Ontario Corn Nitrogen Calculator, 
                      designed to assist corn producers in determining the most economically optimal nitrogen 
                      (N) application rates for their fields. Leveraging over four decades of Ontario-based corn N 
                      response data, the tool integrates key agronomic factors such as soil texture, 
                      regional location (Eastern vs. Western Ontario), yield potential, 
                      crop heat units, and previous crop history to provide tailored N recommendations."
                      ),
                      
                      p(style = "font-size: 20px; line-height: 1.7; color: #555; margin-bottom: 20px;",
                        "The calculator further refines its suggestions by accounting for the 
                      relative pricing of nitrogen fertilizer to corn, credits from starter fertilizers and 
                      manure applications, as well as adjustments based on sidedress application timings. 
                      By incorporating these variables, the app aims to enhance nitrogen use efficiency, 
                      optimize crop yields, and support sustainable farming practices across Ontario's diverse 
                      agricultural landscapes."
                      ),
               )
             ),             
             # Separator line
             fluidRow(
               column(width = 12,
                      hr(style = "border-top: 1px solid #000; margin: 30px 0;")
               )
             ),          
             # Citation 
             fluidRow(
               column(width = 12,
                      h2("Citation", style = "color: #333; font-size: 4rem; margin-bottom: 20px; margin-top: 20px; font-weight: 600;"),
                      
                      p(style = "font-size: 20px; line-height: 1.6; color: #555; font-style: italic; margin-bottom: 10px;",
                        "Ontario Ministry of Agriculture, Food and Rural Affairs. (2024). Ontario Corn Nitrogen Calculator - OMAFRA Recommendations. Field Crop News, Ontario."
                      ),
                      
                      tags$a(href = "https://fieldcropnews.com/2024/05/ontario-corn-nitrogen-calculator/", 
                             target = "_blank",
                             style = "color: #2c5530; text-decoration: underline; font-size: 14px;",
                             "https://fieldcropnews.com/2024/05/ontario-corn-nitrogen-calculator/"
                      ),
                      
                      # Corn Logo Attribution
                      p(style = "font-size: 16px; line-height: 1.6; color: #666; margin-top: 20px;",
                        HTML('<a href="https://www.flaticon.com/free-icons/agriculture" title="agriculture icons" target="_blank" style="color: #2c5530; text-decoration: underline;">Agriculture icons created by juicy_fish - Flaticon</a>')
                      )
               )
             ),             
             # Separator line
             fluidRow(
               column(width = 12,
                      hr(style = "border-top: 1px solid #000; margin: 30px 0;")
               )
             ),             
             # Credits 
             fluidRow(
               column(width = 12,
                      h2("Credits", style = "color: #333; font-size: 4rem; margin-bottom: 20px; margin-top: 20px; font-weight: 600;"),
                      
                      p(style = "font-size: 20px; line-height: 1.6; color: #555; margin-bottom: 15px;",
                        "This application was designed and developed by Atharva Vichare and Supervised by Dr.Adrian Correndo. ",
                        tags$a(href = "https://github.com/avic7", 
                               target = "_blank",
                               style = "color: #2c5530; text-decoration: underline;",
                               "https://github.com/avic7"
                        )
                      ),
                     
                      p(style = "font-size: 16px; line-height: 1.6; color: #666; margin-bottom: 0; font-style: italic;",
                        "Chang, W., Cheng, J., Allaire, J.J., Xie, Y., and McPherson, J. (2021). ",
                        tags$em("shiny: Web Application Framework for R"),
                        ". R package version 1.7.1. ",
                        tags$a(href = "https://CRAN.R-project.org/package=shiny", 
                               target = "_blank",
                               style = "color: #2c5530; text-decoration: underline;",
                               "https://CRAN.R-project.org/package=shiny"
                        )
                      )
               )
             )
           )
  )
)
