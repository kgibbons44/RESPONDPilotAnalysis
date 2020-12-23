/**** RESPOND ED Pilot Data Analysis ****/

/* Number of ED patients that went on to the PICU study */
tab ed_scn_consent_type icu_scn_consent_type, m cell col row

/* Keep only the ED patients */
keep if ed_scn_dt~=.

/*** SCREENING, CONSENT ****/

// Number screened
count if ed_scn_dt~=.

// Number eligible
tab ed_scn_pt_eligibility_calc, m

// Reasons for non-eligibility - inclusion criteria
foreach i of numlist 1/5 {
	capture noisily tab ed_scn_inc_cri_0`i', m
}

// Reasons for non-eligibility - exclusion criteria
foreach i of numlist 1/9 {
	capture noisily tab ed_scn_exc_cri_0`i', m
}
foreach i of numlist 10/13 {
	capture noisily tab ed_scn_exc_cri_`i', m
}

/* Keep only those eligible */
keep if ed_scn_pt_eligibility_calc==1

// Number consented
tab ed_scn_rand_group, m

// Consent rate
tab ed_scn_consent_type if ed_scn_consent_type~=0, m

/* Keep only those consented */
keep if ed_scn_consent_type==1 | ed_scn_consent_type==2

// Consent type
tab ed_scn_consent_type

// Reasons for consent to continue
foreach i of numlist 1/5 {
	capture noisily tab ed_scn_consent_ctc_reason___`i' if ed_scn_consent_type==2, m
}
tab ed_scn_consent_ctc_other

// Written consent obtained
tab ed_scn_consent_yn ed_scn_consent_type, m col

// Informed consent declined
tab ed_scn_declined_yn, m

// Patient missed
tab ed_scn_missed_yn, m

// Withdrawn
tab woc_yn, m
tab woc_applies_to if woc_yn==1, m

// Keep only those randomised, consented and not withdrawn
keep if ~missing(ed_scn_rand_group) & ed_scn_consent_yn==1
drop if woc_applies_to==1

// Time from implementation of consent-to-continue to finalisation of informed consent for consent-to-continue patients
hist t_diff_icu_ctc_writen_hr_ed
tabstat t_diff_icu_ctc_writen_hr_ed, by(ed_scn_rand_group) stats(n mean sd min max q iqr)

/*** Table 1: Baseline characteristics ***/

// Age at randomisation
hist dem_ed_rand_age_days
hist dem_ed_rand_age_years
tabstat dem_ed_rand_age_years, by(ed_scn_rand_group) stats(n mean sd min max q iqr)

// Weight
hist dem_weight
tabstat dem_weight, by(ed_scn_rand_group) stats(n mean sd min max q iqr)

// Sex
tab dem_sex ed_scn_rand_group, m col
tab dem_sex ed_scn_rand_group, col

// Ethnicity 
tab dem_ethnicity_grp ed_scn_rand_group, m col
tab dem_ethnicity_grp ed_scn_rand_group, col

// Chronic disease
local chronic "dem_chronic_yn dem_malform dem_asthma dem_chd dem_onc dem_cp_enceph dem_metabolic dem_immuno dem_syndrome dem_chronic_other_all"
foreach v of varlist `chronic' {
	tab `v' ed_scn_rand_group, m col

}
local chronic_other "dem_malform_specify dem_onc_specify dem_immuno_specify dem_syndrome_specify dem_chronic_specify"
foreach v of varlist `chronic_other' {
	tab `v' ed_scn_rand_group, m col
	tab `v' ed_scn_rand_group, col
}

// mPOPC
hist dem_popc_pre_hosp
tabstat dem_popc_pre_hosp, by(ed_scn_rand_group) stats(n mean sd min max q iqr)

// FSS
hist dem_fss_score
tabstat dem_fss_score, by(ed_scn_rand_group) stats(n mean sd min max q iqr)

// Baseline physiological observations
local ed_baseline_phys_cont "ed_bl_hr ed_bl_rr ed_bl_sbp ed_bl_dbp ed_bl_temp ed_bl_spo2 ed_bl_fio2"
foreach v of varlist `ed_baseline_phys_cont' {
	hist `v', saving(Figures\hist_`v', replace)
	tabstat `v', by(ed_scn_rand_group) stats(n mean sd min max q iqr)
}

// Baseline treatments
local ed_baseline_cat "ed_bl_hfnc ed_bl_niv ed_bl_inv"
foreach v of varlist `ed_baseline_cat' {
	tab `v'_ny ed_scn_rand_group, m col
	tab `v'_ny ed_scn_rand_group, col
}

