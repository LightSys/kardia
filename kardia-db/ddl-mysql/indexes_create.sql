use Kardia_DB;



/* p_partner */
create  index p_fund_idx on p_partner (a_fund, p_partner_key);
create  index p_given_name_idx on p_partner (p_given_name, p_partner_key);
create  index p_legacy_key_1_idx on p_partner (p_legacy_key_1, p_partner_key);
create  index p_legacy_key_2_idx on p_partner (p_legacy_key_2, p_partner_key);
create  index p_merged_with_idx on p_partner (p_merged_with, p_partner_key);
create  index p_org_name_idx on p_partner (p_org_name, p_partner_key);
create  index p_parent_key_idx on p_partner (p_parent_key, p_partner_key);
/* create  index p_partner_pk on p_partner (p_partner_key)*/ 
/* go */
/* create  index p_surname_clustered_idx on p_partner (p_surname, p_given_name, p_preferred_name, p_org_name, p_partner_key)*/ 
/* go */


/* p_partner_key_cnt */
/* create  index p_partner_key_cnt_pk on p_partner_key_cnt (p_partner_key)*/ 
/* go */


/* p_person */
/* create  index p_person_clustered_pk on p_person (p_partner_key)*/ 
/* go */


/* p_location */
create  index p_location_city_idx on p_location (p_city, p_state_province, p_postal_code, p_partner_key, p_location_id, p_revision_id);
/* create  index p_location_pk on p_location (p_partner_key, p_location_id, p_revision_id)*/ 
/* go */
create  index p_location_rev_idx on p_location (p_partner_key, p_revision_id, p_location_id);
create  index p_location_state_idx on p_location (p_state_province, p_postal_code, p_partner_key, p_location_id, p_revision_id);
create  index p_location_zip_idx on p_location (p_postal_code, p_state_province, p_partner_key, p_location_id, p_revision_id);
/* create  index p_postal_sort_clustered_idx on p_location (p_country_code, p_bulk_postal_code, p_postal_code, p_partner_key, p_location_id, p_revision_id)*/ 
/* go */


/* p_address_format */
create  index p_af_country_idx on p_address_format (p_country_code, p_address_set);
/* create  index p_af_pk on p_address_format (p_address_set, p_country_code)*/ 
/* go */


/* p_address_format_set */
/* create  index p_afs_pk on p_address_format_set (p_address_set)*/ 
/* go */


/* p_contact_info */
create  index p_contact_idx on p_contact_info (p_contact_data, p_phone_area_city, p_phone_country, p_partner_key, p_contact_id);
/* create  index p_contact_info_pk on p_contact_info (p_partner_key, p_contact_id)*/ 
/* go */


/* p_contact_usage */
/* create  index p_contact_usg_pk on p_contact_usage (p_partner_key, p_contact_usage_type_code, p_contact_or_location, p_contact_location_id)*/ 
/* go */


/* p_contact_usage_type */
/* create  index p_contact_ut_pk on p_contact_usage_type (p_contact_usage_type_code)*/ 
/* go */


/* p_partner_relationship */
/* create  index p_partner_relationship_pk on p_partner_relationship (p_partner_key, p_relation_type, p_relation_key)*/ 
/* go */
create  index p_relate_reverse_idx on p_partner_relationship (p_relation_key, p_relation_type, p_partner_key);


/* p_partner_relationship_type */
/* create  index p_relat_type_pk on p_partner_relationship_type (p_relation_type)*/ 
/* go */


/* p_church */
/* create  index p_church_pk on p_church (p_partner_key)*/ 
/* go */


/* p_donor */
create  index p_dnr_gl_acct_idx on p_donor (a_gl_account_code, a_gl_ledger_number, p_partner_key);
/* create  index p_donor_pk on p_donor (p_partner_key, a_gl_ledger_number)*/ 
/* go */


/* p_payee */
create  index p_gl_acct_idx on p_payee (a_gl_account_code, a_gl_ledger_number, p_partner_key);
/* create  index p_payee_pk on p_payee (p_partner_key, a_gl_ledger_number)*/ 
/* go */


/* p_staff */
create  index p_staff_login_idx on p_staff (p_kardia_login, p_partner_key);
/* create  index p_staff_pk on p_staff (p_partner_key)*/ 
/* go */
create  index p_staff_weblogin_idx on p_staff (p_kardiaweb_login, p_partner_key);


/* p_bulk_postal_code */
/* create  index p_bulk_code_pk on p_bulk_postal_code (p_country_code,p_bulk_postal_code,p_bulk_code)*/ 
/* go */


/* p_zipranges */
/* create  index p_bulk_code_pk on p_zipranges (p_first_zip,p_last_zip)*/ 
/* go */


/* p_country */
/* create  index p_country_code_pk on p_country (p_country_code)*/ 
/* go */


/* p_pol_division */
/* create  index p_poldiv_pk on p_pol_division (p_country_code, p_pol_division)*/ 
/* go */


/* p_banking_details */
create  index p_bankd_acct_idx on p_banking_details (a_ledger_number, a_account_code, p_banking_details_key);
create  index p_bankd_bpartner_idx on p_banking_details (p_bank_partner_id, p_banking_details_key);
create  index p_bankd_partner_idx on p_banking_details (p_partner_id, p_banking_details_key);
/* create  index p_banking_details_pk on p_banking_details (p_banking_details_key)*/ 
/* go */


/* p_banking_type */
/* create  index p_banking_type_pk on p_banking_type (p_banking_type)*/ 
/* go */


/* p_title */
/* create  index p_title_pk on p_title (p_title)*/ 
/* go */


/* p_gazetteer */
create  index p_gaz_altid_idx on p_gazetteer (p_alt_feature_id, p_country_code, p_feature_type, p_feature_id);
create  index p_gaz_id_idx on p_gazetteer (p_feature_id, p_country_code, p_feature_type);
/* create  index p_gaz_name_clustered_idx on p_gazetteer (p_feature_name, p_country_code, p_feature_type, p_feature_id)*/ 
/* go */
create  index p_gaz_state_idx on p_gazetteer (p_state_province, p_country_code, p_feature_type, p_feature_id);
create  index p_gaz_type_idx on p_gazetteer (p_feature_type, p_country_code, p_feature_id);
/* create  index p_gazetteer_pk on p_gazetteer (p_country_code, p_feature_type, p_feature_id)*/ 
/* go */


/* p_dup_check_tmp */
create  index p_dc_username_idx on p_dup_check_tmp (s_username, p_partner_key);
/* create  index p_dupcheck_pk on p_dup_check_tmp (p_partner_key,s_username)*/ 
/* go */


/* p_partner_sort_tmp */
/* create  index p_sort_pk on p_partner_sort_tmp (p_partner_key,s_username,p_sort_session_id)*/ 
/* go */


/* p_acquisition_code */
/* create  index p_acqcode_pk on p_acquisition_code (p_acquisition_code)*/ 
/* go */


/* p_partner_search */
/* create  index p_search_pk on p_partner_search (p_search_id)*/ 
/* go */


/* p_partner_search_stage */
/* create  index p_searchstage_pk on p_partner_search_stage (p_search_id,p_search_stage_id)*/ 
/* go */


/* p_partner_search_results */
create  index p_search_stage_idx on p_partner_search_results (s_username,p_search_session_id,p_search_stage_id,p_partner_key);
/* create  index p_searchres_pk on p_partner_search_results (p_partner_key,s_username,p_search_session_id,p_search_stage_id)*/ 
/* go */


/* p_search_stage_criteria */
/* create  index p_stage_criteria_pk on p_search_stage_criteria (p_search_id,p_search_stage_id,p_criteria_name)*/ 
/* go */


/* p_nondup */
/* create  index p_nondup_pk on p_nondup (p_partner_key, p_nondup_partner_key)*/ 
/* go */
create  index p_nondup_rev_idx on p_nondup (p_nondup_partner_key, p_partner_key);


