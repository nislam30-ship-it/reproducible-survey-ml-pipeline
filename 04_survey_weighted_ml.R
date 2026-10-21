# 04_survey_weighted_ml.R
# Advanced Survey-Weighted Machine Learning, Survival Modeling, and Design Effects

library(survey)
library(ranger)
library(survival)
library(dplyr)
library(broom)

run_advanced_survey_pipeline <- function() {
  # Load sample survey dataset (apistrat)
  data(api, package = "survey")
  df <- apistrat %>%
    rename(psu = dnm, strata = stype, weights = pw) %>%
    mutate(
      high_performer = as.factor(ifelse(api00 >= 700, 1, 0)),
      time_to_event = api00 / 10, # Mock follow-up time
      event_status  = ifelse(ell > 20, 1, 0)
    )
  
  # Complex Survey Design
  survey_design <- svydesign(
    ids = ~psu,
    strata = ~strata,
    weights = ~weights,
    nest = TRUE,
    data = df
  )
  
 
  # weighted mean and Design Effect (Deff)
  mean_estimates <- svymean(~api00, design = survey_design, deff = TRUE)
  deff_val <- deff(mean_estimates)
  print(mean_estimates)
  cat(sprintf("Design Effect (Deff): %.3f (Variance is %.1fx SRS variance)\n\n", 
              deff_val, deff_val))
  
  # Passing design sampling weights into Random Forest split criterion
  rf_weighted <- ranger(
    formula = high_performer ~ meals + ell + emer + avg.ed,
    data = df,
    case.weights = df$weights,   # Survey weight integration
    num.trees = 500,
    importance = "permutation",
    seed = 42
  )
  
  cat("Weighted Random Forest OOB Error Rate:", rf_weighted$prediction.error, "\n")
  cat("Top Feature Importances (Design-Weighted):\n")
  print(sort(rf_weighted$variable.importance, decreasing = TRUE))
  cat("\n")
  
  
  # complex survey-adjusted Cox model
  cox_fit <- svycoxph(
    Surv(time_to_event, event_status) ~ meals + emer + strata,
    design = survey_design
  )
  
  cox_summary <- tidy(cox_fit, exponentiate = TRUE, conf.int = TRUE)
  print(cox_summary)
  
  return(list(
    deff = deff_val,
    rf_model = rf_weighted,
    cox_model = cox_fit
  ))
}

if (sys.nframe() == 0) {
  results <- run_advanced_survey_pipeline()
}
