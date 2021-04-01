/**** RESPOND PICU Pilot Data Analysis ****/

/* Keep only the PICU patients */
keep if icu_scn_dt~=.

/*** SCREENING, CONSENT ****/

// Number screened
count if icu_scn_dt~=.

// Reasons for non-eligibility - inclusion criteria
gen inc_cri_met=1
foreach v of varlist icu_scn_inc_cri* {
	capture noisily tab `v', m
	replace inc_cri_met=0 if `v'==0
}
tab inc_cri_met, m

// Reasons for non-eligibility - exclusion criteria
gen exc_cri_not_met=1
foreach v of varlist icu_scn_exc_cri* {
	capture noisily tab `v', m
	replace exc_cri_not_met=0 if `v'==1
}
gen exc_cri_chronic=1 if icu_scn_exc_cri_03==1 | icu_scn_exc_cri_04==1
gen exc_cri_illness=1 if icu_scn_exc_cri_09==1 | icu_scn_exc_cri_10==1 | icu_scn_exc_cri_11==1 | icu_scn_exc_cri_12==1 | icu_scn_exc_cri_13==1 | icu_scn_exc_cri_14==1
tab exc_cri_not_met, m
tab exc_cri_chronic, m
tab exc_cri_illness, m

// Number eligible
tab icu_scn_pt_eligibility_calc, m

/* Keep only those eligible */
keep if icu_scn_pt_eligibility_calc==1

// Not approached for consent (=0)
tab icu_scn_consent_type, m

// Non-consent reason
* Collapse non-consent reason into pre-defined categories
gen not_enrol_declined=1 if icu_scn_non_consent_reason___1==1
gen not_enrol_social=1 if icu_scn_non_consent_reason___5==1 | icu_scn_non_consent_reason___6==1 | icu_scn_non_consent_reason___7==1 
gen not_enrol_notapproached=1 if icu_scn_non_consent_reason___4==1 | icu_scn_non_consent_reason___9==1 | icu_scn_non_consent_reason___18==1 | icu_scn_non_consent_reason___19==1 | icu_scn_non_consent_reason___20==1 | icu_scn_non_consent_reason___21==1
gen not_enrol_resourcing=1 if icu_scn_non_consent_reason___2==1 | icu_scn_non_consent_reason___16==1 | icu_scn_non_consent_reason___22==1 | icu_scn_non_consent_reason___23==1 | icu_scn_non_consent_reason___25==1 | icu_scn_non_consent_reason___29==1 | icu_scn_non_consent_reason___30==1
gen not_enrol_covid19=1 if icu_scn_non_consent_reason___26==1 | icu_scn_non_consent_reason___27==1 | icu_scn_non_consent_reason___28==1
gen not_enrol_other=1 if icu_scn_non_consent_reason___0==1 | icu_scn_non_consent_reason___3==1 | icu_scn_non_consent_reason___10==1 | icu_scn_non_consent_reason___11==1 | icu_scn_non_consent_reason___12==1 | icu_scn_non_consent_reason___13==1 | icu_scn_non_consent_reason___14==1 | icu_scn_non_consent_reason___15==1 | icu_scn_non_consent_reason___17==1 | icu_scn_non_consent_reason___24==1
foreach v of varlist icu_scn_non_consent_reason* {
	tab `v', m
}
foreach v of varlist not_enrol_* {
	tab `v', m
}

// Patient missed
tab icu_scn_missed_yn, m

// Approached for prospective consent (=1)
tab icu_scn_consent_type, m

// N declined consent
tab icu_scn_declined_yn if icu_scn_consent_type==1, m

// Eligible for consent-to-continue (=2)
tab icu_scn_consent_type, m

// Number randomised
tab icu_scn_rand_yn, m

/* Keep only those randomised */
keep if icu_scn_rand_yn==1

// Randomisation group
tab icu_scn_rand_group, m

// Consent type in each group
tab icu_scn_consent_type icu_scn_rand_group, m

// Number consented
bysort icu_scn_rand_group: tab icu_scn_consent_yn icu_scn_consent_type, m

// Informed consent declined
tab icu_scn_declined_yn, m

// Withdrawn
tab woc_yn, m
tab woc_applies_to if woc_yn==1, m

// Keep only those randomised, consented and not withdrawn
keep if ~missing(icu_scn_rand_group) & icu_scn_consent_yn==1
drop if woc_applies_to==2 | woc_applies_to==3

// Follow-up to 28 days
tab out_28d_status icu_scn_rand_group, m

// Time from implementation of consent-to-continue to finalisation of informed consent for consent-to-continue patients
hist t_diff_icu_ctc_writen_hr_icu
tabstat t_diff_icu_ctc_writen_hr_icu, by(icu_scn_rand_group) stats(n mean sd min max q iqr)