/* p_dup */
/* create  index p_dup_pk on p_dup (p_partner_key, p_dup_partner_key)*/ 
/* go */
create  index p_dup_rev_idx on p_dup (p_dup_partner_key, p_partner_key);


/* p_merge */
/* create  index p_merge_pk on p_merge (p_partner_key_a, p_partner_key_b, p_data_source, p_data_key)*/ 
/* go */
create  index p_merge_rev_idx on p_merge (p_partner_key_b, p_partner_key_a, p_data_source, p_data_key);


/* m_list */
/* create  index m_list_pk on m_list (m_list_code)*/ 
/* go */


/* m_list_membership */
/* create  index m_list_membership_clustered_pk on m_list_membership (m_list_code, p_partner_key, m_hist_id)*/ 
/* go */
create  index m_lists_by_partner on m_list_membership (p_partner_key, m_list_code, m_hist_id);


/* m_list_document */
/* create  index m_doc_pk on m_list_document (m_list_code, e_document_id)*/ 
/* go */


/* e_contact_autorecord */
create  index e_autorec_collab_idx on e_contact_autorecord (e_collaborator_id, p_partner_key, e_contact_history_type, e_contact_id);
create  index e_autorec_collabhist_idx on e_contact_autorecord (e_collaborator_id, e_contact_history_type, p_partner_key, e_contact_id);
create  index e_autorec_histtype_idx on e_contact_autorecord (p_partner_key, e_contact_history_type, e_collaborator_id, e_contact_id);
/* create  index e_autorec_pk on e_contact_autorecord (p_partner_key, e_collaborator_id, e_contact_history_type, e_contact_id)*/ 
/* go */


/* e_contact_history_type */
/* create  index e_cnt_hist_type_pk on e_contact_history_type (e_contact_history_type)*/ 
/* go */


/* e_contact_history */
create  index e_cnt_hist_locpar_idx on e_contact_history (p_location_partner_key, e_contact_history_type, e_contact_history_id);
create  index e_cnt_hist_par_idx on e_contact_history (p_partner_key, e_contact_history_type, e_contact_history_id);
/* create  index e_cnt_hist_pk on e_contact_history (e_contact_history_id)*/ 
/* go */
create  index e_cnt_hist_type_idx on e_contact_history (e_contact_history_type, p_partner_key, e_contact_history_id);
create  index e_cnt_hist_whom_idx on e_contact_history (e_whom, p_partner_key, e_contact_history_type, e_contact_history_id);


/* e_activity */
create  index e_act_par_idx on e_activity (p_partner_key, e_activity_group_id, e_activity_id);
/* create  index e_act_pk on e_activity (e_activity_group_id, e_activity_id)*/ 
/* go */
create  index e_act_sort_idx on e_activity (e_sort_key, e_activity_group_id, e_activity_id);
create  index e_act_type_idx on e_activity (e_activity_type, e_activity_group_id, e_activity_id);


/* e_engagement_track */
create  index e_trk_name_idx on e_engagement_track (e_track_name, e_track_id);
/* create  index e_trk_pk on e_engagement_track (e_track_id)*/ 
/* go */


/* e_engagement_track_collab */
/* create  index e_trkcoll_pk on e_engagement_track_collab (e_track_id, p_collab_partner_key)*/ 
/* go */
create  index e_trkcoll_ptnr_idx on e_engagement_track_collab (p_collab_partner_key, e_track_id);


/* e_engagement_step */
create  index e_step_name_idx on e_engagement_step (e_step_name, e_track_id, e_step_id);
/* create  index e_step_pk on e_engagement_step (e_track_id, e_step_id)*/ 
/* go */


/* e_engagement_step_collab */
/* create  index e_stepcoll_pk on e_engagement_step_collab (e_track_id, e_step_id, p_collab_partner_key)*/ 
/* go */
create  index e_stepcoll_ptnr_idx on e_engagement_step_collab (p_collab_partner_key, e_track_id, e_step_id);


/* e_engagement_step_req */
/* create  index e_req_pk on e_engagement_step_req (e_track_id, e_step_id, e_req_id)*/ 
/* go */


/* e_partner_engagement */
/* create  index e_pareng_pk on e_partner_engagement (p_partner_key, e_engagement_id, e_hist_id)*/ 
/* go */
create  index e_pareng_start_idx on e_partner_engagement (e_started_by, p_partner_key, e_engagement_id, e_hist_id);
create  index e_pareng_trackstep_idx on e_partner_engagement (e_track_id, e_step_id, p_partner_key, e_engagement_id, e_hist_id);


/* e_partner_engagement_req */
/* create  index e_parreq_pk on e_partner_engagement_req (p_partner_key, e_engagement_id, e_hist_id, e_req_item_id)*/ 
/* go */


/* e_tag_type */
/* create  index e_tagtype_pk on e_tag_type (e_tag_id)*/ 
/* go */


/* e_tag_type_relationship */
/* create  index e_tagtyperel_pk on e_tag_type_relationship (e_tag_id, e_rel_tag_id)*/ 
/* go */


/* e_tag */
/* create  index e_tag_pk on e_tag (e_tag_id, p_partner_key)*/ 
/* go */
create  index e_tag_rev_idx on e_tag (p_partner_key, e_tag_id);
create  index e_tag_strength_idx on e_tag (p_partner_key, e_tag_strength);


/* e_tag_activity */
create  index e_tagact_gptnr_idx on e_tag_activity (e_tag_activity_group, p_partner_key, e_tag_id, e_tag_activity_id);
create  index e_tagact_gtag_idx on e_tag_activity (e_tag_activity_group, e_tag_id, p_partner_key, e_tag_activity_id);
/* create  index e_tagact_pk on e_tag_activity (e_tag_activity_group, e_tag_activity_id)*/ 
/* go */
create  index e_tagact_ptnr_idx on e_tag_activity (p_partner_key, e_tag_id, e_tag_activity_group, e_tag_activity_id);
create  index e_tagact_tagid_idx on e_tag_activity (e_tag_id, p_partner_key, e_tag_activity_group, e_tag_activity_id);


/* e_tag_source */
/* create  index e_tagsrc_pk on e_tag_source (e_tag_id, e_tag_source_type, e_tag_source_key)*/ 
/* go */
create  index e_tagsrc_src_idx on e_tag_source (e_tag_source_type, e_tag_source_key, e_tag_id);


/* e_document_type */
create  index e_doctype_label_idx on e_document_type (e_doc_type_label, e_doc_type_id);
create  index e_doctype_parent_idx on e_document_type (e_parent_doc_type_id, e_doc_type_id);
/* create  index e_doctype_pk on e_document_type (e_doc_type_id)*/ 
/* go */


/* e_document */
create  index e_doc_curpath_idx on e_document (e_current_folder, e_current_filename, e_document_id);
/* create  index e_doc_pk on e_document (e_document_id)*/ 
/* go */
create  index e_doc_type_idx on e_document (e_doc_type_id, e_document_id);
create  index e_doc_work_idx on e_document (e_workflow_instance_id, e_document_id);


/* e_document_comment */
create  index e_doccom_collab_idx on e_document_comment (e_collaborator, e_document_id, e_doc_comment_id);
/* create  index e_doccom_pk on e_document_comment (e_document_id, e_doc_comment_id)*/ 
/* go */
create  index e_doccom_tgtcollab_idx on e_document_comment (e_target_collaborator, e_document_id, e_doc_comment_id);
create  index e_doccom_work_idx on e_document_comment (e_workflow_state_id, e_document_id, e_doc_comment_id);


/* e_partner_document */
create  index e_pardoc_egagement_idx on e_partner_document (e_engagement_id, p_partner_key, e_document_id, e_pardoc_assoc_id);
/* create  index e_pardoc_pk on e_partner_document (e_document_id, p_partner_key, e_pardoc_assoc_id)*/ 
/* go */
create  index e_pardoc_rev_idx on e_partner_document (p_partner_key, e_document_id, e_pardoc_assoc_id);
create  index e_pardoc_work_idx on e_partner_document (e_workflow_instance_id, p_partner_key, e_document_id, e_pardoc_assoc_id);


