### Modelling Past and Future Impacts of Droughts on Tree Mortality and Carbon Storage in Norway Spruce Stands in Germany

## Abstract

Between 2018 and 2020, Central Europe experienced severe droughts, leading to an unprecedented increase in Norway spruce (Picea abies) tree mortality, which has not been reproduced in process-based forest or dynamic vegetation models (DVMs). In this study, we developed logistic regression models for drought-related Norway spruce mortality using climate and weather anomalies and mortality data from the forest monitoring plot network of the German crown condition survey. We integrated these models into the DVM LPJ-GUESS.

Under historical conditions (1998-2020), our models reproduce observed temporal and spatial mortality patterns. Future simulations (2021-2070) under the RCP2.6 and RCP8.5 climate scenarios show periodic increases in Norway spruce mortality. Even though the drought-mortality models reproduce past dynamics similarly well, they do not agree on the timing and magnitude of future drought-related mortality events. Including drought mortality in the DVM reveals substantial reductions in aboveground biomass in 2070 (e.g., -18% in RCP2.6 and -36% in RCP8.5, mean across all simulations) compared to baseline simulations without drought mortality. According to the model, drought-related reductions of potential harvest across Germany could accumulate to 310 million Mg of C (RCP2.6) and 447 million Mg of C (RCP8.5) in the period from 2021 to 2070. Our study underscores the severe risk of large-scale future Norway spruce forest diebacks in Germany. Predictions of the magnitude and timing of such dieback events are, however, still highly uncertain. Nevertheless, such events should be considered in predictive modelling studies because they can have fundamental effects on forest carbon cycling and harvest.

## Overview

This repository contains the code for reproducing the analyses and simulations presented in the publication. Below is an overview of the repository structure and contents:


# Files and Directories

01_model_calibration.R

R script for calibrating statistical logistic regression models predicting weather-related Norway spruce mortality.

02_model_evaluation.R

R script for evaluating the performance of the logistic regression models, including spatial and temporal validation.

lpj-guess_european_applications_tree_species_code_drought_mortality.zip

A ZIP file containing the LPJ-GUESS source code with the implemented empirical-based drought mortality algorithms.


# Instructions

Model Calibration and Evaluation:

Open 01_model_calibration.R and follow the instructions to calibrate the logistic regression models using the provided dataset.

Use 02_model_evaluation.R to evaluate the model performance and reproduce the results in the manuscript.

LPJ-GUESS Integration:

Extract the contents of lpj-guess_european_applications_tree_species_code_drought_mortality.zip.

Follow the documentation within the extracted folder to compile and run LPJ-GUESS with the implemented drought mortality algorithms.


# Publication

This repository accompanies the following publication:Modelling past and future impacts of droughts on tree mortality and carbon storage in Norway spruce stands in GermanyLink: https://doi.org/10.1016/j.ecolmodel.2024.110987

# Citation

If you use this repository, please cite the publication as follows:

Anders T., Hetzer J., Knapp N., Forrest M., Langan L., Tölle M.H., Wellbrock N., Hickler, H.. Modelling past and future impacts of droughts on tree mortality and carbon storage in Norway spruce stands in Germany. Ecological Modelling. 2024, https://doi.org/10.1016/j.ecolmodel.2024.110987.