/*** Table 1: Baseline characteristics ***/

// Age at randomisation
hist dem_picu_rand_age_years
tabstat dem_picu_rand_age_years, by(icu_scn_rand_group) stats(n mean sd min max q iqr)

// Weight
hist dem_weight
tabstat dem_weight, by(icu_scn_rand_group) stats(n mean sd min max q iqr)

// Sex
tab dem_sex icu_scn_rand_group, m col
tab dem_sex icu_scn_rand_group, col

// Ethnicity (collapsed groups)
tab dem_ethnicity_grp icu_scn_rand_group, m col
tab dem_ethnicity_grp icu_scn_rand_group, col

// Chronic disease
local chronic "dem_chronic_yn dem_malform dem_asthma dem_chd dem_onc dem_cp_enceph dem_metabolic dem_immuno dem_syndrome dem_chronic_other_all"
foreach v of varlist `chronic' {
	tab `v' icu_scn_rand_group, m col
}
local chronic_other "dem_malform_specify dem_onc_specify dem_immuno_specify dem_syndrome_specify dem_chronic_specify"
foreach v of varlist `chronic_other' {
	tab `v' icu_scn_rand_group, m col
	tab `v' icu_scn_rand_group, col
}

// POPC
hist dem_popc_pre_hosp
tabstat dem_popc_pre_hosp, by(icu_scn_rand_group) stats(n mean sd min max q iqr)

// FSS
foreach i of numlist 1/6 {
	capture noisily tab dem_fss_0`i', m
}
hist dem_fss_score  // result: non-normally distributed
tabstat dem_fss_score, by(icu_scn_rand_group) stats(n mean sd min max q iqr)

// Baseline physiological observations
local icu_baseline_phys_cont "icu_bl_hr icu_bl_rr icu_bl_sbp icu_bl_mbp icu_bl_dbp icu_bl_temp icu_bl_spo2 icu_bl_fio2 icu_bl_pao2_fio2"
foreach v of varlist `icu_baseline_phys_cont' {
	hist `v', saving(Figures\hist_`v', replace)
	tabstat `v', by(icu_scn_rand_group) stats(n mean sd min max q iqr)
}

// Baseline treatments
local icu_baseline_cat "icu_bl_hfnc icu_bl_niv icu_bl_inv"
foreach v of varlist `icu_baseline_cat' {
	tab `v' icu_scn_rand_group, m col
	tab `v' icu_scn_rand_group, col
}

// CRT
tab icu_bl_crt icu_scn_rand_group, m col
tab icu_bl_crt icu_scn_rand_group, col

// GCS
tab icu_bl_gcs_yn icu_scn_rand_group, m col
tab icu_bl_gcs_yn icu_scn_rand_group, col
hist icu_bl_gcs, saving(Figures\hist_icu_bl_gcs, replace)
tabstat icu_bl_gcs, by(icu_scn_rand_group) stats(n mean sd min max q iqr)

// Pupils 
tab icu_bl_pupil_fix icu_scn_rand_group, m col
tab icu_bl_pupil_fix icu_scn_rand_group, col
tab icu_bl_pupil_fix icu_scn_rand_group if icu_bl_pupil_fix~=-1, col