/* e_workflow_type */
/* create  index e_work_pk on e_workflow_type (e_workflow_id)*/ 
/* go */


/* e_workflow_type_step */
/* create  index e_workstep_pk on e_workflow_type_step (e_workflow_step_id)*/ 
/* go */
create  index e_workstep_trig_idx on e_workflow_type_step (e_workflow_step_trigger_type, e_workflow_step_trigger, e_workflow_step_id);
create  index e_workstep_type_idx on e_workflow_type_step (e_workflow_id, e_workflow_step_id);


/* e_workflow */
/* create  index e_workinst_pk on e_workflow (e_workflow_instance_id)*/ 
/* go */
create  index e_workinst_steptrig_idx on e_workflow (e_workflow_step_trigger_id, e_workflow_instance_id);
create  index e_workinst_trig_idx on e_workflow (e_workflow_trigger_type, e_workflow_trigger_id, e_workflow_instance_id);
create  index e_workinst_type_idx on e_workflow (e_workflow_id, e_workflow_instance_id);


/* e_collaborator_type */
/* create  index e_collabtype_pk on e_collaborator_type (e_collab_type_id)*/ 
/* go */


/* e_collaborator */
/* create  index e_collab_pk on e_collaborator (e_collaborator, p_partner_key)*/ 
/* go */
create  index e_collab_rev_idx on e_collaborator (p_partner_key, e_collaborator);
create  index e_collab_type_idx on e_collaborator (e_collab_type_id, e_collaborator, p_partner_key);


/* e_todo_type */
/* create  index e_todotype_pk on e_todo_type (e_todo_type_id)*/ 
/* go */


/* e_todo */
create  index e_todo_collab_idx on e_todo (e_todo_collaborator, e_todo_id);
create  index e_todo_doc_idx on e_todo (e_todo_document_id, e_todo_id);
create  index e_todo_eng_idx on e_todo (e_todo_engagement_id, e_todo_id);
create  index e_todo_par_idx on e_todo (e_todo_partner, e_todo_id);
/* create  index e_todo_pk on e_todo (e_todo_id)*/ 
/* go */
create  index e_todo_reqitem_idx on e_todo (e_todo_req_item_id, e_todo_id);
create  index e_todo_type_idx on e_todo (e_todo_type_id, e_todo_id);


/* e_data_item_type */
create  index e_ditype_parent_idx on e_data_item_type (e_parent_data_item_type_id, e_data_item_type_id);
/* create  index e_ditype_pk on e_data_item_type (e_data_item_type_id)*/ 
/* go */


/* e_data_item_type_value */
/* create  index e_dataitemval_pk on e_data_item_type_value (e_data_item_type_id, e_data_item_value_id)*/ 
/* go */


/* e_data_item_group */
/* create  index e_digrp_pk on e_data_item_group (e_data_item_group_id)*/ 
/* go */
create  index e_digrp_type_idx on e_data_item_group (e_data_item_type_id, e_data_item_group_id);


/* e_data_item */
create  index e_dataitem_group_idx on e_data_item (e_data_item_group_id, e_data_item_id);
/* create  index e_dataitem_pk on e_data_item (e_data_item_id)*/ 
/* go */
create  index e_dataitem_type_idx on e_data_item (e_data_item_type_id, e_data_item_id);


/* e_highlights */
create  index e_h_nt_idx on e_highlights (e_highlight_type, e_highlight_name, e_highlight_user, e_highlight_partner, e_highlight_id);
/* create  index e_h_pk on e_highlights (e_highlight_user, e_highlight_partner, e_highlight_id)*/ 
/* go */
create  index e_h_prec_idx on e_highlights (e_highlight_user, e_highlight_partner, e_highlight_precedence, e_highlight_id);


/* e_data_highlight */
create  index e_dh_obj_idx on e_data_highlight (e_highlight_object_type, e_highlight_object_id, e_highlight_subject);
/* create  index e_dh_pk on e_data_highlight (e_highlight_subject, e_highlight_object_type, e_highlight_object_id)*/ 
/* go */


/* e_ack */
create  index e_ack_obj_idx on e_ack (e_object_type,e_object_id,e_ack_type,e_whom,e_ack_id);
create  index e_ack_par2_idx on e_ack (p_dn_partner_key,e_ack_type,e_object_type,e_object_id,e_ack_id);
create  index e_ack_par3_idx on e_ack (p_dn_partner_key,e_whom,e_ack_id);
create  index e_ack_par_idx on e_ack (e_whom,e_ack_type,e_object_type,e_object_id,e_ack_id);
/* create  index e_ack_pk on e_ack (e_ack_id)*/ 
/* go */


/* e_ack_type */
/* create  index e_ackt_pk on e_ack_type (e_ack_type)*/ 
/* go */


/* e_trackactivity */
/* create  index e_trkact_pk on e_trackactivity (p_partner_key,e_username,e_sort_key)*/ 
/* go */


/* e_text_expansion */
/* create  index e_exp_pk on e_text_expansion (e_exp_tag)*/ 
/* go */


/* e_text_search_word */
/* create  index e_tsw_pk on e_text_search_word (e_word_id)*/ 
/* go */
create  index e_tsw_word_idx on e_text_search_word (e_word, e_word_id);


/* e_text_search_rel */
/* create  index e_tsr_pk on e_text_search_rel (e_word_id, e_target_word_id)*/ 
/* go */
create  index e_tsr_rev_idx on e_text_search_rel (e_target_word_id, e_word_id);


/* e_text_search_occur */
/* create  index e_tso_pk on e_text_search_occur (e_word_id, e_document_id, e_sequence)*/ 
/* go */
create  index e_tso_seq_idx on e_text_search_occur (e_document_id, e_sequence, e_word_id);


/* h_staff */
/* create  index h_staff_pk on h_staff (p_partner_key)*/ 
/* go */


/* h_group */
/* create  index h_group_pk on h_group (h_group_id)*/ 
/* go */


/* h_group_member */
create  index h_group_ptnr_idx on h_group_member (p_partner_key, h_group_id);
/* create  index h_groupm_pk on h_group_member (h_group_id, p_partner_key)*/ 
/* go */


/* h_holidays */
/* create  index h_holiday_pk on h_holidays (h_holiday_id)*/ 
/* go */


/* h_work_register */
create  index h_workreg_ben_idx on h_work_register (h_benefit_type_id, p_partner_key, h_work_register_id);
/* create  index h_workreg_pk on h_work_register (p_partner_key, h_work_register_id)*/ 
/* go */


/* h_work_register_times */
/* create  index h_workregt_pk on h_work_register_times (p_partner_key, h_work_register_time_id)*/ 
/* go */


/* h_benefit_period */
/* create  index h_benper_pk on h_benefit_period (h_benefit_period_id)*/ 
/* go */


/* h_benefit_type */
/* create  index h_bentype_pk on h_benefit_type (h_benefit_type_id)*/ 
/* go */


/* h_benefit_type_sched */
/* create  index h_bentypesch_pk on h_benefit_type_sched (h_benefit_type_id, h_benefit_type_sched_id)*/ 
/* go */
create  index h_bts_group_idx on h_benefit_type_sched (h_group_id, h_benefit_type_id, h_benefit_type_sched_id);
create  index h_bts_partner_idx on h_benefit_type_sched (p_partner_key, h_benefit_type_id, h_benefit_type_sched_id);


/* h_benefits */
create  index h_ben_partner_idx on h_benefits (p_partner_key, h_benefit_type_id, h_benefit_period_id);
create  index h_ben_period_idx on h_benefits (h_benefit_period_id, h_benefit_type_id, p_partner_key);
/* create  index h_ben_pk on h_benefits (h_benefit_type_id, p_partner_key, h_benefit_period_id)*/ 
/* go */


