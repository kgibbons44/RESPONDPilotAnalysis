/**** PELOD-2 Syntax ****/

/**ED baseline**/

// Set values of 4444, 5555, 9999 to missing for relevant variables 
mvdecode ed_bl_gcs ed_bl_pupil_fix ed_bl_lactate ed_bl_mbp ed_bl_creatinine ed_bl_pao2 ed_bl_bga_fio2 ed_bl_paco2 ed_bl_wcc ed_bl_platelets, mv(9999=.\ 4444=.\ 5555=.)

// Generate age in days at ED baseline
gen ed_bl_age_days=dofc(ed_bl_obs_dt)- (dem_dob)

// Generate points for glasgow coma scale - use the AVPU score which has an equivalent gcs value if the gcs score is not available. Assign a value of 0 where no value
gen ed_bl_gcs_pl_pts=0
replace ed_bl_gcs_pl_pts=1 if (ed_bl_gcs>=5 & ed_bl_gcs<11 & ed_bl_gcs~=.) | (ed_bl_avpu==8 & ed_bl_gcs==.) | (ed_bl_avpu==6 & ed_bl_gcs==.)
replace ed_bl_gcs_pl_pts=4 if ed_bl_gcs>=3 & ed_bl_gcs<5 & ed_bl_gcs~=.

// Generate points for pupils - Assign a value of 0 where no value
gen ed_bl_pupil_pl_pts=0
replace ed_bl_pupil_pl_pts=5 if ed_bl_pupil_fix==1

// Generate points for lactate - Assign a value of 0 where no value
gen ed_bl_lactate_pl_pts=0
replace ed_bl_lactate_pl_pts=1 if ed_bl_lactate>=5 & ed_bl_lactate<11 & ed_bl_lactate~=.
replace ed_bl_lactate_pl_pts=4 if ed_bl_lactate>=11 & ed_bl_lactate~=.

// Generate points for mean arterial pressure - Assign a value of 0 where no value
gen ed_bl_map_pl_pts=0
replace ed_bl_map_pl_pts=2 if ed_bl_mbp>=31 & ed_bl_mbp<46 & ed_bl_mbp~=. & ed_bl_age_days/(365.25/12)<1 & ed_bl_age_days~=.
replace ed_bl_map_pl_pts=2 if ed_bl_mbp>=39 & ed_bl_mbp<55 & ed_bl_mbp~=. & ed_bl_age_days/(365.25/12)>=1 & ed_bl_age_days/(365.25/12)<12 & ed_bl_age_days~=.
replace ed_bl_map_pl_pts=2 if ed_bl_mbp>=44 & ed_bl_mbp<60 & ed_bl_mbp~=. & ed_bl_age_days/(365.25/12)>=12 & ed_bl_age_days/(365.25/12)<24 & ed_bl_age_days~=.
replace ed_bl_map_pl_pts=2 if ed_bl_mbp>=46 & ed_bl_mbp<62 & ed_bl_mbp~=. & ed_bl_age_days/(365.25/12)>=24 & ed_bl_age_days/(365.25/12)<60 & ed_bl_age_days~=.
replace ed_bl_map_pl_pts=2 if ed_bl_mbp>=49 & ed_bl_mbp<65 & ed_bl_mbp~=. & ed_bl_age_days/(365.25/12)>=60 & ed_bl_age_days/(365.25/12)<144 & ed_bl_age_days~=.
replace ed_bl_map_pl_pts=2 if ed_bl_mbp>=52 & ed_bl_mbp<67 & ed_bl_mbp~=. & ed_bl_age_days/(365.25/12)>=144 & ed_bl_age_days~=.

