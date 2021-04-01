/**** PELOD-2 Syntax ****/

/** Daily organ dysfunction**/

// Set values of 4444, 5555, 9999 to missing for relevant variables 
mvdecode dod_gcs* dod_pupil_fix* dod_lactate* dod_mbp* dod_creatinine* dod_pao2* dod_bga_fio2* dod_paco2* dod_wcc* dod_platelets*, mv(9999=.\ 4444=.\ 5555=.)

/* Assignment of points for each component of PELOD-2*/
forvalues i=1/28 {

// Generate the daily age
gen dod_age_days_`i'=dod_dt`i'- dem_dob

// Generate points for glasgow coma scale - Assign a value of 0 where no value
gen dod_gcs_pl_pts_`i'=0
replace dod_gcs_pl_pts_`i'=1 if dod_gcs`i'>=5 & dod_gcs`i'<11 & dod_gcs`i'~=.
replace dod_gcs_pl_pts_`i'=4 if dod_gcs`i'>=3 & dod_gcs`i'<5 & dod_gcs`i'~=.

// Generate points for pupils - Assign a value of 0 where no value
gen dod_pupil_pl_pts_`i'=0
replace dod_pupil_pl_pts_`i'=5 if dod_pupil_fix`i'==1

// Generate points for lactate - Assign a value of 0 where no value
gen dod_lactate_pl_pts_`i'=0
replace dod_lactate_pl_pts_`i'=1 if dod_lactate`i'>=5 & dod_lactate`i'<11 & dod_lactate`i'~=.
replace dod_lactate_pl_pts_`i'=4 if dod_lactate`i'>=11 & dod_lactate`i'~=.

// Generate points for mean arterial pressure - Assign a value of 0 where no value
gen dod_map_pl_pts_`i'=0
replace dod_map_pl_pts_`i'=2 if dod_mbp`i'>=31 & dod_mbp`i'<46 & dod_mbp`i'~=. & dod_age_days_`i'/(365.25/12)<1 & dod_age_days_`i'~=.
replace dod_map_pl_pts_`i'=2 if dod_mbp`i'>=39 & dod_mbp`i'<55 & dod_mbp`i'~=. & dod_age_days_`i'/(365.25/12)>=1 & dod_age_days_`i'/(365.25/12)<12 & dod_age_days_`i'~=.
replace dod_map_pl_pts_`i'=2 if dod_mbp`i'>=44 & dod_mbp`i'<60 & dod_mbp`i'~=. & dod_age_days_`i'/(365.25/12)>=12 & dod_age_days_`i'/(365.25/12)<24 & dod_age_days_`i'~=.
replace dod_map_pl_pts_`i'=2 if dod_mbp`i'>=46 & dod_mbp`i'<62 & dod_mbp`i'~=. & dod_age_days_`i'/(365.25/12)>=24 & dod_age_days_`i'/(365.25/12)<60 & dod_age_days_`i'~=.
replace dod_map_pl_pts_`i'=2 if dod_mbp`i'>=49 & dod_mbp`i'<65 & dod_mbp`i'~=. & dod_age_days_`i'/(365.25/12)>=60 & dod_age_days_`i'/(365.25/12)<144 & dod_age_days_`i'~=.
replace dod_map_pl_pts_`i'=2 if dod_mbp`i'>=52 & dod_mbp`i'<67 & dod_mbp`i'~=. & dod_age_days_`i'/(365.25/12)>=144 & dod_age_days_`i'~=.

replace dod_map_pl_pts_`i'=3 if dod_mbp`i'>=17 & dod_mbp`i'<31 & dod_mbp`i'~=. & dod_age_days_`i'/(365.25/12)<1 & dod_age_days_`i'~=.
replace dod_map_pl_pts_`i'=3 if dod_mbp`i'>=25 & dod_mbp`i'<39 & dod_mbp`i'~=. & dod_age_days_`i'/(365.25/12)>=1 & dod_age_days_`i'/(365.25/12)<12 & dod_age_days_`i'~=.
replace dod_map_pl_pts_`i'=3 if dod_mbp`i'>=31 & dod_mbp`i'<44 & dod_mbp`i'~=. & dod_age_days_`i'/(365.25/12)>=12 & dod_age_days_`i'/(365.25/12)<24 & dod_age_days_`i'~=.
replace dod_map_pl_pts_`i'=3 if dod_mbp`i'>=32 & dod_mbp`i'<46 & dod_mbp`i'~=. & dod_age_days_`i'/(365.25/12)>=24 & dod_age_days_`i'/(365.25/12)<60 & dod_age_days_`i'~=. // appears to be a no score for mbp 45 in this age range. score as 3
replace dod_map_pl_pts_`i'=3 if dod_mbp`i'>=36 & dod_mbp`i'<49 & dod_mbp`i'~=. & dod_age_days_`i'/(365.25/12)>=60 & dod_age_days_`i'/(365.25/12)<144 & dod_age_days_`i'~=.
replace dod_map_pl_pts_`i'=3 if dod_mbp`i'>=38 & dod_mbp`i'<52 & dod_mbp`i'~=. & dod_age_days_`i'/(365.25/12)>=144 & dod_age_days_`i'~=.

replace dod_map_pl_pts_`i'=6 if dod_mbp`i'<=16 & dod_mbp`i'~=. & dod_age_days_`i'/(365.25/12)<1 & dod_age_days_`i'~=.
replace dod_map_pl_pts_`i'=6 if dod_mbp`i'<=24 & dod_mbp`i'~=. & dod_age_days_`i'/(365.25/12)>=1 & dod_age_days_`i'/(365.25/12)<12 & dod_age_days_`i'~=.
replace dod_map_pl_pts_`i'=6 if dod_mbp`i'<=30 & dod_mbp`i'~=. & dod_age_days_`i'/(365.25/12)>=12 & dod_age_days_`i'/(365.25/12)<24 & dod_age_days_`i'~=.
replace dod_map_pl_pts_`i'=6 if dod_mbp`i'<=31 & dod_mbp`i'~=. & dod_age_days_`i'/(365.25/12)>=24 & dod_age_days_`i'/(365.25/12)<60 & dod_age_days_`i'~=.
replace dod_map_pl_pts_`i'=6 if dod_mbp`i'<=35 & dod_mbp`i'~=. & dod_age_days_`i'/(365.25/12)>=60 & dod_age_days_`i'/(365.25/12)<144 & dod_age_days_`i'~=.
replace dod_map_pl_pts_`i'=6 if dod_mbp`i'<=37 & dod_mbp`i'~=. & dod_age_days_`i'/(365.25/12)>=144 & dod_age_days_`i'~=.

// Generate points for creatinine - Assign a value of 0 where no value
gen dod_creatinine_pl_pts_`i'=0
replace dod_creatinine_pl_pts_`i'=2 if dod_creatinine`i'>=70 & dod_creatinine`i'~=. & dod_age_days_`i'/(365.25/12)<1 & dod_age_days_`i'~=.
replace dod_creatinine_pl_pts_`i'=2 if dod_creatinine`i'>=23 & dod_creatinine`i'~=. & dod_age_days_`i'/(365.25/12)>=1 & dod_age_days_`i'/(365.25/12)<12 & dod_age_days_`i'~=.
replace dod_creatinine_pl_pts_`i'=2 if dod_creatinine`i'>=35 & dod_creatinine`i'~=. & dod_age_days_`i'/(365.25/12)>=12 & dod_age_days_`i'/(365.25/12)<24 & dod_age_days_`i'~=.
replace dod_creatinine_pl_pts_`i'=2 if dod_creatinine`i'>=51 & dod_creatinine`i'~=. & dod_age_days_`i'/(365.25/12)>=24 & dod_age_days_`i'/(365.25/12)<60 & dod_age_days_`i'~=.
replace dod_creatinine_pl_pts_`i'=2 if dod_creatinine`i'>=59 & dod_creatinine`i'~=. & dod_age_days_`i'/(365.25/12)>=60 & dod_age_days_`i'/(365.25/12)<144 & dod_age_days_`i'~=.
replace dod_creatinine_pl_pts_`i'=2 if dod_creatinine`i'>=93 & dod_creatinine`i'~=. & dod_age_days_`i'/(365.25/12)>=144 & dod_age_days_`i'~=.

// Generate points for pao2/fio2 ratio - Assign a value of 0 where no value
gen dod_pao2_fio2_pl_pts_`i'=0
replace dod_pao2_fio2_pl_pts_`i'=2 if (dod_pao2`i'/dod_bga_fio2`i')<=60 & dod_pao2`i'~=. & dod_bga_fio2`i'~=.

// Generate points for paco2 - Assign a value of 0 where no value
gen dod_paco2_pl_pts_`i'=0
replace dod_paco2_pl_pts_`i'=1 if dod_paco2`i'>=59 & dod_paco2`i'<95 & dod_paco2`i'~=.
replace dod_paco2_pl_pts_`i'=3 if dod_paco2`i'>=95 & dod_paco2`i'~=.

// Generate points for invasive ventilation - Assign a value of 0 where no value
gen dod_iv_pl_pts_`i'=0
replace dod_iv_pl_pts_`i'=3 if dod_inv`i'==1

// Generate points for white cell count - Assign a value of 0 where no value
gen dod_wcc_pl_pts_`i'=0
replace dod_wcc_pl_pts_`i'=2 if dod_wcc`i'<=2 & dod_wcc`i'~=.

// Generate points for platelets - Assign a value of 0 where no value
gen dod_plat_pl_pts_`i'=0
replace dod_plat_pl_pts_`i'=1 if dod_platelets`i'>=77 & dod_platelets`i'<142 & dod_platelets`i'~=.
replace dod_plat_pl_pts_`i'=2 if dod_platelets`i'<=76 & dod_platelets`i'~=.

/* Generate the PELOD-2 score by summing points for all components */
egen dod_pelod2_`i'= rowtotal(dod_gcs_pl_pts_`i' dod_pupil_pl_pts_`i' dod_lactate_pl_pts_`i' dod_map_pl_pts_`i' dod_creatinine_pl_pts_`i' dod_pao2_fio2_pl_pts_`i' dod_paco2_pl_pts_`i' dod_iv_pl_pts_`i' dod_wcc_pl_pts_`i' dod_plat_pl_pts_`i')

}