/* r_group_sched */
/* create  index r_grp_sch_pk on r_group_sched (r_group_name, r_group_sched_id)*/ 
/* go */


/* r_group_sched_param */
/* create  index r_sparam_pk on r_group_sched_param (r_group_name, r_group_sched_id, r_param_name)*/ 
/* go */


/* r_group_sched_report */
/* create  index r_grp_sch_r_pk on r_group_sched_report (r_group_name, r_delivery_method, r_group_sched_id, p_recipient_partner_key, r_report_id)*/ 
/* go */
create  index r_schrpt_partner_idx on r_group_sched_report (p_recipient_partner_key, r_group_name, r_delivery_method, r_group_sched_id, r_report_id);


/* r_group */
create  index r_grp_modfile_idx on r_group (r_group_module, r_group_file, r_group_name);
/* create  index r_grp_pk on r_group (r_group_name)*/ 
/* go */


/* r_group_report */
create  index r_rpt_partner_idx on r_group_report (p_recipient_partner_key, r_group_name, r_delivery_method, r_report_id);
/* create  index r_rpt_pk on r_group_report (r_group_name, r_delivery_method, p_recipient_partner_key, r_report_id)*/ 
/* go */


/* r_group_param */
create  index r_param_cmp_idx on r_group_param (r_param_cmp_module, r_param_cmp_file, r_group_name, r_param_name);
/* create  index r_param_pk on r_group_param (r_group_name, r_param_name)*/ 
/* go */


/* r_group_report_param */
create  index r_rparam_param_idx on r_group_report_param (r_group_name, r_param_name, r_delivery_method, p_recipient_partner_key, r_report_id);
create  index r_rparam_partner_idx on r_group_report_param (p_recipient_partner_key, r_group_name, r_delivery_method, r_report_id, r_param_name);
/* create  index r_rparam_pk on r_group_report_param (r_group_name, r_delivery_method, p_recipient_partner_key, r_report_id, r_param_name)*/ 
/* go */
create  index r_rparam_value_idx on r_group_report_param (r_param_name, r_param_value, r_group_name, r_delivery_method, p_recipient_partner_key, r_report_id);


/* r_saved_paramset */
create  index r_ps_modfile_idx on r_saved_paramset (r_module, r_file, r_paramset_id);
/* create  index r_ps_pk on r_saved_paramset (r_paramset_id)*/ 
/* go */


/* r_saved_param */
/* create  index r_psparam_pk on r_saved_param (r_paramset_id, r_param_name)*/ 
/* go */


/* a_config */
/* create  index a_config_pk on a_config (a_ledger_number, a_config_name)*/ 
/* go */


/* a_analysis_attr */
/* create  index a_an_attr_pk on a_analysis_attr (a_ledger_number, a_attr_code)*/ 
/* go */


/* a_analysis_attr_value */
/* create  index a_an_attr_val_pk on a_analysis_attr_value (a_ledger_number, a_attr_code, a_value)*/ 
/* go */


/* a_fund_analysis_attr */
/* create  index a_fund_an_attr_pk on a_fund_analysis_attr (a_ledger_number, a_attr_code, a_fund, a_hist_id)*/ 
/* go */


/* a_acct_analysis_attr */
/* create  index a_acct_an_attr_pk on a_acct_analysis_attr (a_ledger_number, a_attr_code, a_account_code, a_hist_id)*/ 
/* go */


/* a_fund */
create  index a_fund_bal_idx on a_fund (a_bal_fund, a_fund, a_ledger_number);
create  index a_fund_ledger_number_idx on a_fund (a_ledger_number, a_fund);
create  index a_fund_legacy_idx on a_fund (a_legacy_code, a_fund, a_ledger_number);
create  index a_fund_parent_idx on a_fund (a_parent_fund, a_fund, a_ledger_number);
/* create  index a_fund_pk on a_fund (a_fund, a_ledger_number)*/ 
/* go */


/* a_account */
/* create  index a_account_pk on a_account (a_account_code, a_ledger_number)*/ 
/* go */
create  index a_acct_ledger_number_idx on a_account (a_ledger_number, a_account_code);
create  index a_acct_legacy_idx on a_account (a_legacy_code, a_account_code, a_ledger_number);
create  index a_acct_parent_idx on a_account (a_parent_account_code, a_account_code, a_ledger_number);


/* a_account_usage */
/* create  index a_account_usage_pk on a_account_usage (a_acct_usage_code, a_ledger_number, a_account_code)*/ 
/* go */
create  index a_acctusg_acct_idx on a_account_usage (a_account_code, a_ledger_number, a_acct_usage_code);
create  index a_acctusg_ledger_number_idx on a_account_usage (a_ledger_number, a_acct_usage_code, a_account_code);


/* a_account_usage_type */
/* create  index a_account_usage_type_pk on a_account_usage_type (a_acct_usage_code)*/ 
/* go */


/* a_account_category */
/* create  index a_account_category_pk on a_account_category (a_account_category, a_ledger_number)*/ 
/* go */


/* a_fund_acct */
/* create  index a_fund_acct_pk on a_fund_acct (a_ledger_number, a_period, a_fund, a_account_code)*/ 
/* go */


/* a_period */
/* create  index a_period_pk on a_period (a_period, a_ledger_number)*/ 
/* go */


/* a_period_usage */
/* create  index a_account_usage_pk on a_period_usage (a_period_usage_code, a_ledger_number, a_period)*/ 
/* go */


/* a_period_usage_type */
/* create  index a_period_usage_type_pk on a_period_usage_type (a_period_usage_code)*/ 
/* go */


/* a_ledger */
/* create  index a_ledger_pk on a_ledger (a_ledger_number)*/ 
/* go */


/* a_batch */
create  index a_batch_ledger_idx on a_batch (a_ledger_number, a_batch_number);
/* create  index a_batch_pk on a_batch (a_batch_number, a_ledger_number)*/ 
/* go */
create  index a_corr_batch_idx on a_batch (a_ledger_number, a_corrects_batch_number, a_batch_number);


/* a_transaction */
/* create  index a_transaction_pk on a_transaction (a_ledger_number, a_batch_number, a_journal_number, a_transaction_number)*/ 
/* go */
create  index a_trx_batch_idx on a_transaction (a_batch_number, a_ledger_number, a_journal_number, a_transaction_number);
create  index a_trx_donor_id_idx on a_transaction (p_ext_partner_id, a_ledger_number, a_batch_number, a_journal_number, a_transaction_number);
/* create  index a_trx_fund_clustered_idx on a_transaction (a_fund, a_account_code, a_ledger_number, a_batch_number, a_journal_number, a_transaction_number)*/ 
/* go */
create  index a_trx_fund_quicksum_idx on a_transaction (a_ledger_number, a_fund, a_effective_date, a_posted, a_amount, a_batch_number, a_journal_number, a_transaction_number);
create  index a_trx_fundperiod_idx on a_transaction (a_ledger_number, a_fund, a_period, a_batch_number, a_journal_number, a_transaction_number);
create  index a_trx_journal_idx on a_transaction (a_journal_number, a_ledger_number, a_batch_number, a_transaction_number);
create  index a_trx_period_idx on a_transaction (a_ledger_number, a_period, a_fund, a_batch_number, a_journal_number, a_transaction_number);
create  index a_trx_recip_id_idx on a_transaction (p_int_partner_id, a_ledger_number, a_batch_number, a_journal_number, a_transaction_number);
create  index a_trx_transaction_idx on a_transaction (a_transaction_number, a_ledger_number, a_batch_number, a_journal_number);