// CRT
tab ed_bl_crt ed_scn_rand_group, m col
tab ed_bl_crt ed_scn_rand_group, col

// GCS
tab ed_bl_gcs_yn ed_scn_rand_group, m col
tab ed_bl_gcs_yn ed_scn_rand_group, col
hist ed_bl_gcs
tabstat ed_bl_gcs, by(ed_scn_rand_group) stats(n mean sd min max q iqr)

// AVPU
tab ed_bl_avpu_yn ed_scn_rand_group, m col
tab ed_bl_avpu_yn ed_scn_rand_group, col
tab ed_bl_avpu ed_scn_rand_group, m col
tab ed_bl_avpu ed_scn_rand_group, col

// Baseline laboratory parameters
local ed_baseline_lab_cont "ed_bl_ph ed_bl_base ed_bl_paco2 ed_bl_lactate ed_bl_glucose ed_bl_na ed_bl_cl ed_bl_creatinine ed_bl_bilirubin ed_bl_alat ed_bl_inr ed_bl_fibrinogen ed_bl_platelets ed_bl_wcc ed_bl_neutrophil ed_bl_hb ed_bl_crp"
foreach v of varlist `ed_baseline_lab_cont' {
	hist `v', saving(Figures\hist_`v', replace)
	tabstat `v', by(ed_scn_rand_group) stats(n mean sd min max q iqr)
}

// pSOFA
hist ed_bl_psofa_comb
tabstat ed_bl_psofa_comb, by(ed_scn_rand_group) stats(n mean sd min max q iqr)

// PELOD-2
hist ed_bl_pelod2
tabstat ed_bl_pelod2, by(ed_scn_rand_group) stats(n mean sd min max q iqr)

// Treatments

* Fluid administered in past four hours / kg
hist ed_bl_fluid_bolus_total_kg
tabstat ed_bl_fluid_bolus_total_kg, by(ed_scn_rand_group) stats(n mean sd min max q iqr)

* Time since antibiotics were started
hist ed_bl_time_diff_iv_rand_min
tabstat ed_bl_time_diff_iv_rand_min, by(ed_scn_rand_group) stats(n mean sd min max q iqr)

/*** Table 2: Feasibility outcomes ***/

// Time from screening to randomisation
hist t_diff_ed_scn_rand_min
tabstat t_diff_ed_scn_rand_min, by(ed_scn_rand_group) stats(n mean sd min max q iqr)
capture noisily qreg t_diff_ed_scn_rand_min ed_scn_rand_group

// Time from randomisation to commencement of treatment
hist t_diff_rand_tmt_min
tabstat t_diff_rand_tmt_min, by(ed_scn_rand_group) stats(n mean sd min max q iqr)
capture noisily qreg t_diff_rand_tmt_min ed_scn_rand_group

// Time from randomisation to adrenaline infusion commencement
tab ed_trt_adren ed_scn_rand_group, m col
tab ed_trt_adren ed_scn_rand_group, col
hist t_diff_rand_adren_min
tabstat t_diff_rand_adren_min, by(ed_scn_rand_group) stats(n mean sd min max q iqr)
capture noisily qreg t_diff_rand_adren_min ed_scn_rand_group

// Time from randomisation to inotrope infusion commencement
hist t_diff_rand_ino_min
tabstat t_diff_rand_ino_min, by(ed_scn_rand_group) stats(n mean sd min max q iqr)
capture noisily qreg t_diff_rand_ino_min ed_scn_rand_group

// Inotrope infusion
// - within first hour of randomisation
tab rand_ino_firsthr ed_scn_rand_group, m col
tab rand_ino_firsthr ed_scn_rand_group, col
capture noisily prtest rand_ino_firsthr, by(ed_scn_rand_group)
// - within 24 hours post randomisation
tab rand_ino_firstday ed_scn_rand_group, m col chi exact
tab rand_ino_firstday ed_scn_rand_group, col chi exact
capture noisily prtest rand_ino_firstday, by(ed_scn_rand_group)

// Total amount in fluids received
local ed_fluids_recvd "ed_obs_fluid_firsthr_kg ed_obs_fluid_61_240min_kg ed_obs_fluid_4_12hr_kg ed_obs_fluid_bolus_total15_kg ed_obs_fluid_24hr_kg"
foreach v in `ed_fluids_recvd' {
	hist `v'
	tabstat `v', by(ed_scn_rand_group) stats(n mean sd min max q iqr)
	capture noisily qreg `v' ed_scn_rand_group
}

/*** Table 3: Primary and secondary clinical outcomes ***/

// Survival free of organ dysfunction (censored at 28 days) - using pSOFA
tabstat organ_dys_psofa_any_death, by(ed_scn_rand_group) stats(n mean sd min max q iqr)
hist organ_dys_psofa_any_death
capture noisily qreg organ_dys_psofa_any_death ed_scn_rand_group
stset organ_dys_psofa_any_death
sts graph, by(ed_scn_rand_group)

// Survival free of inotrope support at 7 days
hist ed_inotropefree_day7_days
tabstat ed_inotropefree_day7_days, by(ed_scn_rand_group) stats(n mean sd min max q iqr)
capture noisily qreg ed_inotropefree_day7_days ed_scn_rand_group

// Survival free of multiorgan dysfunction at 7 days - using pSOFA
tabstat mo_dys_psofa_any_death_7day, by(ed_scn_rand_group) stats(n mean sd min max q iqr)
hist mo_dys_psofa_any_death_7day
capture noisily qreg mo_dys_psofa_any_death_7day ed_scn_rand_group
stset mo_dys_psofa_any_death_7day
sts graph, by(ed_scn_rand_group)

// Death at 28 days
tab out_28d_status ed_scn_rand_group, m col
tab out_28d_status ed_scn_rand_group, col
capture noisily prtest out_28d_status, by(ed_scn_rand_group)

// Survival free of PICU stay (censored at 28 days)
hist picu_free_surv
tabstat picu_free_surv, by(ed_scn_rand_group) stats(n mean sd min max q iqr)
capture noisily qreg picu_free_surv ed_scn_rand_group

// PICU length of stay
hist icu_los
tabstat icu_los, by(ed_scn_rand_group) stats(n mean sd min max q iqr)
capture noisily qreg icu_los ed_scn_rand_group

// Hospital length of stay
hist hosp_los_ed
tabstat hosp_los_ed, by(ed_scn_rand_group) stats(n mean sd min max q iqr)
capture noisily qreg hosp_los_ed ed_scn_rand_group

// 28 day mPOPC
tab out_28d_popc ed_scn_rand_group, m col
tab out_28d_popc ed_scn_rand_group, col
tabstat out_28d_popc, by(ed_scn_rand_group) stats(n mean sd min max q iqr)
capture noisily qreg out_28d_popc ed_scn_rand_group
tab out_mpopc_change ed_scn_rand_group, m col
tab out_mpopc_change ed_scn_rand_group, col
tabstat out_mpopc_change, by(ed_scn_rand_group) stats(n mean sd min max q iqr)
capture noisily qreg out_mpopc_change ed_scn_rand_group

// FSS
hist out_28d_fss_score
tabstat out_28d_fss_score, by(ed_scn_rand_group) stats(n mean sd min max q iqr)
capture noisily qreg out_28d_fss_score ed_scn_rand_group
hist out_fss_change
tabstat out_fss_change, by(ed_scn_rand_group) stats(n mean sd min max q iqr)
capture noisily qreg out_fss_change ed_scn_rand_group

// Lactate <2mmol/L by six hours post enrolment
tab ed_lactate2_first6 ed_scn_rand_group, m col
tab ed_lactate2_first6 ed_scn_rand_group, col
capture noisily prtest ed_lactate2_first6, by(ed_scn_rand_group)

// Lactate <2mmol/L by 12 hours post enrolment
tab ed_lactate2_first12 ed_scn_rand_group, m col
tab ed_lactate2_first12 ed_scn_rand_group, col
capture noisily prtest ed_lactate2_first12, by(ed_scn_rand_group)

// Lactate <2mmol/L by 24 hours post enrolment
tab ed_lactate2_first24 ed_scn_rand_group, m col
tab ed_lactate2_first24 ed_scn_rand_group, col
capture noisily prtest ed_lactate2_first24, by(ed_scn_rand_group)

// Time to reversal of tachycardia censored at 24 hours
hist ed_t_diff_normalhr_rand
tabstat ed_t_diff_normalhr_rand, by(ed_scn_rand_group) stats(n mean sd min max q iqr)
capture noisily qreg ed_t_diff_normalhr_rand ed_scn_rand_group

// Time to shock reversal censored at 28 days
hist ed_t_diff_inoend_rand_min
tabstat ed_t_diff_inoend_rand_min, by(ed_scn_rand_group) stats(n mean sd min max q iqr)
capture noisily qreg ed_t_diff_inoend_rand_min ed_scn_rand_group

/*** Table 4: Protocol violations and adverse events **/

// Protocol deviations
tab pdf_yn, m

preserve
keep if pdf_yn==1

tab pdf_details, m
tab pdf_details ed_scn_rand_group, m
replace pdf_details=0 if pdf_details==8
xi i.pdf_details
foreach v of varlist _Ipdf_detai_* {
	capture noisily prtest `v', by(ed_scn_rand_group)
}

