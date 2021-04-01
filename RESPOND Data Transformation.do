/**** RESPOND PILOT DATA TRANSFORMATION ****/
/**** Prepared by: Kristen Gibbons ****/
/**** Date initialised: 22/01/2020 ****/
/**** Purpose: Analysis of the RESPOND PICU pilot data for the MRFF grant round ****/

/** Transform the data so it's all on one row **/
describe, fullnames
sort record_id redcap_event_name
/// drop test DAG
drop if redcap_data_access_group=="xtest"
save "OutputData\respond0.dta", replace
/// Keep event: respond_ed_arm_1 - initial observations
use "OutputData\respond0.dta", clear
tab redcap_event_name ed_scn_pt_eligibility_calc, m
tab redcap_event_name ed_scn_pt_eligibility_calc
keep if ( redcap_event_name == "respond_ed_arm_1" & redcap_repeat_instrument=="" )
keep if ( ed_scn_dt~=. )
tab redcap_event_name ed_scn_pt_eligibility_calc, m
tab redcap_event_name ed_scn_pt_eligibility_calc
// Keep variables
describe record_id redcap_event_name ed_scn_dt-respond_ed_study_tre_v_0, full
keep record_id redcap_event_name ed_scn_dt-respond_ed_study_tre_v_0
gen ed_scn_indata=1
sort record_id
save "OutputData\ed_scn0.dta", replace
/// Keep event: respond_ed_arm_1 - repeat observations
use "OutputData\respond0.dta", clear
tab redcap_event_name ed_obs_tp, m
tab redcap_event_name ed_obs_tp
keep if ( redcap_event_name == "respond_ed_arm_1" & redcap_repeat_instrument=="respond_ed_first_24_hrs_observations" )
keep if ( ed_obs_tp~=. )
tab redcap_repeat_instance ed_obs_tp, m
tab redcap_repeat_instance ed_obs_tp
// Keep variables
describe record_id redcap_event_name redcap_repeat_instance ed_obs_tp-respond_ed_first_24__v_1, full
keep record_id redcap_event_name redcap_repeat_instance ed_obs_tp-respond_ed_first_24__v_1
// Reshape the data
reshape wide ed_obs_tp-respond_ed_first_24__v_1, i(record_id) j(redcap_repeat_instance)
gen ed_24h_indata=1
sort record_id
save "OutputData\ed_24h0.dta", replace
/// Keep event: shared_respond_for_arm_1 - initial observations
use "OutputData\respond0.dta", clear
tab redcap_event_name bio_sample_yn, m
tab redcap_event_name bio_sample_yn
tab redcap_event_name dem_hosp_adm_source, m
tab redcap_event_name dem_hosp_adm_source
keep if ( redcap_event_name == "shared_respond_for_arm_1" & redcap_repeat_instrument=="" )
keep if ( demographics_complete~=. )
tab redcap_event_name demographics_complete, m
tab redcap_event_name demographics_complete
tab redcap_event_name demographics_complete, m
tab redcap_event_name demographics_complete
// Keep variables
describe record_id redcap_event_name redcap_data_access_group dem_pgci_yn-sepsis_source_complete out_inv-withdrawal_of_consen_v_27, full
keep record_id redcap_event_name redcap_data_access_group dem_pgci_yn-sepsis_source_complete out_inv-withdrawal_of_consen_v_27
gen shared_indata=1
sort record_id
save "OutputData\shared0.dta", replace
/// Keep event: shared_respond_for_arm_1 - repeat observations
use "OutputData\respond0.dta", clear
tab redcap_event_name if dod_dt~=., m
keep if ( redcap_event_name == "shared_respond_for_arm_1" & redcap_repeat_instrument=="daily_organ_dysfunction_data" )
keep if ( dod_dt~=. )
tab redcap_repeat_instance if dod_dt~=., m
// Keep variables
describe record_id redcap_event_name redcap_repeat_instance dod_dt-daily_organ_dysfunct_v_26, full
keep record_id redcap_event_name redcap_repeat_instance dod_dt-daily_organ_dysfunct_v_26
// Reshape the data
reshape wide dod_dt-daily_organ_dysfunct_v_26, i(record_id) j(redcap_repeat_instance)
gen shared_dod_indata=1
sort record_id
save "OutputData\shared_dod0.dta", replace
/// Keep event: respond_picu_arm_1 - initial observations
use "OutputData\respond0.dta", clear
tab redcap_event_name icu_scn_pt_eligibility_calc, m
tab redcap_event_name icu_scn_pt_eligibility_calc
keep if ( redcap_event_name == "respond_picu_arm_1" & redcap_repeat_instrument=="" )
keep if ( icu_scn_dt~=. )
tab redcap_event_name icu_scn_pt_eligibility_calc, m
tab redcap_event_name icu_scn_pt_eligibility_calc
// Keep variables
describe record_id redcap_event_name icu_scn_dt-respond_picu_study_t_v_24, full
keep record_id redcap_event_name icu_scn_dt-respond_picu_study_t_v_24
gen icu_scn_indata=1
sort record_id
save "OutputData\icu_scn0.dta", replace
/// Keep event: respond_picu_arm_1 - repeat observations
use "OutputData\respond0.dta", clear
tab redcap_event_name icu_obs_tp, m
tab redcap_event_name icu_obs_tp
keep if ( redcap_event_name == "respond_picu_arm_1" & redcap_repeat_instrument=="respond_picu_first_24_hrs_observations" )
keep if ( icu_obs_tp~=. )
tab redcap_repeat_instance icu_obs_tp, m
// Keep variables
describe record_id redcap_event_name redcap_repeat_instance icu_obs_tp-respond_picu_first_2_v_25, full
keep record_id redcap_event_name redcap_repeat_instance icu_obs_tp-respond_picu_first_2_v_25
// Reshape the data
reshape wide icu_obs_tp-respond_picu_first_2_v_25, i(record_id) j(redcap_repeat_instance)
gen icu_24h_indata=1
sort record_id
save "OutputData\icu_24h0.dta", replace
/// Keep event: reporting_aes_arm_1
use "OutputData\respond0.dta", clear
tab redcap_event_name ae_yn, m
keep if ( redcap_event_name == "reporting_aes_arm_1" & redcap_repeat_instrument=="" )
keep if ( ae_yn~=. )
tab redcap_event_name ae_yn, m
// Keep variables
describe record_id redcap_event_name ae_yn-adverse_events_manag_v_33, full
keep record_id redcap_repeat_instance redcap_event_name ae_yn-adverse_events_manag_v_33
// Save a version in long format
preserve
sort record_id
save "OutputData\ae_long0.dta", replace
restore
// Reshape the data
reshape wide ae_yn-adverse_events_manag_v_33, i(record_id) j(redcap_repeat_instance)
gen ae_indata=1
sort record_id	
save "OutputData\ae0.dta", replace
/// Keep event: reporting_pds_arm_1
use "OutputData\respond0.dta", clear
tab redcap_event_name pdf_yn, m
keep if ( redcap_event_name == "reporting_pds_arm_1" & redcap_repeat_instrument=="" )
keep if ( pdf_yn~=. )
tab redcap_event_name pdf_yn, m
// Keep variables
describe record_id redcap_event_name pdf_yn-protocol_deviations__v_32, full
keep record_id redcap_event_name pdf_yn-protocol_deviations__v_32
/* Keep this commented out, but uncomment if there are repeating PDs
// Save a version in long format
preserve
sort record_id
save "OutputData\pd_long0.dta", replace
restore
// Reshape the data
reshape wide pd_yn-protocol_deviations__v_27, i(record_id) j(redcap_repeat_instance)*/
gen pd_indata=1
sort record_id
save "OutputData\pd0.dta", replace
/// Keep event: follow_up_arm_1 - 6 month follow-up
use "OutputData\respond0.dta", clear
tab redcap_event_name fu_6m_completed, m
tab redcap_event_name fu_6m_completed
keep if ( redcap_event_name == "follow_up_arm_1" & redcap_repeat_instrument=="" )
keep if ( fu_6m_completed~=. )
tab redcap_event_name fu_6m_completed, m
tab redcap_event_name fu_6m_completed
// Keep variables
describe record_id redcap_event_name fu_6m_completed-follow_up_6_month_complete, full
keep record_id redcap_event_name fu_6m_completed-follow_up_6_month_complete
gen fup_6m_indata=1
sort record_id
save "OutputData\fu_6m0.dta", replace
/// Merge all the files together
use "OutputData\ed_scn0.dta", clear
merge 1:1 record_id using "OutputData\ed_24h0.dta"
drop _merge
merge 1:1 record_id using "OutputData\shared0.dta"
drop _merge
merge 1:1 record_id using "OutputData\shared_dod0.dta"
drop _merge
merge 1:1 record_id using "OutputData\icu_scn0.dta"
drop _merge
merge 1:1 record_id using "OutputData\icu_24h0.dta"
drop _merge
merge 1:1 record_id using "OutputData\ae0.dta"
drop _merge
merge 1:1 record_id using "OutputData\pd0.dta"
drop _merge
merge 1:1 record_id using "OutputData\fu_6m0.dta"
drop _merge
save "RESPOND.dta", replace
/// Merge the ED randomisation group onto the adverse events long format file
use "OutputData\ae_long0.dta", clear
sort record_id
merge m:1 record_id using "OutputData\ed_scn0", keepusing(ed_scn_rand_group)
tab _merge
drop if _merge==2
drop _merge
save "OutputData\ae_long0.dta", replace
/// Merge the ICU randomisation group onto the adverse events long format file
sort record_id
merge m:1 record_id using "OutputData\icu_scn0", keepusing(icu_scn_rand_group)
tab _merge
drop if _merge==2
drop _merge
save "OutputData\ae_long0.dta", replace
/* Keep this code commented out, but if there are repeating PDs uncomment
/// Merge the ED randomisation group onto the protocol deviations long format file
use "OutputData\pd_long0.dta", clear
sort record_id
merge m:1 record_id using "OutputData\ed_scn0", keepusing(ed_scn_rand_group)
tab _merge
drop if _merge==2
drop _merge
save "OutputData\apd0.dta", replace
/// Merge the ICU randomisation group onto the protocol deviations long format file
sort record_id
merge m:1 record_id using "OutputData\icu_scn0", keepusing(icu_scn_rand_group)
tab _merge
drop if _merge==2
drop _merge
save "OutputData\pd_long0.dta", replace*/