/* a_transaction_tmp */
/* create  index a_transaction_tmp_pk on a_transaction_tmp (a_ledger_number, a_batch_number, a_journal_number, a_transaction_number)*/ 
/* go */
create  index a_trxt_batch_idx on a_transaction_tmp (a_batch_number, a_ledger_number, a_journal_number, a_transaction_number);
create  index a_trxt_donor_id_idx on a_transaction_tmp (p_ext_partner_id, a_ledger_number, a_batch_number, a_journal_number, a_transaction_number);
/* create  index a_trxt_fund_clustered_idx on a_transaction_tmp (a_fund, a_account_code, a_ledger_number, a_batch_number, a_journal_number, a_transaction_number)*/ 
/* go */
create  index a_trxt_fund_quicksum_idx on a_transaction_tmp (a_ledger_number, a_fund, a_effective_date, a_posted, a_amount, a_batch_number, a_journal_number, a_transaction_number);
create  index a_trxt_journal_idx on a_transaction_tmp (a_journal_number, a_ledger_number, a_batch_number, a_transaction_number);
create  index a_trxt_recip_id_idx on a_transaction_tmp (p_int_partner_id, a_ledger_number, a_batch_number, a_journal_number, a_transaction_number);
create  index a_trxt_transaction_idx on a_transaction_tmp (a_transaction_number, a_ledger_number, a_batch_number, a_journal_number);


/* a_account_class */
/* create  index a_account_class_pk on a_account_class (a_account_class, a_ledger_number)*/ 
/* go */


/* a_fund_class */
/* create  index a_fund_class_pk on a_fund_class (a_fund_class, a_ledger_number)*/ 
/* go */


/* a_reporting_level */
/* create  index a_level_pk on a_reporting_level (a_reporting_level, a_ledger_number)*/ 
/* go */


/* a_fund_prefix */
create  index a_fund_pfx_ledger_number_idx on a_fund_prefix (a_ledger_number, a_fund_prefix);
/* create  index a_fund_prefix_pk on a_fund_prefix (a_fund_prefix, a_ledger_number)*/ 
/* go */


/* a_fund_staff */
create  index a_fund_staff_partner_idx on a_fund_staff (p_staff_partner_key, a_ledger_number, a_fund);
/* create  index a_fund_staff_pk on a_fund_staff (a_ledger_number, a_fund, p_staff_partner_key)*/ 
/* go */


/* a_ledger_office */
/* create  index a_lo_pk on a_ledger_office (a_ledger_number, p_office_partner_key)*/ 
/* go */


/* a_currency */
/* create  index a_curr_pk on a_currency (a_ledger_number, a_currency_code)*/ 
/* go */


/* a_currency_exch_rate */
/* create  index a_curr_pk on a_currency_exch_rate (a_ledger_number, a_base_currency_code, a_foreign_currency_code, a_exch_rate_date)*/ 
/* go */


/* a_payroll */
create  index a_payroll_fund_idx on a_payroll (a_ledger_number, a_fund, a_payroll_group_id, a_payroll_id);
create  index a_payroll_payee_idx on a_payroll (a_ledger_number, p_payee_partner_key, a_payroll_group_id, a_payroll_id);
/* create  index a_payroll_pk on a_payroll (a_ledger_number, a_payroll_group_id, a_payroll_id)*/ 
/* go */


/* a_payroll_period */
create  index a_payperiod_idx on a_payroll_period (a_period, a_ledger_number, a_payroll_group_id, a_payroll_period);
/* create  index a_payperiod_pk on a_payroll_period (a_ledger_number, a_payroll_group_id, a_payroll_period)*/ 
/* go */


/* a_payroll_period_payee */
/* create  index a_payperiodpayee_pk on a_payroll_period_payee (a_ledger_number, a_payroll_group_id, a_payroll_period, a_payroll_id)*/ 
/* go */


/* a_payroll_group */
create  index a_payroll_fund_idx on a_payroll_group (a_ledger_number, a_fund, a_payroll_group_id);
/* create  index a_payroll_grp_pk on a_payroll_group (a_ledger_number, a_payroll_group_id)*/ 
/* go */


/* a_payroll_import */
create  index a_payrolli_fund_idx on a_payroll_import (a_ledger_number, a_fund, a_payroll_id);
create  index a_payrolli_payee_idx on a_payroll_import (a_ledger_number, p_payee_partner_key, a_payroll_id);
/* create  index a_payrolli_pk on a_payroll_import (a_payroll_id)*/ 
/* go */


/* a_payroll_item */
/* create  index a_payroll_i_pk on a_payroll_item (a_ledger_number, a_payroll_group_id, a_payroll_id, a_payroll_item_id)*/ 
/* go */


/* a_payroll_item_import */
/* create  index a_payrolli_i_pk on a_payroll_item_import (a_payroll_id, a_payroll_item_id)*/ 
/* go */


/* a_payroll_item_type */
/* create  index a_payroll_it_pk on a_payroll_item_type (a_ledger_number, a_payroll_item_type_code)*/ 
/* go */


/* a_payroll_item_class */
/* create  index a_payroll_ic_pk on a_payroll_item_class (a_payroll_item_class_code)*/ 
/* go */


/* a_payroll_item_subclass */
/* create  index a_payroll_isc_pk on a_payroll_item_subclass (a_payroll_item_class_code, a_payroll_item_subclass_code)*/ 
/* go */


/* a_payroll_form_group */
/* create  index a_payroll_f_pk on a_payroll_form_group (a_ledger_number, a_payroll_form_group_name, a_payroll_form_sequence)*/ 
/* go */


/* a_tax_filingstatus */
/* create  index a_filingstatus_pk on a_tax_filingstatus (a_ledger_number, a_payroll_item_type_code, a_filing_status)*/ 
/* go */


/* a_tax_table */
/* create  index a_taxtable_clustered_idx on a_tax_table (a_payroll_item_type, a_ledger_number, a_start_date, a_filing_status, a_payroll_interval, a_minimum_salary)*/ 
/* go */
/* create  index a_taxtable_pk on a_tax_table (a_tax_entry_id)*/ 
/* go */


/* a_tax_allowance_table */
/* create  index a_taxalltable_pk on a_tax_allowance_table (a_tax_allowance_entry_id)*/ 
/* go */


/* a_salary_review */
/* create  index a_salreview_pk on a_salary_review (a_ledger_number, a_payroll_id, a_review)*/ 
/* go */
create  index a_salreview_review_idx on a_salary_review (a_review, a_ledger_number, a_payroll_id);


/* a_fund_admin_fee */
/* create  index a_fund_admin_fee_pk on a_fund_admin_fee (a_fund, a_ledger_number)*/ 
/* go */
create  index a_fundaf_ledger_number_idx on a_fund_admin_fee (a_ledger_number, a_fund);


/* a_admin_fee_type */
/* create  index a_admin_fee_type_pk on a_admin_fee_type (a_ledger_number, a_admin_fee_type, a_admin_fee_subtype)*/ 
/* go */


/* a_admin_fee_type_tmp */
/* create  index a_admin_fee_type_tmp_pk on a_admin_fee_type_tmp (a_ledger_number, a_admin_fee_type, a_admin_fee_subtype)*/ 
/* go */


/* a_admin_fee_type_item */
/* create  index a_admin_fee_type_item_pk on a_admin_fee_type_item (a_ledger_number, a_admin_fee_type, a_admin_fee_subtype, a_dest_fund)*/ 
/* go */
create  index a_afti_ledger_number_idx on a_admin_fee_type_item (a_ledger_number, a_dest_fund, a_admin_fee_type, a_admin_fee_subtype);


/* a_admin_fee_type_item_tmp */
/* create  index a_admin_fee_type_item_tmp_pk on a_admin_fee_type_item_tmp (a_ledger_number, a_admin_fee_type, a_admin_fee_subtype, a_dest_fund)*/ 
/* go */
create  index a_afti_tmp_ledger_number_idx on a_admin_fee_type_item_tmp (a_ledger_number, a_dest_fund, a_admin_fee_type, a_admin_fee_subtype);


/* a_fund_receipting */
/* create  index a_fund_receipting_pk on a_fund_receipting (a_fund, a_ledger_number)*/ 
/* go */
create  index a_fundr_ledger_number_idx on a_fund_receipting (a_ledger_number, a_fund);