restore

// Adverse events
preserve
tab ae_yn1 ed_scn_rand_group, m
use "OutputData\ae_long0.dta", clear
keep if ed_scn_rand_group~=.
tab ae_relationship ed_scn_rand_group, m col
tab ae_relationship ed_scn_rand_group, col
tab ae_type ed_scn_rand_group, m col
tab ae_type ed_scn_rand_group, col
/* Commented out as there is only one AE currently - uncomment if there are more in the final analysis
xi i.ae_type
foreach v of varlist _Iae_type* {
	capture noisily prtest `v', by(ed_scn_rand_group)
}*/

restore

/* Figures */

preserve
keep record_id ed_scn_rand_group ///
			   ed_bl_hr ed_obs_hr* ///
			   ed_bl_rr ed_obs_rr* ///
			   ed_bl_sbp ed_obs_sbp* ///
			   ed_bl_dbp ed_obs_dbp* ///
			   ed_obs_vis_score* ///
			   ed_bl_lactate ed_obs_lactate* ///
			   ed_bl_gcs ed_obs_gcs1 ed_obs_gcs2 ed_obs_gcs3 ed_obs_gcs4 ed_obs_gcs5 ///
			   ed_obs_gcs6 ed_obs_gcs7 ed_obs_gcs8 ed_obs_gcs9 ed_obs_gcs_yn10 ///
			   ed_obs_gcs11 ed_obs_gcs12 ed_obs_gcs13 ed_obs_gcs14 ed_obs_gcs15
			   
