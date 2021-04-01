/// RESPOND

log using "210401_RESPOND Analysis.txt", text replace

/* Run the do file from REDCap */
do "RESPOND_STATA_2021-02-22_0636.do"

/* Run the data transformation file */
do "RESPOND Data Transformation.do"

/* Run the ED to PICU analysis file */
preserve
do "RESPOND ED to PICU Data Analysis.do"
restore

/* Run the ED analysis file */
preserve
do "RESPOND ED Data Analysis.do"
restore

/* Run the PICU analysis file */
use "RESPOND.dta", clear
preserve
do "RESPOND PICU Data Analysis.do"
restore

log close