/* a_fund_receipting_accts */
/* create  index a_fund_rcptacct_pk on a_fund_receipting_accts (a_fund, a_ledger_number,a_account_code)*/ 
/* go */
create  index a_fundra_acct_number_idx on a_fund_receipting_accts (a_ledger_number, a_account_code, a_fund);
create  index a_fundra_ledger_number_idx on a_fund_receipting_accts (a_ledger_number, a_fund, a_account_code);


/* a_receipt_type */
/* create  index a_rcpttype_pk on a_receipt_type (a_receipt_type)*/ 
/* go */


/* a_gift_payment_type */
/* create  index a_gpmttype_pk on a_gift_payment_type (a_ledger_number, a_gift_payment_type)*/ 
/* go */


/* a_receipt_mailing */
/* create  index a_giftlist_pk on a_receipt_mailing (a_ledger_number, m_list_code)*/ 
/* go */


/* a_subtrx_gift */
create  index a_gifttrx_batch_idx on a_subtrx_gift (a_batch_number, a_ledger_number, a_gift_number);
create  index a_gifttrx_donor_id_idx on a_subtrx_gift (p_donor_partner_id, a_ledger_number, a_batch_number, a_gift_number);
/* create  index a_gifttrx_fund_clustered_idx on a_subtrx_gift (a_fund, a_account_code, a_ledger_number, a_batch_number, a_gift_number)*/ 
/* go */
create  index a_gifttrx_gift_idx on a_subtrx_gift (a_gift_number, a_ledger_number, a_batch_number);
/* create  index a_gifttrx_pk on a_subtrx_gift (a_ledger_number, a_batch_number, a_gift_number)*/ 
/* go */
create  index a_gifttrx_recip_id_idx on a_subtrx_gift (p_recip_partner_id, a_ledger_number, a_batch_number, a_gift_number);


/* a_subtrx_gift_group */
create  index a_gifttrxgrp_ack_id_idx on a_subtrx_gift_group (p_ack_partner_id, a_ledger_number, a_batch_number, a_gift_number);
create  index a_gifttrxgrp_batch_idx on a_subtrx_gift_group (a_batch_number, a_ledger_number, a_gift_number);
create  index a_gifttrxgrp_donor_id_idx on a_subtrx_gift_group (p_donor_partner_id, a_ledger_number, a_batch_number, a_gift_number);
create  index a_gifttrxgrp_gift_idx on a_subtrx_gift_group (a_gift_number, a_ledger_number, a_batch_number);
create  index a_gifttrxgrp_pass_id_idx on a_subtrx_gift_group (p_pass_partner_id, a_ledger_number, a_batch_number, a_gift_number);
/* create  index a_gifttrxgrp_pk on a_subtrx_gift_group (a_ledger_number, a_batch_number, a_gift_number)*/ 
/* go */


/* a_subtrx_gift_item */
/* create  index a_gifttrx_pk on a_subtrx_gift_item (a_ledger_number, a_batch_number, a_gift_number, a_split_number)*/ 
/* go */
create  index a_gifttrxi_ack_idx on a_subtrx_gift_item (p_dn_ack_partner_id, a_ledger_number, a_batch_number, a_gift_number, a_split_number);
create  index a_gifttrxi_datetype_idx on a_subtrx_gift_item (a_dn_gift_received_date, a_dn_gift_postmark_date, a_dn_gift_type, a_ledger_number, a_batch_number, a_gift_number, a_split_number);
create  index a_gifttrxi_donor_idx on a_subtrx_gift_item (p_dn_donor_partner_id, a_ledger_number, a_batch_number, a_gift_number, a_split_number);
/* create  index a_gifttrxi_fund_clustered_idx on a_subtrx_gift_item (a_fund, a_account_code, a_ledger_number, a_batch_number, a_gift_number, a_split_number)*/ 
/* go */
create  index a_gifttrxi_gift_idx on a_subtrx_gift_item (a_gift_number, a_ledger_number, a_batch_number, a_split_number);
create  index a_gifttrxi_hash_idx on a_subtrx_gift_item (a_account_hash, a_check_front_image, a_check_back_image, a_ledger_number, a_batch_number, a_gift_number, a_split_number);
create  index a_gifttrxi_mcode_idx on a_subtrx_gift_item (a_motivational_code, a_ledger_number, a_batch_number, a_gift_number, a_split_number);
create  index a_gifttrxi_pass_idx on a_subtrx_gift_item (p_dn_pass_partner_id, a_ledger_number, a_batch_number, a_gift_number, a_split_number);
create  index a_gifttrxi_rcpt_idx on a_subtrx_gift_item (a_dn_receipt_number, a_ledger_number, a_batch_number, a_gift_number, a_split_number);
create  index a_gifttrxi_recip_id_idx on a_subtrx_gift_item (p_recip_partner_id, a_ledger_number, a_batch_number, a_gift_number, a_split_number);
create  index a_gifttrxi_src_idx on a_subtrx_gift_item (i_eg_source_key, a_ledger_number, a_batch_number, a_gift_number, a_split_number);


/* a_subtrx_gift_intent */
create  index a_gifttrxin_gift_idx on a_subtrx_gift_intent (a_ledger_number, a_batch_number, a_gift_number, a_split_number, a_intent_number);
/* create  index a_gifttrxin_pk on a_subtrx_gift_intent (a_ledger_number, a_batch_number, a_gift_number, a_intent_number)*/ 
/* go */
create  index a_gifttrxin_pledge_idx on a_subtrx_gift_intent (a_ledger_number, a_pledge_id, a_batch_number, a_gift_number, a_intent_number);


/* a_subtrx_gift_rcptcnt */
/* create  index a_rcptno_pk on a_subtrx_gift_rcptcnt (a_ledger_number)*/ 
/* go */


/* a_fund_auto_subscribe */
create  index a_fund_as_ledger_number_idx on a_fund_auto_subscribe (a_ledger_number, a_fund, m_list_code);
create  index a_fund_as_listcode_idx on a_fund_auto_subscribe (m_list_code, a_fund, a_ledger_number);
/* create  index a_fund_auto_subscribe_pk on a_fund_auto_subscribe (a_fund, a_ledger_number, m_list_code)*/ 
/* go */


/* a_motivational_code */
create  index a_motiv_code_fund on a_motivational_code (a_ledger_number, a_fund, a_account_code, a_motivational_code);
create  index a_motiv_code_list on a_motivational_code (m_list_code, a_ledger_number, a_motivational_code);
create  index a_motiv_code_parent on a_motivational_code (a_ledger_number, a_parent_motivational_code, a_motivational_code);
/* create  index a_motivational_code_pk on a_motivational_code (a_ledger_number, a_motivational_code)*/ 
/* go */


/* a_giving_pattern */
create  index a_givingp_actual_idx on a_giving_pattern (a_actual_fund, a_ledger_number, p_donor_partner_key, a_fund, a_pattern_id, a_history_id);
create  index a_givingp_donor_idx on a_giving_pattern (p_donor_partner_key, a_ledger_number, a_fund, a_pattern_id, a_history_id);
create  index a_givingp_fund_idx on a_giving_pattern (a_fund, a_ledger_number, p_donor_partner_key, a_pattern_id, a_history_id);
/* create  index a_givingp_pk on a_giving_pattern (a_ledger_number, p_donor_partner_key, a_fund, a_pattern_id, a_history_id)*/ 
/* go */
create  index a_givingp_review_idx on a_giving_pattern (a_review, a_ledger_number, p_donor_partner_key, a_fund, a_pattern_id, a_history_id);