replace ed_bl_map_pl_pts=3 if ed_bl_mbp>=17 & ed_bl_mbp<31 & ed_bl_mbp~=. & ed_bl_age_days/(365.25/12)<1 & ed_bl_age_days~=.
replace ed_bl_map_pl_pts=3 if ed_bl_mbp>=25 & ed_bl_mbp<39 & ed_bl_mbp~=. & ed_bl_age_days/(365.25/12)>=1 & ed_bl_age_days/(365.25/12)<12 & ed_bl_age_days~=.
replace ed_bl_map_pl_pts=3 if ed_bl_mbp>=31 & ed_bl_mbp<44 & ed_bl_mbp~=. & ed_bl_age_days/(365.25/12)>=12 & ed_bl_age_days/(365.25/12)<24 & ed_bl_age_days~=.
replace ed_bl_map_pl_pts=3 if ed_bl_mbp>=32 & ed_bl_mbp<46 & ed_bl_mbp~=. & ed_bl_age_days/(365.25/12)>=24 & ed_bl_age_days/(365.25/12)<60 & ed_bl_age_days~=. // appears to be a no score for mbp 45 in this age range. score as 3
replace ed_bl_map_pl_pts=3 if ed_bl_mbp>=36 & ed_bl_mbp<49 & ed_bl_mbp~=. & ed_bl_age_days/(365.25/12)>=60 & ed_bl_age_days/(365.25/12)<144 & ed_bl_age_days~=.
replace ed_bl_map_pl_pts=3 if ed_bl_mbp>=38 & ed_bl_mbp<52 & ed_bl_mbp~=. & ed_bl_age_days/(365.25/12)>=144 & ed_bl_age_days~=.

replace ed_bl_map_pl_pts=6 if ed_bl_mbp<=16 & ed_bl_mbp~=. & ed_bl_age_days/(365.25/12)<1 & ed_bl_age_days~=.
replace ed_bl_map_pl_pts=6 if ed_bl_mbp<=24 & ed_bl_mbp~=. & ed_bl_age_days/(365.25/12)>=1 & ed_bl_age_days/(365.25/12)<12 & ed_bl_age_days~=.
replace ed_bl_map_pl_pts=6 if ed_bl_mbp<=30 & ed_bl_mbp~=. & ed_bl_age_days/(365.25/12)>=12 & ed_bl_age_days/(365.25/12)<24 & ed_bl_age_days~=.
replace ed_bl_map_pl_pts=6 if ed_bl_mbp<=31 & ed_bl_mbp~=. & ed_bl_age_days/(365.25/12)>=24 & ed_bl_age_days/(365.25/12)<60 & ed_bl_age_days~=.
replace ed_bl_map_pl_pts=6 if ed_bl_mbp<=35 & ed_bl_mbp~=. & ed_bl_age_days/(365.25/12)>=60 & ed_bl_age_days/(365.25/12)<144 & ed_bl_age_days~=.
replace ed_bl_map_pl_pts=6 if ed_bl_mbp<=37 & ed_bl_mbp~=. & ed_bl_age_days/(365.25/12)>=144 & ed_bl_age_days~=.

// Generate points for creatinine - Assign a value of 0 where no value
gen ed_bl_creatinine_pl_pts=0
replace ed_bl_creatinine_pl_pts=2 if ed_bl_creatinine>=70 & ed_bl_creatinine~=. & ed_bl_age_days/(365.25/12)<1 & ed_bl_age_days~=.
replace ed_bl_creatinine_pl_pts=2 if ed_bl_creatinine>=23 & ed_bl_creatinine~=. & ed_bl_age_days/(365.25/12)>=1 & ed_bl_age_days/(365.25/12)<12 & ed_bl_age_days~=.
replace ed_bl_creatinine_pl_pts=2 if ed_bl_creatinine>=35 & ed_bl_creatinine~=. & ed_bl_age_days/(365.25/12)>=12 & ed_bl_age_days/(365.25/12)<24 & ed_bl_age_days~=.
replace ed_bl_creatinine_pl_pts=2 if ed_bl_creatinine>=51 & ed_bl_creatinine~=. & ed_bl_age_days/(365.25/12)>=24 & ed_bl_age_days/(365.25/12)<60 & ed_bl_age_days~=.
replace ed_bl_creatinine_pl_pts=2 if ed_bl_creatinine>=59 & ed_bl_creatinine~=. & ed_bl_age_days/(365.25/12)>=60 & ed_bl_age_days/(365.25/12)<144 & ed_bl_age_days~=.
replace ed_bl_creatinine_pl_pts=2 if ed_bl_creatinine>=93 & ed_bl_creatinine~=. & ed_bl_age_days/(365.25/12)>=144 & ed_bl_age_days~=.

