* Import the dataset created in R
use "complete_case_subset.csv", clear


* BY FATHER ABSENCE (IN WAVE 1 AND WAVE 2), EVERYBODY / BOYS / GIRLS, WAVE 1 AND WAVE 2 USING LONGITUDINAL SAMPLE

* EVERYBODY --------------------------------------------------------------------
  
  * Wave 1 - Maths - LC
bootstrap, reps(100): oaxaca maths_points_adjusted ///
  cog_reading_w1_l cog_maths_w1_l /// 
  sdq_emot_pcg_w1 sdq_cond_pcg_w1 sdq_hyper_pcg_w1 sdq_peer_pcg_w1 /// 
  pcg_educ_w1_dummy34 pcg_educ_w1_dummy56 income_equi_quint_w1 ///
  mixed_school_w1 gender_binary, ///
  by(father_absent_status)


* Wave 2 - Maths - LC
bootstrap, reps(100): oaxaca maths_points_adjusted ///
  drum_vr_w2_l drum_na_w2_l bas_ts_mat_w2 ///  
  sdq_emot_pcg_w2 sdq_cond_pcg_w2 sdq_hyper_pcg_w2 sdq_peer_pcg_w2 ///  
  pcg_educ_w2_dummy34 pcg_educ_w2_dummy56 income_equi_quint_w2 ///  
  fee_paying_w2 deis_w2 mixed_school_w2 religious_school_w2 gender_binary, ///  
  by(father_absent_status)


* GENDER --------------------------------------------------------------------		
  
  
  * Wave 1 - Maths - LC (Boys only)
preserve
keep if gender_binary == 1
bootstrap, reps(100): oaxaca maths_points_adjusted ///
  cog_reading_w1_l cog_maths_w1_l /// 
  sdq_emot_pcg_w1 sdq_cond_pcg_w1 sdq_hyper_pcg_w1 sdq_peer_pcg_w1 /// 
  pcg_educ_w1_dummy34 pcg_educ_w1_dummy56 income_equi_quint_w1 ///
  mixed_school_w1, ///
  by(father_absent_status)
restore

* Wave 1 - Maths - LC (Girls only)
preserve
keep if gender_binary == 0
bootstrap, reps(100): oaxaca maths_points_adjusted ///
  cog_reading_w1_l cog_maths_w1_l /// 
  sdq_emot_pcg_w1 sdq_cond_pcg_w1 sdq_hyper_pcg_w1 sdq_peer_pcg_w1 /// 
  pcg_educ_w1_dummy34 pcg_educ_w1_dummy56 income_equi_quint_w1 ///
  mixed_school_w1, ///
  by(father_absent_status)
restore

* Wave 2 - Maths - LC (Boys only)
preserve
keep if gender_binary == 1
bootstrap, reps(100): oaxaca maths_points_adjusted ///
  drum_vr_w2_l drum_na_w2_l bas_ts_mat_w2 ///  
  sdq_emot_pcg_w2 sdq_cond_pcg_w2 sdq_hyper_pcg_w2 sdq_peer_pcg_w2 ///  
  pcg_educ_w2_dummy34 pcg_educ_w2_dummy56 income_equi_quint_w2 ///  
  fee_paying_w2 deis_w2 mixed_school_w2 religious_school_w2, ///  
  by(father_absent_status)
restore

* Wave 2 - Maths - LC (Girls only)
preserve
keep if gender_binary == 0
bootstrap, reps(100): oaxaca maths_points_adjusted ///
  drum_vr_w2_l drum_na_w2_l bas_ts_mat_w2 ///  
  sdq_emot_pcg_w2 sdq_cond_pcg_w2 sdq_hyper_pcg_w2 sdq_peer_pcg_w2 ///  
  pcg_educ_w2_dummy34 pcg_educ_w2_dummy56 income_equi_quint_w2 ///  
  fee_paying_w2 deis_w2 mixed_school_w2 religious_school_w2, ///  
  by(father_absent_status)
restore