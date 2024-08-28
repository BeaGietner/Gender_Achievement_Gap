ssc install oaxaca, replace
ssc install estout, replace

// SDQ  Wave 2 ------------------------------------------------------

// English SDQ baseline 
oaxaca jc_english_standardized cog_vr_w2 cog_na_w2 cog_matrices_w2 sdq_emo_res_pcg_w2 sdq_good_conduct_pcg_w2 sdq_focus_behav_pcg_w2 sdq_posi_peer_pcg_w2, by(gender_yp_w2)
outreg2 using oaxaca_results_english_sdq_complete_W2.tex, replace
estimates store baseline_ESDQ_CW2

// English SDQ controls SES
oaxaca jc_english_standardized cog_vr_w2 cog_na_w2 cog_matrices_w2 sdq_emo_res_pcg_w2 sdq_good_conduct_pcg_w2 sdq_focus_behav_pcg_w2 sdq_posi_peer_pcg_w2 pcg_educ_w2 scg_educ_w2 income_quin_eq_w2, by(gender_yp_w2)
estimates store ses_controls_ESDQ_CW2

// English SDQ controls School
oaxaca jc_english_standardized cog_vr_w2 cog_na_w2 cog_matrices_w2 sdq_emo_res_pcg_w2 sdq_good_conduct_pcg_w2 sdq_focus_behav_pcg_w2 sdq_posi_peer_pcg_w2 deis_w2 fee_paying_w2 mixed_w2, by(gender_yp_w2)
estimates store school_controls_ESDQ_CW2

// English SDQ controls All
oaxaca jc_english_standardized cog_vr_w2 cog_na_w2 cog_matrices_w2 sdq_emo_res_pcg_w2 sdq_good_conduct_pcg_w2 sdq_focus_behav_pcg_w2 sdq_posi_peer_pcg_w2 pcg_educ_w2 scg_educ_w2 income_quin_eq_w2 deis_w2 fee_paying_w2 mixed_w2, by(gender_yp_w2)
estimates store full_model_ESDQ_CW2

esttab baseline_ESDQ_CW2 ses_controls_ESDQ_CW2 school_controls_ESDQ_CW2 full_model_ESDQ_CW2 using oaxaca_results_english_sdq_complete_W2.tex, replace ///
    label booktabs nomtitles nonumbers ///
    cells(b(star fmt(3))) stats(N r2) ///
    prehead("English SDQ Results - Complete Sample Wave 2") ///
    posthead("SES Controls: No Yes No Yes" "School Controls: No No Yes Yes")


// SDQ  Wave 3 ------------------------------------------------------

// English SDQ baseline 
oaxaca lc_english_standardized cog_naming_total_w3 cog_maths_total_w3 cog_vocabulary_w3 sdq_emo_res_pcg_w3 sdq_good_conduct_pcg_w3 sdq_focus_behav_pcg_w3 sdq_posi_peer_pcg_w3, by(gender_yp_w3)
outreg2 using oaxaca_results_english_sdq_complete_W3.tex, replace
estimates store baseline_ESDQ_CW3

// English SDQ controls SES
oaxaca lc_english_standardized cog_naming_total_w3 cog_maths_total_w3 cog_vocabulary_w3 sdq_emo_res_pcg_w3 sdq_good_conduct_pcg_w3 sdq_focus_behav_pcg_w3 sdq_posi_peer_pcg_w3 pcg_educ_w3 scg_educ_w3 income_quin_eq_w3, by(gender_yp_w3)
estimates store ses_controls_ESDQ_CW3

// English SDQ controls School
oaxaca lc_english_standardized cog_naming_total_w3 cog_maths_total_w3 cog_vocabulary_w3 sdq_emo_res_pcg_w3 sdq_good_conduct_pcg_w3 sdq_focus_behav_pcg_w3 sdq_posi_peer_pcg_w3 deis_w3 fee_paying_w3 mixed_w3, by(gender_yp_w3)
estimates store school_controls_ESDQ_CW3

// English SDQ controls All
oaxaca lc_english_standardized cog_naming_total_w3 cog_maths_total_w3 cog_vocabulary_w3 sdq_emo_res_pcg_w3 sdq_good_conduct_pcg_w3 sdq_focus_behav_pcg_w3 sdq_posi_peer_pcg_w3 pcg_educ_w3 scg_educ_w3 income_quin_eq_w3 deis_w3 fee_paying_w3 mixed_w3, by(gender_yp_w3)
estimates store full_model_ESDQ_CW3

esttab baseline_ESDQ_CW3 ses_controls_ESDQ_CW3 school_controls_ESDQ_CW3 full_model_ESDQ_CW3 using oaxaca_results_english_sdq_complete_W3.tex, replace ///
    label booktabs nomtitles nonumbers ///
    cells(b(star fmt(3))) stats(N r2) ///
    prehead("English SDQ Results - Complete Sample Wave 3") ///
    posthead("SES Controls: No Yes No Yes" "School Controls: No No Yes Yes")