// Laboratory parameters
local icu_baseline_labs "icu_bl_ph icu_bl_base icu_bl_pao2 icu_bl_paco2 icu_bl_lactate icu_bl_glucose icu_bl_na icu_bl_cl icu_bl_creatinine icu_bl_bilirubin icu_bl_alat icu_bl_inr icu_bl_fibrinogen icu_bl_platelets icu_bl_wcc icu_bl_neutrophil icu_bl_hb icu_bl_crp"
foreach v of varlist `icu_baseline_labs' {
	hist `v', saving(Figures\hist_`v', replace)
	tabstat `v', by(icu_scn_rand_group) stats(n mean sd min max q iqr)
}

// pSOFA
hist icu_bl_psofa_comb
tabstat icu_bl_psofa_comb, by(icu_scn_rand_group) stats(n mean sd min max q iqr)

// PELOD-2
hist icu_bl_pelod2
tabstat icu_bl_pelod2, by(icu_scn_rand_group) stats(n mean sd min max q iqr)

// Total amount of fluid bolus received within the past four hours
hist icu_bl_fluid_bolus_total_kg
tabstat icu_bl_fluid_bolus_total_kg, by(icu_scn_rand_group) stats(n mean sd min max q iqr)

// Time since IV antibiotics were started
hist t_diff_ivantib_rand_hr
tabstat t_diff_ivantib_rand_hr, by(icu_scn_rand_group) stats(n mean sd min max q iqr)

// Vasoactive inotrope score
hist icu_bl_vis_score
tabstat icu_bl_vis_score, by(icu_scn_rand_group) stats(n mean sd min max q iqr)

// Steroids prior to randomisation
tab icu_bl_steroids icu_scn_rand_group, m col
tab icu_bl_steroids icu_scn_rand_group, col

// Renal replacement therapy
tab icu_bl_rrt icu_scn_rand_group, m col
tab icu_bl_rrt icu_scn_rand_group, col

// ECMO
tab icu_bl_ecls icu_scn_rand_group, m col
tab icu_bl_ecls icu_scn_rand_group, col

/*** Table 2: Feasibility outcomes ***/

/* Run this table three times - all sites, QCH only, all sites apart from QCH */
gen allsites=1
gen qch_only=1 if redcap_data_access_group=="qch"
gen not_qch=1 if qch_only==.

foreach v of varlist allsites qch_only not_qch {

	preserve
	keep if `v'==1

	// Time from screening to randomisation
	hist t_diff_icu_scn_rand_min
	tabstat t_diff_icu_scn_rand_min, by(icu_scn_rand_group) stats(n mean sd min max q iqr)
	capture noisily qreg t_diff_icu_scn_rand_min icu_scn_rand_group

	// Time from PICU admission to randomisation
	hist t_diff_icu_adm_rand_min
	tabstat t_diff_icu_adm_rand_min, by(icu_scn_rand_group) stats(n mean sd min max q iqr)
	capture noisily qreg t_diff_icu_adm_rand_min icu_scn_rand_group

	// Time from randomisation to commencement of metabolic resuscitation
	hist t_rand_metab_resusc_min
	tabstat t_rand_metab_resusc_min, by(icu_scn_rand_group) stats(n mean sd min max q iqr)
	capture noisily qreg t_rand_metab_resusc_min icu_scn_rand_group

	// Hydrocortisone after randomisation
	tab icu_trt_hydro_yn icu_scn_rand_group, m col
	tab icu_trt_hydro_yn icu_scn_rand_group, col
	capture noisily prtest icu_trt_hydro_yn, by(icu_scn_rand_group)

	// Cumulative hydrocortisone dose after randomisation
	hist icu_trt_hydro_total_kg
	tabstat icu_trt_hydro_total_kg, by(icu_scn_rand_group) stats(n mean sd min max q iqr)
	capture noisily qreg icu_trt_hydro_total_kg icu_scn_rand_group

	// Ascorbic acid after randomisation
	tab icu_trt_vitc_yn icu_scn_rand_group, m col
	tab icu_trt_vitc_yn icu_scn_rand_group, col
	capture noisily prtest icu_trt_vitc_yn, by(icu_scn_rand_group)

	// Cumulative hydrocortisone dose after randomisation
	hist icu_trt_vitc_total_kg
	tabstat icu_trt_vitc_total_kg, by(icu_scn_rand_group) stats(n mean sd min max q iqr)
	capture noisily qreg icu_trt_vitc_total_kg icu_scn_rand_group

	// Thiamine received after randomisation
	tab icu_trt_thia_yn icu_scn_rand_group, m col
	tab icu_trt_thia_yn icu_scn_rand_group, col
	capture noisily prtest icu_trt_thia_yn, by(icu_scn_rand_group) 

	// Cumulative thiamine dose after randomisation
	hist icu_trt_thia_total_kg
	tabstat icu_trt_thia_total_kg, by(icu_scn_rand_group) stats(n mean sd min max q iqr)
	capture noisily qreg icu_trt_thia_total_kg icu_scn_rand_group

	// Time from randomisation to inotrope infusion commencement
	hist t_diff_icu_inotrope_min
	tabstat t_diff_icu_inotrope_min, by(icu_scn_rand_group) stats(n mean sd min max q iqr)

	// Metabolic resuscitation started within first hour of randomisation
	tab metab_resusc icu_scn_rand_group, m col
	tab metab_resusc icu_scn_rand_group, col

	restore

}

/*** Table 3: Outcomes ***/

// Survival free of organ dysfunction (censored at 28 days) - using pSOFA
tabstat organ_dys_psofa_any_death, by(icu_scn_rand_group) stats(n mean sd min max q iqr)
hist organ_dys_psofa_any_death
capture noisily qreg organ_dys_psofa_any_death icu_scn_rand_group
stset organ_dys_psofa_any_death
sts graph, by(icu_scn_rand_group)

// Survival free of inotrope support at 7 days
hist icu_inotropefree_day7_days
tabstat icu_inotropefree_day7_days, by(icu_scn_rand_group) stats(n mean sd min max q iqr)
capture noisily qreg icu_inotropefree_day7_days icu_scn_rand_group