/**** pSOFA Syntax ****/

/** Daily organ dysfunction**/

// Set values of 4444, 5555, 9999 to missing for relevant variables 
mvdecode dod_gcs*  dod_mbp* dod_creatinine* dod_pao2* dod_bga_fio2* dod_platelets* dod_bilirubin* dod_spo2* dod_fio2* , mv(9999=.\ 4444=.\ 5555=.)

/* Assignment of points for each component of PSOFA*/
forvalues i=1/28 {

// Generate points for glasgow coma scale - Assign a value of 0 where no value
gen dod_gcs_ps_pts_`i'=0
replace dod_gcs_ps_pts_`i'=1 if dod_gcs`i'>=13 & dod_gcs`i'<15 & dod_gcs`i'~=.
replace dod_gcs_ps_pts_`i'=2 if dod_gcs`i'>=10 & dod_gcs`i'<13 & dod_gcs`i'~=.
replace dod_gcs_ps_pts_`i'=3 if dod_gcs`i'>=6 & dod_gcs`i'<10 & dod_gcs`i'~=.
replace dod_gcs_ps_pts_`i'=4 if dod_gcs`i'<6 & dod_gcs`i'~=.

// Generate points for mean arterial pressure - Assign a value of 0 where no value
gen dod_map_ps_pts_`i'=0
replace dod_map_ps_pts_`i'=1 if dod_mbp`i'<46 & dod_mbp`i'~=. & dod_age_days_`i'/(365.25/12)<1 & dod_age_days_`i'~=.
replace dod_map_ps_pts_`i'=1 if dod_mbp`i'<55 & dod_mbp`i'~=. & dod_age_days_`i'/(365.25/12)>=1 & dod_age_days_`i'/(365.25/12)<12 & dod_age_days_`i'~=.
replace dod_map_ps_pts_`i'=1 if dod_mbp`i'<60 & dod_mbp`i'~=. & dod_age_days_`i'/(365.25/12)>=12 & dod_age_days_`i'/(365.25/12)<24 & dod_age_days_`i'~=.
replace dod_map_ps_pts_`i'=1 if dod_mbp`i'<62 & dod_mbp`i'~=. & dod_age_days_`i'/(365.25/12)>=24 & dod_age_days_`i'/(365.25/12)<60 & dod_age_days_`i'~=.
replace dod_map_ps_pts_`i'=1 if dod_mbp`i'<65 & dod_mbp`i'~=. & dod_age_days_`i'/(365.25/12)>=60 & dod_age_days_`i'/(365.25/12)<144 & dod_age_days_`i'~=.
replace dod_map_ps_pts_`i'=1 if dod_mbp`i'<67 & dod_mbp`i'~=. & dod_age_days_`i'/(365.25/12)>=144 & dod_age_days_`i'/(365.25/12)<=216 & dod_age_days_`i'~=.
replace dod_map_ps_pts_`i'=1 if dod_mbp`i'<70 & dod_mbp`i'~=. & dod_age_days_`i'/(365.25/12)>216 & dod_age_days_`i'~=.

replace dod_map_ps_pts_`i'=2 if (dod_dopa`i'>0 & dod_dopa`i'<=5 & dod_dopa`i'~=.) | (dod_dobu`i'>0 & dod_dobu`i'~=.)
replace dod_map_ps_pts_`i'=3 if (dod_dopa`i'>5 & dod_dopa`i'~=.) | (dod_adren`i'>0 & dod_adren`i'<=0.1 & dod_adren`i'~=.) | (dod_norad`i'>0 & dod_norad`i'<=0.1 & dod_norad`i'~=.)
replace dod_map_ps_pts_`i'=4 if (dod_dopa`i'>15 & dod_dopa`i'~=.) | (dod_adren`i'>0.1 & dod_adren`i'~=.) | (dod_norad`i'>0.1 & dod_norad`i'~=.)

// Generate points for creatinine - creatinine evaluated in mg/dL (divide by 88.4 to convert from micromol/L). Assign a value of 0 where no value
gen dod_creatinine_ps_pts_`i'=0
replace dod_creatinine_ps_pts_`i'=1 if (dod_creatinine`i'/88.4)>=0.8 & (dod_creatinine`i'/88.4)<1.0 & dod_creatinine`i'~=. & dod_age_days_`i'/(365.25/12)<1 & dod_age_days_`i'~=.
replace dod_creatinine_ps_pts_`i'=1 if (dod_creatinine`i'/88.4)>=0.3 & (dod_creatinine`i'/88.4)<0.5 & dod_creatinine`i'~=. & dod_age_days_`i'/(365.25/12)>=1 & dod_age_days_`i'/(365.25/12)<12 & dod_age_days_`i'~=.
replace dod_creatinine_ps_pts_`i'=1 if (dod_creatinine`i'/88.4)>=0.4 & (dod_creatinine`i'/88.4)<0.6 & dod_creatinine`i'~=. & dod_age_days_`i'/(365.25/12)>=12 & dod_age_days_`i'/(365.25/12)<24 & dod_age_days_`i'~=.
replace dod_creatinine_ps_pts_`i'=1 if (dod_creatinine`i'/88.4)>=0.6 & (dod_creatinine`i'/88.4)<0.9 & dod_creatinine`i'~=. & dod_age_days_`i'/(365.25/12)>=24 & dod_age_days_`i'/(365.25/12)<60 & dod_age_days_`i'~=.
replace dod_creatinine_ps_pts_`i'=1 if (dod_creatinine`i'/88.4)>=0.7 & (dod_creatinine`i'/88.4)<1.1 & dod_creatinine`i'~=. & dod_age_days_`i'/(365.25/12)>=60 & dod_age_days_`i'/(365.25/12)<144 & dod_age_days_`i'~=.
replace dod_creatinine_ps_pts_`i'=1 if (dod_creatinine`i'/88.4)>=1.0 & (dod_creatinine`i'/88.4)<1.7 & dod_creatinine`i'~=. & dod_age_days_`i'/(365.25/12)>=144 & dod_age_days_`i'/(365.25/12)<=216 & dod_age_days_`i'~=.
replace dod_creatinine_ps_pts_`i'=1 if (dod_creatinine`i'/88.4)>=1.2 & (dod_creatinine`i'/88.4)<2.0 & dod_creatinine`i'~=. & dod_age_days_`i'/(365.25/12)>216 & dod_age_days_`i'~=.

replace dod_creatinine_ps_pts_`i'=2 if (dod_creatinine`i'/88.4)>=1.0 & (dod_creatinine`i'/88.4)<1.2 & dod_creatinine`i'~=. & dod_age_days_`i'/(365.25/12)<1 & dod_age_days_`i'~=.
replace dod_creatinine_ps_pts_`i'=2 if (dod_creatinine`i'/88.4)>=0.5 & (dod_creatinine`i'/88.4)<0.8 & dod_creatinine`i'~=. & dod_age_days_`i'/(365.25/12)>=1 & dod_age_days_`i'/(365.25/12)<12 & dod_age_days_`i'~=.
replace dod_creatinine_ps_pts_`i'=2 if (dod_creatinine`i'/88.4)>=0.6 & (dod_creatinine`i'/88.4)<1.1 & dod_creatinine`i'~=. & dod_age_days_`i'/(365.25/12)>=12 & dod_age_days_`i'/(365.25/12)<24 & dod_age_days_`i'~=.
replace dod_creatinine_ps_pts_`i'=2 if (dod_creatinine`i'/88.4)>=0.9 & (dod_creatinine`i'/88.4)<1.6 & dod_creatinine`i'~=. & dod_age_days_`i'/(365.25/12)>=24 & dod_age_days_`i'/(365.25/12)<60 & dod_age_days_`i'~=.
replace dod_creatinine_ps_pts_`i'=2 if (dod_creatinine`i'/88.4)>=1.1 & (dod_creatinine`i'/88.4)<1.8 & dod_creatinine`i'~=. & dod_age_days_`i'/(365.25/12)>=60 & dod_age_days_`i'/(365.25/12)<144 & dod_age_days_`i'~=.
replace dod_creatinine_ps_pts_`i'=2 if (dod_creatinine`i'/88.4)>=1.7 & (dod_creatinine`i'/88.4)<2.9 & dod_creatinine`i'~=. & dod_age_days_`i'/(365.25/12)>=144 & dod_age_days_`i'/(365.25/12)<=216 & dod_age_days_`i'~=.
replace dod_creatinine_ps_pts_`i'=2 if (dod_creatinine`i'/88.4)>=2.0 & (dod_creatinine`i'/88.4)<3.5 & dod_creatinine`i'~=. & dod_age_days_`i'/(365.25/12)>216 & dod_age_days_`i'~=.