// Generate points for pao2/fio2 ratio - Assign a value of 0 where no value
gen ed_bl_pao2_fio2_pl_pts=0
replace ed_bl_pao2_fio2_pl_pts=2 if (ed_bl_pao2/ed_bl_bga_fio2)<=60 & ed_bl_pao2~=. & ed_bl_bga_fio2~=.

// Generate points for paco2 - Assign a value of 0 where no value
gen ed_bl_paco2_pl_pts=0
replace ed_bl_paco2_pl_pts=1 if ed_bl_paco2>=59 & ed_bl_paco2<95 & ed_bl_paco2~=.
replace ed_bl_paco2_pl_pts=3 if ed_bl_paco2>=95 & ed_bl_paco2~=.

// Generate points for invasive ventilation - Assign a value of 0 where no value
gen ed_bl_iv_pl_pts=0
replace ed_bl_iv_pl_pts=3 if ed_bl_inv==1

// Generate points for white cell count - Assign a value of 0 where no value
gen ed_bl_wcc_pl_pts=0
replace ed_bl_wcc_pl_pts=2 if ed_bl_wcc<=2 & ed_bl_wcc~=.

// Generate points for platelets - Assign a value of 0 where no value
gen ed_bl_plat_pl_pts=0
replace ed_bl_plat_pl_pts=1 if ed_bl_platelets>=77 & ed_bl_platelets<142 & ed_bl_platelets~=.
replace ed_bl_plat_pl_pts=2 if ed_bl_platelets<=76 & ed_bl_platelets~=.

/* Generate the PELOD-2 score by summing points for all components */
egen ed_bl_pelod2 = rowtotal(ed_bl_gcs_pl_pts ed_bl_pupil_pl_pts ed_bl_lactate_pl_pts ed_bl_map_pl_pts ed_bl_creatinine_pl_pts ed_bl_pao2_fio2_pl_pts ed_bl_paco2_pl_pts ed_bl_iv_pl_pts ed_bl_wcc_pl_pts ed_bl_plat_pl_pts)




/**** pSOFA Syntax ****/

/**ED baseline*/

// Set values of 4444, 5555, 9999 to missing for relevant variables 
mvdecode ed_bl_gcs  ed_bl_mbp ed_bl_creatinine ed_bl_pao2 ed_bl_bga_fio2 ed_bl_platelets ed_bl_bilirubin ed_bl_spo2 ed_bl_fio2 , mv(9999=.\ 4444=.\ 5555=.)

// Generate points for glasgow coma scale - use the AVPU score which has an equivalent gcs value if the gcs score is not available. Assign a value of 0 where no value
gen ed_bl_gcs_ps_pts=0
replace ed_bl_gcs_ps_pts=1 if (ed_bl_gcs>=13 & ed_bl_gcs<15 & ed_bl_gcs~=.) | (ed_bl_avpu==13 & ed_bl_gcs==.) 
replace ed_bl_gcs_ps_pts=2 if ed_bl_gcs>=10 & ed_bl_gcs<13 & ed_bl_gcs~=.
replace ed_bl_gcs_ps_pts=3 if (ed_bl_gcs>=6 & ed_bl_gcs<10 & ed_bl_gcs~=.) | (ed_bl_avpu==8 & ed_bl_gcs==.) | (ed_bl_avpu==6 & ed_bl_gcs==.)
replace ed_bl_gcs_ps_pts=4 if ed_bl_gcs<6 & ed_bl_gcs~=.