/* a_giving_pattern_allocation */
create  index a_givingpa_actual_idx on a_giving_pattern_allocation (a_actual_fund, a_ledger_number, p_donor_partner_key, a_fund, a_pattern_id, a_history_id);
create  index a_givingpa_donor_idx on a_giving_pattern_allocation (p_donor_partner_key, a_ledger_number, a_fund, a_pattern_id, a_history_id);
create  index a_givingpa_fund_idx on a_giving_pattern_allocation (a_fund, a_ledger_number, p_donor_partner_key, a_pattern_id, a_history_id);
/* create  index a_givingpa_pk on a_giving_pattern_allocation (a_ledger_number, p_donor_partner_key, a_fund, a_pattern_id, a_history_id)*/ 
/* go */
create  index a_givingpa_review_idx on a_giving_pattern_allocation (a_review, a_ledger_number, p_donor_partner_key, a_fund, a_pattern_id, a_history_id);


/* a_giving_pattern_flag */
/* create  index a_givingf_pk on a_giving_pattern_flag (a_ledger_number, p_donor_partner_key, a_fund, a_pattern_id, a_history_id)*/ 
/* go */
create  index a_givingf_review_idx on a_giving_pattern_flag (a_review, a_ledger_number, p_donor_partner_key, a_fund, a_pattern_id, a_history_id);


/* a_funding_target */
/* create  index a_target_pk on a_funding_target (a_ledger_number, a_fund, a_target_id)*/ 
/* go */


/* a_support_review */
/* create  index a_supportreview_pk on a_support_review (a_ledger_number, a_review)*/ 
/* go */


/* a_support_review_target */
/* create  index a_supptgt_pk on a_support_review_target (a_ledger_number, a_fund, a_target_id, a_review)*/ 
/* go */
create  index a_supptgt_review_idx on a_support_review_target (a_review, a_ledger_number, a_fund, a_target_id);
create  index a_supptgt_target_idx on a_support_review_target (a_target_id, a_ledger_number, a_fund, a_review);


/* a_descriptives */
create  index a_descr_fund_idx on a_descriptives (a_ledger_number, a_fund, p_donor_partner_key);
create  index a_descr_par_idx on a_descriptives (p_donor_partner_key, a_ledger_number, a_fund);
/* create  index a_descr_pk on a_descriptives (a_ledger_number, p_donor_partner_key, a_fund)*/ 
/* go */


/* a_descriptives_hist */
create  index a_descrhist_fund_idx on a_descriptives_hist (a_ledger_number, a_fund, p_donor_partner_key, a_hist_id);
create  index a_descrhist_merge_idx on a_descriptives_hist (a_ledger_number, a_fund, p_donor_partner_key, a_merged_id, a_hist_id);
create  index a_descrhist_par_idx on a_descriptives_hist (p_donor_partner_key, a_ledger_number, a_fund, a_hist_id);
/* create  index a_descrhist_pk on a_descriptives_hist (a_ledger_number, p_donor_partner_key, a_fund, a_hist_id)*/ 
/* go */


/* a_pledge */
create  index a_pledge_donor_idx on a_pledge (a_ledger_number, p_donor_partner_id, a_pledge_id);
create  index a_pledge_fund_idx on a_pledge (a_ledger_number, a_fund, a_pledge_id);
/* create  index a_pledge_pk on a_pledge (a_ledger_number, a_pledge_id)*/ 
/* go */


/* a_intent_type */
/* create  index a_intenttype_pk on a_intent_type (a_ledger_number, a_intent_type)*/ 
/* go */


/* a_subtrx_cashdisb */
create  index a_subtrx_cashdisb_acct_idx on a_subtrx_cashdisb (a_cash_account_code, a_ledger_number, a_batch_number, a_disbursement_id, a_line_item);
create  index a_subtrx_cashdisb_batch_idx on a_subtrx_cashdisb (a_batch_number, a_ledger_number, a_disbursement_id, a_line_item);
/* create  index a_subtrx_cashdisb_pk on a_subtrx_cashdisb (a_ledger_number, a_batch_number, a_disbursement_id, a_line_item)*/ 
/* go */


/* a_subtrx_payable */
/* create  index a_subtrx_payable_pk on a_subtrx_payable (a_ledger_number, a_payable_id)*/ 
/* go */


/* a_subtrx_payable_item */
/* create  index a_subtrx_payable_item_pk on a_subtrx_payable_item (a_ledger_number, a_payable_id, a_line_item)*/ 
/* go */


/* a_subtrx_xfer */
/* create  index a_subtrx_xfer_pk on a_subtrx_xfer (a_ledger_number, a_batch_number, a_journal_number)*/ 
/* go */


/* a_subtrx_deposit */
create  index a_subtrx_dep_acct_idx on a_subtrx_deposit (a_account_code, a_ledger_number, a_batch_number);
create  index a_subtrx_dep_batch_idx on a_subtrx_deposit (a_batch_number, a_ledger_number);
/* create  index a_subtrx_deposit_pk on a_subtrx_deposit (a_ledger_number, a_batch_number)*/ 
/* go */


/* a_subtrx_cashxfer */
/* create  index a_subtrx_cashxfer_pk on a_subtrx_cashxfer (a_ledger_number, a_batch_number, a_journal_number)*/ 
/* go */
create  index a_subtrx_cxf_batch_idx on a_subtrx_cashxfer (a_batch_number, a_ledger_number, a_journal_number);
/* create  index a_subtrx_cxf_fund_clustered_idx on a_subtrx_cashxfer (a_fund, a_source_cash_acct, a_ledger_number, a_batch_number, a_journal_number)*/ 
/* go */
create  index a_subtrx_cxf_fund_rev1_idx on a_subtrx_cashxfer (a_source_cash_acct, a_fund, a_batch_number, a_journal_number);
create  index a_subtrx_cxf_fund_rev2_idx on a_subtrx_cashxfer (a_dest_cash_acct, a_fund, a_batch_number, a_journal_number);
create  index a_subtrx_cxf_journal_idx on a_subtrx_cashxfer (a_journal_number, a_ledger_number, a_batch_number);


/* i_eg_gift_import */
create  index i_eg_edeposit_idx on i_eg_gift_import (i_eg_deposit_uuid, a_ledger_number, i_eg_trx_uuid, i_eg_desig_uuid);
create  index i_eg_edonor_idx on i_eg_gift_import (i_eg_donor_uuid, i_eg_donor_alt_id, i_eg_donormap_future, i_eg_donormap_confidence, p_donor_partner_key, a_ledger_number, i_eg_trx_uuid, i_eg_desig_uuid);
create  index i_eg_efund_idx on i_eg_gift_import (i_eg_desig_name, a_ledger_number, i_eg_fundmap_future, i_eg_fundmap_confidence, a_fund, i_eg_trx_uuid, i_eg_desig_uuid);
create  index i_eg_egift_idx on i_eg_gift_import (i_eg_gift_uuid, a_ledger_number, i_eg_trx_uuid, i_eg_desig_uuid);
/* create  index i_eg_gift_import_pk on i_eg_gift_import (a_ledger_number, i_eg_trx_uuid, i_eg_desig_uuid)*/ 
/* go */
create  index i_eg_kdepbatch_idx on i_eg_gift_import (a_batch_number_deposit, a_ledger_number, i_eg_trx_uuid, i_eg_desig_uuid);
create  index i_eg_kdonfund_idx on i_eg_gift_import (p_donor_partner_key, a_ledger_number, a_fund, i_eg_trx_uuid, i_eg_desig_uuid);
create  index i_eg_kdonor_idx on i_eg_gift_import (p_donor_partner_key, a_ledger_number, i_eg_trx_uuid, i_eg_desig_uuid);
create  index i_eg_kfeebatch_idx on i_eg_gift_import (a_batch_number_fees, a_ledger_number, i_eg_trx_uuid, i_eg_desig_uuid);
create  index i_eg_kfund_idx on i_eg_gift_import (a_fund, a_account_code, a_ledger_number, i_eg_trx_uuid, i_eg_desig_uuid);
create  index i_eg_kgiftbatch_idx on i_eg_gift_import (a_batch_number, a_ledger_number, i_eg_trx_uuid, i_eg_desig_uuid);
create  index i_eg_stats_idx on i_eg_gift_import (i_eg_gift_trx_date, i_eg_status, i_eg_donormap_confidence, i_eg_fundmap_confidence, i_eg_acctmap_confidence, a_batch_number, i_eg_gift_amount, a_ledger_number, i_eg_trx_uuid, i_eg_desig_uuid);