rename ed_bl_hr ed_obs_hr0
rename ed_bl_rr ed_obs_rr0
rename ed_bl_sbp ed_obs_sbp0
rename ed_bl_dbp ed_obs_dbp0
rename ed_bl_lactate ed_obs_lactate0
rename ed_bl_gcs ed_obs_gcs0
reshape long ed_obs_hr ed_obs_rr ed_obs_sbp ed_obs_dbp ed_obs_vis_score ///
			 ed_obs_lactate ed_obs_gcs, i(record_id) j(timepoint)
gen ed_obs_map=(ed_obs_sbp+2*ed_obs_dbp)/3
gen ed_obs_pp=ed_obs_sbp-ed_obs_dbp
gen ed_obs_shock=ed_obs_hr/ed_obs_sbp
label define timepoint 0 "Baseline" 1 "0-20min" 2 ">20-40min" 3 ">40-60min" 4 ">60-80min" ///
					   5 ">80-100min" 6 ">100-120min" 7 ">120-140min" 8 ">140-160min" ///
					   9 ">160-180min" 10 ">180-200min" 11 ">200-220min" 12 ">220-240min" ///
					   13 ">4-6hr" 14 ">6-12hr" 15 ">12-24hr"
label values timepoint timepoint

// Heart rate
graph box ed_obs_hr if ed_obs_hr<4444, over(ed_scn_rand_group, label(nolabel)) over(timepoint, label(labsize(small) angle(vertical))) ///
	  graphr(color(white)) plotr(lcolor(black)) box(1,color(black)) box(2,color(red)) ///
	  fcolor(gs8)) marker(1, msize(small) mfcolor(black) mlcolor(black)) ///
	  ytitle("Heart Rate (beats per minute)") ylabel(, glpattern(dash) glcolor(gs14)) ///
	  caption("Timepoint", position(6))
	  