// Generate points for mean arterial pressure (no baseline inotropes for ed. have used the values recorded at the 0-20min timepoint)- Assign a value of 0 where no value
gen ed_bl_map_ps_pts=0
replace ed_bl_map_ps_pts=1 if ed_bl_mbp<46 & ed_bl_mbp~=. & ed_bl_age_days/(365.25/12)<1 & ed_bl_age_days~=.
replace ed_bl_map_ps_pts=1 if ed_bl_mbp<55 & ed_bl_mbp~=. & ed_bl_age_days/(365.25/12)>=1 & ed_bl_age_days/(365.25/12)<12 & ed_bl_age_days~=.
replace ed_bl_map_ps_pts=1 if ed_bl_mbp<60 & ed_bl_mbp~=. & ed_bl_age_days/(365.25/12)>=12 & ed_bl_age_days/(365.25/12)<24 & ed_bl_age_days~=.
replace ed_bl_map_ps_pts=1 if ed_bl_mbp<62 & ed_bl_mbp~=. & ed_bl_age_days/(365.25/12)>=24 & ed_bl_age_days/(365.25/12)<60 & ed_bl_age_days~=.
replace ed_bl_map_ps_pts=1 if ed_bl_mbp<65 & ed_bl_mbp~=. & ed_bl_age_days/(365.25/12)>=60 & ed_bl_age_days/(365.25/12)<144 & ed_bl_age_days~=.
replace ed_bl_map_ps_pts=1 if ed_bl_mbp<67 & ed_bl_mbp~=. & ed_bl_age_days/(365.25/12)>=144 & ed_bl_age_days/(365.25/12)<=216 & ed_bl_age_days~=.
replace ed_bl_map_ps_pts=1 if ed_bl_mbp<70 & ed_bl_mbp~=. & ed_bl_age_days/(365.25/12)>216 & ed_bl_age_days~=.

replace ed_bl_map_ps_pts=2 if (ed_obs_dopa1>0 & ed_obs_dopa1<=5 & ed_obs_dopa1~=.) | (ed_obs_dobu1>0 & ed_obs_dobu1~=.)
replace ed_bl_map_ps_pts=3 if (ed_obs_dopa1>5 & ed_obs_dopa1~=.) | (ed_obs_adren1>0 & ed_obs_adren1<=0.1 & ed_obs_adren1~=.) | (ed_obs_norad1>0 & ed_obs_norad1<=0.1 & ed_obs_norad1~=.)
replace ed_bl_map_ps_pts=4 if (ed_obs_dopa1>15 & ed_obs_dopa1~=.) | (ed_obs_adren1>0.1 & ed_obs_adren1~=.) | (ed_obs_norad1>0.1 & ed_obs_norad1~=.)

// Generate points for creatinine - creatinine evaluated in mg/dL (divide by 88.4 to convert from micromol/L). Assign a value of 0 where no value
gen ed_bl_creatinine_ps_pts=0
replace ed_bl_creatinine_ps_pts=1 if (ed_bl_creatinine/88.4)>=0.8 & (ed_bl_creatinine/88.4)<1.0 & ed_bl_creatinine~=. & ed_bl_age_days/(365.25/12)<1 & ed_bl_age_days~=.
replace ed_bl_creatinine_ps_pts=1 if (ed_bl_creatinine/88.4)>=0.3 & (ed_bl_creatinine/88.4)<0.5 & ed_bl_creatinine~=. & ed_bl_age_days/(365.25/12)>=1 & ed_bl_age_days/(365.25/12)<12 & ed_bl_age_days~=.
replace ed_bl_creatinine_ps_pts=1 if (ed_bl_creatinine/88.4)>=0.4 & (ed_bl_creatinine/88.4)<0.6 & ed_bl_creatinine~=. & ed_bl_age_days/(365.25/12)>=12 & ed_bl_age_days/(365.25/12)<24 & ed_bl_age_days~=.
replace ed_bl_creatinine_ps_pts=1 if (ed_bl_creatinine/88.4)>=0.6 & (ed_bl_creatinine/88.4)<0.9 & ed_bl_creatinine~=. & ed_bl_age_days/(365.25/12)>=24 & ed_bl_age_days/(365.25/12)<60 & ed_bl_age_days~=.
replace ed_bl_creatinine_ps_pts=1 if (ed_bl_creatinine/88.4)>=0.7 & (ed_bl_creatinine/88.4)<1.1 & ed_bl_creatinine~=. & ed_bl_age_days/(365.25/12)>=60 & ed_bl_age_days/(365.25/12)<144 & ed_bl_age_days~=.
replace ed_bl_creatinine_ps_pts=1 if (ed_bl_creatinine/88.4)>=1.0 & (ed_bl_creatinine/88.4)<1.7 & ed_bl_creatinine~=. & ed_bl_age_days/(365.25/12)>=144 & ed_bl_age_days/(365.25/12)<=216 & ed_bl_age_days~=.
replace ed_bl_creatinine_ps_pts=1 if (ed_bl_creatinine/88.4)>=1.2 & (ed_bl_creatinine/88.4)<2.0 & ed_bl_creatinine~=. & ed_bl_age_days/(365.25/12)>216 & ed_bl_age_days~=.