// Survival free of multiorgan dysfunction at 7 days - using pSOFA
tabstat mo_dys_psofa_any_death_7day, by(icu_scn_rand_group) stats(n mean sd min max q iqr)
hist mo_dys_psofa_any_death_7day
capture noisily qreg mo_dys_psofa_any_death_7day icu_scn_rand_group
stset mo_dys_psofa_any_death_7day
sts graph, by(icu_scn_rand_group)

// Survival free of AKI (censored at 28 days)
tabstat surv_free_aki_28, by(icu_scn_rand_group) stats(n mean sd min max q iqr)
hist surv_free_aki_28
capture noisily qreg surv_free_aki_28 icu_scn_rand_group
stset surv_free_aki_28
sts graph, by(icu_scn_rand_group)

// Death at 28 days
tab out_28d_status icu_scn_rand_group, m col
tab out_28d_status icu_scn_rand_group, col
capture noisily prtest out_28d_status, by(icu_scn_rand_group)

// Survival free of PICU stay (censored at 28 days)
hist picu_free_surv
tabstat picu_free_surv, by(icu_scn_rand_group) stats(n mean sd min max q iqr)
capture noisily qreg picu_free_surv icu_scn_rand_group

// PICU length of stay
hist icu_los
tabstat icu_los, by(icu_scn_rand_group) stats(n mean sd min max q iqr)
capture noisily qreg icu_los icu_scn_rand_group

// Hospital length of stay
hist hosp_los_ed
tabstat hosp_los_ed, by(icu_scn_rand_group) stats(n mean sd min max q iqr)
capture noisily qreg hosp_los_ed icu_scn_rand_group

// 28 day POPC
tab out_28d_popc icu_scn_rand_group, m col
tab out_28d_popc icu_scn_rand_group, col
tabstat out_28d_popc, by(icu_scn_rand_group) stats(n mean sd min max q iqr)
capture noisily qreg out_28d_popc icu_scn_rand_group
tab out_mpopc_change icu_scn_rand_group, m col
tab out_mpopc_change icu_scn_rand_group, col
tabstat out_mpopc_change, by(icu_scn_rand_group) stats(n mean sd min max q iqr)
capture noisily qreg out_mpopc_change icu_scn_rand_group

// FSS
hist out_28d_fss_score
tabstat out_28d_fss_score, by(icu_scn_rand_group) stats(n mean sd min max q iqr)
capture noisily qreg out_28d_fss_score icu_scn_rand_group
hist out_fss_change
tabstat out_fss_change, by(icu_scn_rand_group) stats(n mean sd min max q iqr)
capture noisily qreg out_fss_change icu_scn_rand_group

// Lactate <2mmol/L by six hours post enrolment
tab icu_lactate2_first6 icu_scn_rand_group, m col
tab icu_lactate2_first6 icu_scn_rand_group, col
capture noisily prtest icu_lactate2_first6, by(icu_scn_rand_group)

// Lactate <2mmol/L by 12 hours post enrolment
tab icu_lactate2_first12 icu_scn_rand_group, m col
tab icu_lactate2_first12 icu_scn_rand_group, col
capture noisily prtest icu_lactate2_first12, by(icu_scn_rand_group)

// Lactate <2mmol/L by 24 hours post enrolment
tab icu_lactate2_first24 icu_scn_rand_group, m col
tab icu_lactate2_first24 icu_scn_rand_group, col
capture noisily prtest icu_lactate2_first24, by(icu_scn_rand_group)

// Time to reversal of tachycardia censored at 24 hours
hist icu_t_diff_normalhr_rand
tabstat icu_t_diff_normalhr_rand, by(icu_scn_rand_group) stats(n mean sd min max q iqr)
capture noisily qreg icu_t_diff_normalhr_rand icu_scn_rand_group

// Time to shock reversal censored at 28 days
hist icu_t_diff_inoend_rand_min
tabstat icu_t_diff_inoend_rand_min, by(icu_scn_rand_group) stats(n mean sd min max q iqr)
capture noisily qreg icu_t_diff_inoend_rand_min icu_scn_rand_group

/*** Table 4: Protocol violations and adverse events **/

// Protocol deviations
tab pdf_yn icu_scn_rand_group, m col

preserve
keep if pdf_yn==1

tab pdf_details, m
tab pdf_details icu_scn_rand_group, m
replace pdf_details=0 if pdf_details==8
xi i.pdf_details
foreach v of varlist _Ipdf_detai_* {
	capture noisily prtest `v', by(icu_scn_rand_group)
}

restore

// Adverse events
preserve
tab ae_yn1 icu_scn_rand_group, m col
use "OutputData\ae_long0.dta", clear
keep if icu_scn_rand_group~=.
tab ae_yn icu_scn_rand_group, m col
tab ae_relationship icu_scn_rand_group, m col
tab ae_relationship icu_scn_rand_group, col
tab ae_type icu_scn_rand_group, m col
tab ae_type icu_scn_rand_group, col
xi i.ae_type
foreach v of varlist _Iae_type* {
	capture noisily prtest `v', by(icu_scn_rand_group)
}