replace dod_creatinine_ps_pts_`i'=3 if (dod_creatinine`i'/88.4)>=1.2 & (dod_creatinine`i'/88.4)<1.6 & dod_creatinine`i'~=. & dod_age_days_`i'/(365.25/12)<1 & dod_age_days_`i'~=.
replace dod_creatinine_ps_pts_`i'=3 if (dod_creatinine`i'/88.4)>=0.8 & (dod_creatinine`i'/88.4)<1.2 & dod_creatinine`i'~=. & dod_age_days_`i'/(365.25/12)>=1 & dod_age_days_`i'/(365.25/12)<12 & dod_age_days_`i'~=.
replace dod_creatinine_ps_pts_`i'=3 if (dod_creatinine`i'/88.4)>=1.1 & (dod_creatinine`i'/88.4)<1.5 & dod_creatinine`i'~=. & dod_age_days_`i'/(365.25/12)>=12 & dod_age_days_`i'/(365.25/12)<24 & dod_age_days_`i'~=.
replace dod_creatinine_ps_pts_`i'=3 if (dod_creatinine`i'/88.4)>=1.6 & (dod_creatinine`i'/88.4)<2.3 & dod_creatinine`i'~=. & dod_age_days_`i'/(365.25/12)>=24 & dod_age_days_`i'/(365.25/12)<60 & dod_age_days_`i'~=.
replace dod_creatinine_ps_pts_`i'=3 if (dod_creatinine`i'/88.4)>=1.8 & (dod_creatinine`i'/88.4)<2.6 & dod_creatinine`i'~=. & dod_age_days_`i'/(365.25/12)>=60 & dod_age_days_`i'/(365.25/12)<144 & dod_age_days_`i'~=.
replace dod_creatinine_ps_pts_`i'=3 if (dod_creatinine`i'/88.4)>=2.9 & (dod_creatinine`i'/88.4)<4.2 & dod_creatinine`i'~=. & dod_age_days_`i'/(365.25/12)>=144 & dod_age_days_`i'/(365.25/12)<=216 & dod_age_days_`i'~=.
replace dod_creatinine_ps_pts_`i'=3 if (dod_creatinine`i'/88.4)>=3.5 & (dod_creatinine`i'/88.4)<5 & dod_creatinine`i'~=. & dod_age_days_`i'/(365.25/12)>216 & dod_age_days_`i'~=.

replace dod_creatinine_ps_pts_`i'=4 if (dod_creatinine`i'/88.4)>=1.6 & dod_creatinine`i'~=. & dod_age_days_`i'/(365.25/12)<1 & dod_age_days_`i'~=.
replace dod_creatinine_ps_pts_`i'=4 if (dod_creatinine`i'/88.4)>=1.2 & dod_creatinine`i'~=. & dod_age_days_`i'/(365.25/12)>=1 & dod_age_days_`i'/(365.25/12)<12 & dod_age_days_`i'~=.
replace dod_creatinine_ps_pts_`i'=4 if (dod_creatinine`i'/88.4)>=1.5 & dod_creatinine`i'~=. & dod_age_days_`i'/(365.25/12)>=12 & dod_age_days_`i'/(365.25/12)<24 & dod_age_days_`i'~=.
replace dod_creatinine_ps_pts_`i'=4 if (dod_creatinine`i'/88.4)>=2.3 & dod_creatinine`i'~=. & dod_age_days_`i'/(365.25/12)>=24 & dod_age_days_`i'/(365.25/12)<60 & dod_age_days_`i'~=.
replace dod_creatinine_ps_pts_`i'=4 if (dod_creatinine`i'/88.4)>=2.6 & dod_creatinine`i'~=. & dod_age_days_`i'/(365.25/12)>=60 & dod_age_days_`i'/(365.25/12)<144 & dod_age_days_`i'~=.
replace dod_creatinine_ps_pts_`i'=4 if (dod_creatinine`i'/88.4)>=4.2 & dod_creatinine`i'~=. & dod_age_days_`i'/(365.25/12)>=144 & dod_age_days_`i'/(365.25/12)<=216 & dod_age_days_`i'~=.
replace dod_creatinine_ps_pts_`i'=4 if (dod_creatinine`i'/88.4)>=5 & dod_creatinine`i'~=. & dod_age_days_`i'/(365.25/12)>216 & dod_age_days_`i'~=.