/**** Undertake required data transformations for the analysis ****/

use "RESPOND.dta", replace

// Drop the test cases
drop if redcap_data_access_group=="xtest"

mvdecode ed_bl_hr ed_bl_rr ed_bl_sbp ed_bl_dbp ed_bl_temp ed_bl_spo2 ed_bl_fio2 ed_bl_ph ed_bl_lactate ed_bl_glucose ed_bl_base ed_bl_na ed_bl_cl ed_bl_pao2 ed_bl_bga_fio2 ed_bl_paco2 ed_bl_creatinine ed_bl_bilirubin ed_bl_inr ed_bl_platelets ed_bl_wcc ed_bl_neutrophil ed_bl_crp ed_bl_hb ed_bl_fibrinogen ed_bl_alat ed_bl_pct ed_obs_hr1 ed_obs_hr2 ed_obs_hr3 ed_obs_hr4 ed_obs_hr5 ed_obs_hr6 ed_obs_hr7 ed_obs_hr8 ed_obs_hr9 ed_obs_hr10 ed_obs_hr11 ed_obs_hr12 ed_obs_hr13 ed_obs_hr14 ed_obs_hr15 icu_bl_hr icu_bl_rr icu_bl_sbp icu_bl_mbp icu_bl_dbp icu_bl_temp icu_bl_spo2 icu_bl_pao2 icu_bl_bga_fio2 icu_bl_ph icu_bl_lactate icu_bl_glucose icu_bl_base icu_bl_na icu_bl_cl icu_bl_paco2 icu_bl_creatinine icu_bl_bilirubin icu_bl_inr icu_bl_platelets icu_bl_wcc icu_bl_neutrophil icu_bl_crp icu_bl_hb icu_bl_fibrinogen icu_bl_alat icu_bl_pct icu_bl_fluid_bolus_total icu_bl_vis_score, mv(9999=.\ 4444=.\ 5555=.\ 9999.9=.\ 4444.4=.\ 5555.5=.)

