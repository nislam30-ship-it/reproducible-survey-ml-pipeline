library(survey)
library(dplyr)

preprocess_survey_data <- function() {
  data(api, package = "survey")
  df <- apistrat %>%
    rename(psu = dnm, strata = stype, weights = pw) %>%
    group_by(strata) %>%
    mutate(
      emer = ifelse(is.na(emer), median(emer, na.rm = TRUE), emer),
      pctcomp = ifelse(is.na(pctcomp), median(pctcomp, na.rm = TRUE), pctcomp)
    ) %>%
    ungroup() %>%
    mutate(
      high_performer = ifelse(api00 >= 700, 1, 0),
      meals_scaled = as.numeric(scale(meals))
    )
  
  saveRDS(df, file = "preprocessed_survey_data.rds")
  message("Data preprocessed and saved.")
  return(df)
}

if (sys.nframe() == 0) {
  preprocess_survey_data()
}