restore

/*** Sensivity Analysis: Table 3 - Outcomes - in three groups ***/

// Survival free of organ dysfunction (censored at 28 days) - using pSOFA
tabstat organ_dys_psofa_any_death, by(icu_scn_rand_3gp) stats(n mean sd min max q iqr)
hist organ_dys_psofa_any_death
stset organ_dys_psofa_any_death
sts graph, by(icu_scn_rand_3gp)

// Survival free of inotrope support at 7 days
hist icu_inotropefree_day7_days
tabstat icu_inotropefree_day7_days, by(icu_scn_rand_3gp) stats(n mean sd min max q iqr)

// Survival free of multiorgan dysfunction at 7 days - using pSOFA
tabstat mo_dys_psofa_any_death_7day, by(icu_scn_rand_3gp) stats(n mean sd min max q iqr)
hist mo_dys_psofa_any_death_7day
stset mo_dys_psofa_any_death_7day
sts graph, by(icu_scn_rand_3gp)

// Death at 28 days
tab out_28d_status icu_scn_rand_3gp, m col
tab out_28d_status icu_scn_rand_3gp, col

// Survival free of PICU stay (censored at 28 days)
hist picu_free_surv
tabstat picu_free_surv, by(icu_scn_rand_3gp) stats(n mean sd min max q iqr)

// PICU length of stay
hist icu_los
tabstat icu_los, by(icu_scn_rand_3gp) stats(n mean sd min max q iqr)

// Hospital length of stay
hist hosp_los_ed
tabstat hosp_los_ed, by(icu_scn_rand_3gp) stats(n mean sd min max q iqr)
capture noisily qreg hosp_los_ed icu_scn_rand_3gp

// 28 day POPC
tab out_28d_popc icu_scn_rand_3gp, m col
tab out_28d_popc icu_scn_rand_3gp, col
tabstat out_28d_popc, by(icu_scn_rand_3gp) stats(n mean sd min max q iqr)
tab out_mpopc_change icu_scn_rand_3gp, m col
tab out_mpopc_change icu_scn_rand_3gp, col
tabstat out_mpopc_change, by(icu_scn_rand_3gp) stats(n mean sd min max q iqr)

// FSS
hist out_28d_fss_score
tabstat out_28d_fss_score, by(icu_scn_rand_3gp) stats(n mean sd min max q iqr)
hist out_fss_change
tabstat out_fss_change, by(icu_scn_rand_3gp) stats(n mean sd min max q iqr)

// Lactate <2mmol/L by six hours post enrolment
tab icu_lactate2_first6 icu_scn_rand_3gp, m col
tab icu_lactate2_first6 icu_scn_rand_3gp, col

// Lactate <2mmol/L by 12 hours post enrolment
tab icu_lactate2_first12 icu_scn_rand_3gp, m col
tab icu_lactate2_first12 icu_scn_rand_3gp, col

// Lactate <2mmol/L by 24 hours post enrolment
tab icu_lactate2_first24 icu_scn_rand_3gp, m col
tab icu_lactate2_first24 icu_scn_rand_3gp, col

// Time to reversal of tachycardia censored at 24 hours
hist icu_t_diff_normalhr_rand
tabstat icu_t_diff_normalhr_rand, by(icu_scn_rand_3gp) stats(n mean sd min max q iqr)

// Time to shock reversal censored at 28 days
hist icu_t_diff_inoend_rand_min
tabstat icu_t_diff_inoend_rand_min, by(icu_scn_rand_3gp) stats(n mean sd min max q iqr)

/*** Sensivity Analysis: Table 4 - Outcomes - only patients with septic shock and pSOFA lung component >=2 ***/
preserve

tab subgroup_acutelung
keep if subgroup_acutelung==1

// Survival free of organ dysfunction (censored at 28 days) - using pSOFA
tabstat organ_dys_psofa_any_death, by(icu_scn_rand_group) stats(n mean sd min max q iqr)
hist organ_dys_psofa_any_death
stset organ_dys_psofa_any_death
sts graph, by(icu_scn_rand_group)

// Survival free of inotrope support at 7 days
hist icu_inotropefree_day7_days
tabstat icu_inotropefree_day7_days, by(icu_scn_rand_group) stats(n mean sd min max q iqr)

// Survival free of multiorgan dysfunction at 7 days - using pSOFA
tabstat mo_dys_psofa_any_death_7day, by(icu_scn_rand_group) stats(n mean sd min max q iqr)
hist mo_dys_psofa_any_death_7day
stset mo_dys_psofa_any_death_7day
sts graph, by(icu_scn_rand_group)

