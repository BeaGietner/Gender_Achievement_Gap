* Loop through all variables and convert to numeric if necessary
foreach var of varlist _all {
    capture confirm numeric variable `var'
    if _rc == 7 {   // If variable is a string, convert it to numeric
        destring `var', replace ignore("NA")
    }
}


* DECOMPOSITIONS
* BY GENDER, WITHOUT FATHER X WITH FATHER, WAVE 1 AND WAVE 2

* Wave 1 - English * WITHOUT THE FATHER
bootstrap, reps(100): oaxaca english_points_w3 ///
  cog_reading_w1_l cog_maths_w1_l /// 
  sdq_emot_pcg_w1 sdq_cond_pcg_w1 sdq_hyper_pcg_w1 sdq_peer_pcg_w1 /// 
  pcg_educ_w1_dummy34 pcg_educ_w1_dummy56 income_equi_quint_w1 ///
  mixed_school_w1, ///
  by(gender_binary)

* Wave 1 - English * WITH THE FATHER
bootstrap, reps(100): oaxaca english_points_w3 ///
  cog_reading_w1_l cog_maths_w1_l /// 
  sdq_emot_pcg_w1 sdq_cond_pcg_w1 sdq_hyper_pcg_w1 sdq_peer_pcg_w1 /// 
  pcg_educ_w1_dummy34 pcg_educ_w1_dummy56 scg_educ_w1_dummy34 scg_educ_w1_dummy56 income_equi_quint_w1 ///
  mixed_school_w1, ///
  by(gender_binary)

* Wave 2 - English * WITHOUT THE FATHER
bootstrap, reps(100): oaxaca english_points_w3 ///
  drum_vr_w2_l drum_na_w2_l bas_ts_mat_w2 ///  
  sdq_emot_pcg_w2 sdq_cond_pcg_w2 sdq_hyper_pcg_w2 sdq_peer_pcg_w2 ///  
  pcg_educ_w2_dummy34 pcg_educ_w2_dummy56 income_equi_quint_w2 ///  
  fee_paying_w2 deis_w2 mixed_school_w2 religious_school_w2, ///  
  by(gender_binary)


* Wave 2 - English * WITH THE FATHER
bootstrap, reps(100): oaxaca english_points_w3 ///
  drum_vr_w2_l drum_na_w2_l bas_ts_mat_w2 ///  
  sdq_emot_pcg_w2 sdq_cond_pcg_w2 sdq_hyper_pcg_w2 sdq_peer_pcg_w2 ///  
  pcg_educ_w2_dummy34 pcg_educ_w2_dummy56 scg_educ_w2_dummy34 scg_educ_w2_dummy56 income_equi_quint_w2 ///  
  fee_paying_w2 deis_w2 mixed_school_w2 religious_school_w2, ///  
  by(gender_binary)



* DECOMPOSITIONS
* BY FATHER ABSENCE (IN WAVE 1 AND WAVE 2), EVERYBODY / BOYS / GIRLS, WAVE 1 AND WAVE 2 USING LONGITUDINAL SAMPLE

* EVERYBODY --------------------------------------------------------------------
  
  * Wave 1 - English
bootstrap, reps(100): oaxaca english_points_w3 ///
  cog_reading_w1_l cog_maths_w1_l /// 
  sdq_emot_pcg_w1 sdq_cond_pcg_w1 sdq_hyper_pcg_w1 sdq_peer_pcg_w1 /// 
  pcg_educ_w1_dummy34 pcg_educ_w1_dummy56 income_equi_quint_w1 ///
  mixed_school_w1 gender_binary, ///
  by(father_absent_status)


* Wave 2 - English
bootstrap, reps(100): oaxaca english_points_w3 ///
  drum_vr_w2_l drum_na_w2_l bas_ts_mat_w2 ///  
  sdq_emot_pcg_w2 sdq_cond_pcg_w2 sdq_hyper_pcg_w2 sdq_peer_pcg_w2 ///  
  pcg_educ_w2_dummy34 pcg_educ_w2_dummy56 income_equi_quint_w2 ///  
  fee_paying_w2 deis_w2 mixed_school_w2 religious_school_w2 gender_binary, ///  
  by(father_absent_status)


* GENDER --------------------------------------------------------------------		
  
 
* Wave 1 - English (Boys only)
preserve
keep if gender_binary == 1
bootstrap, reps(100): oaxaca english_points_w3 ///
  cog_reading_w1_l cog_maths_w1_l /// 
  sdq_emot_pcg_w1 sdq_cond_pcg_w1 sdq_hyper_pcg_w1 sdq_peer_pcg_w1 /// 
  pcg_educ_w1_dummy34 pcg_educ_w1_dummy56 income_equi_quint_w1 ///
  mixed_school_w1, ///
  by(father_absent_status)
restore

* Wave 1 - English (Girls only)
preserve
keep if gender_binary == 0
bootstrap, reps(100): oaxaca english_points_w3 ///
  cog_reading_w1_l cog_maths_w1_l /// 
  sdq_emot_pcg_w1 sdq_cond_pcg_w1 sdq_hyper_pcg_w1 sdq_peer_pcg_w1 /// 
  pcg_educ_w1_dummy34 pcg_educ_w1_dummy56 income_equi_quint_w1 ///
  mixed_school_w1, ///
  by(father_absent_status)
restore


* Wave 2 - English (Boys only)
preserve
keep if gender_binary == 1
bootstrap, reps(100): oaxaca english_points_w3 ///
  drum_vr_w2_l drum_na_w2_l bas_ts_mat_w2 ///  
  sdq_emot_pcg_w2 sdq_cond_pcg_w2 sdq_hyper_pcg_w2 sdq_peer_pcg_w2 ///  
  pcg_educ_w2_dummy34 pcg_educ_w2_dummy56 income_equi_quint_w2 ///  
  fee_paying_w2 deis_w2 mixed_school_w2 religious_school_w2, ///  
  by(father_absent_status)
restore

* Wave 2 - English (Girls only)
preserve
keep if gender_binary == 0
bootstrap, reps(100): oaxaca english_points_w3 ///
  drum_vr_w2_l drum_na_w2_l bas_ts_mat_w2 ///  
  sdq_emot_pcg_w2 sdq_cond_pcg_w2 sdq_hyper_pcg_w2 sdq_peer_pcg_w2 ///  
  pcg_educ_w2_dummy34 pcg_educ_w2_dummy56 income_equi_quint_w2 ///  
  fee_paying_w2 deis_w2 mixed_school_w2 religious_school_w2, ///  
  by(father_absent_status)
restore




