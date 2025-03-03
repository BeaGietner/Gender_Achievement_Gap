************ Oaxaca Decomposition Using TIPI ************

* Low-Income Group (TIPI) - Remove `income_equi_quint`
preserve
    keep if low_income == 1
    bootstrap, reps(100): oaxaca maths_points ///
        drum_vr_w2_p drum_na_w2_p bas_ts_mat_w2 ///
        agreeable_w2_pcg emo_stability_w2_pcg conscientious_w2_pcg ///
        extravert_w2_pcg openness_w2_pcg ///
        pcg_educ_w2 scg_educ_w2 /// <-- Keeping education variables, but not income
        deis_binary_w2 fee_paying_w2 mixed, ///
        by(gender_binary)
restore

* Low-Income Group (TIPI) - Don't remove `income_equi_quint`
preserve
    keep if low_income == 1
    bootstrap, reps(100): oaxaca maths_points ///
        drum_vr_w2_p drum_na_w2_p bas_ts_mat_w2 ///
        agreeable_w2_pcg emo_stability_w2_pcg conscientious_w2_pcg ///
        extravert_w2_pcg openness_w2_pcg ///
        pcg_educ_w2 scg_educ_w2 income_equi_quint /// <-- Keeping education variables and income
        deis_binary_w2 fee_paying_w2 mixed, ///
        by(gender_binary)
restore

* High-Income Group (TIPI) - Remove `income_equi_quint`
preserve
    keep if high_income == 1
    bootstrap, reps(100): oaxaca maths_points ///
        drum_vr_w2_p drum_na_w2_p bas_ts_mat_w2 ///
        agreeable_w2_pcg emo_stability_w2_pcg conscientious_w2_pcg ///
        extravert_w2_pcg openness_w2_pcg ///
        pcg_educ_w2 scg_educ_w2 /// <-- Keeping education variables, but not income
        deis_binary_w2 fee_paying_w2 mixed, ///
        by(gender_binary)
restore


* High-Income Group (TIPI) - Add `income_equi_quint`
preserve
    keep if high_income == 1
    bootstrap, reps(100): oaxaca maths_points ///
        drum_vr_w2_p drum_na_w2_p bas_ts_mat_w2 ///
        agreeable_w2_pcg emo_stability_w2_pcg conscientious_w2_pcg ///
        extravert_w2_pcg openness_w2_pcg ///
        pcg_educ_w2 scg_educ_w2 income_equi_quint /// <-- Keeping education variables and income
        deis_binary_w2 fee_paying_w2 mixed, ///
        by(gender_binary)
restore

************ Oaxaca Decomposition by PCG Education ************

* Low-Education PCG (TIPI) - EXCLUDING PCG 
preserve
    keep if low_educ_pcg == 1
    bootstrap, reps(100): oaxaca maths_points ///
        drum_vr_w2_p drum_na_w2_p bas_ts_mat_w2 ///
        agreeable_w2_pcg emo_stability_w2_pcg conscientious_w2_pcg ///
        extravert_w2_pcg openness_w2_pcg ///
        income_equi_quint scg_educ_w2 /// <-- Keeping income, removing PCG education
        deis_binary_w2 fee_paying_w2 mixed, ///
        by(gender_binary)
restore

* Low-Education PCG (TIPI) - KEEPING PCG
preserve
    keep if low_educ_pcg == 1
    bootstrap, reps(100): oaxaca maths_points ///
        drum_vr_w2_p drum_na_w2_p bas_ts_mat_w2 ///
        agreeable_w2_pcg emo_stability_w2_pcg conscientious_w2_pcg ///
        extravert_w2_pcg openness_w2_pcg ///
        income_equi_quint  scg_educ_w2 pcg_educ_w2 /// <-- Keeping income, keeping PCG education
        deis_binary_w2 fee_paying_w2 mixed, ///
        by(gender_binary)
restore


* High-Education PCG (TIPI) - EXCLUDING PCG
preserve
    keep if high_educ_pcg == 1
    bootstrap, reps(100): oaxaca maths_points ///
        drum_vr_w2_p drum_na_w2_p bas_ts_mat_w2 ///
        agreeable_w2_pcg emo_stability_w2_pcg conscientious_w2_pcg ///
        extravert_w2_pcg openness_w2_pcg ///
        income_equi_quint scg_educ_w2 /// <-- Keeping income, removing PCG education
        deis_binary_w2 fee_paying_w2 mixed, ///
        by(gender_binary)
restore


* High-Education PCG (TIPI) - KEEPING PCG
preserve
    keep if high_educ_pcg == 1
    bootstrap, reps(100): oaxaca maths_points ///
        drum_vr_w2_p drum_na_w2_p bas_ts_mat_w2 ///
        agreeable_w2_pcg emo_stability_w2_pcg conscientious_w2_pcg ///
        extravert_w2_pcg openness_w2_pcg ///
        income_equi_quint scg_educ_w2 pcg_educ_w2 /// <-- Keeping income, keeping PCG education
        deis_binary_w2 fee_paying_w2 mixed, ///
        by(gender_binary)
