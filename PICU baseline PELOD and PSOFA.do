/**** PELOD-2 Syntax ****/

/**PICU baseline**/

// Set values of 4444, 5555, 9999 to missing for relevant variables 
mvdecode icu_bl_gcs icu_bl_pupil_fix icu_bl_lactate icu_bl_mbp icu_bl_creatinine icu_bl_pao2 icu_bl_bga_fio2 icu_bl_paco2 icu_bl_wcc icu_bl_platelets, mv(9999=.\ 4444=.\ 5555=.)

// Generate age in days at PICU baseline
gen icu_bl_age_days=dofc(icu_bl_obs_dt)- (dem_dob)

// Generate points for glasgow coma scale - use the AVPU score which has an equivalent gcs value if the gcs score is not available. Assign a value of 0 where no value
gen icu_bl_gcs_pl_pts=0
replace icu_bl_gcs_pl_pts=1 if (icu_bl_gcs>=5 & icu_bl_gcs<11 & icu_bl_gcs~=.) | (icu_bl_avpu==8 & icu_bl_gcs==.) | (icu_bl_avpu==6 & icu_bl_gcs==.)
replace icu_bl_gcs_pl_pts=4 if icu_bl_gcs>=3 & icu_bl_gcs<5 & icu_bl_gcs~=.

// Generate points for pupils - Assign a value of 0 where no value
gen icu_bl_pupil_pl_pts=0
replace icu_bl_pupil_pl_pts=5 if icu_bl_pupil_fix==1

// Generate points for lactate - Assign a value of 0 where no value
gen icu_bl_lactate_pl_pts=0
replace icu_bl_lactate_pl_pts=1 if icu_bl_lactate>=5 & icu_bl_lactate<11 & icu_bl_lactate~=.
replace icu_bl_lactate_pl_pts=4 if icu_bl_lactate>=11 & icu_bl_lactate~=.

// Generate points for mean arterial pressure - Assign a value of 0 where no value
gen icu_bl_map_pl_pts=0
replace icu_bl_map_pl_pts=2 if icu_bl_mbp>=31 & icu_bl_mbp<46 & icu_bl_mbp~=. & icu_bl_age_days/(365.25/12)<1 & icu_bl_age_days~=.
replace icu_bl_map_pl_pts=2 if icu_bl_mbp>=39 & icu_bl_mbp<55 & icu_bl_mbp~=. & icu_bl_age_days/(365.25/12)>=1 & icu_bl_age_days/(365.25/12)<12 & icu_bl_age_days~=.
replace icu_bl_map_pl_pts=2 if icu_bl_mbp>=44 & icu_bl_mbp<60 & icu_bl_mbp~=. & icu_bl_age_days/(365.25/12)>=12 & icu_bl_age_days/(365.25/12)<24 & icu_bl_age_days~=.
replace icu_bl_map_pl_pts=2 if icu_bl_mbp>=46 & icu_bl_mbp<62 & icu_bl_mbp~=. & icu_bl_age_days/(365.25/12)>=24 & icu_bl_age_days/(365.25/12)<60 & icu_bl_age_days~=.
replace icu_bl_map_pl_pts=2 if icu_bl_mbp>=49 & icu_bl_mbp<65 & icu_bl_mbp~=. & icu_bl_age_days/(365.25/12)>=60 & icu_bl_age_days/(365.25/12)<144 & icu_bl_age_days~=.
replace icu_bl_map_pl_pts=2 if icu_bl_mbp>=52 & icu_bl_mbp<67 & icu_bl_mbp~=. & icu_bl_age_days/(365.25/12)>=144 & icu_bl_age_days~=.