/* Calculate PELOD-2 and pSOFA scores */
do "ED baseline PELOD and PSOFA.do"
do "PICU baseline PELOD and PSOFA.do"
do "Daily organ dysfunction PELOD and PSOFA.do"

// Age at randomisation
gen dem_ed_rand_age_years=dem_ed_rand_age_days/365.25

// Ethnicity 
gen dem_ethnicity_grp=1 if dem_ethnicity==1
replace dem_ethnicity_grp=2 if dem_ethnicity==6 
replace dem_ethnicity_grp=3 if dem_ethnicity==2 |  dem_ethnicity==4
replace dem_ethnicity_grp=4 if dem_ethnicity==7 |  dem_ethnicity==8
replace dem_ethnicity_grp=5 if dem_ethnicity==3 |  dem_ethnicity==5 | dem_ethnicity==9
label define dem_ethnicity_grp_ 1 "Caucasian" 2 "Aboriginal or Torres Strait Islander" 3 "Asian" 4 "Maori/Pacific Islander" 5 "Mixed/Other"
label values dem_ethnicity_grp dem_ethnicity_grp_
label variable dem_ethnicity_grp "Ethnicity"
tab dem_ethnicity_grp dem_ethnicity

// Chronic disease
gen dem_chronic_other_all=1 if dem_chronic_other==1 | dem_cf==1 | dem_hepatic==1 | dem_cld==1 | dem_crf==1 | dem_neuromusc==1

// Baseline treatments
local ed_baseline_cat "ed_bl_inv ed_bl_niv ed_bl_hfnc"
foreach v of varlist `ed_baseline_cat' {
	gen `v'_ny=1 if `v'==1
	replace `v'_ny=0 if `v'==0 | missing(`v')
}

// Fluid administered in past four hours / kg
gen ed_bl_fluid_bolus_total_kg=ed_bl_fluid_bolus_total/dem_weight

// Time since intravenous antibiotics were started
gen ed_bl_time_diff_iv_rand_min=hours(ed_scn_rand_dt-ed_bl_antibiotics_dt)*60 if ~missing(ed_scn_rand_dt) & ~missing(ed_bl_antibiotics_dt)

// Time from screening to randomisation (ED)
gen t_diff_ed_scn_rand_min=hours(ed_scn_rand_dt-ed_scn_dt)*60

// Time from randomisation to treatment (ED)
gen t_diff_rand_tmt_min=hours(ed_bl_alloc_dt_start-ed_scn_rand_dt)*60

// Time from randomisation to adrenaline infusion commencement
gen t_diff_rand_adren_min=hours(ed_trt_adren_dt_start-ed_scn_rand_dt)*60 if ed_trt_adren==1

// Time from randomisation to noradrenaline infusion commencement
gen t_diff_rand_norad_min=hours(ed_trt_norad_dt_start-ed_scn_rand_dt)*60 if ed_trt_norad==1

// Time from randomisation to any inotrope infusion commencement
egen inotrope_commencement_dt=rowmin(ed_trt_dopa_dt_start ed_trt_dobu_dt_start ed_trt_adren_dt_start ed_trt_norad_dt_start ed_trt_milri_dt_start ed_trt_vasopr_dt_start)
gen t_diff_rand_ino_min=hours(inotrope_commencement_dt-ed_scn_rand_dt)*60 if inotrope_commencement_dt~=.

// Inotrope infusion
* - within first hour of randomisation
gen rand_ino_firsthr=1 if t_diff_rand_ino_min<60 & t_diff_rand_ino_min>=0 & ~missing(t_diff_rand_ino_min)
replace rand_ino_firsthr=0 if t_diff_rand_ino_min>=60 & ~missing(t_diff_rand_ino_min)
replace rand_ino_firsthr=0 if missing(inotrope_commencement_dt)
* - within four hours of randomisation
gen rand_ino_firstday=1 if t_diff_rand_ino_min<240 & t_diff_rand_ino_min>=0 & ~missing(t_diff_rand_ino_min)
replace rand_ino_firstday=0 if t_diff_rand_ino_min>=1440 & ~missing(t_diff_rand_ino_min)
replace rand_ino_firstday=0 if missing(inotrope_commencement_dt)

// Total amount of fluids received
// - during the first 60minutes
gen ed_obs_fluid_firsthr = ed_obs_fluid_bolus_total1+ed_obs_fluid_bolus_total2+ed_obs_fluid_bolus_total3
// - 61-240min
gen ed_obs_fluid_61_240min = ed_obs_fluid_bolus_total4+ed_obs_fluid_bolus_total5+ ///
							 ed_obs_fluid_bolus_total6+ed_obs_fluid_bolus_total7+ ///
							 ed_obs_fluid_bolus_total8+ed_obs_fluid_bolus_total9+ ///
							 ed_obs_fluid_bolus_total10+ed_obs_fluid_bolus_total11+ ///
							 ed_obs_fluid_bolus_total12
// - >4hrs to 12hrs
gen ed_obs_fluid_4_12hr = ed_obs_fluid_bolus_total13+ed_obs_fluid_bolus_total14
// - first 24 hours
gen ed_obs_fluid_24hr=ed_obs_fluid_firsthr+ed_obs_fluid_61_240min+ed_obs_fluid_4_12hr+ed_obs_fluid_bolus_total15
local ed_fluids_recvd "ed_obs_fluid_firsthr ed_obs_fluid_61_240min ed_obs_fluid_4_12hr ed_obs_fluid_24hr ed_obs_fluid_bolus_total1 ed_obs_fluid_bolus_total2 ed_obs_fluid_bolus_total3 ed_obs_fluid_bolus_total4 ed_obs_fluid_bolus_total5 ed_obs_fluid_bolus_total6 ed_obs_fluid_bolus_total7 ed_obs_fluid_bolus_total8 ed_obs_fluid_bolus_total9 ed_obs_fluid_bolus_total10 ed_obs_fluid_bolus_total11 ed_obs_fluid_bolus_total12 ed_obs_fluid_bolus_total13 ed_obs_fluid_bolus_total14 ed_obs_fluid_bolus_total15"
foreach v in `ed_fluids_recvd' {	
	// per kg
	gen `v'_kg=`v'/dem_weight
}