// Generate points for pao2/fio2 ratio - Assign a value of 0 where no value
gen dod_pao2_fio2_ps_pts_`i'=0
replace dod_pao2_fio2_ps_pts_`i'=1 if (dod_pao2`i'/dod_bga_fio2`i')>=300  & (dod_pao2`i'/dod_bga_fio2`i')<400 & dod_pao2`i'~=. & dod_bga_fio2`i'~=.
replace dod_pao2_fio2_ps_pts_`i'=2 if (dod_pao2`i'/dod_bga_fio2`i')>=200  & (dod_pao2`i'/dod_bga_fio2`i')<300 & dod_pao2`i'~=. & dod_bga_fio2`i'~=.
replace dod_pao2_fio2_ps_pts_`i'=3 if (dod_pao2`i'/dod_bga_fio2`i')>=100  & (dod_pao2`i'/dod_bga_fio2`i')<200 & dod_pao2`i'~=. & dod_bga_fio2`i'~=. & (dod_inv`i'==1 | dod_niv`i'==1) // do not include hfnc
replace dod_pao2_fio2_ps_pts_`i'=4 if (dod_pao2`i'/dod_bga_fio2`i')<100  & dod_pao2`i'~=. & dod_bga_fio2`i'~=. & (dod_inv`i'==1 | dod_niv`i'==1) // do not include hfnc

// Generate points for spo2/fio2 ratio - Only values of 97% were used in the calculation. Assign a value of 0 where no value
gen dod_spo2_fio2_ps_pts_`i'=0
replace dod_spo2_fio2_ps_pts_`i'=1 if (dod_spo2`i'/dod_fio2`i')>=265  & (dod_spo2`i'/dod_fio2`i')<292 & dod_spo2`i'~=. & dod_spo2`i'<=97 & dod_fio2`i'~=. 
replace dod_spo2_fio2_ps_pts_`i'=2 if (dod_spo2`i'/dod_fio2`i')>=221  & (dod_spo2`i'/dod_fio2`i')<265 & dod_spo2`i'~=. & dod_spo2`i'<=97 & dod_fio2`i'~=. // appears to be a double up for the value of 264. score as 2 
replace dod_spo2_fio2_ps_pts_`i'=3 if (dod_spo2`i'/dod_fio2`i')>=148  & (dod_spo2`i'/dod_fio2`i')<221 & dod_spo2`i'~=. & dod_spo2`i'<=97 & dod_fio2`i'~=. & (dod_inv`i'==1 | dod_niv`i'==1) // do not include hfnc
replace dod_spo2_fio2_ps_pts_`i'=4 if (dod_spo2`i'/dod_fio2`i')<148  & dod_spo2`i'~=. & dod_spo2`i'<=97 & dod_fio2`i'~=. & (dod_inv`i'==1 | dod_niv`i'==1) // do not include hfnc

