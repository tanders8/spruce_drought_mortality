# -----------------------------------------------------------------------------#
# Project: Modelling past and future drought impacts on Norway spruce forests 
#          in Germany
#
# Author: Tim Anders
# Email:  tim.anders@senckenberg.de
# 
# Description: 2. Model evaluation
# Evaluation of the four statistical logistic regression models for weather-
# related Norway spruce tree mortality (McFadden's R2, AIC, AUC_ROC, AUC_PR, VIP)
# -----------------------------------------------------------------------------#

#### 1. Load required package libraries ####
library(data.table)
library(vip)
library(pscl)
library(PRROC)
library(stats)
library(caret)
library(scoring)
library(ggpubr)
# -----------------------------------------------------------------------------#

#### 2. Define directories #### 
rm(list = ls())
wd <- "/home/tanders/Mortalitymodel/final_model/Updated_version/"
setwd(wd)

# -----------------------------------------------------------------------------#

#### 3. Load spruce tree mortality models #### 
model_1 <- readRDS("./spruce_tree_MA_1.rds")
model_2 <- readRDS("./spruce_tree_MA_2.rds")
model_3a <- readRDS("./spruce_tree_MA_3a.rds")
model_3b <- readRDS("./spruce_tree_MA_3b.rds")
# -----------------------------------------------------------------------------#

#### 4. Load data ####
all_training_data <- fread("./final_predictor_var_020224.txt")
train <- fread("./train_data.txt")
test <- fread("./test_data.txt")

#### 5. Model predictions for test data ####
pred_model_1 <- stats::predict(model_1, newdata = test, type = "response")
test$pred_model_1 <- pred_model_1
pred_model_2 <- stats::predict(model_2, newdata = test, type = "response")
test$pred_model_2 <- pred_model_2
pred_model_3a <- stats::predict(model_3a, newdata = test, type = "response")
test$pred_model_3a <- pred_model_3a
pred_model_3b <- stats::predict(model_3b, newdata = test, type = "response")
test$pred_model_3b <- pred_model_3b

#### 6. Evaluation metrics ####
### 6.1 McFadden's R2
m1_R2 <- pscl::pR2(model_1)["McFadden"]
m2_R2 <- pscl::pR2(model_2)["McFadden"]
m3a_R2 <- pscl::pR2(model_3a)["McFadden"]
m3b_R2 <- pscl::pR2(model_3b)["McFadden"]

m_R2 <- c(m1_R2, m2_R2, m3a_R2, m3b_R2)

### 6.2 Akaike Information Criterion (AIC)
m_AIC <- c(model_1$aic, model_2$aic, model_3a$aic, model_3b$aic)

### 6.3 Area under the receiver operating curve (AUC_ROC)
auc_roc_model_1 <- PRROC::roc.curve(scores.class0 = test$pred_model_1, weights.class0=test$dead,
                                       curve=TRUE)
auc_roc_model_2 <- PRROC::roc.curve(scores.class0 = test$pred_model_2, weights.class0=test$dead,
                                      curve=TRUE)
auc_roc_model_3a <- PRROC::roc.curve(scores.class0 = test$pred_model_3a, weights.class0=test$dead,
                                       curve=TRUE)
auc_roc_model_3b <- PRROC::roc.curve(scores.class0 = test$pred_model_3b, weights.class0=test$dead,
                                       curve=TRUE)
m3b_auc_roc <- auc_roc_model_3b$auc

m_auc_roc <- c(auc_roc_model_1$auc, auc_roc_model_2$auc, auc_roc_model_3a$auc, auc_roc_model_3b$auc)

### 6.4 Area under the precision recall curve (AUC_PR)
auc_pr_model_1 <- PRROC::pr.curve(scores.class0 = test$pred_model_1, weights.class0=test$dead,
                                     curve=TRUE)
auc_pr_model_2 <- PRROC::pr.curve(scores.class0 = test$pred_model_2, weights.class0=test$dead,
                                    curve=TRUE)
auc_pr_model_3a <- PRROC::pr.curve(scores.class0 = test$pred_model_3a, weights.class0=test$dead,
                                     curve=TRUE)
auc_pr_model_3b <- PRROC::pr.curve(scores.class0 = test$pred_model_3b, weights.class0=test$dead,
                                     curve=TRUE)

m_auc_pr <- c(auc_pr_model_1$auc.integral, auc_pr_model_2$auc.integral, auc_pr_model_3a$auc.integral, 
              auc_pr_model_3b$auc.integral)

### 6.5 Brier score
m1_brier_score <- brierscore(dead ~ pred_model_1, data = test)
m1_brier_score <- mean(m1_brier_score) # 0.01181564
m2_brier_score <- brierscore(dead ~ pred_model_2, data = test)
m2_brier_score <- mean(m2_brier_score) # 0.01215363
m3a_brier_score <- brierscore(dead ~ pred_model_3a, data = test)
m3a_brier_score <- mean(m3a_brier_score) # 0.01174511
m3b_brier_score <- brierscore(dead ~ pred_model_3b, data = test)
m3b_brier_score <- mean(m3b_brier_score) # 0.01181564