replace icu_bl_map_pl_pts=3 if icu_bl_mbp>=17 & icu_bl_mbp<31 & icu_bl_mbp~=. & icu_bl_age_days/(365.25/12)<1 & icu_bl_age_days~=.
replace icu_bl_map_pl_pts=3 if icu_bl_mbp>=25 & icu_bl_mbp<39 & icu_bl_mbp~=. & icu_bl_age_days/(365.25/12)>=1 & icu_bl_age_days/(365.25/12)<12 & icu_bl_age_days~=.
replace icu_bl_map_pl_pts=3 if icu_bl_mbp>=31 & icu_bl_mbp<44 & icu_bl_mbp~=. & icu_bl_age_days/(365.25/12)>=12 & icu_bl_age_days/(365.25/12)<24 & icu_bl_age_days~=.
replace icu_bl_map_pl_pts=3 if icu_bl_mbp>=32 & icu_bl_mbp<46 & icu_bl_mbp~=. & icu_bl_age_days/(365.25/12)>=24 & icu_bl_age_days/(365.25/12)<60 & icu_bl_age_days~=. // appears to be a no score for mbp 45 in this age range. score as 3
replace icu_bl_map_pl_pts=3 if icu_bl_mbp>=36 & icu_bl_mbp<49 & icu_bl_mbp~=. & icu_bl_age_days/(365.25/12)>=60 & icu_bl_age_days/(365.25/12)<144 & icu_bl_age_days~=.
replace icu_bl_map_pl_pts=3 if icu_bl_mbp>=38 & icu_bl_mbp<52 & icu_bl_mbp~=. & icu_bl_age_days/(365.25/12)>=144 & icu_bl_age_days~=.

replace icu_bl_map_pl_pts=6 if icu_bl_mbp<=16 & icu_bl_mbp~=. & icu_bl_age_days/(365.25/12)<1 & icu_bl_age_days~=.
replace icu_bl_map_pl_pts=6 if icu_bl_mbp<=24 & icu_bl_mbp~=. & icu_bl_age_days/(365.25/12)>=1 & icu_bl_age_days/(365.25/12)<12 & icu_bl_age_days~=.
replace icu_bl_map_pl_pts=6 if icu_bl_mbp<=30 & icu_bl_mbp~=. & icu_bl_age_days/(365.25/12)>=12 & icu_bl_age_days/(365.25/12)<24 & icu_bl_age_days~=.
replace icu_bl_map_pl_pts=6 if icu_bl_mbp<=31 & icu_bl_mbp~=. & icu_bl_age_days/(365.25/12)>=24 & icu_bl_age_days/(365.25/12)<60 & icu_bl_age_days~=.
replace icu_bl_map_pl_pts=6 if icu_bl_mbp<=35 & icu_bl_mbp~=. & icu_bl_age_days/(365.25/12)>=60 & icu_bl_age_days/(365.25/12)<144 & icu_bl_age_days~=.
replace icu_bl_map_pl_pts=6 if icu_bl_mbp<=37 & icu_bl_mbp~=. & icu_bl_age_days/(365.25/12)>=144 & icu_bl_age_days~=.

// Generate points for creatinine - Assign a value of 0 where no value
gen icu_bl_creatinine_pl_pts=0
replace icu_bl_creatinine_pl_pts=2 if icu_bl_creatinine>=70 & icu_bl_creatinine~=. & icu_bl_age_days/(365.25/12)<1 & icu_bl_age_days~=.
replace icu_bl_creatinine_pl_pts=2 if icu_bl_creatinine>=23 & icu_bl_creatinine~=. & icu_bl_age_days/(365.25/12)>=1 & icu_bl_age_days/(365.25/12)<12 & icu_bl_age_days~=.
replace icu_bl_creatinine_pl_pts=2 if icu_bl_creatinine>=35 & icu_bl_creatinine~=. & icu_bl_age_days/(365.25/12)>=12 & icu_bl_age_days/(365.25/12)<24 & icu_bl_age_days~=.
replace icu_bl_creatinine_pl_pts=2 if icu_bl_creatinine>=51 & icu_bl_creatinine~=. & icu_bl_age_days/(365.25/12)>=24 & icu_bl_age_days/(365.25/12)<60 & icu_bl_age_days~=.
replace icu_bl_creatinine_pl_pts=2 if icu_bl_creatinine>=59 & icu_bl_creatinine~=. & icu_bl_age_days/(365.25/12)>=60 & icu_bl_age_days/(365.25/12)<144 & icu_bl_age_days~=.
replace icu_bl_creatinine_pl_pts=2 if icu_bl_creatinine>=93 & icu_bl_creatinine~=. & icu_bl_age_days/(365.25/12)>=144 & icu_bl_age_days~=.