graph box ed_obs_hr if ed_obs_hr<4444, over(timepoint, label(labsize(small) angle(vertical))) ///
	  graphr(color(white)) plotr(lcolor(black)) box(1,color(black) ///
	  fcolor(gs8)) marker(1, msize(small) mfcolor(black) mlcolor(black)) ///
	  ytitle("Heart Rate (beats per minute)") ylabel(, glpattern(dash) glcolor(gs14)) ///
	  caption("Timepoint", position(6))
	
twoway lfitci ed_obs_hr timepoint if ed_obs_hr<4444 & ed_scn_rand_group==1 || ///
	   lfitci ed_obs_hr timepoint if ed_obs_hr<4444 & ed_scn_rand_group==2
	
ciplot ed_obs_hr if ed_obs_hr<4444, by(timepoint) graphr(color(white)) plotr(lcolor(black)) ///
	  ylabel(, glpattern(dash) glcolor(gs14)) rcap(lcolor(black)) ///
	  mfcolor(black) mlcolor(black) msymbol(D) msize(small) ///
	  xlabel(,labsize(small) angle(vertical)) xtitle("Timepoint",margin(small)) ///
	  ytitle("Heart Rate (beats per minute)")
	  
// Respiratory rate
graph box ed_obs_rr if ed_obs_rr<4444, over(timepoint, label(labsize(small) angle(vertical))) ///
	  graphr(color(white)) plotr(lcolor(black)) box(1,color(black) ///
	  fcolor(gs8)) marker(1, msize(small) mfcolor(black) mlcolor(black)) ///
	  ytitle("Respiratory Rate (breaths per minute)") ylabel(, glpattern(dash) glcolor(gs14)) ///
	  caption("Timepoint", position(6))

ciplot ed_obs_rr if ed_obs_rr<4444, by(timepoint) graphr(color(white)) plotr(lcolor(black)) ///
	  ylabel(, glpattern(dash) glcolor(gs14)) rcap(lcolor(black)) ///
	  mfcolor(black) mlcolor(black) msymbol(D) msize(small) ///
	  xlabel(,labsize(small) angle(vertical)) xtitle("Timepoint",margin(small)) ///
	  ytitle("Respiratory Rate (breaths per minute)")
	  
