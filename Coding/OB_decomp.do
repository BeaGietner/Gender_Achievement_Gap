ssc install oaxaca, replace
ssc install estout, replace
outreg2 using oaxaca_results_maths_sdq.tex, replace
outreg2 using oaxaca_results_english_sdq.tex, replace
outreg2 using oaxaca_results_maths_tipi.tex, replace
outreg2 using oaxaca_results_english_tipi.tex, replace

// SDQ ------------------------------------------------------

// Maths SDQ baseline 
oaxaca Maths_points Drum_VR_W2_p Drum_NA_W2_p BAS_TS_Mat_W2 SDQ_emot_PCG_W2 SDQ_cond_PCG_W2 SDQ_hyper_PCG_W2 SDQ_peer_PCG_W2, by(Gender) 
estimates store baseline_maths_sdq
// Maths SDQ controls SES
oaxaca Maths_points Drum_VR_W2_p Drum_NA_W2_p BAS_TS_Mat_W2 SDQ_emot_PCG_W2 SDQ_cond_PCG_W2 SDQ_hyper_PCG_W2 SDQ_peer_PCG_W2 PCG_Educ_W2 SCG_Educ_W2 Income_equi_quint, by(Gender)
estimates store ses_controls_maths_sdq
// Maths SDQ controls School
oaxaca Maths_points Drum_VR_W2_p Drum_NA_W2_p BAS_TS_Mat_W2 SDQ_emot_PCG_W2 SDQ_cond_PCG_W2 SDQ_hyper_PCG_W2 SDQ_peer_PCG_W2 DEIS_binary_W2 Fee_paying_W2 Mixed , by(Gender) 
estimates store school_controls_maths_sdq
// Maths SDQ controls All
oaxaca Maths_points Drum_VR_W2_p Drum_NA_W2_p BAS_TS_Mat_W2 SDQ_emot_PCG_W2 SDQ_cond_PCG_W2 SDQ_hyper_PCG_W2 SDQ_peer_PCG_W2 PCG_Educ_W2 SCG_Educ_W2 Income_equi_quint DEIS_binary_W2 Fee_paying_W2 Mixed , by(Gender) 
estimates store full_model_maths_sdq

esttab baseline_maths_sdq ses_controls_maths_sdq school_controls_maths_sdq full_model_maths_sdq using oaxaca_results_maths_sdq.tex, replace ///
    label booktabs nomtitles nonumbers ///
    cells(b(star fmt(3))) stats(N r2) ///
    prehead("Maths SDQ Results") ///
    posthead("SES Controls: No Yes No Yes" "School Controls: No No Yes Yes")
 
// English SDQ baseline
oaxaca English_points Drum_VR_W2_p Drum_NA_W2_p BAS_TS_Mat_W2 SDQ_emot_PCG_W2 SDQ_cond_PCG_W2 SDQ_hyper_PCG_W2 SDQ_peer_PCG_W2, by(Gender) 
estimates store baseline_english_sdq
// English SDQ controls SES
oaxaca English_points Drum_VR_W2_p Drum_NA_W2_p BAS_TS_Mat_W2 SDQ_emot_PCG_W2 SDQ_cond_PCG_W2 SDQ_hyper_PCG_W2 SDQ_peer_PCG_W2 PCG_Educ_W2 SCG_Educ_W2 Income_equi_quint, by(Gender)
estimates store ses_controls_maths_sdq
// English SDQ controls School
oaxaca English_points Drum_VR_W2_p Drum_NA_W2_p BAS_TS_Mat_W2 SDQ_emot_PCG_W2 SDQ_cond_PCG_W2 SDQ_hyper_PCG_W2 SDQ_peer_PCG_W2 DEIS_binary_W2 Fee_paying_W2 Mixed , by(Gender)
estimates store school_controls_english_sdq
// English SDQ controls All
oaxaca English_points Drum_VR_W2_p Drum_NA_W2_p BAS_TS_Mat_W2 SDQ_emot_PCG_W2 SDQ_cond_PCG_W2 SDQ_hyper_PCG_W2 SDQ_peer_PCG_W2 PCG_Educ_W2 SCG_Educ_W2 Income_equi_quint DEIS_binary_W2 Fee_paying_W2 Mixed , by(Gender)
estimates store full_model_english_sdq

esttab baseline_english_sdq ses_controls_english_sdq school_controls_english_sdq full_model_english_sdq using oaxaca_results_english_sdq.tex, replace ///
    label booktabs nomtitles nonumbers ///
    cells(b(star fmt(3))) stats(N r2) ///
    prehead("English SDQ Results") ///
    posthead("SES Controls: No Yes No Yes" "School Controls: No No Yes Yes")