// Daily organ dysfunction score
gen organ_dys_pelod2_any=0
gen organ_dys_pelod2_days=0
gen organ_dys_psofa_any=0
gen organ_dys_psofa_days=0
gen mo_dys_psofa_any=0
gen mo_dys_psofa_days=0
gen aki_any=0
gen aki_days=0
foreach i of numlist 1/28 {

	// PELOD-2
	tab dod_pelod2_`i', m
	gen organ_dys_pelod2_`i'=1 if dod_pelod2_`i'>0 & dod_pelod2_`i'~=.
	replace organ_dys_pelod2_any=1 if organ_dys_pelod2_`i'==1
	replace organ_dys_pelod2_days=organ_dys_pelod2_days+1 if organ_dys_pelod2_`i'==1 & organ_dys_pelod2_`i'~=.
	
	// pSOFA
	tab dod_psofa_comb_`i', m
	gen organ_dys_psofa_`i'=1 if dod_psofa_comb_`i'>0 & dod_psofa_comb_`i'~=.
	replace organ_dys_psofa_`i'=0 if dod_psofa_comb_`i'==0
	replace organ_dys_psofa_any=1 if organ_dys_psofa_`i'==1
	replace organ_dys_psofa_days=organ_dys_psofa_days+1 if organ_dys_psofa_`i'==1 & organ_dys_psofa_`i'~=.
	replace mo_dys_psofa_any=1 if dod_psofa_mo_comb_`i'==1 & `i'<8
	replace mo_dys_psofa_days=mo_dys_psofa_days+1 if dod_psofa_mo_comb_`i'==1 & organ_dys_psofa_`i'~=. & `i'<8
	
	// AKI
	tab icu_aki_`i', m
	gen aki_day_`i'=1 if icu_aki_`i' | dod_rrt`i'==1
	replace aki_any=1 if aki_day_`i'==1
	replace aki_days=aki_days+1 if aki_day_`i'==1
	
	
}

// Survival free of organ dysfunction at 28 days - using pSOFA
gen organ_dys_psofa_any_death=28-organ_dys_psofa_days if organ_dys_psofa_days~=.
replace organ_dys_psofa_any_death=0 if out_28d_status==0

// Survival free of AKI at 28 days
gen surv_free_aki_28=28-aki_days if aki_days~=.
replace surv_free_aki_28=0 if out_28d_status==0

// Duration of inotropes (ED and ICU)
gen ed_rand_plus7day=ed_scn_rand_dt+7*24*60*60*1000
format ed_rand_plus7day %tCMonth_dd,_CCYY_HH:MM
gen ed_rand_plus28day=ed_scn_rand_dt+28*24*60*60*1000
format ed_rand_plus28day %tCMonth_dd,_CCYY_HH:MM

gen icu_rand_plus7day=ed_scn_rand_dt+7*24*60*60*1000
format icu_rand_plus7day %tCMonth_dd,_CCYY_HH:MM
gen icu_rand_plus28day=ed_scn_rand_dt+28*24*60*60*1000
format icu_rand_plus28day %tCMonth_dd,_CCYY_HH:MM

gen ed_dur_inotropes_day7_hr=0
gen ed_dur_inotropes_day28_hr=0

gen icu_dur_inotropes_day7_hr=0
gen icu_dur_inotropes_day28_hr=0
foreach i of numlist 1/9 {
	
	// Start and stop times within the 7/28 day window
	gen dur_inotropes`i'_all=hours(out_vaso_dt_stop_0`i'-out_vaso_dt_start_0`i')
	* ED
	replace ed_dur_inotropes_day7_hr=ed_dur_inotropes_day7_hr+dur_inotropes`i'_all if out_vaso_dt_start_0`i'>ed_scn_rand_dt & out_vaso_dt_stop_0`i'<ed_rand_plus7day & dur_inotropes`i'_all~=.
	replace ed_dur_inotropes_day28_hr=ed_dur_inotropes_day28_hr+dur_inotropes`i'_all if out_vaso_dt_start_0`i'>ed_scn_rand_dt & out_vaso_dt_stop_0`i'<ed_rand_plus28day & dur_inotropes`i'_all~=.
	* ICU
	replace icu_dur_inotropes_day7_hr=icu_dur_inotropes_day7_hr+dur_inotropes`i'_all if out_vaso_dt_start_0`i'>icu_scn_rand_dt & out_vaso_dt_stop_0`i'<icu_rand_plus7day & dur_inotropes`i'_all~=.
	replace icu_dur_inotropes_day28_hr=icu_dur_inotropes_day28_hr+dur_inotropes`i'_all if out_vaso_dt_start_0`i'>icu_scn_rand_dt & out_vaso_dt_stop_0`i'<icu_rand_plus28day & dur_inotropes`i'_all~=.
	
	// Start time before randomisation (ED)
	gen ed_dur_inotropes`i'_beforerand=hours(out_vaso_dt_stop_0`i'-ed_scn_rand_dt) if out_vaso_dt_stop_0`i'>ed_scn_rand_dt & out_vaso_dt_start_0`i'<ed_scn_rand_dt
	replace ed_dur_inotropes_day7_hr=ed_dur_inotropes_day7_hr+ed_dur_inotropes`i'_beforerand if out_vaso_dt_stop_0`i'<ed_rand_plus7day & ed_dur_inotropes`i'_beforerand~=.
	replace ed_dur_inotropes_day28_hr=ed_dur_inotropes_day28_hr+ed_dur_inotropes`i'_beforerand if out_vaso_dt_stop_0`i'<ed_rand_plus28day & ed_dur_inotropes`i'_beforerand~=.
	
	// Start time before randomisation (ICU)
	gen icu_dur_inotropes`i'_beforerand=hours(out_vaso_dt_stop_0`i'-icu_scn_rand_dt) if out_vaso_dt_stop_0`i'>icu_scn_rand_dt & out_vaso_dt_start_0`i'<icu_scn_rand_dt
	replace icu_dur_inotropes_day7_hr=icu_dur_inotropes_day7_hr+icu_dur_inotropes`i'_beforerand if out_vaso_dt_stop_0`i'<icu_rand_plus7day & icu_dur_inotropes`i'_beforerand~=.
	replace icu_dur_inotropes_day28_hr=icu_dur_inotropes_day28_hr+icu_dur_inotropes`i'_beforerand if out_vaso_dt_stop_0`i'<icu_rand_plus28day & icu_dur_inotropes`i'_beforerand~=.

	// Stop time after 7 days post-randomisation (ED)
	gen ed_dur_inotropes`i'_afterrand7=hours(ed_rand_plus7day-out_vaso_dt_start_0`i') if out_vaso_dt_stop_0`i'>ed_rand_plus7day & out_vaso_dt_start_0`i'<ed_rand_plus7day & out_vaso_dt_start_0`i'>ed_scn_rand_dt
	replace ed_dur_inotropes_day7_hr=ed_dur_inotropes_day7_hr+ed_dur_inotropes`i'_afterrand7 if ed_dur_inotropes`i'_afterrand7~=.

	// Stop time after 7 days post-randomisation (ICU)
	gen icu_dur_inotropes`i'_afterrand7=hours(icu_rand_plus7day-out_vaso_dt_start_0`i') if out_vaso_dt_stop_0`i'>icu_rand_plus7day & out_vaso_dt_start_0`i'<icu_rand_plus7day & out_vaso_dt_start_0`i'>icu_scn_rand_dt
	replace icu_dur_inotropes_day7_hr=icu_dur_inotropes_day7_hr+icu_dur_inotropes`i'_afterrand7 if icu_dur_inotropes`i'_afterrand7~=.
	
	// Stop time after 28 days post-randomisation (ED)
	gen ed_dur_inotropes`i'_afterrand28=hours(ed_rand_plus28day-out_vaso_dt_start_0`i') if out_vaso_dt_stop_0`i'>ed_rand_plus28day & out_vaso_dt_start_0`i'<ed_rand_plus28day & out_vaso_dt_start_0`i'>ed_scn_rand_dt
	replace ed_dur_inotropes_day28_hr=ed_dur_inotropes_day28_hr+ed_dur_inotropes`i'_afterrand28 if ed_dur_inotropes`i'_afterrand28~=.
	
	// Stop time after 28 days post-randomisation (ICU)
	gen icu_dur_inotropes`i'_afterrand28=hours(icu_rand_plus28day-out_vaso_dt_start_0`i') if out_vaso_dt_stop_0`i'>icu_rand_plus28day & out_vaso_dt_start_0`i'<icu_rand_plus28day & out_vaso_dt_start_0`i'>icu_scn_rand_dt
	replace icu_dur_inotropes_day28_hr=icu_dur_inotropes_day28_hr+icu_dur_inotropes`i'_afterrand28 if icu_dur_inotropes`i'_afterrand28~=.
	
	drop dur_inotropes`i'_all ed_dur_inotropes`i'_beforerand ed_dur_inotropes`i'_afterrand7 ed_dur_inotropes`i'_afterrand28 icu_dur_inotropes`i'_beforerand icu_dur_inotropes`i'_afterrand7 icu_dur_inotropes`i'_afterrand28
	
}

/// 10th instance
// Start and stop times within the 7/28 day window (ED and ICU)
gen dur_inotropes10_all=hours(out_vaso_dt_stop_10-out_vaso_dt_start_10)
replace ed_dur_inotropes_day7_hr=ed_dur_inotropes_day7_hr+dur_inotropes10_all if out_vaso_dt_start_10>ed_scn_rand_dt & out_vaso_dt_stop_10<ed_rand_plus7day & dur_inotropes10_all~=.
replace ed_dur_inotropes_day28_hr=ed_dur_inotropes_day28_hr+dur_inotropes10_all if out_vaso_dt_start_10>ed_scn_rand_dt & out_vaso_dt_stop_10<ed_rand_plus28day & dur_inotropes10_all~=.
replace icu_dur_inotropes_day7_hr=icu_dur_inotropes_day7_hr+dur_inotropes10_all if out_vaso_dt_start_10>icu_scn_rand_dt & out_vaso_dt_stop_10<icu_rand_plus7day & dur_inotropes10_all~=.
replace icu_dur_inotropes_day28_hr=icu_dur_inotropes_day28_hr+dur_inotropes10_all if out_vaso_dt_start_10>icu_scn_rand_dt & out_vaso_dt_stop_10<icu_rand_plus28day & dur_inotropes10_all~=.

// Start time before randomisation (ED)
gen ed_dur_inotropes10_beforerand=hours(out_vaso_dt_stop_10-ed_scn_rand_dt) if out_vaso_dt_stop_10>ed_scn_rand_dt & out_vaso_dt_start_10<ed_scn_rand_dt
replace ed_dur_inotropes_day7_hr=ed_dur_inotropes_day7_hr+ed_dur_inotropes10_beforerand if out_vaso_dt_stop_10<ed_rand_plus7day & ed_dur_inotropes10_beforerand~=.
replace ed_dur_inotropes_day28_hr=ed_dur_inotropes_day28_hr+ed_dur_inotropes10_beforerand if out_vaso_dt_stop_10<ed_rand_plus28day & ed_dur_inotropes10_beforerand~=.

// Start time before randomisation (ICU)
gen icu_dur_inotropes10_beforerand=hours(out_vaso_dt_stop_10-icu_scn_rand_dt) if out_vaso_dt_stop_10>icu_scn_rand_dt & out_vaso_dt_start_10<icu_scn_rand_dt
replace icu_dur_inotropes_day7_hr=icu_dur_inotropes_day7_hr+icu_dur_inotropes10_beforerand if out_vaso_dt_stop_10<icu_rand_plus7day & icu_dur_inotropes10_beforerand~=.
replace icu_dur_inotropes_day28_hr=icu_dur_inotropes_day28_hr+icu_dur_inotropes10_beforerand if out_vaso_dt_stop_10<icu_rand_plus28day & icu_dur_inotropes10_beforerand~=.

// Stop time after 7 days post-randomisation (ED)
gen ed_dur_inotropes10_afterrand7=hours(ed_rand_plus7day-out_vaso_dt_start_10) if out_vaso_dt_stop_10>ed_rand_plus7day & out_vaso_dt_start_10<ed_rand_plus7day & out_vaso_dt_start_10>ed_scn_rand_dt
replace ed_dur_inotropes_day7_hr=ed_dur_inotropes_day7_hr+ed_dur_inotropes10_afterrand7 if ed_dur_inotropes10_afterrand7~=.

// Stop time after 7 days post-randomisation (ICU)
gen icu_dur_inotropes10_afterrand7=hours(icu_rand_plus7day-out_vaso_dt_start_10) if out_vaso_dt_stop_10>icu_rand_plus7day & out_vaso_dt_start_10<icu_rand_plus7day & out_vaso_dt_start_10>icu_scn_rand_dt
replace icu_dur_inotropes_day7_hr=icu_dur_inotropes_day7_hr+icu_dur_inotropes10_afterrand7 if icu_dur_inotropes10_afterrand7~=.

// Stop time after 28 days post-randomisation (ED)
gen ed_dur_inotropes10_afterrand28=hours(ed_rand_plus28day-out_vaso_dt_start_10) if out_vaso_dt_stop_10>ed_rand_plus28day & out_vaso_dt_start_10<ed_rand_plus28day & out_vaso_dt_start_10>ed_scn_rand_dt
replace ed_dur_inotropes_day7_hr=ed_dur_inotropes_day28_hr+ed_dur_inotropes10_afterrand28 if ed_dur_inotropes10_afterrand28~=.

// Stop time after 28 days post-randomisation (ICU)
gen icu_dur_inotropes10_afterrand28=hours(icu_rand_plus28day-out_vaso_dt_start_10) if out_vaso_dt_stop_10>icu_rand_plus28day & out_vaso_dt_start_10<icu_rand_plus28day & out_vaso_dt_start_10>icu_scn_rand_dt
replace icu_dur_inotropes_day7_hr=icu_dur_inotropes_day28_hr+icu_dur_inotropes10_afterrand28 if icu_dur_inotropes10_afterrand28~=.

drop ed_dur_inotropes10* icu_dur_inotropes10*

// Summarise the data
replace ed_dur_inotropes_day7_hr=0 if out_vaso==0
replace ed_dur_inotropes_day28_hr=0 if out_vaso==0
replace ed_dur_inotropes_day7_hr=. if out_vaso==.
replace ed_dur_inotropes_day28_hr=. if out_vaso==.
replace icu_dur_inotropes_day7_hr=0 if out_vaso==0
replace icu_dur_inotropes_day28_hr=0 if out_vaso==0
replace icu_dur_inotropes_day7_hr=. if out_vaso==.
replace icu_dur_inotropes_day28_hr=. if out_vaso==.
gen ed_dur_inotropes_day7_days=ed_dur_inotropes_day7_hr/24
gen ed_dur_inotropes_day28_days=ed_dur_inotropes_day28_hr/24
gen ed_inotropefree_day7_days=7-ed_dur_inotropes_day7_days
gen ed_inotropefree_day28_days=28-ed_dur_inotropes_day28_days
gen icu_dur_inotropes_day7_days=icu_dur_inotropes_day7_hr/24
gen icu_dur_inotropes_day28_days=icu_dur_inotropes_day28_hr/24
gen icu_inotropefree_day7_days=7-icu_dur_inotropes_day7_days
gen icu_inotropefree_day28_days=28-icu_dur_inotropes_day28_days

// Survival free of mo dysfunction at 7 days - using pSOFA
gen mo_dys_psofa_any_death_7day=7-mo_dys_psofa_days if mo_dys_psofa_days~=.
replace mo_dys_psofa_any_death_7day=0 if out_28d_status==0

// PICU length of stay
gen icu_los=0
replace icu_los=icu_los+hours(out_icu_dc_dt-dem_picu_adm_dt)/24 if dem_picu_adm_yn==1 // difference from randomisation to PICU discharge
replace icu_los=28 if out_icu_dc_dt>(dem_picu_adm_dt+28*24*60*60*1000)  // if discharged from PICU more than 28 days after randomisation censor at 28 days
foreach i of numlist 1/3 { // PICU re-admissions
	gen los_`i'=hours(out_28d_icu_dc_dt_0`i'-out_28d_icu_adm_dt_0`i')/24 if out_28d_icu_dc_dt_0`i'<(dem_picu_adm_dt+28*24*60*60*1000)  // number of days if discharge is before 28 days since randomisaion
	replace los_`i'=hours(icu_rand_plus28day-out_28d_icu_adm_dt_0`i')/24 if out_28d_icu_dc_dt_0`i'>(dem_picu_adm_dt+28*24*60*60*1000)  // number of days if discharge is after 28 days since randomisation
	replace icu_los=icu_los+los_`i' if los_`i'~=.
}
gen surv_icu_los=28-icu_los
* PICU free survival
gen picu_free_surv=surv_icu_los
replace picu_free_surv=0 if out_icu_dc_status==0 | out_28d_status==0

