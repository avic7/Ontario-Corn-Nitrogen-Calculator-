library(shiny)
library(shinydashboard)
library(DT)
library(readxl)
library(shinythemes)
library(fontawesome)
library(shinyWidgets)

# UI 
ui <- navbarPage(
  title = "OCNC",
  theme = shinytheme("flatly"),
  fluid = TRUE,
  header = tags$head(
    tags$style(HTML("
      /* Agricultural Color Palette for Ontario Corn Calculator */
      :root {
        /* Primary Agricultural Colors */
        --corn-gold: #F1C40F;          /* Bright corn yellow */
        --corn-mature: #F39C12;        /* Mature corn orange */
        --fertile-soil: #8B4513;       /* Rich soil brown */
        --spring-green: #27AE60;       /* Fresh growth green */
        --forest-green: #1E8449;       /* Deep forest green */
        --sky-blue: #3498DB;           /* Clear sky blue */
        --harvest-orange: #E67E22;     /* Harvest sunset orange */
        --nitrogen-blue: #2980B9;      /* Nitrogen rich blue */
        --healthy-crop: #58D68D;       /* Healthy crop light green */
        --prairie-beige: #D5DBDB;      /* Prairie/field beige */
      }

      /* Enhanced Small Boxes with Agricultural Theme */
      .small-box {
        display: flex;
        flex-direction: column;
        justify-content: center;
        align-items: flex-start;
        height: 110px;
        padding: 16px;
        border-radius: 12px;
        font-weight: bold;
        color: white;
        margin-top: 10px;
        margin-bottom: 10px;
        position: relative;
        box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        transition: transform 0.2s ease, box-shadow 0.2s ease;
      }

      .small-box:hover {
        transform: translateY(-2px);
        box-shadow: 0 6px 20px rgba(0,0,0,0.2);
      }

      .small-box .main-text {
        font-size: 20px;
        font-weight: 700;
        line-height: 1.2;
        text-shadow: 0 1px 2px rgba(0,0,0,0.1);
      }

      .small-box .subtext {
        font-size: 14px;
        opacity: 0.95;
        margin-top: 6px;
        text-shadow: 0 1px 2px rgba(0,0,0,0.1);
      }

      .small-box .icon {
        position: absolute;
        top: 10px;
        right: 12px;
        font-size: 26px;
        opacity: 0.3;
      }

      /* Agricultural Color Scheme for Value Boxes */
      .bg-soil { 
        background: linear-gradient(135deg, var(--fertile-soil), #A0522D);
      }

      .bg-yield { 
        background: linear-gradient(135deg, var(--corn-gold), var(--corn-mature));
      }

      .bg-heat { 
        background: linear-gradient(135deg, var(--harvest-orange), #D35400);
      }

      .bg-crop { 
        background: linear-gradient(135deg, var(--spring-green), var(--forest-green));
      }

      .bg-nitrogen {
        background: linear-gradient(135deg, var(--nitrogen-blue), var(--sky-blue));
      }

      .bg-calculation {
        background: linear-gradient(135deg, var(--healthy-crop), var(--spring-green));
      }

      /* Enhanced Input Cards */
      .input-card {
        background: white;
        border-radius: 15px;
        box-shadow: 0 4px 15px rgba(0,0,0,0.08);
        padding: 30px;
        margin-bottom: 25px;
        transition: box-shadow 0.3s ease;
      }

      .input-card:hover {
        box-shadow: 0 8px 25px rgba(0,0,0,0.12);
      }

      h1, h2, h3 {
        color: var(--forest-green);
        font-weight: 600;
      }

      h2 {
        padding-bottom: 10px;
        margin-bottom: 25px;
      }

      /* Form Inputs Enhancement */
      .form-control:focus {
        border-color: var(--spring-green);
        box-shadow: 0 0 0 0.2rem rgba(39, 174, 96, 0.25);
      }

      .form-group label {
        color: var(--forest-green);
        font-weight: 500;
        margin-bottom: 8px;
      }

      /* Select Dropdown Styling */
      .selectize-input {
        border: 2px solid #E8F5E8;
        border-radius: 8px;
      }

      .selectize-input.focus {
        border-color: var(--spring-green);
      }

      /* Region Select Enhancement */
      #region_select {
        border: 2px solid var(--corn-gold);
        border-radius: 8px;
        background-color: white;
      }

      /* Numeric Input Styling */
      input[type='number'] {
        border: 2px solid #E8F5E8;
        border-radius: 8px;
        padding: 8px 12px;
      }

      input[type='number']:focus {
        border-color: var(--spring-green);
        outline: none;
        box-shadow: 0 0 5px rgba(39, 174, 96, 0.3);
      }

      /* Card Input Title */
      .card-input-title {
        color: var(--forest-green);
        font-weight: 600;
        margin-bottom: 10px;
        font-size: 14px;
      }

      /* Responsive Design */
      @media (max-width: 768px) {
        .small-box {
          height: 90px;
          padding: 12px;
        }
        
        .small-box .main-text {
          font-size: 16px !important;
        }
      }
    "))
  ),
  
  tabPanel("OMAFRA Calculator",
           fluidPage(
             # Header Section
             fluidRow(
               column(width = 12,offset = 2,
                      tags$h1(
                        "OMAFRA General Recommended Nitrogen", tags$br(),
                        "Rates for Corn",
                        style = "
                        font-size:5rem; 
                        font-weight:700; 
                        line-height:1.2; 
                        margin-bottom:0.2rem; 
                        text-align:left;"
                      ),
                      tags$h4(
                        "Corn N Calculator",
                        style = "color:#6c757d; 
                        font-size:3rem; 
                        font-weight:400; 
                        margin-top:0; 
                        margin-bottom:2rem; 
                        text-align:left;"
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
             
             h2("Base N Requirement"),
             fluidRow(
               column(width = 12,
                      div(class = "input-card",
                          fluidRow(
                            column(3,
                                   div(class = "card-input-title", "Select Soil type"),
                                   selectInput("soil_type", NULL,
                                               choices = c("Clay", "Loam", "Sandy Loam", "Sand"),
                                               selected = "Loam"),
                                   uiOutput("vb_soil_1"),
                                   uiOutput("vb_soil_2")
                            ),
                            column(3,
                                   div(class = "card-input-title", "Yield Adjustment"),
                                   numericInput("yield_adjustment", NULL,
                                                value = 180, min = 70, max = 200, step = 10),
                                   uiOutput("vb_yield_1"),
                                   uiOutput("vb_yield_2")
                            ), 
                            column(3,
                                   div(class = "card-input-title", "Heat Units"),
                                   numericInput("heat_units", NULL,
                                                value = 1800, min = 1200, max = 2400, step = 100),
                                   uiOutput("vb_heat_1"),
                                   uiOutput("vb_heat_2")
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
                            )
                          )
                      )
               )
             ),
             
             h2("Total N Recommendation"),
             fluidRow(
               column(width = 12,
                      div(class = "input-card",
                          fluidRow(
                            column(6,
                                   uiOutput("vb_total_1"),
                                   div(class = "card-input-title", "Imperial (lb/ac)"),
                                   div(style = "background-color: white; color: black; border: 2px solid #ddd; border-radius: 8px; padding: 15px; text-align: center; font-weight: bold; font-size: 18px; box-shadow: 0 4px 12px rgba(0,0,0,0.15);",
                                       textOutput("total_n_imperial")
                                   )
                            ),
                            column(6,
                                   uiOutput("vb_total_2"),
                                   div(class = "card-input-title", "Metric (kg/ha"),
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
                            span(style = "font-weight: bold; color: var(--forest-green); font-size: 18px;",), 
                            "This recommendation considers your soil type, previous crop,yield goal and heat units. For more detailed information and adjustment factors, please consult the ",
                            a("OMAFRA Agronomy Guide", href = "#", style = "color: var(--spring-green); text-decoration: underline;"),
                            " or visit the Resources section."
                          )
                      )
               )
             ),
             
             # Box 2: Nitrogen Credits (2 inputs, 2 outputs)
             h2("Nitrogen Credits"),
             fluidRow(
               column(width = 12,
                      div(class = "input-card",
                          fluidRow(
                            # Left column - Input labels and input boxes
                            column(6,
                                   # Starter N row
                                   fluidRow(
                                     column(8,
                                            div(class = "card-input-title", "Enter Starter N (lb-N/ac)")
                                     ),
                                     column(4,
                                            numericInput("starter_n_imperial", NULL, value = 10, min = 0, step = 1,
                                                         width = "100%")
                                     )
                                   ),
                                   # Manure Credit row  
                                   fluidRow(
                                     column(8,
                                            div(class = "card-input-title", "Enter Manure Credit (lb-N/ac)")
                                     ),
                                     column(4,
                                            numericInput("manure_credit_imperial", NULL, value = 20, min = 0, step = 1,
                                                         width = "100%")
                                     )
                                   )
                            ),
                            
                            # Right column - Output boxes
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
             
             h2("Additional Nitrogen Application"),
             # Box 3: Preplant Additional N OR SideDress Additional N
             fluidRow(
               column(width = 12,
                      div(class = "input-card",
                          # Preplant Additional N outputs (green background)
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
                          
                          # SideDress Additional N outputs (green background)
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
             ),
            
             h2("Price Ratio Calculations"),
             fluidRow(
               column(width = 12,
                      div(class = "input-card",
                          # Conditional layout for Western Ontario (3 inputs evenly distributed)
                          conditionalPanel(
                            condition = "input.region == 'Western Ontario'",  
                            fluidRow(
                              column(4,
                                     div(class = "card-input-title", "Enter expected corn price"),
                                     numericInput("corn_price", NULL, value = 2.80, min = 0, step = 0.01)
                              ),
                              column(4,
                                     div(class = "card-input-title", "Select fertilizer product:"),
                                     selectInput("fertilizer_product", NULL,
                                                 choices = c("Urea", "Anhydrous Ammonia", "UAN Solution"),
                                                 selected = "Urea")
                              ),
                              column(4,
                                     div(class = "card-input-title", "Enter price per tonne of product:"),
                                     numericInput("fertilizer_price_tonne", NULL, value = 450, min = 0, step = 1)
                              )
                            )
                          ),
                          # Layout for Eastern Ontario (5 inputs)
                          conditionalPanel(
                            condition = "input.region == 'Eastern Ontario'",  # ✅ Fixed: changed from region_select to region
                            fluidRow(
                              column(2,
                                     div(class = "card-input-title", "Enter expected corn price"),
                                     numericInput("corn_price", NULL, value = 2.80, min = 0, step = 0.01)
                              ),
                              column(2,
                                     div(class = "card-input-title", "Enter drying charges ($/bu)"),
                                     numericInput("drying_charges", NULL, value = 0.35, min = 0, step = 0.01)
                              ),
                              column(3,
                                     div(class = "card-input-title", "Enter transportation and marketing ($/bu)"),
                                     numericInput("transport_marketing", NULL, value = 0.25, min = 0, step = 0.01)
                              ),
                              column(2,
                                     div(class = "card-input-title", "Select fertilizer product:"),
                                     selectInput("fertilizer_product", NULL,
                                                 choices = c("Urea", "Anhydrous Ammonia", "UAN Solution"),
                                                 selected = "Urea")
                              ),
                              column(3,
                                     div(class = "card-input-title", "Enter price per tonne of product:"),
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
             h2("Price Ratio Adjustment"),
             fluidRow(
               column(width = 12,
                      div(class = "input-card",
                          # First row - Price Ratio output
                          fluidRow(
                            column(12,
                                   div(class = "card-input-title", style = "font-weight: bold; font-size: 16px;", "Price Ratio ($N:$corn)"),
                                   div(style = "background-color: white; color: black; border: 2px solid #ddd; border-radius: 8px; padding: 15px; text-align: center; font-weight: bold; font-size: 18px; box-shadow: 0 4px 12px rgba(0,0,0,0.15); margin-bottom: 20px;",
                                       textOutput("price_ratio_output")
                                   )
                            )
                          ),
                          
                          # Second row - 2 adjustment outputs
                          fluidRow(
                            column(6,
                                   div(class = "card-input-title", style = "font-weight: bold; font-size: 16px;", "Imperial(lb/ac)"),
                                   div(style = "background-color: white; color: black; border: 2px solid #ddd; border-radius: 8px; padding: 15px; text-align: center; font-weight: bold; font-size: 18px; box-shadow: 0 4px 12px rgba(0,0,0,0.15); margin-bottom: 20px;",
                                       textOutput("adjustment_lb_ac_output")
                                   )
                            ),
                            column(6,
                                   div(class = "card-input-title", style = "font-weight: bold; font-size: 16px;", "Metric (kg/ha)"),
                                   div(style = "background-color: white; color: black; border: 2px solid #ddd; border-radius: 8px; padding: 15px; text-align: center; font-weight: bold; font-size: 18px; box-shadow: 0 4px 12px rgba(0,0,0,0.15); margin-bottom: 20px;",
                                       textOutput("adjustment_kg_ha_output")
                                   )
                            )
                          ))))
             
             )
           )
  )