// SDQ  Wave 2 ------------------------------------------------------ NOT STANDARDIZED

// English SDQ baseline 
oaxaca jc_english_points cog_vr_w2 cog_na_w2 cog_matrices_w2 sdq_emo_res_pcg_w2 sdq_good_conduct_pcg_w2 sdq_focus_behav_pcg_w2 sdq_posi_peer_pcg_w2, by(gender_yp_w2)
outreg2 using oaxaca_results_english_sdq_complete_W2NS.tex, replace
estimates store baseline_ESDQ_CW2_NS

// English SDQ controls SES
oaxaca jc_english_points cog_vr_w2 cog_na_w2 cog_matrices_w2 sdq_emo_res_pcg_w2 sdq_good_conduct_pcg_w2 sdq_focus_behav_pcg_w2 sdq_posi_peer_pcg_w2 pcg_educ_w2 scg_educ_w2 income_quin_eq_w2, by(gender_yp_w2)
estimates store ses_controls_ESDQ_CW2_NS

// English SDQ controls School
oaxaca jc_english_points cog_vr_w2 cog_na_w2 cog_matrices_w2 sdq_emo_res_pcg_w2 sdq_good_conduct_pcg_w2 sdq_focus_behav_pcg_w2 sdq_posi_peer_pcg_w2 deis_w2 fee_paying_w2 mixed_w2, by(gender_yp_w2)
estimates store school_controls_ESDQ_CW2_NS

// English SDQ controls All
oaxaca jc_english_points cog_vr_w2 cog_na_w2 cog_matrices_w2 sdq_emo_res_pcg_w2 sdq_good_conduct_pcg_w2 sdq_focus_behav_pcg_w2 sdq_posi_peer_pcg_w2 pcg_educ_w2 scg_educ_w2 income_quin_eq_w2 deis_w2 fee_paying_w2 mixed_w2, by(gender_yp_w2)
estimates store full_model_ESDQ_CW2_NS

esttab baseline_ESDQ_CW2_NS ses_controls_ESDQ_CW2_NS school_controls_ESDQ_CW2_NS full_model_ESDQ_CW2_NS using oaxaca_results_english_sdq_complete_W2NS.tex, replace ///
    label booktabs nomtitles nonumbers ///
    cells(b(star fmt(3))) stats(N r2) ///
    prehead("English SDQ Results - Complete Sample Wave 2 - NS") ///
    posthead("SES Controls: No Yes No Yes" "School Controls: No No Yes Yes")


// SDQ  Wave 3 ------------------------------------------------------

// English SDQ baseline 
oaxaca lc_english_points cog_naming_total_w3 cog_maths_total_w3 cog_vocabulary_w3 sdq_emo_res_pcg_w3 sdq_good_conduct_pcg_w3 sdq_focus_behav_pcg_w3 sdq_posi_peer_pcg_w3, by(gender_yp_w3)
outreg2 using oaxaca_results_english_sdq_complete_W3NS.tex, replace
estimates store baseline_ESDQ_CW3NS

// English SDQ controls SES
oaxaca lc_english_points cog_naming_total_w3 cog_maths_total_w3 cog_vocabulary_w3 sdq_emo_res_pcg_w3 sdq_good_conduct_pcg_w3 sdq_focus_behav_pcg_w3 sdq_posi_peer_pcg_w3 pcg_educ_w3 scg_educ_w3 income_quin_eq_w3, by(gender_yp_w3)
estimates store ses_controls_ESDQ_CW3NS

// English SDQ controls School
oaxaca lc_english_points cog_naming_total_w3 cog_maths_total_w3 cog_vocabulary_w3 sdq_emo_res_pcg_w3 sdq_good_conduct_pcg_w3 sdq_focus_behav_pcg_w3 sdq_posi_peer_pcg_w3 deis_w3 fee_paying_w3 mixed_w3, by(gender_yp_w3)
estimates store school_controls_ESDQ_CW3NS

// English SDQ controls All
oaxaca lc_english_points cog_naming_total_w3 cog_maths_total_w3 cog_vocabulary_w3 sdq_emo_res_pcg_w3 sdq_good_conduct_pcg_w3 sdq_focus_behav_pcg_w3 sdq_posi_peer_pcg_w3 pcg_educ_w3 scg_educ_w3 income_quin_eq_w3 deis_w3 fee_paying_w3 mixed_w3, by(gender_yp_w3)
estimates store full_model_ESDQ_CW3NS

esttab baseline_ESDQ_CW3NS ses_controls_ESDQ_CW3NS school_controls_ESDQ_CW3NS full_model_ESDQ_CW3NS using oaxaca_results_english_sdq_complete_W3NS.tex, replace ///
    label booktabs nomtitles nonumbers ///
    cells(b(star fmt(3))) stats(N r2) ///
    prehead("English SDQ Results - Complete Sample Wave 3 - NS") ///
    posthead("SES Controls: No Yes No Yes" "School Controls: No No Yes Yes")