// Generate points for platelets - Assign a value of 0 where no value
gen dod_plat_ps_pts_`i'=0
replace dod_plat_ps_pts_`i'=1 if dod_platelets`i'>=100 & dod_platelets`i'<150 & dod_platelets`i'~=.
replace dod_plat_ps_pts_`i'=2 if dod_platelets`i'>=50 & dod_platelets`i'<100 & dod_platelets`i'~=.
replace dod_plat_ps_pts_`i'=3 if dod_platelets`i'>=20 & dod_platelets`i'<50 & dod_platelets`i'~=.
replace dod_plat_ps_pts_`i'=4 if dod_platelets`i'<20 & dod_platelets`i'~=.

// Generate points for bilirubin - Bilirubin evaluated in mg/dL (divide by 17.104 to convert from micromol/L). Assign a value of 0 where no value
gen dod_bili_ps_pts_`i'=0
replace dod_bili_ps_pts_`i'=1 if (dod_bilirubin`i'/17.104)>=1.2 & (dod_bilirubin`i'/17.104)<2.0 & dod_bilirubin`i'~=.
replace dod_bili_ps_pts_`i'=2 if (dod_bilirubin`i'/17.104)>=2.0 & (dod_bilirubin`i'/17.104)<6.0 & dod_bilirubin`i'~=.
replace dod_bili_ps_pts_`i'=3 if (dod_bilirubin`i'/17.104)>=6.0 & (dod_bilirubin`i'/17.104)<12.0 & dod_bilirubin`i'~=.
replace dod_bili_ps_pts_`i'=4 if (dod_bilirubin`i'/17.104)>=12.0 & (dod_bilirubin`i'/17.104)~=. // appears to be no score for bilirubin of 12. score as 4 