// Mean arterial pressure
graph box ed_obs_map if ed_obs_map<4444, over(timepoint, label(labsize(small) angle(vertical))) ///
	  graphr(color(white)) plotr(lcolor(black)) box(1,color(black) ///
	  fcolor(gs8)) marker(1, msize(small) mfcolor(black) mlcolor(black)) ///
	  ytitle("Mean Arterial Pressure") ylabel(, glpattern(dash) glcolor(gs14)) ///
	  caption("Timepoint", position(6))

ciplot ed_obs_map if ed_obs_map<4444, by(timepoint) graphr(color(white)) plotr(lcolor(black)) ///
	  ylabel(, glpattern(dash) glcolor(gs14)) rcap(lcolor(black)) ///
	  mfcolor(black) mlcolor(black) msymbol(D) msize(small) ///
	  xlabel(,labsize(small) angle(vertical)) xtitle("Timepoint",margin(small)) ///
	  ytitle("Mean Arterial Pressure")

// Systolic blood pressure
graph box ed_obs_sbp if ed_obs_sbp<4444, over(timepoint, label(labsize(small) angle(vertical))) ///
	  graphr(color(white)) plotr(lcolor(black)) box(1,color(black) ///
	  fcolor(gs8)) marker(1, msize(small) mfcolor(black) mlcolor(black)) ///
	  ytitle("Systolic Blood Pressure (mmHg)") ylabel(, glpattern(dash) glcolor(gs14)) ///
	  caption("Timepoint", position(6))

ciplot ed_obs_sbp if ed_obs_sbp<4444, by(timepoint) graphr(color(white)) plotr(lcolor(black)) ///
	  ylabel(, glpattern(dash) glcolor(gs14)) rcap(lcolor(black)) ///
	  mfcolor(black) mlcolor(black) msymbol(D) msize(small) ///
	  xlabel(,labsize(small) angle(vertical)) xtitle("Timepoint",margin(small)) ///
	  ytitle("Systolic Blood Pressure (mmHg)")

// Diastolic blood pressure
graph box ed_obs_dbp if ed_obs_dbp<4444, over(timepoint, label(labsize(small) angle(vertical))) ///
	  graphr(color(white)) plotr(lcolor(black)) box(1,color(black) ///
	  fcolor(gs8)) marker(1, msize(small) mfcolor(black) mlcolor(black)) ///
	  ytitle("Diastolic Blood Pressure (mmHg)") ylabel(, glpattern(dash) glcolor(gs14)) ///
	  caption("Timepoint", position(6))

ciplot ed_obs_dbp if ed_obs_dbp<4444, by(timepoint) graphr(color(white)) plotr(lcolor(black)) ///
	  ylabel(, glpattern(dash) glcolor(gs14)) rcap(lcolor(black)) ///
	  mfcolor(black) mlcolor(black) msymbol(D) msize(small) ///
	  xlabel(,labsize(small) angle(vertical)) xtitle("Timepoint",margin(small)) ///
	  ytitle("Diastolic Blood Pressure (mmHg)")
	  
// Pulse pressure
graph box ed_obs_pp if ed_obs_pp<4444, over(timepoint, label(labsize(small) angle(vertical))) ///
	  graphr(color(white)) plotr(lcolor(black)) box(1,color(black) ///
	  fcolor(gs8)) marker(1, msize(small) mfcolor(black) mlcolor(black)) ///
	  ytitle("Pulse Pressure (mmHg)") ylabel(, glpattern(dash) glcolor(gs14)) ///
	  caption("Timepoint", position(6))

ciplot ed_obs_pp if ed_obs_pp<4444, by(timepoint) graphr(color(white)) plotr(lcolor(black)) ///
	  ylabel(, glpattern(dash) glcolor(gs14)) rcap(lcolor(black)) ///
	  mfcolor(black) mlcolor(black) msymbol(D) msize(small) ///
	  xlabel(,labsize(small) angle(vertical)) xtitle("Timepoint",margin(small)) ///
	  ytitle("Pulse Pressure (mmHg)")
	  