// Death at 28 days
tab out_28d_status icu_scn_rand_group, m col
tab out_28d_status icu_scn_rand_group, col

// Survival free of PICU stay (censored at 28 days)
hist picu_free_surv
tabstat picu_free_surv, by(icu_scn_rand_group) stats(n mean sd min max q iqr)

// PICU length of stay
hist icu_los
tabstat icu_los, by(icu_scn_rand_group) stats(n mean sd min max q iqr)

// Hospital length of stay
hist hosp_los_ed
tabstat hosp_los_ed, by(icu_scn_rand_group) stats(n mean sd min max q iqr)
capture noisily qreg hosp_los_ed icu_scn_rand_group

// 28 day POPC
tab out_28d_popc icu_scn_rand_group, m col
tab out_28d_popc icu_scn_rand_group, col
tabstat out_28d_popc, by(icu_scn_rand_group) stats(n mean sd min max q iqr)
tab out_mpopc_change icu_scn_rand_group, m col
tab out_mpopc_change icu_scn_rand_group, col
tabstat out_mpopc_change, by(icu_scn_rand_group) stats(n mean sd min max q iqr)

// FSS
hist out_28d_fss_score
tabstat out_28d_fss_score, by(icu_scn_rand_group) stats(n mean sd min max q iqr)
hist out_fss_change
tabstat out_fss_change, by(icu_scn_rand_group) stats(n mean sd min max q iqr)

// Lactate <2mmol/L by six hours post enrolment
tab icu_lactate2_first6 icu_scn_rand_group, m col
tab icu_lactate2_first6 icu_scn_rand_group, col

// Lactate <2mmol/L by 12 hours post enrolment
tab icu_lactate2_first12 icu_scn_rand_group, m col
tab icu_lactate2_first12 icu_scn_rand_group, col

// Lactate <2mmol/L by 24 hours post enrolment
tab icu_lactate2_first24 icu_scn_rand_group, m col
tab icu_lactate2_first24 icu_scn_rand_group, col

// Time to reversal of tachycardia censored at 24 hours
hist icu_t_diff_normalhr_rand
tabstat icu_t_diff_normalhr_rand, by(icu_scn_rand_group) stats(n mean sd min max q iqr)

// Time to shock reversal censored at 28 days
hist icu_t_diff_inoend_rand_min
tabstat icu_t_diff_inoend_rand_min, by(icu_scn_rand_group) stats(n mean sd min max q iqr)

restore

/* Figures */

preserve
keep record_id icu_bl_hr icu_obs_hr1 icu_obs_hr2 icu_obs_hr3 icu_obs_hr4 ///
			   icu_bl_rr icu_obs_rr1 icu_obs_rr2 icu_obs_rr3 icu_obs_rr4 ///
			   icu_bl_sbp icu_obs_sbp1 icu_obs_sbp2 icu_obs_sbp3 icu_obs_sbp4 ///
			   icu_bl_dbp icu_obs_dbp1 icu_obs_dbp2 icu_obs_dbp3 icu_obs_dbp4 ///
			   icu_bl_vis_score icu_obs_vis_score1 icu_obs_vis_score2 icu_obs_vis_score3 icu_obs_vis_score4 ///
			   icu_bl_lactate icu_obs_lactate1 icu_obs_lactate2 icu_obs_lactate3 icu_obs_lactate4 ///
			   icu_bl_gcs icu_obs_gcs1 icu_obs_gcs2 icu_obs_gcs3 icu_obs_gcs4
			   
rename icu_bl_hr icu_obs_hr0
rename icu_bl_rr icu_obs_rr0
rename icu_bl_sbp icu_obs_sbp0
rename icu_bl_dbp icu_obs_dbp0
rename icu_bl_vis_score icu_obs_vis_score0
rename icu_bl_lactate icu_obs_lactate0
rename icu_bl_gcs icu_obs_gcs0
reshape long icu_obs_hr icu_obs_rr icu_obs_sbp icu_obs_dbp icu_obs_vis_score ///
			 icu_obs_lactate icu_obs_gcs, i(record_id) j(timepoint)
gen icu_obs_map=(icu_obs_sbp+2*icu_obs_dbp)/3
gen icu_obs_pp=icu_obs_sbp-icu_obs_dbp
gen icu_obs_shock=icu_obs_hr/icu_obs_sbp
label define timepoint 0 "Baseline" 1 "0-1hr" 2 ">1-6hr" 3 ">6-12hr" 4 ">12-24hr"
label values timepoint timepoint