// Generate points for pao2/fio2 ratio - Assign a value of 0 where no value
gen icu_bl_pao2_fio2_pl_pts=0
replace icu_bl_pao2_fio2_pl_pts=2 if (icu_bl_pao2/icu_bl_bga_fio2)<=60 & icu_bl_pao2~=. & icu_bl_bga_fio2~=.

// Generate points for paco2 - Assign a value of 0 where no value
gen icu_bl_paco2_pl_pts=0
replace icu_bl_paco2_pl_pts=1 if icu_bl_paco2>=59 & icu_bl_paco2<95 & icu_bl_paco2~=.
replace icu_bl_paco2_pl_pts=3 if icu_bl_paco2>=95 & icu_bl_paco2~=.

// Generate points for invasive ventilation - Assign a value of 0 where no value
gen icu_bl_iv_pl_pts=0
replace icu_bl_iv_pl_pts=3 if icu_bl_inv==1

// Generate points for white cell count - Assign a value of 0 where no value
gen icu_bl_wcc_pl_pts=0
replace icu_bl_wcc_pl_pts=2 if icu_bl_wcc<=2 & icu_bl_wcc~=.

// Generate points for platelets - Assign a value of 0 where no value
gen icu_bl_plat_pl_pts=0
replace icu_bl_plat_pl_pts=1 if icu_bl_platelets>=77 & icu_bl_platelets<142 & icu_bl_platelets~=.
replace icu_bl_plat_pl_pts=2 if icu_bl_platelets<=76 & icu_bl_platelets~=.

/* Generate the PELOD-2 score by summing points for all components */
egen icu_bl_pelod2 = rowtotal(icu_bl_gcs_pl_pts icu_bl_pupil_pl_pts icu_bl_lactate_pl_pts icu_bl_map_pl_pts icu_bl_creatinine_pl_pts icu_bl_pao2_fio2_pl_pts icu_bl_paco2_pl_pts icu_bl_iv_pl_pts icu_bl_wcc_pl_pts icu_bl_plat_pl_pts)




/**** pSOFA Syntax ****/

/**PICU baseline*/

// Set values of 4444, 5555, 9999 to missing for relevant variables 
mvdecode icu_bl_gcs  icu_bl_mbp icu_bl_creatinine icu_bl_pao2 icu_bl_bga_fio2 icu_bl_platelets icu_bl_bilirubin icu_bl_spo2 icu_bl_fio2 , mv(9999=.\ 4444=.\ 5555=.)

// Generate points for glasgow coma scale -  use the AVPU score which has an equivalent gcs value if the gcs score is not available. Assign a value of 0 where no value
gen icu_bl_gcs_ps_pts=0
replace icu_bl_gcs_ps_pts=1 if (icu_bl_gcs>=13 & icu_bl_gcs<15 & icu_bl_gcs~=.) | (icu_bl_avpu==13 & icu_bl_gcs==.) 
replace icu_bl_gcs_ps_pts=2 if icu_bl_gcs>=10 & icu_bl_gcs<13 & icu_bl_gcs~=. 
replace icu_bl_gcs_ps_pts=3 if (icu_bl_gcs>=6 & icu_bl_gcs<10 & icu_bl_gcs~=.) | (icu_bl_avpu==8 & icu_bl_gcs==.) | (icu_bl_avpu==6 & icu_bl_gcs==.)
replace icu_bl_gcs_ps_pts=4 if icu_bl_gcs<6 & icu_bl_gcs~=.