// Shock Index
graph box ed_obs_shock if ed_obs_shock<4444, over(timepoint, label(labsize(small) angle(vertical))) ///
	  graphr(color(white)) plotr(lcolor(black)) box(1,color(black) ///
	  fcolor(gs8)) marker(1, msize(small) mfcolor(black) mlcolor(black)) ///
	  ytitle("Shock Index (bpm/mmHg)") ylabel(, glpattern(dash) glcolor(gs14)) ///
	  caption("Timepoint", position(6))

ciplot ed_obs_shock if ed_obs_shock<4444, by(timepoint) graphr(color(white)) plotr(lcolor(black)) ///
	  ylabel(, glpattern(dash) glcolor(gs14)) rcap(lcolor(black)) ///
	  mfcolor(black) mlcolor(black) msymbol(D) msize(small) ///
	  xlabel(,labsize(small) angle(vertical)) xtitle("Timepoint",margin(small)) ///
	  ytitle("Shock Index (bpm/mmHg)")
	  
// VIS
graph box ed_obs_vis_score if ed_obs_vis_score<4444, over(timepoint, label(labsize(small) angle(vertical))) ///
	  graphr(color(white)) plotr(lcolor(black)) box(1,color(black) ///
	  fcolor(gs8)) marker(1, msize(small) mfcolor(black) mlcolor(black)) ///
	  ytitle("Vasoactive Inotrope Score") ylabel(, glpattern(dash) glcolor(gs14)) ///
	  caption("Timepoint", position(6))

ciplot ed_obs_vis_score if ed_obs_vis_score<4444, by(timepoint) graphr(color(white)) plotr(lcolor(black)) ///
	  ylabel(, glpattern(dash) glcolor(gs14)) rcap(lcolor(black)) ///
	  mfcolor(black) mlcolor(black) msymbol(D) msize(small) ///
	  xlabel(,labsize(small) angle(vertical)) xtitle("Timepoint",margin(small)) ///
	  ytitle("Vasoactive Inotrope Score")
	  
// Lactate
graph box ed_obs_lactate if ed_obs_lactate<4444, over(timepoint, label(labsize(small) angle(vertical))) ///
	  graphr(color(white)) plotr(lcolor(black)) box(1,color(black) ///
	  fcolor(gs8)) marker(1, msize(small) mfcolor(black) mlcolor(black)) ///
	  ytitle("Lactate (mmol/L)") ylabel(, glpattern(dash) glcolor(gs14)) ///
	  caption("Timepoint", position(6))

ciplot ed_obs_lactate if ed_obs_lactate<4444, by(timepoint) graphr(color(white)) plotr(lcolor(black)) ///
	  ylabel(, glpattern(dash) glcolor(gs14)) rcap(lcolor(black)) ///
	  mfcolor(black) mlcolor(black) msymbol(D) msize(small) ///
	  xlabel(,labsize(small) angle(vertical)) xtitle("Timepoint",margin(small)) ///
	  ytitle("Lactate (mmol/L)")

// Glasgow Coma Score
graph box ed_obs_gcs if ed_obs_gcs<4444, over(timepoint, label(labsize(small) angle(vertical))) ///
	  graphr(color(white)) plotr(lcolor(black)) box(1,color(black) ///
	  fcolor(gs8)) marker(1, msize(small) mfcolor(black) mlcolor(black)) ///
	  ytitle("Glasgow Coma Score") ylabel(, glpattern(dash) glcolor(gs14)) ///
	  caption("Timepoint", position(6))

ciplot ed_obs_gcs if ed_obs_gcs<4444, by(timepoint) graphr(color(white)) plotr(lcolor(black)) ///
	  ylabel(, glpattern(dash) glcolor(gs14)) rcap(lcolor(black)) ///
	  mfcolor(black) mlcolor(black) msymbol(D) msize(small) ///
	  xlabel(,labsize(small) angle(vertical)) xtitle("Timepoint",margin(small)) ///
	  ytitle("Glasgow Coma Score")
	  
restore