/* i_eg_gift_trx_fees */
/* create  index i_eg_gift_trx_fees_pk on i_eg_gift_trx_fees (a_ledger_number, i_eg_fees_id)*/ 
/* go */


/* i_eg_giving_url */
create  index i_eg_giveurl_revidx on i_eg_giving_url (a_fund, a_ledger_number);
/* create  index i_eg_giving_url_pk on i_eg_giving_url (a_ledger_number, a_fund)*/ 
/* go */


/* i_crm_partner_import */
/* create  index i_crm_partner_import_pk on i_crm_partner_import (i_crm_import_id, i_crm_import_session_id)*/ 
/* go */


/* i_crm_partner_import_option */
/* create  index i_crm_partner_import_opt_pk on i_crm_partner_import_option (i_crm_import_id, i_crm_import_session_id, i_crm_import_type_option_id)*/ 
/* go */


/* i_crm_import_type */
/* create  index i_crm_import_type_pk on i_crm_import_type (i_crm_import_type_id)*/ 
/* go */


/* i_crm_import_type_option */
/* create  index i_crm_import_type_option_pk on i_crm_import_type_option (i_crm_import_type_id,i_crm_import_type_option_id)*/ 
/* go */


/* i_disb_import_classify */
/* create  index i_disb_import_pk on i_disb_import_classify (a_ledger_number, i_disb_classify_item)*/ 
/* go */


/* i_disb_import_status */
/* create  index i_disb_legacy_pk on i_disb_import_status (a_ledger_number, i_disb_legacy_key)*/ 
/* go */


/* c_message */
/* create  index c_message_pk on c_message (c_chat_id, c_message_id)*/ 
/* go */


/* c_chat */
/* create  index c_chat_pk on c_chat (c_chat_id)*/ 
/* go */
create  index c_public_idx on c_chat (c_public, c_chat_id);


/* c_member */
/* create  index c_member_pk on c_member (c_chat_id, s_username)*/ 
/* go */
create  index s_username_idx on c_member (s_username, c_chat_id);


/* t_project */
create  index t_parent_idx on t_project (t_parent_project_id, t_project_id);
/* create  index t_project_pk on t_project (t_project_id)*/ 
/* go */


/* t_sprint */
create  index t_sprint_idx on t_sprint (t_sprint_id);
/* create  index t_sprint_pk on t_sprint (t_sprint_id)*/ 
/* go */


/* t_sprint_project */
/* create  index t_sprintproj_pk on t_sprint_project (t_project_id, t_sprint_id)*/ 
/* go */


/* t_sprint_time */
/* create  index t_sprint_time_pk on t_sprint_time (t_time_id)*/ 
/* go */
create  index t_time_proj_idx on t_sprint_time (t_project_id, t_sprint_id, t_time_id);
create  index t_time_sprint_idx on t_sprint_time (t_sprint_id, t_time_id);


/* t_task */
/* create  index t_task_pk on t_task (t_task_id)*/ 
/* go */
create  index t_task_proj_idx on t_task (t_project_id, t_sprint_id, t_task_id);
create  index t_task_sprint_idx on t_task (t_sprint_id, t_task_id);


/* t_participant */
create  index t_part_proj_idx on t_participant (t_project_id, p_partner_key);
/* create  index t_participant_pk on t_participant (p_partner_key, t_project_id)*/ 
/* go */


/* t_sprint_participant */
create  index t_spart_proj_idx on t_sprint_participant (t_project_id, t_sprint_id, p_partner_key);
create  index t_spart_sprint_idx on t_sprint_participant (t_sprint_id, p_partner_key, t_project_id);
/* create  index t_sprint_participant_pk on t_sprint_participant (p_partner_key, t_sprint_id, t_project_id)*/ 
/* go */


/* t_assignee */
/* create  index t_assignee_pk on t_assignee (p_partner_key, t_task_id)*/ 
/* go */
create  index t_assignee_task_idx on t_assignee (t_task_id, p_partner_key);


/* t_task_state */
/* create  index t_tstate_pk on t_task_state (t_task_state_id)*/ 
/* go */


/* t_task_history */
/* create  index t_history_pk on t_task_history (t_task_id, t_history_id)*/ 
/* go */
create  index t_taskhist_idx on t_task_history (t_task_id, t_transition_date, t_history_id);


/* s_config */
/* create  index s_config_pk on s_config (s_config_name)*/ 
/* go */


/* s_user_data */
/* create  index s_user_data_pk on s_user_data (s_username)*/ 
/* go */


/* s_user_loginhistory */
/* create  index s_loginhist_pk on s_user_loginhistory (s_username, s_sessionid)*/ 
/* go */


/* s_subsystem */
/* create  index s_subsystem_pk on s_subsystem (s_subsystem_code)*/ 
/* go */


/* s_process */
/* create  index s_process_pk on s_process (s_subsystem_code, s_process_code)*/ 
/* go */


/* s_process_status */
/* create  index s_procstat_pk on s_process_status (s_subsystem_code, s_process_code, s_process_status_code)*/ 
/* go */


/* s_motd */
/* create  index s_motd_pk on s_motd (s_motd_id)*/ 
/* go */


/* s_motd_viewed */
/* create  index s_motd_viewed_pk on s_motd_viewed (s_motd_id, s_username)*/ 
/* go */
create  index s_motd_viewed_username_idx on s_motd_viewed (s_username, s_motd_id);


/* s_sec_endorsement */
/* create  index s_end_pk on s_sec_endorsement (s_endorsement, s_context, s_subject)*/ 
/* go */


/* s_sec_endorsement_type */
/* create  index s_endt_pk on s_sec_endorsement_type (s_endorsement)*/ 
/* go */


/* s_sec_endorsement_context */
/* create  index s_endc_pk on s_sec_endorsement_context (s_context)*/ 
/* go */


/* s_mykardia */
/* create  index s_myk_pk on s_mykardia (s_username, s_module, s_plugin, s_occurrence)*/ 
/* go */


/* s_request */
create  index s_objkey12_idx on s_request (s_object_key_1, s_object_key_2, s_request_id);
create  index s_objkey21_idx on s_request (s_object_key_2, s_object_key_1, s_request_id);
/* create  index s_req_pk on s_request (s_request_id)*/ 
/* go */


/* s_request_type */
/* create  index s_reqtype_pk on s_request_type (s_request_type)*/ 
/* go */


/* s_audit */
create  index s_audit_intval_idx on s_audit (s_table, s_attrname, s_valueint, s_key, s_sequence);
create  index s_audit_name_idx on s_audit (s_table, s_key, s_attrname, s_sequence);
/* create  index s_audit_pk on s_audit (s_sequence)*/ 
/* go */
create  index s_audit_strval_idx on s_audit (s_table, s_attrname, s_valuestring, s_key, s_sequence);


/* s_role */
/* create  index s_role_pk on s_role (s_role_id)*/ 
/* go */


/* s_role_exclusivity */
/* create  index s_role_ex_pk on s_role_exclusivity (s_role1_id, s_role2_id)*/ 
/* go */


/* s_user_role */
/* create  index s_user_role_pk on s_user_role (s_role_id, s_username)*/ 
/* go */


/* s_global_search */
/* create  index s_global_search_pk on s_global_search (s_search_id, s_username, s_search_res_id)*/ 
/* go */


/* s_stats_cache */
/* create  index s_stats_cache_pk on s_stats_cache (s_stat_type, s_stat_group, s_stat)*/ 
/* go */


/* s_document_scanner */
/* create  index s_scanner_pk on s_document_scanner (s_scanner_id)*/ 
/* go */
