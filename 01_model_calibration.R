# -----------------------------------------------------------------------------#
# Project:  Modelling past and future impacts of droughts on tree mortality and carbon
#           storage in Norway spruce stands in Germany
#            
# Author:   Tim Anders
# Email:    tim.anders@senckenberg.de
# Date:     2024-04-30
# 
# Description: 
#           1. Model calibration
#           Calibration of the four statistical logistic regression models for
#           weather-related Norway spruce tree mortality
# -----------------------------------------------------------------------------#

#### 1. Load required package libraries ####
library(data.table)
library(plyr)
library(dplyr)
library(car)
library(caret)

# -----------------------------------------------------------------------------#

#### 2. Define directories #### 
rm(list = ls())
wd <- "/home/tanders/Mortalitymodel/final_model/Updated_version/"
setwd(wd)

# -----------------------------------------------------------------------------#

#### 3. Load data ####
all_training_data <- fread("./final_predictor_var_020224.txt")
head(all_training_data)

# -----------------------------------------------------------------------------#

#### 4. Process training & testing data ####

# Calculate annual number of dead trees in training data
death_rec_year_training_data <- all_training_data %>%
  group_by(year) %>%
  summarise(death_count = sum(dead))

# create ID variable
all_training_data$id <- 1:nrow(all_training_data)

# set seed for reproducability
set.seed(5)

# Use 75% of dataset as training set remaining 25% as testing set
train <- all_training_data %>% dplyr::sample_frac(0.75)
test <- dplyr::anti_join(all_training_data, train, by = "id")

# View dimensions of train
dim(train)
# View dimensions of test
dim(test)

# Save training and testing data
write.table(train, "./train_data.txt", quote = FALSE, sep = "\t", 
            row.names = FALSE, col.names = TRUE)
write.table(test, "./test_data.txt", quote = FALSE, sep = "\t", 
            row.names = FALSE, col.names = TRUE)

# -----------------------------------------------------------------------------#

#### 5. Model calibration ####

### 5.1 Model 1 calibration ####
model_1 <- glm(formula = dead ~ CWB_summer_dev_1yr 
               + CWB_summer_dev_2yr 
               + rsds_long_mean_1981_2010_summer 
               + temp_mean_long_mean_1981_2010_winter
               + rsds_spring_dev_1yr  
               + rsds_winter_dev_2yr 
               + prec_winter_dev_0yr  
               + temp_mean_autumn_dev_1yr 
               + rsds_summer_dev_1yr ,
               family = binomial(link = "logit"), 
               data = train)

# Save coefficients in variable 
coef_m1 <- setDT(as.data.frame(model_1$coefficients), keep.rownames = "predictor")[]

# Save model 1
saveRDS(model_1, "./spruce_tree_MA_1.rds")

# -----------------------------------------------------------------------------#

### 5.2 Model 2 calibration ###
model_2 <- glm(formula = dead ~ CWB_mean_3month_summer_rollmean_3yr_dev     
               + temp_mean_3month_mean_summer_rollmax_2yr_dev 
               + temp_mean_3month_mean_summer_rollmean_5yr_dev     
               + rsds_long_mean_1981_2010_summer  
               + temp_mean_long_mean_1981_2010_winter 
               ,family = binomial(link = "logit"), 
               data = train)

# Save coefficients in variable 
coef_m2 <- setDT(as.data.frame(model_2$coefficients), keep.rownames = "predictor")[]

# Save model 2
saveRDS(model_2, "./spruce_tree_MA_2.rds")

# -----------------------------------------------------------------------------#

### 5.3 Model 3a calibration ###
model_3a <- glm(formula = dead ~ 
                  CWB_summer_dev_1yr
                + temp_mean_3month_mean_summer_rollmax_2yr_dev 
                + CWB_summer_dev_2yr   
                + rsds_long_mean_1981_2010_summer 
                + temp_mean_long_mean_1981_2010_winter 
                + rsds_spring_dev_1yr
                + rsds_winter_dev_2yr 
                + prec_winter_dev_0yr 
                + temp_mean_autumn_dev_1yr
                + rsds_summer_dev_1yr
                ,family = binomial(link = "logit"), 
                data = train)

# Save coefficients in variable
coef_m3a <- setDT(as.data.frame(model_3a$coefficients), keep.rownames = "predictor")[]

# Save model 3a
saveRDS(model_3a, "./spruce_tree_MA_3a.rds")

# -----------------------------------------------------------------------------#

### 5.4 Model 3b calibration ###
model_3b <- glm(formula = dead ~ 
                  CWB_summer_dev_1yr
                + temp_mean_3month_mean_summer_rollmean_5yr_dev
                + CWB_summer_dev_2yr   
                + rsds_long_mean_1981_2010_summer 
                + temp_mean_long_mean_1981_2010_winter 
                + rsds_spring_dev_1yr
                + rsds_winter_dev_2yr 
                + prec_winter_dev_0yr 
                + temp_mean_autumn_dev_1yr
                + rsds_summer_dev_1yr
                ,family = binomial(link = "logit"), 
                data = train)

# Save coefficients in variable
coef_m3b <- setDT(as.data.frame(model_3b$coefficients), keep.rownames = "predictor")[]

# Save model 3b
saveRDS(model_3b, "./spruce_tree_MA_3b.rds")

# -----------------------------------------------------------------------------#

### 5.5 Summary of calibrated models ### 
summary(model_1)
summary(model_2)
summary(model_3a)
summary(model_3b)

# -----------------------------------------------------------------------------#

### 5.6 Check variation inflation factor of predictor variables of each model ###
vif_m1 <- setDT(as.data.frame(vif(model_1)), keep.rownames = "predictor")[]
vif_m2 <- setDT(as.data.frame(vif(model_2)), keep.rownames = "predictor")[]
vif_m3a <- setDT(as.data.frame(vif(model_3a)), keep.rownames = "predictor")[]
vif_m3b <- setDT(as.data.frame(vif(model_3b)), keep.rownames = "predictor")[]

# Combine in one table
vif_all_m <- join_all(list(vif_m1, vif_m2, vif_m3a, vif_m3b), by = "predictor", type = "full")

# Save VIF table as txt file
write.table(vif_all_m, file = "./vif_all_models.txt", sep = "\t", 
            quote = FALSE, row.names = FALSE, col.names = TRUE)

# -----------------------------------------------------------------------------#

#### 6. Save model coefficients as txt file ####
# Combine in one table
coef_all_m <- join_all(list(coef_m1, coef_m2, coef_m3a, coef_m3b), by = "predictor", type = "full")

# Save VIF table as txt file
write.table(format(coef_all_m, scientific = TRUE), file = "./coef_all_models.txt", sep = "\t", 
            quote = FALSE, row.names = FALSE, col.names = TRUE)