m_brier_score <- c(m1_brier_score, m2_brier_score, m3a_brier_score, m3b_brier_score)

# Create one table & save
model <- c("model_1", "model_2", "model_3a", "model_3b")
eval_metric_df <- data.frame(model, m_R2, m_AIC, m_auc_roc, m_auc_pr, m_brier_score)
write.table(eval_metric_df, "./eval_metrics.txt", quote = FALSE, sep = "\t", 
            col.names = TRUE, row.names = FALSE)

# -----------------------------------------------------------------------------#

#### 7. Variable importance plots ####

# 7.1 Calculate variable importance score and plot it
# Permutation approach to calculate variable importance using the baseline 
# performance R2 and the permutated performance R2

# Prediction wrapper
pfun_ppr <- function(object, newdata) {  # needs to return a numeric vector
  stats::predict(object, newdata = newdata)
}


# Boxplot of multiple runs
train_m1 <- train[,7:16]
vi_m1 <- vi(model_1, method = "permute", train = train_m1, target = "dead", 
              metric = "rsq", pred_wrapper = pfun_ppr, nsim = 30) 

vip_m1_boxplot <- vip(vi_m1, geom="boxplot") + ggtitle("Variable importance model 1") + theme_bw()

vi_m2 <- vi(model_2, method = "permute", train = train_m2, target = "dead", 
            metric = "rsq", pred_wrapper = pfun_ppr, nsim = 30) 

vip_m2_boxplot <- vip(vi_m2, geom="boxplot") + ggtitle("Variable importance model 2") + theme_bw()

vi_m3a <- vi(model_3a, method = "permute", train = train_m3a, target = "dead", 
            metric = "rsq", pred_wrapper = pfun_ppr, nsim = 30) 

vip_m3a_boxplot <- vip(vi_m3a, geom="boxplot") + ggtitle("Variable importance model 3a") + theme_bw()

vi_m3b <- vi(model_3b, method = "permute", train = train_m3b, target = "dead", 
            metric = "rsq", pred_wrapper = pfun_ppr, nsim = 30) 

vip_m3b_boxplot <- vip(vi_m3b, geom="boxplot") + ggtitle("Variable importance model 3b") + theme_bw()

vip_boxplot_all <- ggarrange(vip_m1_boxplot, vip_m2_boxplot, vip_m3a_boxplot, vip_m3b_boxplot,
                     nrow = 2, ncol = 2)

vip_boxplot_all
ggsave("vip_all_boxplot_nsim30.png", plot = vip_boxplot_all, width = 16, height = 8)

# -----------------------------------------------------------------------------#

#### 8. Calibration plots ####

# Model 1
test_m1 <- test[,c(1:2, 6:7, 22)]
test_m1 <- test_m1 %>%
  dplyr::group_by(year) %>%
  dplyr::summarise(amean_obs = mean(dead),
            amean_pred = mean(pred_model_1))
test_m1$model <- "model 1"
r_m1 <- cor.test(test_m1$amean_obs, test_m1$amean_pred, method = "pearson")
r2_m1 <- r_m1$estimate^2

# Model 2
test_m2 <- test[,c(1:2, 6:7, 23)]
test_m2 <- test_m2 %>%
  dplyr::group_by(year) %>%
  dplyr::summarise(amean_obs = mean(dead),
                   amean_pred = mean(pred_model_2))
test_m2$model <- "model 2"

r_m2 <- cor.test(test_m2$amean_obs, test_m2$amean_pred, method = "pearson")
r2_m2 <- r_m2$estimate^2

# Model 3a
test_m3a <- test[,c(1:2, 6:7, 24)]
test_m3a <- test_m3a %>%
  dplyr::group_by(year) %>%
  dplyr::summarise(amean_obs = mean(dead),
                   amean_pred = mean(pred_model_3a))
test_m3a$model <- "model 3a"
r_m3a <- cor.test(test_m3a$amean_obs, test_m3a$amean_pred, method = "pearson")
r2_m3a <- r_m3a$estimate^2

# Model 3b
test_m3b <- test[,c(1:2, 6:7, 25)]
test_m3b <- test_m3b %>%
  dplyr::group_by(year) %>%
  dplyr::summarise(amean_obs = mean(dead),
                   amean_pred = mean(pred_model_3b))
test_m3b$model <- "model 3b"
r_m3b <- cor.test(test_m3b$amean_obs, test_m3b$amean_pred, method = "pearson")
r2_m3b <- r_m3b$estimate^2

# Combine the data in one data frame
test_m <- rbind(test_m1, test_m2, test_m3a, test_m3b)