restore

************ Oaxaca Decomposition by SCG Education ************

* Low-Education SCG (TIPI) - DROP SCG EDUC
preserve
    keep if low_educ_scg == 1
    bootstrap, reps(100): oaxaca maths_points ///
        drum_vr_w2_p drum_na_w2_p bas_ts_mat_w2 ///
        agreeable_w2_pcg emo_stability_w2_pcg conscientious_w2_pcg ///
        extravert_w2_pcg openness_w2_pcg ///
        income_equi_quint pcg_educ_w2 /// <-- Keeping income, removing SCG education
        deis_binary_w2 fee_paying_w2 mixed, ///
        by(gender_binary)
restore

* Low-Education SCG (TIPI) - KEEP SCG EDUC
preserve
    keep if low_educ_scg == 1
    bootstrap, reps(100): oaxaca maths_points ///
        drum_vr_w2_p drum_na_w2_p bas_ts_mat_w2 ///
        agreeable_w2_pcg emo_stability_w2_pcg conscientious_w2_pcg ///
        extravert_w2_pcg openness_w2_pcg ///
        income_equi_quint pcg_educ_w2 scg_educ_w2 /// <-- Keeping income, keeping SCG education
        deis_binary_w2 fee_paying_w2 mixed, ///
        by(gender_binary)
restore

* High-Education SCG (TIPI) - DROP SCG EDUC
preserve
    keep if high_educ_scg == 1
    bootstrap, reps(100): oaxaca maths_points ///
        drum_vr_w2_p drum_na_w2_p bas_ts_mat_w2 ///
        agreeable_w2_pcg emo_stability_w2_pcg conscientious_w2_pcg ///
        extravert_w2_pcg openness_w2_pcg ///
        income_equi_quint pcg_educ_w2 /// <-- Keeping income, removing SCG education
        deis_binary_w2 fee_paying_w2 mixed, ///
        by(gender_binary)
restore

* High-Education SCG (TIPI) - KEEP SCG EDUC
preserve
    keep if high_educ_scg == 1
    bootstrap, reps(100): oaxaca maths_points ///
        drum_vr_w2_p drum_na_w2_p bas_ts_mat_w2 ///
        agreeable_w2_pcg emo_stability_w2_pcg conscientious_w2_pcg ///
        extravert_w2_pcg openness_w2_pcg ///
        income_equi_quint pcg_educ_w2 scg_educ_w2 /// <-- Keeping income, keeping SCG education
        deis_binary_w2 fee_paying_w2 mixed, ///
        by(gender_binary)
restore


************************************* Oaxaca Decomposition Using SDQ *************************************

* Low-Income Group (SDQ) - Remove `income_equi_quint`
preserve
    keep if low_income == 1
    bootstrap, reps(100): oaxaca maths_points ///
        drum_vr_w2_p drum_na_w2_p bas_ts_mat_w2 ///
        sdq_emot_pcg_w2 sdq_cond_pcg_w2 sdq_hyper_pcg_w2 sdq_peer_pcg_w2 ///
        pcg_educ_w2 scg_educ_w2 /// <-- Keeping education variables, but not income
        deis_binary_w2 fee_paying_w2 mixed, ///
        by(gender_binary)
restore

* Low-Income Group (SDQ) - Don't remove `income_equi_quint`
preserve
    keep if low_income == 1
    bootstrap, reps(100): oaxaca maths_points ///
        drum_vr_w2_p drum_na_w2_p bas_ts_mat_w2 ///
        sdq_emot_pcg_w2 sdq_cond_pcg_w2 sdq_hyper_pcg_w2 sdq_peer_pcg_w2 ///
        pcg_educ_w2 scg_educ_w2 income_equi_quint /// <-- Keeping education variables and income
        deis_binary_w2 fee_paying_w2 mixed, ///
        by(gender_binary)
restore

* High-Income Group (SDQ) - Remove `income_equi_quint`
preserve
    keep if high_income == 1
    bootstrap, reps(100): oaxaca maths_points ///
        drum_vr_w2_p drum_na_w2_p bas_ts_mat_w2 ///
        sdq_emot_pcg_w2 sdq_cond_pcg_w2 sdq_hyper_pcg_w2 sdq_peer_pcg_w2 ///
        pcg_educ_w2 scg_educ_w2 /// <-- Keeping education variables, but not income
        deis_binary_w2 fee_paying_w2 mixed, ///
        by(gender_binary)
restore


* High-Income Group (SDQ) - Add `income_equi_quint`
preserve
    keep if high_income == 1
    bootstrap, reps(100): oaxaca maths_points ///
        drum_vr_w2_p drum_na_w2_p bas_ts_mat_w2 ///
        sdq_emot_pcg_w2 sdq_cond_pcg_w2 sdq_hyper_pcg_w2 sdq_peer_pcg_w2 ///
        pcg_educ_w2 scg_educ_w2 income_equi_quint /// <-- Keeping education variables and income
        deis_binary_w2 fee_paying_w2 mixed, ///
        by(gender_binary)
restore