replace ed_bl_creatinine_ps_pts=2 if (ed_bl_creatinine/88.4)>=1.0 & (ed_bl_creatinine/88.4)<1.2 & ed_bl_creatinine~=. & ed_bl_age_days/(365.25/12)<1 & ed_bl_age_days~=.
replace ed_bl_creatinine_ps_pts=2 if (ed_bl_creatinine/88.4)>=0.5 & (ed_bl_creatinine/88.4)<0.8 & ed_bl_creatinine~=. & ed_bl_age_days/(365.25/12)>=1 & ed_bl_age_days/(365.25/12)<12 & ed_bl_age_days~=.
replace ed_bl_creatinine_ps_pts=2 if (ed_bl_creatinine/88.4)>=0.6 & (ed_bl_creatinine/88.4)<1.1 & ed_bl_creatinine~=. & ed_bl_age_days/(365.25/12)>=12 & ed_bl_age_days/(365.25/12)<24 & ed_bl_age_days~=.
replace ed_bl_creatinine_ps_pts=2 if (ed_bl_creatinine/88.4)>=0.9 & (ed_bl_creatinine/88.4)<1.6 & ed_bl_creatinine~=. & ed_bl_age_days/(365.25/12)>=24 & ed_bl_age_days/(365.25/12)<60 & ed_bl_age_days~=.
replace ed_bl_creatinine_ps_pts=2 if (ed_bl_creatinine/88.4)>=1.1 & (ed_bl_creatinine/88.4)<1.8 & ed_bl_creatinine~=. & ed_bl_age_days/(365.25/12)>=60 & ed_bl_age_days/(365.25/12)<144 & ed_bl_age_days~=.
replace ed_bl_creatinine_ps_pts=2 if (ed_bl_creatinine/88.4)>=1.7 & (ed_bl_creatinine/88.4)<2.9 & ed_bl_creatinine~=. & ed_bl_age_days/(365.25/12)>=144 & ed_bl_age_days/(365.25/12)<=216 & ed_bl_age_days~=.
replace ed_bl_creatinine_ps_pts=2 if (ed_bl_creatinine/88.4)>=2.0 & (ed_bl_creatinine/88.4)<3.5 & ed_bl_creatinine~=. & ed_bl_age_days/(365.25/12)>216 & ed_bl_age_days~=.

replace ed_bl_creatinine_ps_pts=3 if (ed_bl_creatinine/88.4)>=1.2 & (ed_bl_creatinine/88.4)<1.6 & ed_bl_creatinine~=. & ed_bl_age_days/(365.25/12)<1 & ed_bl_age_days~=.
replace ed_bl_creatinine_ps_pts=3 if (ed_bl_creatinine/88.4)>=0.8 & (ed_bl_creatinine/88.4)<1.2 & ed_bl_creatinine~=. & ed_bl_age_days/(365.25/12)>=1 & ed_bl_age_days/(365.25/12)<12 & ed_bl_age_days~=.
replace ed_bl_creatinine_ps_pts=3 if (ed_bl_creatinine/88.4)>=1.1 & (ed_bl_creatinine/88.4)<1.5 & ed_bl_creatinine~=. & ed_bl_age_days/(365.25/12)>=12 & ed_bl_age_days/(365.25/12)<24 & ed_bl_age_days~=.
replace ed_bl_creatinine_ps_pts=3 if (ed_bl_creatinine/88.4)>=1.6 & (ed_bl_creatinine/88.4)<2.3 & ed_bl_creatinine~=. & ed_bl_age_days/(365.25/12)>=24 & ed_bl_age_days/(365.25/12)<60 & ed_bl_age_days~=.
replace ed_bl_creatinine_ps_pts=3 if (ed_bl_creatinine/88.4)>=1.8 & (ed_bl_creatinine/88.4)<2.6 & ed_bl_creatinine~=. & ed_bl_age_days/(365.25/12)>=60 & ed_bl_age_days/(365.25/12)<144 & ed_bl_age_days~=.
replace ed_bl_creatinine_ps_pts=3 if (ed_bl_creatinine/88.4)>=2.9 & (ed_bl_creatinine/88.4)<4.2 & ed_bl_creatinine~=. & ed_bl_age_days/(365.25/12)>=144 & ed_bl_age_days/(365.25/12)<=216 & ed_bl_age_days~=.
replace ed_bl_creatinine_ps_pts=3 if (ed_bl_creatinine/88.4)>=3.5 & (ed_bl_creatinine/88.4)<5 & ed_bl_creatinine~=. & ed_bl_age_days/(365.25/12)>216 & ed_bl_age_days~=.