// Heart rate
graph box icu_obs_hr if icu_obs_hr<4444, over(timepoint, label(labsize(small))) ///
	  graphr(color(white)) plotr(lcolor(black)) box(1,color(black) ///
	  fcolor(gs8)) marker(1, msize(small) mfcolor(black) mlcolor(black)) ///
	  ytitle("Heart Rate (beats per minute)") ylabel(, glpattern(dash) glcolor(gs14)) ///
	  caption("Timepoint", position(6))
	  
ciplot icu_obs_hr if icu_obs_hr<4444, by(timepoint) graphr(color(white)) plotr(lcolor(black)) ///
	  ylabel(, glpattern(dash) glcolor(gs14)) rcap(lcolor(black)) ///
	  mfcolor(black) mlcolor(black) msymbol(D) msize(small) ///
	  xlabel(,labsize(small)) xtitle("Timepoint",margin(small)) ///
	  ytitle("Heart Rate (beats per minute)")
	  
// Respiratory rate
graph box icu_obs_rr if icu_obs_rr<4444, over(timepoint, label(labsize(small))) ///
	  graphr(color(white)) plotr(lcolor(black)) box(1,color(black) ///
	  fcolor(gs8)) marker(1, msize(small) mfcolor(black) mlcolor(black)) ///
	  ytitle("Respiratory Rate (breaths per minute)") ylabel(, glpattern(dash) glcolor(gs14)) ///
	  caption("Timepoint", position(6))
	  
ciplot icu_obs_rr if icu_obs_rr<4444, by(timepoint) graphr(color(white)) plotr(lcolor(black)) ///
	  ylabel(, glpattern(dash) glcolor(gs14)) rcap(lcolor(black)) ///
	  mfcolor(black) mlcolor(black) msymbol(D) msize(small) ///
	  xlabel(,labsize(small)) xtitle("Timepoint",margin(small)) ///
	  ytitle("Respiratory Rate (breaths per minute)")

// Mean arterial pressure
graph box icu_obs_map if icu_obs_map<4444, over(timepoint, label(labsize(small))) ///
	  graphr(color(white)) plotr(lcolor(black)) box(1,color(black) ///
	  fcolor(gs8)) marker(1, msize(small) mfcolor(black) mlcolor(black)) ///
	  ytitle("Mean Arterial Pressure") ylabel(, glpattern(dash) glcolor(gs14)) ///
	  caption("Timepoint", position(6))
	  
ciplot icu_obs_map if icu_obs_map<4444, by(timepoint) graphr(color(white)) plotr(lcolor(black)) ///
	  ylabel(, glpattern(dash) glcolor(gs14)) rcap(lcolor(black)) ///
	  mfcolor(black) mlcolor(black) msymbol(D) msize(small) ///
	  xlabel(,labsize(small)) xtitle("Timepoint",margin(small)) ///
	  ytitle("Mean Arterial Pressure")

// Systolic blood pressure
graph box icu_obs_sbp if icu_obs_sbp<4444, over(timepoint, label(labsize(small))) ///
	  graphr(color(white)) plotr(lcolor(black)) box(1,color(black) ///
	  fcolor(gs8)) marker(1, msize(small) mfcolor(black) mlcolor(black)) ///
	  ytitle("Systolic Blood Pressure (mmHg)") ylabel(, glpattern(dash) glcolor(gs14)) ///
	  caption("Timepoint", position(6))
	  
ciplot icu_obs_sbp if icu_obs_sbp<4444, by(timepoint) graphr(color(white)) plotr(lcolor(black)) ///
	  ylabel(, glpattern(dash) glcolor(gs14)) rcap(lcolor(black)) ///
	  mfcolor(black) mlcolor(black) msymbol(D) msize(small) ///
	  xlabel(,labsize(small)) xtitle("Timepoint",margin(small)) ///
	  ytitle("Systolic Blood Pressure (mmHg)")

// Diastolic blood pressure
graph box icu_obs_dbp if icu_obs_dbp<4444, over(timepoint, label(labsize(small))) ///
	  graphr(color(white)) plotr(lcolor(black)) box(1,color(black) ///
	  fcolor(gs8)) marker(1, msize(small) mfcolor(black) mlcolor(black)) ///
	  ytitle("Diastolic Blood Pressure (mmHg)") ylabel(, glpattern(dash) glcolor(gs14)) ///
	  caption("Timepoint", position(6))
	  
ciplot icu_obs_dbp if icu_obs_dbp<4444, by(timepoint) graphr(color(white)) plotr(lcolor(black)) ///
	  ylabel(, glpattern(dash) glcolor(gs14)) rcap(lcolor(black)) ///
	  mfcolor(black) mlcolor(black) msymbol(D) msize(small) ///
	  xlabel(,labsize(small)) xtitle("Timepoint",margin(small)) ///
	  ytitle("Diastolic Blood Pressure (mmHg)")
	  