// TIPI ---------------------------------------------

// Maths TIPI baseline 
oaxaca Maths_points Drum_VR_W2_p Drum_NA_W2_p BAS_TS_Mat_W2 Agreeable_W2_PCG Conscientious_W2_PCG Emo_Stability_W2_PCG Extravert_W2_PCG Openness_W2_PCG, by(Gender) 
estimates store baseline_maths_tipi
// Maths TIPI controls SES
oaxaca Maths_points Drum_VR_W2_p Drum_NA_W2_p BAS_TS_Mat_W2 Agreeable_W2_PCG Conscientious_W2_PCG Emo_Stability_W2_PCG Extravert_W2_PCG Openness_W2_PCG PCG_Educ_W2 SCG_Educ_W2 Income_equi_quint, by(Gender)
estimates store ses_controls_maths_tipi
// Maths TIPI controls School
oaxaca Maths_points Drum_VR_W2_p Drum_NA_W2_p BAS_TS_Mat_W2 Agreeable_W2_PCG Conscientious_W2_PCG Emo_Stability_W2_PCG Extravert_W2_PCG Openness_W2_PCG DEIS_binary_W2 Fee_paying_W2 Mixed , by(Gender) 
estimates store school_controls_maths_tipi
// Maths TIPI controls All
oaxaca Maths_points Drum_VR_W2_p Drum_NA_W2_p BAS_TS_Mat_W2 Agreeable_W2_PCG Conscientious_W2_PCG Emo_Stability_W2_PCG Extravert_W2_PCG Openness_W2_PCG PCG_Educ_W2 SCG_Educ_W2 Income_equi_quint DEIS_binary_W2 Fee_paying_W2 Mixed , by(Gender) 
estimates store full_model_maths_tipi

esttab baseline_maths_tipi ses_controls_maths_tipi school_controls_maths_tipi full_model_maths_tipi using oaxaca_results_maths_tipi.tex, replace ///
    label booktabs nomtitles nonumbers ///
    cells(b(star fmt(3))) stats(N r2) ///
    prehead("Maths TIPI Results") ///
    posthead("SES Controls: No Yes No Yes" "School Controls: No No Yes Yes")
 
// English TIPI baseline
oaxaca English_points Drum_VR_W2_p Drum_NA_W2_p BAS_TS_Mat_W2 Agreeable_W2_PCG Conscientious_W2_PCG Emo_Stability_W2_PCG Extravert_W2_PCG Openness_W2_PCG, by(Gender) 
estimates store baseline_english_tipi

// English TIPI controls SES
oaxaca English_points Drum_VR_W2_p Drum_NA_W2_p BAS_TS_Mat_W2 Agreeable_W2_PCG Conscientious_W2_PCG Emo_Stability_W2_PCG Extravert_W2_PCG Openness_W2_PCG PCG_Educ_W2 SCG_Educ_W2 Income_equi_quint, by(Gender)
estimates store ses_controls_english_tipi

// English TIPI controls School
oaxaca English_points Drum_VR_W2_p Drum_NA_W2_p BAS_TS_Mat_W2 Agreeable_W2_PCG Conscientious_W2_PCG Emo_Stability_W2_PCG Extravert_W2_PCG Openness_W2_PCG DEIS_binary_W2 Fee_paying_W2 Mixed, by(Gender) 
estimates store school_controls_eng_tipi

// English TIPI controls All
oaxaca English_points Drum_VR_W2_p Drum_NA_W2_p BAS_TS_Mat_W2 Agreeable_W2_PCG Conscientious_W2_PCG Emo_Stability_W2_PCG Extravert_W2_PCG Openness_W2_PCG PCG_Educ_W2 SCG_Educ_W2 Income_equi_quint DEIS_binary_W2 Fee_paying_W2 Mixed , by(Gender)
estimates store full_model_english_tipi

esttab baseline_english_tipi ses_controls_english_tipi school_controls_eng_tipi full_model_english_tipi using oaxaca_results_english_tipi.tex, replace ///
    label booktabs nomtitles nonumbers ///
    cells(b(star fmt(3))) stats(N r2) ///
    prehead("English TIPI Results") ///
    posthead("SES Controls: No Yes No Yes" "School Controls: No No Yes Yes")
	
// Pooled
	
