### Modelling Past and Future Impacts of Droughts on Tree Mortality and Carbon Storage in Norway Spruce Stands in Germany

## Summary
Central Europe faced severe droughts between 2018 and 2020, causing unprecedented Norway spruce mortality, which existing dynamic vegetation models (DVMs) failed to reproduce. To address this, logistic regression models were developed using climate anomalies and mortality data from German forest monitoring plots and integrated into the DVM LPJ-GUESS. These models accurately captured historical mortality patterns (1998-2020) but showed variability in predicting future events (2021-2070) under RCP2.6 and RCP8.5 scenarios. Simulations indicated significant biomass and carbon storage losses, highlighting the urgent need to consider drought-induced mortality in predictive studies, despite uncertainties in event timing and magnitude.

## Overview
This repository contains the code for reproducing the analyses and simulations presented in the publication. Below is an overview of the repository structure and contents:

### Files and Directories

- **`01_model_calibration.R`**  
  R script for calibrating statistical logistic regression models predicting weather-related Norway spruce mortality.

- **`02_model_evaluation.R`**  
  R script for evaluating the performance of the logistic regression models, including spatial and temporal validation.

- **`lpj-guess_european_applications_tree_species_code_drought_mortality.zip`**  
  A ZIP file containing the LPJ-GUESS source code with the implemented empirical-based drought mortality algorithms.

### Instructions

#### Model Calibration and Evaluation:
- Open `01_model_calibration.R` and follow the instructions to calibrate the logistic regression models using the provided dataset.
- Use `02_model_evaluation.R` to evaluate the model performance and reproduce the results in the manuscript.

#### LPJ-GUESS Integration:
- Extract the contents of `lpj-guess_european_applications_tree_species_code_drought_mortality.zip`.
- Follow the documentation within the extracted folder to compile and run LPJ-GUESS with the implemented drought mortality algorithms.

## Publication
This repository accompanies the following publication:  
**Modelling past and future impacts of droughts on tree mortality and carbon storage in Norway spruce stands in Germany**  
Link: [https://doi.org/10.1016/j.ecolmodel.2024.110987](https://doi.org/10.1016/j.ecolmodel.2024.110987)

## Citation
If you use this repository, please cite the publication as follows:

> Anders T., Hetzer J., Knapp N., Forrest M., Langan L., Tölle M.H., Wellbrock N., Hickler, H. Modelling past and future impacts of droughts on tree mortality and carbon storage in Norway spruce stands in Germany. *Ecological Modelling*, 2024, [https://doi.org/10.1016/j.ecolmodel.2024.110987](https://doi.org/10.1016/j.ecolmodel.2024.110987).