replace ed_bl_creatinine_ps_pts=4 if (ed_bl_creatinine/88.4)>=1.6 & ed_bl_creatinine~=. & ed_bl_age_days/(365.25/12)<1 & ed_bl_age_days~=.
replace ed_bl_creatinine_ps_pts=4 if (ed_bl_creatinine/88.4)>=1.2 & ed_bl_creatinine~=. & ed_bl_age_days/(365.25/12)>=1 & ed_bl_age_days/(365.25/12)<12 & ed_bl_age_days~=.
replace ed_bl_creatinine_ps_pts=4 if (ed_bl_creatinine/88.4)>=1.5 & ed_bl_creatinine~=. & ed_bl_age_days/(365.25/12)>=12 & ed_bl_age_days/(365.25/12)<24 & ed_bl_age_days~=.
replace ed_bl_creatinine_ps_pts=4 if (ed_bl_creatinine/88.4)>=2.3 & ed_bl_creatinine~=. & ed_bl_age_days/(365.25/12)>=24 & ed_bl_age_days/(365.25/12)<60 & ed_bl_age_days~=.
replace ed_bl_creatinine_ps_pts=4 if (ed_bl_creatinine/88.4)>=2.6 & ed_bl_creatinine~=. & ed_bl_age_days/(365.25/12)>=60 & ed_bl_age_days/(365.25/12)<144 & ed_bl_age_days~=.
replace ed_bl_creatinine_ps_pts=4 if (ed_bl_creatinine/88.4)>=4.2 & ed_bl_creatinine~=. & ed_bl_age_days/(365.25/12)>=144 & ed_bl_age_days/(365.25/12)<=216 & ed_bl_age_days~=.
replace ed_bl_creatinine_ps_pts=4 if (ed_bl_creatinine/88.4)>=5 & ed_bl_creatinine~=. & ed_bl_age_days/(365.25/12)>216 & ed_bl_age_days~=.

// Generate points for pao2/fio2 ratio - Assign a value of 0 where no value
gen ed_bl_pao2_fio2_ps_pts=0
replace ed_bl_pao2_fio2_ps_pts=1 if (ed_bl_pao2/ed_bl_bga_fio2)>=300  & (ed_bl_pao2/ed_bl_bga_fio2)<400 & ed_bl_pao2~=. & ed_bl_bga_fio2~=.
replace ed_bl_pao2_fio2_ps_pts=2 if (ed_bl_pao2/ed_bl_bga_fio2)>=200  & (ed_bl_pao2/ed_bl_bga_fio2)<300 & ed_bl_pao2~=. & ed_bl_bga_fio2~=.
replace ed_bl_pao2_fio2_ps_pts=3 if (ed_bl_pao2/ed_bl_bga_fio2)>=100  & (ed_bl_pao2/ed_bl_bga_fio2)<200 & ed_bl_pao2~=. & ed_bl_bga_fio2~=. & (ed_bl_inv==1 | ed_bl_niv==1) // do not include hfnc
replace ed_bl_pao2_fio2_ps_pts=4 if (ed_bl_pao2/ed_bl_bga_fio2)<100  & ed_bl_pao2~=. & ed_bl_bga_fio2~=. & (ed_bl_inv==1 | ed_bl_niv==1) // do not include hfnc