outreg2 using oaxaca_results_maths_sdq_pooled.tex, replace
outreg2 using oaxaca_results_english_sdq_pooled.tex, replace
outreg2 using oaxaca_results_maths_tipi_pooled.tex, replace
outreg2 using oaxaca_results_english_tipi_pooled.tex, replace

// SDQ ------------------------------------------------------

// Maths SDQ baseline 
oaxaca Maths_points Drum_VR_W2_p Drum_NA_W2_p BAS_TS_Mat_W2 SDQ_emot_PCG_W2 SDQ_cond_PCG_W2 SDQ_hyper_PCG_W2 SDQ_peer_PCG_W2, by(Gender) pooled
estimates store baseline_maths_sdq_pooled
// Maths SDQ controls SES
oaxaca Maths_points Drum_VR_W2_p Drum_NA_W2_p BAS_TS_Mat_W2 SDQ_emot_PCG_W2 SDQ_cond_PCG_W2 SDQ_hyper_PCG_W2 SDQ_peer_PCG_W2 PCG_Educ_W2 SCG_Educ_W2 Income_equi_quint, by(Gender) pooled 
estimates store sescontrols_maths_sdq_pooled 
// Maths SDQ controls School
oaxaca Maths_points Drum_VR_W2_p Drum_NA_W2_p BAS_TS_Mat_W2 SDQ_emot_PCG_W2 SDQ_cond_PCG_W2 SDQ_hyper_PCG_W2 SDQ_peer_PCG_W2 DEIS_binary_W2 Fee_paying_W2 Mixed , by(Gender) pooled 
estimates store schoolcon_maths_sdqpool 
// Maths SDQ controls All
oaxaca Maths_points Drum_VR_W2_p Drum_NA_W2_p BAS_TS_Mat_W2 SDQ_emot_PCG_W2 SDQ_cond_PCG_W2 SDQ_hyper_PCG_W2 SDQ_peer_PCG_W2 PCG_Educ_W2 SCG_Educ_W2 Income_equi_quint DEIS_binary_W2 Fee_paying_W2 Mixed , by(Gender) pooled 
estimates store full_maths_sdq_pooled 

esttab baseline_maths_sdq_pooled sescontrols_maths_sdq_pooled schoolcon_maths_sdqpool full_maths_sdq_pooled using oaxaca_results_maths_sdq_pooled.tex, replace ///
    label booktabs nomtitles nonumbers ///
    cells(b(star fmt(3))) stats(N r2) ///
    prehead("Maths SDQ Results") ///
    posthead("SES Controls: No Yes No Yes" "School Controls: No No Yes Yes")
	
	
// English SDQ baseline 
oaxaca English_points Drum_VR_W2_p Drum_NA_W2_p BAS_TS_Mat_W2 SDQ_emot_PCG_W2 SDQ_cond_PCG_W2 SDQ_hyper_PCG_W2 SDQ_peer_PCG_W2, by(Gender) pooled
estimates store baseline_english_sdq_pooled
// English SDQ controls SES
oaxaca English_points Drum_VR_W2_p Drum_NA_W2_p BAS_TS_Mat_W2 SDQ_emot_PCG_W2 SDQ_cond_PCG_W2 SDQ_hyper_PCG_W2 SDQ_peer_PCG_W2 PCG_Educ_W2 SCG_Educ_W2 Income_equi_quint, by(Gender) pooled 
estimates store sescontrols_english_sdqpool
// English SDQ controls School
oaxaca English_points Drum_VR_W2_p Drum_NA_W2_p BAS_TS_Mat_W2 SDQ_emot_PCG_W2 SDQ_cond_PCG_W2 SDQ_hyper_PCG_W2 SDQ_peer_PCG_W2 DEIS_binary_W2 Fee_paying_W2 Mixed , by(Gender) pooled 
estimates store schoolcon_english_sdqpool 
// English SDQ controls All
oaxaca English_points Drum_VR_W2_p Drum_NA_W2_p BAS_TS_Mat_W2 SDQ_emot_PCG_W2 SDQ_cond_PCG_W2 SDQ_hyper_PCG_W2 SDQ_peer_PCG_W2 PCG_Educ_W2 SCG_Educ_W2 Income_equi_quint DEIS_binary_W2 Fee_paying_W2 Mixed , by(Gender) pooled 
estimates store full_english_sdq_pooled 

esttab baseline_english_sdq_pooled sescontrols_english_sdqpool schoolcon_english_sdqpool full_english_sdq_pooled using oaxaca_results_english_sdq_pooled.tex, replace ///
    label booktabs nomtitles nonumbers ///
    cells(b(star fmt(3))) stats(N r2) ///
    prehead("English SDQ Results") ///
    posthead("SES Controls: No Yes No Yes" "School Controls: No No Yes Yes")



