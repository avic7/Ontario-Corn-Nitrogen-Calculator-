# Ontario Corn Nitrogen Calculator 

Farmers across Ontario rely on the Ontario Corn Nitrogen Calculator (OCNC) for fertilizer decisions. However, the existing tool lacked interactivity, modern visualization, and the ability to leverage six decades of agronomic trials. This project aimed to: 

- Modernize the OCNC
- Visualize over 7,600 data points across 667 site-years
- Enable smarter, region-specific, and yield-specific N recommendations
- Create a new dashboard to visualize the historical data. 


## Overview

This project modernizes how nitrogen (N) recommendations are generated for corn farmers in Ontario. For decades, growers relied on the Ontario Corn Nitrogen Calculator (OCNC), a static tool that offered limited flexibility. My goal was to redesign the calculator into a data-driven, interactive RShiny application and complement it with a historical nitrogen database dashboard that visualizes over 60 years of agronomic trial data.

## Problem Statement

Farmers face rising input costs and variable yields. The traditional OCNC provided generalized recommendations but:

- Lacked interactivity and flexibility.
- Did not leverage historical trial data fully.
- Failed to incorporate metadata (e.g., soil type, previous crops, tillage practices).

This created uncertainty in fertilizer planning and limited the ability to tailor nitrogen strategies.

## Objectives

- Integrate and modernize agronomic trial data (1962–2024, 7,600+ data points).
- Identify limitations and gaps in existing recommendations.
- Redesign the OCNC into a modern, modularized RShiny app.
- Build a historical nitrogen database dashboard for visualization and exploration.
- Enable farmers and agronomists to make data-driven fertilizer decisions.


## Data Insights

### Database scope:

- 1962–2024, 7,608 data points, ~667 site-years.
- 951 nitrogen response curves across multiple yield levels.



### Key findings:

- Higher yield potential (≥200 bu/ac) dominates trials since 2010.
- Metadata gaps remain: tillage, planting dates, soil tests often missing.
- Many trials discarded due to incomplete experimental designs.

## Impact

- Smarter Recommendations: Farmers receive more tailored nitrogen rate suggestions based on yield potential, region, and historical evidence.
- Interactive Decision-Making: Users can run “what-if” scenarios (e.g., changing fertilizer prices or soil conditions).
- Transparency & Accessibility: Farmers can visualize six decades of agronomic trials and even export data for their own analysis.



## OCNC Calculator

#### Before <br/> 

<img width="469" height="456" alt="image" src="https://github.com/user-attachments/assets/67f1ff2c-de92-4a14-9bb1-d0919c04a307" />




#### After <br/>

<img width="635" height="343" alt="image" src="https://github.com/user-attachments/assets/18fd6232-c268-4b10-b127-807915279938" />



## Historical Ontario Corn Nitrogen Database Dashboard ( Under Development ) 


<img width="854" height="414" alt="image" src="https://github.com/user-attachments/assets/83cae6f0-e32c-4b9d-b830-12984514d6fb" /> <br/> 


<img width="894" height="437" alt="image" src="https://github.com/user-attachments/assets/4c09206c-0b92-467b-bff6-a88b688a7b13" />


The code repository for this dashboard is not yet public since its not yet published. It will be pulished soon . Thank you for your patience 😊


### Future Directions

- Finalize dashboard components and integrate economic outcomes (profitability of nitrogen strategies).
- Enable secure CSV export for farmers and advisors.
- Add a login system for personalized data tracking.
- Conduct extensive user testing with OMAFRA and Ontario farmers for feedback and refinement.



## Acknowledgments

- Dr. Adrian Correndo – Project Supervisor
- Dr. John Sulik – Secondary Supervisor
- OMAFA – Data Support
- University of Guelph, Dept. of Math & Stats
- Ben Rosser (OMAFA)