// Generate points for mean arterial pressure - Assign a value of 0 where no value
gen icu_bl_map_ps_pts=0
replace icu_bl_map_ps_pts=1 if icu_bl_mbp<46 & icu_bl_mbp~=. & icu_bl_age_days/(365.25/12)<1 & icu_bl_age_days~=.
replace icu_bl_map_ps_pts=1 if icu_bl_mbp<55 & icu_bl_mbp~=. & icu_bl_age_days/(365.25/12)>=1 & icu_bl_age_days/(365.25/12)<12 & icu_bl_age_days~=.
replace icu_bl_map_ps_pts=1 if icu_bl_mbp<60 & icu_bl_mbp~=. & icu_bl_age_days/(365.25/12)>=12 & icu_bl_age_days/(365.25/12)<24 & icu_bl_age_days~=.
replace icu_bl_map_ps_pts=1 if icu_bl_mbp<62 & icu_bl_mbp~=. & icu_bl_age_days/(365.25/12)>=24 & icu_bl_age_days/(365.25/12)<60 & icu_bl_age_days~=.
replace icu_bl_map_ps_pts=1 if icu_bl_mbp<65 & icu_bl_mbp~=. & icu_bl_age_days/(365.25/12)>=60 & icu_bl_age_days/(365.25/12)<144 & icu_bl_age_days~=.
replace icu_bl_map_ps_pts=1 if icu_bl_mbp<67 & icu_bl_mbp~=. & icu_bl_age_days/(365.25/12)>=144 & icu_bl_age_days/(365.25/12)<=216 & icu_bl_age_days~=.
replace icu_bl_map_ps_pts=1 if icu_bl_mbp<70 & icu_bl_mbp~=. & icu_bl_age_days/(365.25/12)>216 & icu_bl_age_days~=.

replace icu_bl_map_ps_pts=2 if (icu_bl_dopa>0 & icu_bl_dopa<=5 & icu_bl_dopa~=.) | (icu_bl_dobu>0 & icu_bl_dobu~=.)
replace icu_bl_map_ps_pts=3 if (icu_bl_dopa>5 & icu_bl_dopa~=.) | (icu_bl_adren>0 & icu_bl_adren<=0.1 & icu_bl_adren~=.) | (icu_bl_norad>0 & icu_bl_norad<=0.1 & icu_bl_norad~=.)
replace icu_bl_map_ps_pts=4 if (icu_bl_dopa>15 & icu_bl_dopa~=.) | (icu_bl_adren>0.1 & icu_bl_adren~=.) | (icu_bl_norad>0.1 & icu_bl_norad~=.)

// Generate points for creatinine - creatinine evaluated in mg/dL (divide by 88.4 to convert from micromol/L). Assign a value of 0 where no value
gen icu_bl_creatinine_ps_pts=0
replace icu_bl_creatinine_ps_pts=1 if (icu_bl_creatinine/88.4)>=0.8 & (icu_bl_creatinine/88.4)<1.0 & icu_bl_creatinine~=. & icu_bl_age_days/(365.25/12)<1 & icu_bl_age_days~=.
replace icu_bl_creatinine_ps_pts=1 if (icu_bl_creatinine/88.4)>=0.3 & (icu_bl_creatinine/88.4)<0.5 & icu_bl_creatinine~=. & icu_bl_age_days/(365.25/12)>=1 & icu_bl_age_days/(365.25/12)<12 & icu_bl_age_days~=.
replace icu_bl_creatinine_ps_pts=1 if (icu_bl_creatinine/88.4)>=0.4 & (icu_bl_creatinine/88.4)<0.6 & icu_bl_creatinine~=. & icu_bl_age_days/(365.25/12)>=12 & icu_bl_age_days/(365.25/12)<24 & icu_bl_age_days~=.
replace icu_bl_creatinine_ps_pts=1 if (icu_bl_creatinine/88.4)>=0.6 & (icu_bl_creatinine/88.4)<0.9 & icu_bl_creatinine~=. & icu_bl_age_days/(365.25/12)>=24 & icu_bl_age_days/(365.25/12)<60 & icu_bl_age_days~=.
replace icu_bl_creatinine_ps_pts=1 if (icu_bl_creatinine/88.4)>=0.7 & (icu_bl_creatinine/88.4)<1.1 & icu_bl_creatinine~=. & icu_bl_age_days/(365.25/12)>=60 & icu_bl_age_days/(365.25/12)<144 & icu_bl_age_days~=.
replace icu_bl_creatinine_ps_pts=1 if (icu_bl_creatinine/88.4)>=1.0 & (icu_bl_creatinine/88.4)<1.7 & icu_bl_creatinine~=. & icu_bl_age_days/(365.25/12)>=144 & icu_bl_age_days/(365.25/12)<=216 & icu_bl_age_days~=.
replace icu_bl_creatinine_ps_pts=1 if (icu_bl_creatinine/88.4)>=1.2 & (icu_bl_creatinine/88.4)<2.0 & icu_bl_creatinine~=. & icu_bl_age_days/(365.25/12)>216 & icu_bl_age_days~=.