# Create the calibration plot of the testing data
cal_plot_test <- ggplot(test_m, aes(x=amean_obs*100, y=amean_pred*100, color = model)) +
  geom_point() +
  ylim(0,15) +
  xlim(0,15) +
  xlab("Mean annual observed drought-related mortality (GFC) [%]") +
  ylab("Mean annual predicted drought-related mortality [%]") +
  geom_smooth(method = "lm", fullrange = TRUE) +
  geom_abline (slope=1, linetype = "dashed", color="Red") +
  scale_color_manual(values =  c("#D55E00", "#009E73", "#56B4E9", "#CC79A7")) +
  annotate(geom = "text", x = 1, y = 13, label = paste0('R^2 == ', round(r2_m1, 4)), parse = TRUE, colour ="#D55E00") +
  annotate(geom = "text", x = 1, y = 12, label =paste0('R^2 == ', round(r2_m2, 4)), parse = TRUE, colour ="#009E73") +
  annotate(geom = "text", x = 1, y = 11, label =paste0('R^2 == ', round(r2_m3a, 4)), parse = TRUE, colour ="#56B4E9") +
  annotate(geom = "text", x = 1, y = 10, label =paste0('R^2 == ', round(r2_m3b, 4)), parse = TRUE, colour ="#CC79A7") +
  ggtitle("Calibration plot testing data") +
  theme_bw()
cal_plot_test


# Predictions based on training data
pred_model_1 <- stats::predict(model_1, newdata = train, type = "response")
train$pred_model_1 <- pred_model_1
pred_model_2 <- stats::predict(model_2, newdata = train, type = "response")
train$pred_model_2 <- pred_model_2
pred_model_3a <- stats::predict(model_3a, newdata = train, type = "response")
train$pred_model_3a <- pred_model_3a
pred_model_3b <- stats::predict(model_3b, newdata = train, type = "response")
train$pred_model_3b <- pred_model_3b


train_m1 <- train[,c(1:2, 6:7, 22)]
train_m1 <- train_m1 %>%
  dplyr::group_by(year) %>%
  dplyr::summarise(amean_obs = mean(dead),
                   amean_pred = mean(pred_model_1))
train_m1$model <- "model 1"
r_m1 <- cor.test(train_m1$amean_obs, train_m1$amean_pred, method = "pearson")
r2_m1 <- r_m1$estimate^2

# Model 2
train_m2 <- train[,c(1:2, 6:7, 23)]
train_m2 <- train_m2 %>%
  dplyr::group_by(year) %>%
  dplyr::summarise(amean_obs = mean(dead),
                   amean_pred = mean(pred_model_2))
train_m2$model <- "model 2"

r_m2 <- cor.test(train_m2$amean_obs, train_m2$amean_pred, method = "pearson")
r2_m2 <- r_m2$estimate^2

# Model 3a
train_m3a <- train[,c(1:2, 6:7, 24)]
train_m3a <- train_m3a %>%
  dplyr::group_by(year) %>%
  dplyr::summarise(amean_obs = mean(dead),
                   amean_pred = mean(pred_model_3a))
train_m3a$model <- "model 3a"
r_m3a <- cor.test(train_m3a$amean_obs, train_m3a$amean_pred, method = "pearson")
r2_m3a <- r_m3a$estimate^2

# Model 3b
train_m3b <- train[,c(1:2, 6:7, 25)]
train_m3b <- train_m3b %>%
  dplyr::group_by(year) %>%
  dplyr::summarise(amean_obs = mean(dead),
                   amean_pred = mean(pred_model_3b))
train_m3b$model <- "model 3b"
r_m3b <- cor.test(train_m3b$amean_obs, train_m3b$amean_pred, method = "pearson")
r2_m3b <- r_m3b$estimate^2

# Combine the models in one data frame
train_m <- rbind(train_m1, train_m2, train_m3a, train_m3b)

# Create the calibration plot of the training data
cal_plot_train <- ggplot(train_m, aes(x=amean_obs*100, y=amean_pred*100, color = model)) +
  geom_point() +
  ylim(0,15) +
  xlim(0,15) +
  xlab("Mean annual observed drought-related mortality (GFC) [%]") +
  ylab("Mean annual predicted drought-related mortality [%]") +
  geom_smooth(method = "lm", fullrange = TRUE) +
  geom_abline (slope=1, linetype = "dashed", color="Red") +
  scale_color_manual(values =  c("#D55E00", "#009E73", "#56B4E9", "#CC79A7")) +
  annotate(geom = "text", x = 1, y = 13, label = paste0('R^2 == ', round(r2_m1, 4)), parse = TRUE, colour ="#D55E00") +
  annotate(geom = "text", x = 1, y = 12, label =paste0('R^2 == ', round(r2_m2, 4)), parse = TRUE, colour ="#009E73") +
  annotate(geom = "text", x = 1, y = 11, label =paste0('R^2 == ', round(r2_m3a, 4)), parse = TRUE, colour ="#56B4E9") +
  annotate(geom = "text", x = 1, y = 10, label =paste0('R^2 == ', round(r2_m3b, 4)), parse = TRUE, colour ="#CC79A7") +
  ggtitle("Calibration plot training data") +
  theme_bw()
cal_plot_train

cal_plot_train_test <- ggarrange(cal_plot_train, cal_plot_test,
                                 labels = c("A", "B"),
                                 ncol = 2, nrow = 1, common.legend = T,
                                 legend = "bottom")
ggsave("cal_plot_train_test_1104.jpeg", plot = cal_plot_train_test, width = 12, height = 6, dpi = 300, units = "in")