// TIPI ---------------------------------------------

// Maths TIPI baseline 
oaxaca Maths_points Drum_VR_W2_p Drum_NA_W2_p BAS_TS_Mat_W2 Agreeable_W2_PCG Conscientious_W2_PCG Emo_Stability_W2_PCG Extravert_W2_PCG Openness_W2_PCG, by(Gender) pooled
estimates store baseline_maths_tipi_pooled
// Maths TIPI controls SES
oaxaca Maths_points Drum_VR_W2_p Drum_NA_W2_p BAS_TS_Mat_W2 Agreeable_W2_PCG Conscientious_W2_PCG Emo_Stability_W2_PCG Extravert_W2_PCG Openness_W2_PCG PCG_Educ_W2 SCG_Educ_W2 Income_equi_quint, by(Gender) pooled
estimates store sescontrols_maths_tipi_pool 
// Maths TIPI controls School
oaxaca Maths_points Drum_VR_W2_p Drum_NA_W2_p BAS_TS_Mat_W2 Agreeable_W2_PCG Conscientious_W2_PCG Emo_Stability_W2_PCG Extravert_W2_PCG Openness_W2_PCG DEIS_binary_W2 Fee_paying_W2 Mixed , by(Gender) pooled
estimates store schoolcon_maths_tipipool 
// Maths TIPI controls All
oaxaca Maths_points Drum_VR_W2_p Drum_NA_W2_p BAS_TS_Mat_W2 Agreeable_W2_PCG Conscientious_W2_PCG Emo_Stability_W2_PCG Extravert_W2_PCG Openness_W2_PCG PCG_Educ_W2 SCG_Educ_W2 Income_equi_quint DEIS_binary_W2 Fee_paying_W2 Mixed , by(Gender) pooled
estimates store full_maths_tipi_pooled 

esttab baseline_maths_tipi_pooled sescontrols_maths_tipi_pool schoolcon_maths_tipipool full_maths_tipi_pooled using oaxaca_results_maths_tipi_pooled.tex, replace ///
    label booktabs nomtitles nonumbers ///
    cells(b(star fmt(3))) stats(N r2) ///
    prehead("Maths TIPI Results") ///
    posthead("SES Controls: No Yes No Yes" "School Controls: No No Yes Yes")
 
// English TIPI baseline 
oaxaca English_points Drum_VR_W2_p Drum_NA_W2_p BAS_TS_Mat_W2 Agreeable_W2_PCG Conscientious_W2_PCG Emo_Stability_W2_PCG Extravert_W2_PCG Openness_W2_PCG, by(Gender) pooled
estimates store baseline_english_tipi_pool
// English TIPI controls SES
oaxaca English_points Drum_VR_W2_p Drum_NA_W2_p BAS_TS_Mat_W2 Agreeable_W2_PCG Conscientious_W2_PCG Emo_Stability_W2_PCG Extravert_W2_PCG Openness_W2_PCG PCG_Educ_W2 SCG_Educ_W2 Income_equi_quint, by(Gender) pooled
estimates store sescontrols_en_tipi_pool 
// English TIPI controls School
oaxaca English_points Drum_VR_W2_p Drum_NA_W2_p BAS_TS_Mat_W2 Agreeable_W2_PCG Conscientious_W2_PCG Emo_Stability_W2_PCG Extravert_W2_PCG Openness_W2_PCG DEIS_binary_W2 Fee_paying_W2 Mixed , by(Gender) pooled
estimates store schoolcon_english_tipipool 
// English TIPI controls All
oaxaca English_points Drum_VR_W2_p Drum_NA_W2_p BAS_TS_Mat_W2 Agreeable_W2_PCG Conscientious_W2_PCG Emo_Stability_W2_PCG Extravert_W2_PCG Openness_W2_PCG PCG_Educ_W2 SCG_Educ_W2 Income_equi_quint DEIS_binary_W2 Fee_paying_W2 Mixed , by(Gender) pooled
estimates store full_english_tipi_pooled 

esttab baseline_english_tipi_pool sescontrols_en_tipi_pool schoolcon_english_tipipool full_english_tipi_pooled using oaxaca_results_english_tipi_pooled.tex, replace ///
    label booktabs nomtitles nonumbers ///
    cells(b(star fmt(3))) stats(N r2) ///
    prehead("English TIPI Results") ///
    posthead("SES Controls: No Yes No Yes" "School Controls: No No Yes Yes")