replace icu_bl_creatinine_ps_pts=2 if (icu_bl_creatinine/88.4)>=1.0 & (icu_bl_creatinine/88.4)<1.2 & icu_bl_creatinine~=. & icu_bl_age_days/(365.25/12)<1 & icu_bl_age_days~=.
replace icu_bl_creatinine_ps_pts=2 if (icu_bl_creatinine/88.4)>=0.5 & (icu_bl_creatinine/88.4)<0.8 & icu_bl_creatinine~=. & icu_bl_age_days/(365.25/12)>=1 & icu_bl_age_days/(365.25/12)<12 & icu_bl_age_days~=.
replace icu_bl_creatinine_ps_pts=2 if (icu_bl_creatinine/88.4)>=0.6 & (icu_bl_creatinine/88.4)<1.1 & icu_bl_creatinine~=. & icu_bl_age_days/(365.25/12)>=12 & icu_bl_age_days/(365.25/12)<24 & icu_bl_age_days~=.
replace icu_bl_creatinine_ps_pts=2 if (icu_bl_creatinine/88.4)>=0.9 & (icu_bl_creatinine/88.4)<1.6 & icu_bl_creatinine~=. & icu_bl_age_days/(365.25/12)>=24 & icu_bl_age_days/(365.25/12)<60 & icu_bl_age_days~=.
replace icu_bl_creatinine_ps_pts=2 if (icu_bl_creatinine/88.4)>=1.1 & (icu_bl_creatinine/88.4)<1.8 & icu_bl_creatinine~=. & icu_bl_age_days/(365.25/12)>=60 & icu_bl_age_days/(365.25/12)<144 & icu_bl_age_days~=.
replace icu_bl_creatinine_ps_pts=2 if (icu_bl_creatinine/88.4)>=1.7 & (icu_bl_creatinine/88.4)<2.9 & icu_bl_creatinine~=. & icu_bl_age_days/(365.25/12)>=144 & icu_bl_age_days/(365.25/12)<=216 & icu_bl_age_days~=.
replace icu_bl_creatinine_ps_pts=2 if (icu_bl_creatinine/88.4)>=2.0 & (icu_bl_creatinine/88.4)<3.5 & icu_bl_creatinine~=. & icu_bl_age_days/(365.25/12)>216 & icu_bl_age_days~=.

replace icu_bl_creatinine_ps_pts=3 if (icu_bl_creatinine/88.4)>=1.2 & (icu_bl_creatinine/88.4)<1.6 & icu_bl_creatinine~=. & icu_bl_age_days/(365.25/12)<1 & icu_bl_age_days~=.
replace icu_bl_creatinine_ps_pts=3 if (icu_bl_creatinine/88.4)>=0.8 & (icu_bl_creatinine/88.4)<1.2 & icu_bl_creatinine~=. & icu_bl_age_days/(365.25/12)>=1 & icu_bl_age_days/(365.25/12)<12 & icu_bl_age_days~=.
replace icu_bl_creatinine_ps_pts=3 if (icu_bl_creatinine/88.4)>=1.1 & (icu_bl_creatinine/88.4)<1.5 & icu_bl_creatinine~=. & icu_bl_age_days/(365.25/12)>=12 & icu_bl_age_days/(365.25/12)<24 & icu_bl_age_days~=.
replace icu_bl_creatinine_ps_pts=3 if (icu_bl_creatinine/88.4)>=1.6 & (icu_bl_creatinine/88.4)<2.3 & icu_bl_creatinine~=. & icu_bl_age_days/(365.25/12)>=24 & icu_bl_age_days/(365.25/12)<60 & icu_bl_age_days~=.
replace icu_bl_creatinine_ps_pts=3 if (icu_bl_creatinine/88.4)>=1.8 & (icu_bl_creatinine/88.4)<2.6 & icu_bl_creatinine~=. & icu_bl_age_days/(365.25/12)>=60 & icu_bl_age_days/(365.25/12)<144 & icu_bl_age_days~=.
replace icu_bl_creatinine_ps_pts=3 if (icu_bl_creatinine/88.4)>=2.9 & (icu_bl_creatinine/88.4)<4.2 & icu_bl_creatinine~=. & icu_bl_age_days/(365.25/12)>=144 & icu_bl_age_days/(365.25/12)<=216 & icu_bl_age_days~=.
replace icu_bl_creatinine_ps_pts=3 if (icu_bl_creatinine/88.4)>=3.5 & (icu_bl_creatinine/88.4)<5 & icu_bl_creatinine~=. & icu_bl_age_days/(365.25/12)>216 & icu_bl_age_days~=.

