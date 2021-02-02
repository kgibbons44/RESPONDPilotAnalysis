The RESPOND ED and PICU Pilot study datasets are contained within a single REDCap database containing records on all screened patients (data fields include date of screening, inclusion criteria, exclusion criteria, eligibility status, informed consent process, withdrawal of consent), and all consented patients (randomisation details, demographics, clinical history, baseline assessment, treatments and management, outcomes, biobanking, 6-month follow up, adverse events and portocol deviations). The database also contains additional forms to undertake and record details of data monitoring processes.

The RESPOND Pilot study dataset will be exported from REDCap using the in-built functionality into Stata format; a Stata compatible dataset in comma-separated value (CSV) format (.csv) and Stata do-file (.do) is generated. The do-file is used to undertake preliminary data transformations; this file imports the data from the CSV file, labels the variables and assigns value labels to categorical variables. This do-file is not provided in this repository as it was not constructed by the author.

The study dataset contains one row per screened patient per repeating event. This is not the optimal format for analysis, and as such, significant data transformation occurs prior to analysis to result in a dataset that contains one row per patient.

The code is broken into the four sections:

Part A: Transformation of primary study dataset and calculation of outcomes (“RESPOND Data Transformation.do”).  This file also calls "Daily organ dysfunction PELOD and PSOFA.do", "ED baseline PELOD and PSOFA.do" and "PICU baseline PELOD and PSOFA.do" to calculate PELOD and pSOFA scores.

Part B: Analysis of patients who were enrolled in both ED and PICU studies ("RESPOND ED to PICU Data Analysis.do")

Part C: Analysis of patients enrolled in the ED study ("RESPOND ED Data Analysis.do")

Part D: Analysis of patients enrolled in the PICU study ("RESPOND PICU Data Analysis.do")

We have chosen to include all code, including code for assessing completeness, distribution and range, as well as the code to undertake the analyses.

The do files should be executed in the order contained in "RESPOND Analysis.do".