// Hospital length of stay
gen hosp_los_ed=0
replace hosp_los_ed=hosp_los_ed+ (out_hosp_dc_dt-dofc(ed_scn_rand_dt))

// Lactate <2mmol/L by six hours post enrolment
gen ed_lactate2_first6=0
foreach i of numlist 1/13 {
	replace ed_lactate2_first6=1 if ed_obs_lactate`i'<2 & ~missing(ed_obs_lactate`i') 
}

// Lactate <2mmol/L by 12 hours post enrolment
gen ed_lactate2_first12=ed_lactate2_first6
replace ed_lactate2_first12=1 if ed_obs_lactate14<2 & ~missing(ed_obs_lactate14)

// Lactate <2mmol/L by 24 hours post enrolment
gen ed_lactate2_first24=ed_lactate2_first12
replace ed_lactate2_first24=1 if ed_obs_lactate15<2 & ~missing(ed_obs_lactate15)

// Time to reversal of tachycardia censored at 24hours    
foreach i of numlist 1/15 {
	gen ed_tc`i'=0 if ed_obs_hr`i'~=.
	replace ed_tc`i'=1 if ((dem_ed_rand_age_days/365.25)>=0 & (dem_ed_rand_age_days/365.25)<2) & ed_obs_hr`i'>180 & ed_obs_hr`i'~=.
	replace ed_tc`i'=1 if ((dem_ed_rand_age_days/365.25)>=2 & (dem_ed_rand_age_days/365.25)<6) & ed_obs_hr`i'>140 & ed_obs_hr`i'~=.
	replace ed_tc`i'=1 if ((dem_ed_rand_age_days/365.25)>=6 & (dem_ed_rand_age_days/365.25)<13) & ed_obs_hr`i'>130 & ed_obs_hr`i'~=.
	replace ed_tc`i'=1 if ((dem_ed_rand_age_days/365.25)>=13 & (dem_ed_rand_age_days/365.25)<18) & ed_obs_hr`i'>110 & ed_obs_hr`i'~=.  
}

