# reproducible-survey-ml-pipeline

A modular portfolio demonstration of data processing, complex survey design specification, and statistical modeling in R.

## Overview
Complex survey designs require specialized handling for weights, strata, and clusters. This pipeline demonstrates:
- Missing data imputation and feature transformation.
- Survey design specification (`svydesign`).
- Design-weighted generalized linear modeling (`svyglm`).

## Dataset
Uses the California Academic Performance Index (`apistrat`) dataset from R's `survey` package.

## Files
- `01_data_preprocessing.R`: Preprocessing and imputation.
- `02_survey_design_setup.R`: `svydesign` configuration.
- `03_modeling_pipeline.R`: Weighted GLM modeling functions.
