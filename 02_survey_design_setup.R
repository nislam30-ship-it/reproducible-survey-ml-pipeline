library(survey)

setup_survey_design <- function(data_path = "preprocessed_survey_data.rds") {
  df <- readRDS(data_path)
  
  # Set up complex survey design
  survey_design <- svydesign(
    ids = ~psu,
    strata = ~strata,
    weights = ~weights,
    nest = TRUE,
    data = df
  )
  
  return(survey_design)
}

if (sys.nframe() == 0) {
  design_obj <- setup_survey_design()
  print(svymean(~api00, design = design_obj))
}
