library(survey)
library(broom)

fit_weighted_linear <- function(design_obj, formula) {
  svyglm(formula, design = design_obj, family = gaussian())
}

fit_weighted_logistic <- function(design_obj, formula) {
  svyglm(formula, design = design_obj, family = quasibinomial())
}

run_modeling_pipeline <- function() {
  source("02_survey_design_setup.R")
  design_obj <- setup_survey_design()
  
  # Weighted Linear Model
  lm_fit <- fit_weighted_linear(design_obj, api00 ~ meals + ell + emer)
  print(tidy(lm_fit, conf.int = TRUE))
  
  # Weighted Logistic Model
  logistic_fit <- fit_weighted_logistic(design_obj, high_performer ~ meals + ell + emer)
  print(tidy(logistic_fit, conf.int = TRUE))
}

if (sys.nframe() == 0) {
  run_modeling_pipeline()
}
