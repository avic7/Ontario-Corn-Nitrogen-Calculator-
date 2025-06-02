# Ontario Corn Nitrogen Calculator Modernization and Dashboard 

## Overview
This project modernizes the existing Ontario Corn Nitrogen Calculator Tool by building an **interactive R Shiny app and also a dashboard**. It provides Ontario farmers, advisors, and researchers with user-friendly access to a **historical database of nitrogen fertilization trials** in corn, helping drive **data-informed decisions** on nitrogen application.

The dashboard visualizes nitrogen response trends and calculates the **Most Economical Rate of Nitrogen (MERN)** based on updated non-linear regression models and research data.


## Features
- **Farmer-Focused**: Easy-to-use UI with input options for:
  - Soil type
  - Previous crop
  - Corn price
  - Fertilizer cost
  - Target yield
- **Data Visualizations**: Interactive graphs using `ggplot2` and `plotly`.
- **Modeling**: Non-linear regression (`nls()`) to estimate MERN using quadratic-plateau models.
- **Dual Units**: Output available in both **Metric** and **Imperial** units.
- **Historical Dataset**: Leverages decades of Ontario agronomic research data with spatial (location) and temporal (year) dimensions.
- **Version Control**: Project managed and updated via GitHub.


## Tech Stack
- **R**, **RStudio**
- **R Shiny** (UI + Server Logic)
- **dplyr**, **tidyr**,(Data Wrangling)
- **ggplot2**, **plotly** (Visualizations)
- **nls()** (Non-linear Regression Modeling)
- **GitHub** (Version Control)


## Data Science Techniques
- Merging and harmonizing agronomic research datasets.
- Aggregating data at regional, county, and year levels.
- Refining non-linear regression models to calculate MERN.
- Building interactive visualizations to communicate insights effectively.


## Installation

```bash
# Clone the repository
git clone https://github.com/yourusername/ontario-corn-nitrogen-calculator.git
cd ontario-corn-nitrogen-calculator

# Open the project in RStudio
# Install necessary R packages
install.packages(c("shiny", "dplyr", "tidyr", "purrr", "ggplot2", "plotly"))
```


## Acknowledgments
- Ontario Ministry of Agriculture, Food and Rural Affairs (OMAFA) research data
- University of Guelph 