// Generate points for spo2/fio2 ratio - Only values of 97% were used in the calculation. Assign a value of 0 where no value
gen ed_bl_spo2_fio2_ps_pts=0
replace ed_bl_spo2_fio2_ps_pts=1 if (ed_bl_spo2/ed_bl_fio2)>=265  & (ed_bl_spo2/ed_bl_fio2)<292 & ed_bl_spo2~=. & ed_bl_spo2<=97 & ed_bl_fio2~=. 
replace ed_bl_spo2_fio2_ps_pts=2 if (ed_bl_spo2/ed_bl_fio2)>=221  & (ed_bl_spo2/ed_bl_fio2)<265 & ed_bl_spo2~=. & ed_bl_spo2<=97 & ed_bl_fio2~=. // appears to be a double up for the value of 264. score as 2
replace ed_bl_spo2_fio2_ps_pts=3 if (ed_bl_spo2/ed_bl_fio2)>=148  & (ed_bl_spo2/ed_bl_fio2)<221 & ed_bl_spo2~=. & ed_bl_spo2<=97 & ed_bl_fio2~=. & (ed_bl_inv==1 | ed_bl_niv==1) // do not include hfnc
replace ed_bl_spo2_fio2_ps_pts=4 if (ed_bl_spo2/ed_bl_fio2)<148  & ed_bl_spo2~=. & ed_bl_spo2<=97 & ed_bl_fio2~=. & (ed_bl_inv==1 | ed_bl_niv==1) // do not include hfnc

// Generate points for platelets - Assign a value of 0 where no value
gen ed_bl_plat_ps_pts=0
replace ed_bl_plat_ps_pts=1 if ed_bl_platelets>=100 & ed_bl_platelets<150 & ed_bl_platelets~=.
replace ed_bl_plat_ps_pts=2 if ed_bl_platelets>=50 & ed_bl_platelets<100 & ed_bl_platelets~=.
replace ed_bl_plat_ps_pts=3 if ed_bl_platelets>=20 & ed_bl_platelets<50 & ed_bl_platelets~=.
replace ed_bl_plat_ps_pts=4 if ed_bl_platelets<20 & ed_bl_platelets~=.

// Generate points for bilirubin - Bilirubin evaluated in mg/dL (divide by 17.104 to convert from micromol/L). Assign a value of 0 where no value
gen ed_bl_bili_ps_pts=0
replace ed_bl_bili_ps_pts=1 if (ed_bl_bilirubin/17.104)>=1.2 & (ed_bl_bilirubin/17.104)<2.0 & ed_bl_bilirubin~=.
replace ed_bl_bili_ps_pts=2 if (ed_bl_bilirubin/17.104)>=2.0 & (ed_bl_bilirubin/17.104)<6.0 & ed_bl_bilirubin~=.
replace ed_bl_bili_ps_pts=3 if (ed_bl_bilirubin/17.104)>=6.0 & (ed_bl_bilirubin/17.104)<12.0 & ed_bl_bilirubin~=.
replace ed_bl_bili_ps_pts=4 if (ed_bl_bilirubin/17.104)>=12.0 & (ed_bl_bilirubin/17.104)~=. // appears to be no score for bilirubin of 12. score as 4

/* Generate the pSOFA using pao2 score by summing points for all components */
egen ed_bl_psofa_pao2 = rowtotal(ed_bl_gcs_ps_pts ed_bl_map_ps_pts ed_bl_creatinine_ps_pts ed_bl_pao2_fio2_ps_pts ed_bl_plat_ps_pts ed_bl_bili_ps_pts)

/* Generate the pSOFA using spo2 score by summing points for all components */
egen ed_bl_psofa_spo2= rowtotal(ed_bl_gcs_ps_pts ed_bl_map_ps_pts ed_bl_creatinine_ps_pts ed_bl_spo2_fio2_ps_pts ed_bl_plat_ps_pts ed_bl_bili_ps_pts)

/* Generate the combined pSOFA score by using the pSOFA score which uses the pao2/fio2 points if pao2 and bga fio2 are avaialble, otherwise the pSOFA score which uses the spo2/fio2 points */
gen ed_bl_psofa_comb=ed_bl_psofa_pao2 if ed_bl_pao2~=. & ed_bl_bga_fio2~=.
replace ed_bl_psofa_comb=ed_bl_psofa_spo2 if ed_bl_pao2==.