replace icu_bl_creatinine_ps_pts=4 if (icu_bl_creatinine/88.4)>=1.6 & icu_bl_creatinine~=. & icu_bl_age_days/(365.25/12)<1 & icu_bl_age_days~=.
replace icu_bl_creatinine_ps_pts=4 if (icu_bl_creatinine/88.4)>=1.2 & icu_bl_creatinine~=. & icu_bl_age_days/(365.25/12)>=1 & icu_bl_age_days/(365.25/12)<12 & icu_bl_age_days~=.
replace icu_bl_creatinine_ps_pts=4 if (icu_bl_creatinine/88.4)>=1.5 & icu_bl_creatinine~=. & icu_bl_age_days/(365.25/12)>=12 & icu_bl_age_days/(365.25/12)<24 & icu_bl_age_days~=.
replace icu_bl_creatinine_ps_pts=4 if (icu_bl_creatinine/88.4)>=2.3 & icu_bl_creatinine~=. & icu_bl_age_days/(365.25/12)>=24 & icu_bl_age_days/(365.25/12)<60 & icu_bl_age_days~=.
replace icu_bl_creatinine_ps_pts=4 if (icu_bl_creatinine/88.4)>=2.6 & icu_bl_creatinine~=. & icu_bl_age_days/(365.25/12)>=60 & icu_bl_age_days/(365.25/12)<144 & icu_bl_age_days~=.
replace icu_bl_creatinine_ps_pts=4 if (icu_bl_creatinine/88.4)>=4.2 & icu_bl_creatinine~=. & icu_bl_age_days/(365.25/12)>=144 & icu_bl_age_days/(365.25/12)<=216 & icu_bl_age_days~=.
replace icu_bl_creatinine_ps_pts=4 if (icu_bl_creatinine/88.4)>=5 & icu_bl_creatinine~=. & icu_bl_age_days/(365.25/12)>216 & icu_bl_age_days~=.

// Generate points for pao2/fio2 ratio - Assign a value of 0 where no value
gen icu_bl_pao2_fio2_ps_pts=0
replace icu_bl_pao2_fio2_ps_pts=1 if (icu_bl_pao2/icu_bl_bga_fio2)>=300  & (icu_bl_pao2/icu_bl_bga_fio2)<400 & icu_bl_pao2~=. & icu_bl_bga_fio2~=.
replace icu_bl_pao2_fio2_ps_pts=2 if (icu_bl_pao2/icu_bl_bga_fio2)>=200  & (icu_bl_pao2/icu_bl_bga_fio2)<300 & icu_bl_pao2~=. & icu_bl_bga_fio2~=.
replace icu_bl_pao2_fio2_ps_pts=3 if (icu_bl_pao2/icu_bl_bga_fio2)>=100  & (icu_bl_pao2/icu_bl_bga_fio2)<200 & icu_bl_pao2~=. & icu_bl_bga_fio2~=. & (icu_bl_inv==1 | icu_bl_niv==1) // do not include hfnc
replace icu_bl_pao2_fio2_ps_pts=4 if (icu_bl_pao2/icu_bl_bga_fio2)<100  & icu_bl_pao2~=. & icu_bl_bga_fio2~=. & (icu_bl_inv==1 | icu_bl_niv==1) // do not include hfnc

