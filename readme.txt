# Modelling past and future drought impacts on Norway spruce forests in Germany

## Abstract

Between 2018 and 2020, Central Europe experienced severe droughts. Leading to unprecedented increase in Norway spruce (Picea abies) tree mortality, which has not been reproduced in process-based forest or dynamic vegetation models (DVMs). In this study, we developed logistic regression models for drought-related Norway spruce mortality using climate and weather anomalies and mortality data from the forest monitoring plot network of the German crown condition survey. We integrated these models into the DVM LPJ-GUESS. 
Under historical conditions (1998-2020), our models reproduce observed temporal and spatial mortality patterns. Future simulations (2021-2070) under the RCP2.6 and RCP8.5 climate scenarios show periodic increases in Norway spruce mortality. Even though the drought-mortality models reproduce past dynamics similarly well, they do not agree on the timing and magnitude of future drought-related mortality events. Including drought mortality in the DVM reveals substantial reductions in aboveground biomass in 2070 (e.g. -18% in RCP2.6 and -36% in RCP8.5 (mean across all simulations)), compared to baseline simulations without drought mortality. According to the model, drought-related reductions of potential harvest across Germany could accumulate to 310 million Mg of C (RCP2.6) and 447 million Mg of C (RCP 8.5) in the period from 2021 to 2070. Our study underscores the severe risk of large-scale future Norway spruce forest diebacks in Germany. Predictions of the magnitude and timing of such dieback events are, however, still highly uncertain. Nevertheless, such events should be considered in predictive modelling studies because they can have fundamental effects on forest carbon cycling and harvest.

## Overview
# 01_model_calibration.R & 02_model_evaluation.R
This code was used to calibrate and evaluate the differnt statistic logistic regression models for predicting weather-related Norway spruce mortality.

# lpj-guess_european_applications_tree_species_code_drought_mortality.zip
Consists the LPJ-GUESS source code with the implemented empirical-based drought mortality algorithms. 
