/**** RESPOND ED to PICU Pilot Data Analysis ****/

preserve

// Number screened

keep if ed_scn_dt~=. | icu_scn_dt~=.

/*** SCREENING, CONSENT ****/

// Number screened
count if ed_scn_dt~=.
count if icu_scn_dt~=.

// Number screened for both
count if ed_scn_dt~=. & icu_scn_dt~=.

// Number eligible
tab ed_scn_pt_eligibility_calc if ed_scn_dt~=., m
tab icu_scn_pt_eligibility_calc if icu_scn_dt~=., m

// Number missed
tab ed_scn_missed_yn ed_scn_pt_eligibility_calc if ed_scn_dt~=., m
tab icu_scn_missed_yn icu_scn_pt_eligibility_calc if icu_scn_dt~=., m

/* Keep only those eligible */
keep if ed_scn_pt_eligibility_calc==1 | icu_scn_pt_eligibility_calc==1

// Number consented
tab ed_scn_rand_group if ed_scn_dt~=., m
tab icu_scn_rand_group if icu_scn_dt~=., m

// Consent rate
tab ed_scn_consent_type if ed_scn_dt~=., m
tab icu_scn_consent_type if icu_scn_dt~=., m

/* Keep only those consented */
keep if ed_scn_consent_type==1 | ed_scn_consent_type==2 | icu_scn_consent_type==1 | icu_scn_consent_type==2

// Consent type
tab ed_scn_consent_type, m
tab icu_scn_consent_type, m

// Reasons for consent to continue
foreach i of numlist 1/5 {
	capture noisily tab ed_scn_consent_ctc_reason___`i', m
}

// Written consent obtained
tab ed_scn_consent_yn, m
tab icu_scn_consent_yn, m

// Informed consent declined
tab ed_scn_declined_yn, m
tab icu_scn_declined_yn, m

// Patient missed
tab ed_scn_missed_yn, m
tab icu_scn_missed_yn, m

/* Number of ED patients that went on to the PICU study */
keep if ed_scn_consent_type==1 | ed_scn_consent_type==2 | icu_scn_consent_type==1 | icu_scn_consent_type==2
tab ed_scn_consent_type icu_scn_consent_type, m cell col row

/* Time from ED randomisation to PICU randomisation */
gen t_diff_ed_picu_rand_hr=hours(icu_scn_rand_dt-ed_scn_rand_dt) if ~missing(icu_scn_rand_dt) & ~missing(ed_scn_rand_dt)
hist t_diff_ed_picu_rand_hr
tabstat t_diff_ed_picu_rand_hr, stats(n mean sd min max q iqr)

/* Time from randomised treatment initiation in ED to randomised treatment initiation in PICU */
gen t_diff_ed_picu_tmt_start_hr=hours(icu_bl_alloc_dt_start-ed_bl_alloc_dt_start) if ~missing(icu_bl_alloc_dt_start) & ~missing(ed_bl_alloc_dt_start) & ~missing(icu_scn_rand_dt) & ~missing(ed_scn_rand_dt)
hist t_diff_ed_picu_tmt_start_hr
tabstat t_diff_ed_picu_tmt_start_hr, stats(n mean sd min max q iqr)

/* RESPOND PICU allocation: was it balanced between the two RESPOND ED arms? */
tab icu_scn_rand_group ed_scn_rand_group, m col
tab icu_scn_rand_group ed_scn_rand_group, col

restore