// Generate points for spo2/fio2 ratio - Only values of 97% were used in the calculation. Assign a value of 0 where no value
gen icu_bl_spo2_fio2_ps_pts=0
replace icu_bl_spo2_fio2_ps_pts=1 if (icu_bl_spo2/icu_bl_fio2)>=265  & (icu_bl_spo2/icu_bl_fio2)<292 & icu_bl_spo2~=. & icu_bl_spo2<=97 & icu_bl_fio2~=. 
replace icu_bl_spo2_fio2_ps_pts=2 if (icu_bl_spo2/icu_bl_fio2)>=221  & (icu_bl_spo2/icu_bl_fio2)<265 & icu_bl_spo2~=. & icu_bl_spo2<=97 & icu_bl_fio2~=. // appears to be a double up for the value of 264. score as 2
replace icu_bl_spo2_fio2_ps_pts=3 if (icu_bl_spo2/icu_bl_fio2)>=148  & (icu_bl_spo2/icu_bl_fio2)<221 & icu_bl_spo2~=. & icu_bl_spo2<=97 & icu_bl_fio2~=. & (icu_bl_inv==1 | icu_bl_niv==1) // do not include hfnc
replace icu_bl_spo2_fio2_ps_pts=4 if (icu_bl_spo2/icu_bl_fio2)<148  & icu_bl_spo2~=. & icu_bl_spo2<=97 & icu_bl_fio2~=. & (icu_bl_inv==1 | icu_bl_niv==1) // do not include hfnc

// Generate points for platelets - Assign a value of 0 where no value
gen icu_bl_plat_ps_pts=0
replace icu_bl_plat_ps_pts=1 if icu_bl_platelets>=100 & icu_bl_platelets<150 & icu_bl_platelets~=.
replace icu_bl_plat_ps_pts=2 if icu_bl_platelets>=50 & icu_bl_platelets<100 & icu_bl_platelets~=.
replace icu_bl_plat_ps_pts=3 if icu_bl_platelets>=20 & icu_bl_platelets<50 & icu_bl_platelets~=.
replace icu_bl_plat_ps_pts=4 if icu_bl_platelets<20 & icu_bl_platelets~=.

// Generate points for bilirubin - Bilirubin evaluated in mg/dL (divide by 17.104 to convert from micromol/L). Assign a value of 0 where no value
gen icu_bl_bili_ps_pts=0
replace icu_bl_bili_ps_pts=1 if (icu_bl_bilirubin/17.104)>=1.2 & (icu_bl_bilirubin/17.104)<2.0 & icu_bl_bilirubin~=.
replace icu_bl_bili_ps_pts=2 if (icu_bl_bilirubin/17.104)>=2.0 & (icu_bl_bilirubin/17.104)<6.0 & icu_bl_bilirubin~=.
replace icu_bl_bili_ps_pts=3 if (icu_bl_bilirubin/17.104)>=6.0 & (icu_bl_bilirubin/17.104)<12.0 & icu_bl_bilirubin~=.
replace icu_bl_bili_ps_pts=4 if (icu_bl_bilirubin/17.104)>=12.0 & (icu_bl_bilirubin/17.104)~=. // appears to be no score for bilirubin of 12. score as 4

/* Generate the pSOFA using pao2 score by summing points for all components */
egen icu_bl_psofa_pao2 = rowtotal(icu_bl_gcs_ps_pts icu_bl_map_ps_pts icu_bl_creatinine_ps_pts icu_bl_pao2_fio2_ps_pts icu_bl_plat_ps_pts icu_bl_bili_ps_pts)

/* Generate the pSOFA using spo2 score by summing points for all components */
egen icu_bl_psofa_spo2= rowtotal(icu_bl_gcs_ps_pts icu_bl_map_ps_pts icu_bl_creatinine_ps_pts icu_bl_spo2_fio2_ps_pts icu_bl_plat_ps_pts icu_bl_bili_ps_pts)

/* Generate the combined pSOFA score by using the pSOFA score which uses the pao2/fio2 points if pao2 and bga fio2 are avaialble, otherwise the pSOFA score which uses the spo2/fio2 points */
gen icu_bl_psofa_comb=icu_bl_psofa_pao2 if icu_bl_pao2~=. & icu_bl_bga_fio2~=.
replace icu_bl_psofa_comb=icu_bl_psofa_spo2 if icu_bl_pao2==.