************ Oaxaca Decomposition by PCG Education ************

* Low-Education PCG (SDQ) - EXCLUDING PCG 
preserve
    keep if low_educ_pcg == 1
    bootstrap, reps(100): oaxaca maths_points ///
        drum_vr_w2_p drum_na_w2_p bas_ts_mat_w2 ///
        sdq_emot_pcg_w2 sdq_cond_pcg_w2 sdq_hyper_pcg_w2 sdq_peer_pcg_w2 ///
        income_equi_quint scg_educ_w2 /// <-- Keeping income, removing PCG education
        deis_binary_w2 fee_paying_w2 mixed, ///
        by(gender_binary)
restore

* Low-Education PCG (SDQ) - KEEPING PCG
preserve
    keep if low_educ_pcg == 1
    bootstrap, reps(100): oaxaca maths_points ///
        drum_vr_w2_p drum_na_w2_p bas_ts_mat_w2 ///
        sdq_emot_pcg_w2 sdq_cond_pcg_w2 sdq_hyper_pcg_w2 sdq_peer_pcg_w2 ///
        income_equi_quint  scg_educ_w2 pcg_educ_w2 /// <-- Keeping income, keeping PCG education
        deis_binary_w2 fee_paying_w2 mixed, ///
        by(gender_binary)
restore


* High-Education PCG (SDQ) - EXCLUDING PCG
preserve
    keep if high_educ_pcg == 1
    bootstrap, reps(100): oaxaca maths_points ///
        drum_vr_w2_p drum_na_w2_p bas_ts_mat_w2 ///
       sdq_emot_pcg_w2 sdq_cond_pcg_w2 sdq_hyper_pcg_w2 sdq_peer_pcg_w2 ///
        income_equi_quint scg_educ_w2 /// <-- Keeping income, removing PCG education
        deis_binary_w2 fee_paying_w2 mixed, ///
        by(gender_binary)
restore


* High-Education PCG (SDQ) - KEEPING PCG
preserve
    keep if high_educ_pcg == 1
    bootstrap, reps(100): oaxaca maths_points ///
        drum_vr_w2_p drum_na_w2_p bas_ts_mat_w2 ///
        sdq_emot_pcg_w2 sdq_cond_pcg_w2 sdq_hyper_pcg_w2 sdq_peer_pcg_w2 ///
        income_equi_quint scg_educ_w2 pcg_educ_w2 /// <-- Keeping income, keeping PCG education
        deis_binary_w2 fee_paying_w2 mixed, ///
        by(gender_binary)
restore

************ Oaxaca Decomposition by SCG Education ************

* Low-Education SCG (SDQ) - DROP SCG EDUC
preserve
    keep if low_educ_scg == 1
    bootstrap, reps(100): oaxaca maths_points ///
        drum_vr_w2_p drum_na_w2_p bas_ts_mat_w2 ///
        sdq_emot_pcg_w2 sdq_cond_pcg_w2 sdq_hyper_pcg_w2 sdq_peer_pcg_w2 ///
        income_equi_quint pcg_educ_w2 /// <-- Keeping income, removing SCG education
        deis_binary_w2 fee_paying_w2 mixed, ///
        by(gender_binary)
restore

* Low-Education SCG (SDQ) - KEEP SCG EDUC
preserve
    keep if low_educ_scg == 1
    bootstrap, reps(100): oaxaca maths_points ///
        drum_vr_w2_p drum_na_w2_p bas_ts_mat_w2 ///
        sdq_emot_pcg_w2 sdq_cond_pcg_w2 sdq_hyper_pcg_w2 sdq_peer_pcg_w2 ///
        income_equi_quint pcg_educ_w2 scg_educ_w2 /// <-- Keeping income, keeping SCG education
        deis_binary_w2 fee_paying_w2 mixed, ///
        by(gender_binary)
restore

* High-Education SCG (SDQ) - DROP SCG EDUC
preserve
    keep if high_educ_scg == 1
    bootstrap, reps(100): oaxaca maths_points ///
        drum_vr_w2_p drum_na_w2_p bas_ts_mat_w2 ///
        sdq_emot_pcg_w2 sdq_cond_pcg_w2 sdq_hyper_pcg_w2 sdq_peer_pcg_w2 ///
        income_equi_quint pcg_educ_w2 /// <-- Keeping income, removing SCG education
        deis_binary_w2 fee_paying_w2 mixed, ///
        by(gender_binary)
restore

* High-Education SCG (SDQ) - KEEP SCG EDUC
preserve
    keep if high_educ_scg == 1
    bootstrap, reps(100): oaxaca maths_points ///
        drum_vr_w2_p drum_na_w2_p bas_ts_mat_w2 ///
        sdq_emot_pcg_w2 sdq_cond_pcg_w2 sdq_hyper_pcg_w2 sdq_peer_pcg_w2 ///
        income_equi_quint pcg_educ_w2 scg_educ_w2 /// <-- Keeping income, keeping SCG education
        deis_binary_w2 fee_paying_w2 mixed, ///
        by(gender_binary)
restore