// Pulse pressure
graph box icu_obs_pp if icu_obs_pp<4444, over(timepoint, label(labsize(small))) ///
	  graphr(color(white)) plotr(lcolor(black)) box(1,color(black) ///
	  fcolor(gs8)) marker(1, msize(small) mfcolor(black) mlcolor(black)) ///
	  ytitle("Pulse Pressure (mmHg)") ylabel(, glpattern(dash) glcolor(gs14)) ///
	  caption("Timepoint", position(6))
	  
ciplot icu_obs_pp if icu_obs_pp<4444, by(timepoint) graphr(color(white)) plotr(lcolor(black)) ///
	  ylabel(, glpattern(dash) glcolor(gs14)) rcap(lcolor(black)) ///
	  mfcolor(black) mlcolor(black) msymbol(D) msize(small) ///
	  xlabel(,labsize(small)) xtitle("Timepoint",margin(small)) ///
	  ytitle("Pulse Pressure (mmHg)")
	  
// Shock Index
graph box icu_obs_shock if icu_obs_shock<4444, over(timepoint, label(labsize(small))) ///
	  graphr(color(white)) plotr(lcolor(black)) box(1,color(black) ///
	  fcolor(gs8)) marker(1, msize(small) mfcolor(black) mlcolor(black)) ///
	  ytitle("Shock Index (bpm/mmHg)") ylabel(, glpattern(dash) glcolor(gs14)) ///
	  caption("Timepoint", position(6))
	  
ciplot icu_obs_shock if icu_obs_shock<4444, by(timepoint) graphr(color(white)) plotr(lcolor(black)) ///
	  ylabel(, glpattern(dash) glcolor(gs14)) rcap(lcolor(black)) ///
	  mfcolor(black) mlcolor(black) msymbol(D) msize(small) ///
	  xlabel(,labsize(small)) xtitle("Timepoint",margin(small)) ///
	  ytitle("Shock Index (bpm/mmHg)")
	  
// VIS
graph box icu_obs_vis_score if icu_obs_vis_score<4444, over(timepoint, label(labsize(small))) ///
	  graphr(color(white)) plotr(lcolor(black)) box(1,color(black) ///
	  fcolor(gs8)) marker(1, msize(small) mfcolor(black) mlcolor(black)) ///
	  ytitle("Vasoactive Inotrope Score") ylabel(, glpattern(dash) glcolor(gs14)) ///
	  caption("Timepoint", position(6))
	  
ciplot icu_obs_vis_score if icu_obs_vis_score<4444, by(timepoint) graphr(color(white)) plotr(lcolor(black)) ///
	  ylabel(, glpattern(dash) glcolor(gs14)) rcap(lcolor(black)) ///
	  mfcolor(black) mlcolor(black) msymbol(D) msize(small) ///
	  xlabel(,labsize(small)) xtitle("Timepoint",margin(small)) ///
	  ytitle("Vasoactive Inotrope Score")
	  
// Lactate
graph box icu_obs_lactate if icu_obs_lactate<4444, over(timepoint, label(labsize(small))) ///
	  graphr(color(white)) plotr(lcolor(black)) box(1,color(black) ///
	  fcolor(gs8)) marker(1, msize(small) mfcolor(black) mlcolor(black)) ///
	  ytitle("Lactate (mmol/L)") ylabel(, glpattern(dash) glcolor(gs14)) ///
	  caption("Timepoint", position(6))
	  
ciplot icu_obs_lactate if icu_obs_lactate<4444, by(timepoint) graphr(color(white)) plotr(lcolor(black)) ///
	  ylabel(, glpattern(dash) glcolor(gs14)) rcap(lcolor(black)) ///
	  mfcolor(black) mlcolor(black) msymbol(D) msize(small) ///
	  xlabel(,labsize(small)) xtitle("Timepoint",margin(small)) ///
	  ytitle("Lactate (mmol/L)")

// Glasgow Coma Score
graph box icu_obs_gcs if icu_obs_gcs<4444, over(timepoint, label(labsize(small))) ///
	  graphr(color(white)) plotr(lcolor(black)) box(1,color(black) ///
	  fcolor(gs8)) marker(1, msize(small) mfcolor(black) mlcolor(black)) ///
	  ytitle("Glasgow Coma Score") ylabel(, glpattern(dash) glcolor(gs14)) ///
	  caption("Timepoint", position(6))
	  
ciplot icu_obs_gcs if icu_obs_gcs<4444, by(timepoint) graphr(color(white)) plotr(lcolor(black)) ///
	  ylabel(, glpattern(dash) glcolor(gs14)) rcap(lcolor(black)) ///
	  mfcolor(black) mlcolor(black) msymbol(D) msize(small) ///
	  xlabel(,labsize(small)) xtitle("Timepoint",margin(small)) ///
	  ytitle("Glasgow Coma Score")
	  
restore