foreach i of numlist 1/15 {
	gen double ed_tc_dt`i'= ed_obs_dt`i' if ed_tc`i'==1
	format ed_tc_dt`i' %tc
}

egen double ed_tc_dt_first = rowmin(ed_tc_dt1 ed_tc_dt2 ed_tc_dt3 ed_tc_dt4 ed_tc_dt5 ed_tc_dt6 ed_tc_dt7 ed_tc_dt8 ed_tc_dt9 ed_tc_dt10 ed_tc_dt11 ed_tc_dt12 ed_tc_dt13 ed_tc_dt14 ed_tc_dt15)
format ed_tc_dt_first`i' %tc

foreach i of numlist 1/15 {
	gen double ed_normalhr_dt`i'= ed_obs_dt`i' if ed_tc`i'==0 & ed_obs_dt`i'>ed_tc_dt_first
	format ed_normalhr_dt`i' %tc
}

egen double ed_normalhr_dt_first = rowmin(ed_normalhr_dt1 ed_normalhr_dt2 ed_normalhr_dt3 ed_normalhr_dt4 ed_normalhr_dt5 ed_normalhr_dt6 ed_normalhr_dt7 ed_normalhr_dt8 ed_normalhr_dt9 ed_normalhr_dt10 ed_normalhr_dt11 ed_normalhr_dt12 ed_normalhr_dt13 ed_normalhr_dt14 ed_normalhr_dt15)
format ed_normalhr_dt_first %tc

gen ed_t_diff_normalhr_rand=hours(ed_normalhr_dt_first-ed_scn_rand_dt) if ed_normalhr_dt_first~=.
replace ed_t_diff_normalhr_rand=24 if ed_normalhr_dt_first==. & ed_tc_dt_first~=. // value of 24 hours if does not normalise
replace ed_t_diff_normalhr_rand=0 if ed_tc_dt_first==. // value of 0 if no tachycardia

// Time from screening to randomisation (ICU)
gen t_diff_icu_scn_rand_min=hours(icu_scn_rand_dt-icu_scn_dt)*60

// Time from implementation of consent-to-continue to finalisation of informed consent for consent-to-continue patients (ED)
gen t_diff_icu_ctc_writen_hr_ed=hours(ed_scn_consent_dt-ed_scn_consent_ctc_dt) if ed_scn_consent_type==2

// Time from implementation of consent-to-continue to finalisation of informed consent for consent-to-continue patients
gen t_diff_icu_ctc_writen_hr_icu=hours(icu_scn_consent_dt-icu_scn_consent_ctc_dt) if icu_scn_consent_type==2

// Time from inotropes to randomisation (ICU)
gen t_diff_preino_rand_hr=hours(icu_scn_rand_dt-out_vaso_dt_start_01)

// Age at randomisation (ICU)
gen dem_picu_rand_age_years=dem_picu_rand_age_days/365.25

// ICU treatments received
gen icu_tmt_all=1 if icu_trt_vitc_yn==1 & icu_trt_thia_yn==1 & icu_trt_hydro_yn==1
replace icu_tmt_all=0 if icu_trt_vitc_yn==0 | icu_trt_thia_yn==0 | icu_trt_hydro_yn==0
gen icu_tmt_any=1 if icu_trt_vitc_yn==1 | icu_trt_thia_yn==1 | icu_trt_hydro_yn==1
replace icu_tmt_all=0 if icu_trt_vitc_yn==0 & icu_trt_thia_yn==0 & icu_trt_hydro_yn==0

// Hydrocortisone before randomisation
gen icu_tmt_hydro_before_rand=1 if icu_trt_hydro_dt_first<icu_scn_rand_dt & icu_trt_hydro_dt_first~=. & icu_scn_rand_dt~=. & icu_trt_hydro_yn==1
replace icu_tmt_hydro_before_rand=0 if icu_trt_hydro_dt_first>=icu_scn_rand_dt & icu_trt_hydro_dt_first~=. & icu_scn_rand_dt~=. & icu_trt_hydro_yn==1
gen t_diff_icu_tmt_hydro_rand=hours(icu_scn_rand_dt-icu_trt_hydro_dt_first) if icu_tmt_hydro_before_rand==1

// Total amount in fluids received
gen icu_obs_fluid_24hr=icu_obs_fluid_bolus_total1+icu_obs_fluid_bolus_total2+icu_obs_fluid_bolus_total3+icu_obs_fluid_bolus_total4

// PaO2/FiO2 ratio (ICU)
gen icu_bl_pao2_fio2=icu_bl_pao2/icu_bl_fio2 if icu_bl_pao2~=. & icu_bl_fio2~=.

// Total amount of fluid bolus received within the past four hours (ICU)
gen icu_bl_fluid_bolus_total_kg=icu_bl_fluid_bolus_total/dem_weigh

// Time since IV antibiotics were started
gen t_diff_ivantib_rand_hr=hours(icu_scn_rand_dt-icu_bl_antibiotics_dt)

// Time from PICU admission to randomisation
gen t_diff_icu_adm_rand_min=hours(icu_scn_rand_dt-dem_picu_adm_dt)*60

// Cumulative hydrocortisone dose after randomisation
gen icu_trt_hydro_total_kg=icu_trt_hydro_total/dem_weight

// Cumulative ascorbic acid dose after randomisation
gen icu_trt_vitc_total_kg=icu_trt_vitc_total/dem_weight

// Cumulative thiamine dose after randomisation
gen icu_trt_thia_total_kg=icu_trt_thia_total/dem_weight

// Lactate <2mmol/L by six hours post enrolment
gen icu_lactate2_first6=0
foreach i of numlist 1/2 {
	replace icu_lactate2_first6=1 if icu_obs_lactate`i'<2 & ~missing(icu_obs_lactate`i') 
}

// Lactate <2mmol/L by 12 hours post enrolment
gen icu_lactate2_first12=icu_lactate2_first6
replace icu_lactate2_first12=1 if icu_obs_lactate3<2 & ~missing(icu_obs_lactate3)

// Lactate <2mmol/L by 24 hours post enrolment
gen icu_lactate2_first24=icu_lactate2_first12
replace icu_lactate2_first24=1 if icu_obs_lactate4<2 & ~missing(icu_obs_lactate4)

// Time to reversal of tachycardia censored at 24hours    
foreach i of numlist 1/4 {
	gen icu_tc`i'=0 if icu_obs_hr`i'~=.
	replace icu_tc`i'=1 if ((dem_picu_rand_age_days/365.25)>=0 & (dem_picu_rand_age_days/365.25)<2) & icu_obs_hr`i'>180 & icu_obs_hr`i'~=.
	replace icu_tc`i'=1 if ((dem_picu_rand_age_days/365.25)>=2 & (dem_picu_rand_age_days/365.25)<6) & icu_obs_hr`i'>140 & icu_obs_hr`i'~=.
	replace icu_tc`i'=1 if ((dem_picu_rand_age_days/365.25)>=6 & (dem_picu_rand_age_days/365.25)<13) & icu_obs_hr`i'>130 & icu_obs_hr`i'~=.
	replace icu_tc`i'=1 if ((dem_picu_rand_age_days/365.25)>=13 & (dem_picu_rand_age_days/365.25)<18) & icu_obs_hr`i'>110 & icu_obs_hr`i'~=.  
}

foreach i of numlist 1/4 {
	gen double icu_tc_dt`i'= icu_obs_dt`i' if icu_tc`i'==1
	format icu_tc_dt`i' %tc
}

egen double icu_tc_dt_first = rowmin(icu_tc_dt1 icu_tc_dt2 icu_tc_dt3 icu_tc_dt4)
format icu_tc_dt_first`i' %tc

foreach i of numlist 1/4 {
	gen double icu_normalhr_dt`i'= icu_obs_dt`i' if icu_tc`i'==0 & icu_obs_dt`i'>icu_tc_dt_first
	format icu_normalhr_dt`i' %tc
}

egen double icu_normalhr_dt_first = rowmin(icu_normalhr_dt1 icu_normalhr_dt2 icu_normalhr_dt3 icu_normalhr_dt4)
format icu_normalhr_dt_first %tc

gen icu_t_diff_normalhr_rand=hours(icu_normalhr_dt_first-icu_scn_rand_dt) if icu_normalhr_dt_first~=.
replace icu_t_diff_normalhr_rand=24 if icu_normalhr_dt_first==. & icu_tc_dt_first~=. // value of 24 hours if does not normalise?
replace icu_t_diff_normalhr_rand=0 if icu_tc_dt_first==. // value of 0 if no tachycardia? 

// Time to shock reversal censored at 28 days (ED)
egen inotrope_end_dt=rowmax(out_vaso_dt_stop_*)
gen ed_t_diff_inoend_rand_min=hours(inotrope_end_dt-ed_scn_rand_dt) if inotrope_end_dt~=.
replace ed_t_diff_inoend_rand_min=1680 if ed_t_diff_inoend_rand_min>1680 & ed_t_diff_inoend_rand_min~=.
replace ed_t_diff_inoend_rand_min=0 if inotrope_end_dt==.

// Time to shock reversal censored at 28 days (ICU)
gen icu_t_diff_inoend_rand_min=hours(inotrope_end_dt-icu_scn_rand_dt) if inotrope_end_dt~=.
replace icu_t_diff_inoend_rand_min=1680 if icu_t_diff_inoend_rand_min>1680 & icu_t_diff_inoend_rand_min~=.
replace icu_t_diff_inoend_rand_min=0 if inotrope_end_dt==.

// Metabolic resuscitation started within first hour of randomisation (ICU)
gen metab_resusc=0 if icu_trt_vitc_yn==0 | icu_trt_thia_yn==0 | icu_trt_hydro_yn==0
egen metab_resusc_maxstarttime=rowmax(icu_trt_vitc_dt_first icu_trt_thia_dt_first icu_trt_hydro_yn)
gen metab_resusc_hr=hours(metab_resusc_maxstarttime-icu_scn_rand_dt)
gen t_rand_metab_resusc_min=metab_resusc_hr*60
replace metab_resusc=1 if metab_resusc_hr<=1 & metab_resusc_hr~=.
replace metab_resusc=0 if metab_resusc_hr>1 & metab_resusc_hr~=.
replace t_rand_metab_resusc_min=. if icu_scn_rand_group==1
replace metab_resusc=. if icu_scn_rand_group==1

// Time from randomisation to inotrope infusion commencement (ICU)
egen icu_inotrope_start_dt=rowmin(out_vaso_dt_start_*)
format icu_inotrope_start_dt %tCMonth_dd,_CCYY_HH:MM
gen t_diff_icu_inotrope_min=hours(icu_inotrope_start_dt-icu_scn_rand_dt)*60

// Change in POPC and FSS from baseline to 28 days (ED and ICU)
gen out_mpopc_change=out_28d_popc-dem_popc_pre_hosp if ~missing(out_28d_popc) & ~missing(dem_popc_pre_hosp)
gen out_fss_change=out_28d_fss_score-dem_fss_score if ~missing(out_28d_fss_score) & ~missing(dem_fss_score)

// Variable to separate PICU group into three groups (standard care no hydrocort, standard care hydrocort, intervention)
gen icu_scn_rand_3gp=icu_scn_rand_group
replace icu_scn_rand_3gp=3 if icu_scn_rand_group==2
replace icu_scn_rand_3gp=2 if icu_trt_hydro_yn==1 & icu_scn_rand_group==1
label define icu_scn_rand_3gp 1 "Std: no hydrocort" 2 "Std: hydrocort" 3 "Intervention"
label values icu_scn_rand_3gp icu_scn_rand_3gp

// Variable to define subgroup analysis - pSOFA at ICU randomisation >=2 for lung component
gen subgroup_acutelung=0
replace subgroup_acutelung=1 if icu_bl_pao2_fio2_ps_pts>=2 & ~missing(icu_bl_pao2_fio2_ps_pts)
replace subgroup_acutelung=1 if missing(icu_bl_pao2_fio2_ps_pts) & ~missing(icu_bl_spo2_fio2_ps_pts) & icu_bl_spo2_fio2_ps_pts>=2

save "RESPOND.dta", replace