/* Generate the pSOFA using pao2 score by summing points for all components */
egen dod_psofa_pao2_`i'= rowtotal(dod_gcs_ps_pts_`i' dod_map_ps_pts_`i' dod_creatinine_ps_pts_`i' dod_pao2_fio2_ps_pts_`i' dod_plat_ps_pts_`i' dod_bili_ps_pts_`i') 

/* Generate the pSOFA using spo2 score by summing points for all components */
egen dod_psofa_spo2_`i'= rowtotal(dod_gcs_ps_pts_`i' dod_map_ps_pts_`i' dod_creatinine_ps_pts_`i' dod_spo2_fio2_ps_pts_`i' dod_plat_ps_pts_`i' dod_bili_ps_pts_`i') 

/* Generate the combined pSOFA score by using the pSOFA score which uses the pao2/fio2 points if pao2 and bga fio2 are avaialble, otherwise the pSOFA score which uses the spo2/fio2 points */
gen dod_psofa_comb_`i'=dod_psofa_pao2_`i' if dod_pao2`i'~=. & dod_bga_fio2`i'~=.
replace dod_psofa_comb_`i'=dod_psofa_spo2_`i' if dod_pao2`i'==.

/* Generate whether there is multiorgan dysfunction using the pSOFA score */
gen dod_psofa_mo_comb_count_`i'=0
foreach v of varlist dod_gcs_ps_pts_`i' dod_map_ps_pts_`i' dod_creatinine_ps_pts_`i' dod_pao2_fio2_ps_pts_`i' dod_plat_ps_pts_`i' dod_bili_ps_pts_`i' {
	replace dod_psofa_mo_comb_count_`i'=dod_psofa_mo_comb_count_`i'+1 if `v'>0 & ~missing(`v')
}
replace dod_psofa_mo_comb_count_`i'=dod_psofa_mo_comb_count_`i'+1 if dod_pao2`i'==. & dod_pao2`i'>0

gen dod_psofa_mo_comb_`i'=1 if dod_psofa_mo_comb_count_`i'~=. & dod_psofa_mo_comb_count_`i'>=2

}

/**** AKI Syntax ****/


forvalues i=1/28 {
	// Stage 1
	gen icu_aki_`i'=0
	replace icu_aki_`i'=1 if dod_creatinine`i'>=(70*1.5) & dod_creatinine`i'<(70*2) & dem_picu_rand_age_days/(365.25/12)<1 & dem_picu_rand_age_days~=.
	replace icu_aki_`i'=1 if dod_creatinine`i'>=(23*1.5) & dod_creatinine`i'<(23*2) & dem_picu_rand_age_days/(365.25/12)>=1 & dem_picu_rand_age_days/(365.25/12)<12 & dem_picu_rand_age_days~=.
	replace icu_aki_`i'=1 if dod_creatinine`i'>=(35*1.5) & dod_creatinine`i'<(35*2) & dem_picu_rand_age_days/(365.25/12)>=12 & dem_picu_rand_age_days/(365.25/12)<24 & dem_picu_rand_age_days~=.
	replace icu_aki_`i'=1 if dod_creatinine`i'>=(51*1.5) & dod_creatinine`i'<(51*2) & dem_picu_rand_age_days/(365.25/12)>=24 & dem_picu_rand_age_days/(365.25/12)<60 & dem_picu_rand_age_days~=.
	replace icu_aki_`i'=1 if dod_creatinine`i'>=(59*1.5) & dod_creatinine`i'<(59*2) & dem_picu_rand_age_days/(365.25/12)>=60 & dem_picu_rand_age_days/(365.25/12)<144 & dem_picu_rand_age_days~=.
	replace icu_aki_`i'=1 if dod_creatinine`i'>=(93*1.5) & dod_creatinine`i'<(93*2) & dem_picu_rand_age_days/(365.25/12)>=144 & dem_picu_rand_age_days~=.
	
	// Stage 2
	replace icu_aki_`i'=2 if dod_creatinine`i'>=(70*2) & dod_creatinine`i'<(70*3) & dem_picu_rand_age_days/(365.25/12)<1 & dem_picu_rand_age_days~=.
	replace icu_aki_`i'=2 if dod_creatinine`i'>=(23*2) & dod_creatinine`i'<(23*3) & dem_picu_rand_age_days/(365.25/12)>=1 & dem_picu_rand_age_days/(365.25/12)<12 & dem_picu_rand_age_days~=.
	replace icu_aki_`i'=2 if dod_creatinine`i'>=(35*2) & dod_creatinine`i'<(35*3) & dem_picu_rand_age_days/(365.25/12)>=12 & dem_picu_rand_age_days/(365.25/12)<24 & dem_picu_rand_age_days~=.
	replace icu_aki_`i'=2 if dod_creatinine`i'>=(51*2) & dod_creatinine`i'<(51*3) & dem_picu_rand_age_days/(365.25/12)>=24 & dem_picu_rand_age_days/(365.25/12)<60 & dem_picu_rand_age_days~=.
	replace icu_aki_`i'=2 if dod_creatinine`i'>=(59*2) & dod_creatinine`i'<(59*3) & dem_picu_rand_age_days/(365.25/12)>=60 & dem_picu_rand_age_days/(365.25/12)<144 & dem_picu_rand_age_days~=.
	replace icu_aki_`i'=2 if dod_creatinine`i'>=(93*2) & dod_creatinine`i'<(93*3) & dem_picu_rand_age_days/(365.25/12)>=144 & dem_picu_rand_age_days~=.
	
	// Stage 3
	replace icu_aki_`i'=3 if dod_creatinine`i'>=(70*3) & dod_creatinine`i'~=. & dem_picu_rand_age_days/(365.25/12)<1 & dem_picu_rand_age_days~=.
	replace icu_aki_`i'=3 if dod_creatinine`i'>=(23*3) & dod_creatinine`i'~=. & dem_picu_rand_age_days/(365.25/12)>=1 & dem_picu_rand_age_days/(365.25/12)<12 & dem_picu_rand_age_days~=.
	replace icu_aki_`i'=3 if dod_creatinine`i'>=(35*3) & dod_creatinine`i'~=. & dem_picu_rand_age_days/(365.25/12)>=12 & dem_picu_rand_age_days/(365.25/12)<24 & dem_picu_rand_age_days~=.
	replace icu_aki_`i'=3 if dod_creatinine`i'>=(51*3) & dod_creatinine`i'~=. & dem_picu_rand_age_days/(365.25/12)>=24 & dem_picu_rand_age_days/(365.25/12)<60 & dem_picu_rand_age_days~=.
	replace icu_aki_`i'=3 if dod_creatinine`i'>=(59*3) & dod_creatinine`i'~=. & dem_picu_rand_age_days/(365.25/12)>=60 & dem_picu_rand_age_days/(365.25/12)<144 & dem_picu_rand_age_days~=.
	replace icu_aki_`i'=3 if dod_creatinine`i'>=(93*3) & dod_creatinine`i'~=. & dem_picu_rand_age_days/(365.25/12)>=144 & dem_picu_rand_age_days~=.
}