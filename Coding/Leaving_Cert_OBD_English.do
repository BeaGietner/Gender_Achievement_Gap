
/*=============================================================================
  STATA INSTRUCTIONS FOR RUNNING OAXACA-BLINDER DECOMPOSITIONS
=============================================================================*/
  
  /*-----------------------------------------------------------------------------
  STEP 1: IMPORT AND PREPARE DATA
-----------------------------------------------------------------------------*/
  * Import the dataset created in R
use "decomposition_dataset_english.dta", clear

* Examine the dataset structure
desc
sum

* Check sample sizes for gender and father presence
tab gender_binary
tab father_educ_missing_w1 father_educ_missing_w2

* Make variable names lowercase (Stata convention)
rename *, lower

/*-----------------------------------------------------------------------------
  STEP 2: RUN DECOMPOSITIONS BY GENDER WITH AND WITHOUT FATHER VARIABLES
-----------------------------------------------------------------------------*/
  
  /*
  NOTE: We'll use 'preserve' and 'restore' commands to temporarily subset data
for analyses that require only observations with fathers present, while
maintaining the full dataset for other analyses.
*/


foreach var in ///
  cog_reading_w1_l cog_maths_w1_l sdq_emot_pcg_w1 sdq_cond_pcg_w1 sdq_hyper_pcg_w1 sdq_peer_pcg_w1 ///
  scg_educ_w1_dummy34 scg_educ_w1_dummy56 income_equi_quint_w1 mixed_school_w1 ///
  drum_vr_w2_l drum_na_w2_l bas_ts_mat_w2 ///
  sdq_emot_pcg_w2 sdq_cond_pcg_w2 sdq_hyper_pcg_w2 sdq_peer_pcg_w2 ///
  pcg_educ_w2_dummy34 pcg_educ_w2_dummy56 scg_educ_w2_dummy34 scg_educ_w2_dummy56 ///
  income_equi_quint_w2 fee_paying_w2 deis_w2 mixed_school_w2 father_absent_status_test {
  
  destring `var', replace force
}

describe

* WAVE 1 DECOMPOSITIONS

* Wave 1 - English - LC - WITHOUT THE FATHER
* Uses all observations, controls for father absence, doesn't include father's education
bootstrap, reps(100): oaxaca english_lc_points ///
  cog_reading_w1_l cog_maths_w1_l ///
  sdq_emot_pcg_w1 sdq_cond_pcg_w1 sdq_hyper_pcg_w1 sdq_peer_pcg_w1 ///
  pcg_educ_w1_dummy34 pcg_educ_w1_dummy56 income_equi_quint_w1 ///
  mixed_school_w1 father_educ_missing_w1, ///
  by(gender_binary)

* Wave 1 - English - LC - WITH THE FATHER
* Only includes observations where we have father's education
bootstrap, reps(100): oaxaca english_lc_points ///
    cog_reading_w1_l cog_maths_w1_l ///
    sdq_emot_pcg_w1 sdq_cond_pcg_w1 sdq_hyper_pcg_w1 sdq_peer_pcg_w1 ///
    pcg_educ_w1_dummy34 pcg_educ_w1_dummy56 scg_educ_w1_dummy34 scg_educ_w1_dummy56 ///
    income_equi_quint_w1 mixed_school_w1, ///
    by(gender_binary)


* WAVE 2 DECOMPOSITIONS

* Wave 2 - English - LC - WITHOUT THE FATHER
* Uses all observations, controls for father absence, doesn't include father's education
bootstrap, reps(100): oaxaca english_lc_points ///
    drum_vr_w2_l drum_na_w2_l bas_ts_mat_w2 ///  
    sdq_emot_pcg_w2 sdq_cond_pcg_w2 sdq_hyper_pcg_w2 sdq_peer_pcg_w2 ///  
    pcg_educ_w2_dummy34 pcg_educ_w2_dummy56 income_equi_quint_w2 ///  
    fee_paying_w2 deis_w2 mixed_school_w2 religious_school_w2 father_educ_missing_w2, ///
    by(gender_binary)

* Wave 2 - English - LC - WITH THE FATHER
* Only includes observations where we have father's education
bootstrap, reps(100): oaxaca english_lc_points ///
  drum_vr_w2_l drum_na_w2_l bas_ts_mat_w2 ///  
  sdq_emot_pcg_w2 sdq_cond_pcg_w2 sdq_hyper_pcg_w2 sdq_peer_pcg_w2 ///
  pcg_educ_w2_dummy34 pcg_educ_w2_dummy56 scg_educ_w2_dummy34 scg_educ_w2_dummy56 ///
  income_equi_quint_w2 fee_paying_w2 deis_w2 mixed_school_w2 religious_school_w2, ///
  by(gender_binary)



/*-----------------------------------------------------------------------------
  STEP 3: ADDITIONAL COMPARISONS (OPTIONAL)
-----------------------------------------------------------------------------*/
  
  * If you want to compare boys with and without fathers
preserve
keep if gender_binary == 1
bootstrap, reps(100): oaxaca english_lc_points ///
  cog_reading_w1_l cog_maths_w1_l ///
  sdq_emot_pcg_w1 sdq_cond_pcg_w1 sdq_hyper_pcg_w1 sdq_peer_pcg_w1 ///
  pcg_educ_w1_dummy34 pcg_educ_w1_dummy56 income_equi_quint_w1 ///
  mixed_school_w1, ///
  by(father_educ_missing_w1)
restore

* If you want to compare girls with and without fathers
preserve
keep if gender_binary == 0
bootstrap, reps(100): oaxaca english_lc_points ///
  cog_reading_w1_l cog_maths_w1_l ///
  sdq_emot_pcg_w1 sdq_cond_pcg_w1 sdq_hyper_pcg_w1 sdq_peer_pcg_w1 ///
  pcg_educ_w1_dummy34 pcg_educ_w1_dummy56 income_equi_quint_w1 ///
  mixed_school_w1, ///
  by(father_educ_missing_w1)
restore
