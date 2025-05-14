use Kardia_DB;


alter table p_partner
	add constraint p_given_name_idx unique  (p_given_name, p_partner_key);

alter table p_partner
	add constraint p_org_name_idx unique  (p_org_name, p_partner_key);

alter table p_partner
	add constraint p_legacy_key_1_idx unique  (p_legacy_key_1, p_partner_key);

alter table p_partner
	add constraint p_legacy_key_2_idx unique  (p_legacy_key_2, p_partner_key);

alter table p_partner
	add constraint p_parent_key_idx unique  (p_parent_key, p_partner_key);

alter table p_partner
	add constraint p_fund_idx unique  (a_fund, p_partner_key);

alter table p_partner
	add constraint p_merged_with_idx unique  (p_merged_with, p_partner_key);

alter table p_location
	add constraint p_location_state_idx unique  (p_state_province, p_postal_code, p_partner_key, p_location_id, p_revision_id);

alter table p_location
	add constraint p_location_zip_idx unique  (p_postal_code, p_state_province, p_partner_key, p_location_id, p_revision_id);

alter table p_location
	add constraint p_location_city_idx unique  (p_city, p_state_province, p_postal_code, p_partner_key, p_location_id, p_revision_id);

alter table p_contact_info
	add constraint p_contact_idx unique  (p_contact_data, p_phone_area_city, p_phone_country, p_partner_key, p_contact_id);

alter table p_staff
	add constraint p_staff_login_idx unique  (p_kardia_login, p_partner_key);

alter table p_staff
	add constraint p_staff_weblogin_idx unique  (p_kardiaweb_login, p_partner_key);

alter table p_banking_details
	add constraint p_bankd_partner_idx unique  (p_partner_id, p_banking_details_key);

alter table p_banking_details
	add constraint p_bankd_bpartner_idx unique  (p_bank_partner_id, p_banking_details_key);

alter table p_banking_details
	add constraint p_bankd_acct_idx unique  (a_ledger_number, a_account_code, p_banking_details_key);

alter table p_gazetteer
	add constraint p_gaz_altid_idx unique  (p_alt_feature_id, p_country_code, p_feature_type, p_feature_id);

alter table p_gazetteer
	add constraint p_gaz_state_idx unique  (p_state_province, p_country_code, p_feature_type, p_feature_id);

alter table p_notification
	add constraint p_notify_recip_idx unique  (p_recip_partner_key, p_notify_id);

alter table p_notification
	add constraint p_notify_source_idx unique  (p_source_partner_key, p_notify_id);

alter table p_notification
	add constraint p_notify_type_idx unique  (p_notify_type, p_object_id, p_recip_partner_key, p_notify_method, p_notify_method_item, p_notify_id);

alter table e_contact_history
	add constraint e_cnt_hist_type_idx unique  (e_contact_history_type, p_partner_key, e_contact_history_id);

alter table e_contact_history
	add constraint e_cnt_hist_par_idx unique  (p_partner_key, e_contact_history_type, e_contact_history_id);

alter table e_contact_history
	add constraint e_cnt_hist_locpar_idx unique  (p_location_partner_key, e_contact_history_type, e_contact_history_id);

alter table e_contact_history
	add constraint e_cnt_hist_whom_idx unique  (e_whom, p_partner_key, e_contact_history_type, e_contact_history_id);

alter table e_engagement_track
	add constraint e_trk_name_idx unique  (e_track_name, e_track_id);

alter table e_engagement_step
	add constraint e_step_name_idx unique  (e_step_name, e_track_id, e_step_id);

alter table e_partner_engagement
	add constraint e_pareng_trackstep_idx unique  (e_track_id, e_step_id, p_partner_key, e_engagement_id, e_hist_id);

alter table e_partner_engagement
	add constraint e_pareng_start_idx unique  (e_started_by, p_partner_key, e_engagement_id, e_hist_id);

alter table e_tag_activity
	add constraint e_tagact_tagid_idx unique  (e_tag_id, p_partner_key, e_tag_activity_group, e_tag_activity_id);

alter table e_tag_activity
	add constraint e_tagact_ptnr_idx unique  (p_partner_key, e_tag_id, e_tag_activity_group, e_tag_activity_id);

alter table e_document_type
	add constraint e_doctype_parent_idx unique  (e_parent_doc_type_id, e_doc_type_id);

alter table e_document_type
	add constraint e_doctype_label_idx unique  (e_doc_type_label, e_doc_type_id);

alter table e_document
	add constraint e_doc_work_idx unique  (e_workflow_instance_id, e_document_id);

alter table e_document
	add constraint e_doc_type_idx unique  (e_doc_type_id, e_document_id);

alter table e_document
	add constraint e_doc_curpath_idx unique  (e_current_folder, e_current_filename, e_document_id);

alter table e_document_comment
	add constraint e_doccom_collab_idx unique  (e_collaborator, e_document_id, e_doc_comment_id);

alter table e_document_comment
	add constraint e_doccom_tgtcollab_idx unique  (e_target_collaborator, e_document_id, e_doc_comment_id);

alter table e_document_comment
	add constraint e_doccom_work_idx unique  (e_workflow_state_id, e_document_id, e_doc_comment_id);

alter table e_workflow_type_step
	add constraint e_workstep_type_idx unique  (e_workflow_id, e_workflow_step_id);

alter table e_workflow_type_step
	add constraint e_workstep_trig_idx unique  (e_workflow_step_trigger_type, e_workflow_step_trigger, e_workflow_step_id);

alter table e_workflow
	add constraint e_workinst_type_idx unique  (e_workflow_id, e_workflow_instance_id);

alter table e_workflow
	add constraint e_workinst_trig_idx unique  (e_workflow_trigger_type, e_workflow_trigger_id, e_workflow_instance_id);

alter table e_workflow
	add constraint e_workinst_steptrig_idx unique  (e_workflow_step_trigger_id, e_workflow_instance_id);

alter table e_collaborator
	add constraint e_collab_type_idx unique  (e_collab_type_id, e_collaborator, p_partner_key);

alter table e_todo
	add constraint e_todo_type_idx unique  (e_todo_type_id, e_todo_id);

alter table e_todo
	add constraint e_todo_collab_idx unique  (e_todo_collaborator, e_todo_id);

alter table e_todo
	add constraint e_todo_par_idx unique  (e_todo_partner, e_todo_id);

alter table e_todo
	add constraint e_todo_eng_idx unique  (e_todo_engagement_id, e_todo_id);

alter table e_todo
	add constraint e_todo_doc_idx unique  (e_todo_document_id, e_todo_id);

alter table e_todo
	add constraint e_todo_reqitem_idx unique  (e_todo_req_item_id, e_todo_id);

alter table e_data_item_type
	add constraint e_ditype_parent_idx unique  (e_parent_data_item_type_id, e_data_item_type_id);

alter table e_data_item_group
	add constraint e_digrp_type_idx unique  (e_data_item_type_id, e_data_item_group_id);

alter table e_data_item
	add constraint e_dataitem_type_idx unique  (e_data_item_type_id, e_data_item_id);

alter table e_data_item
	add constraint e_dataitem_group_idx unique  (e_data_item_group_id, e_data_item_id);

alter table e_highlights
	add constraint e_h_nt_idx unique  (e_highlight_type, e_highlight_name, e_highlight_user, e_highlight_partner, e_highlight_id);

alter table e_activity
	add constraint e_act_type_idx unique  (e_activity_type, e_activity_group_id, e_activity_id);

alter table e_activity
	add constraint e_act_par_idx unique  (p_partner_key, e_activity_group_id, e_activity_id);

alter table e_activity
	add constraint e_act_sort_idx unique  (e_sort_key, e_activity_group_id, e_activity_id);

alter table e_ack
	add constraint e_ack_obj_idx unique  (e_object_type,e_object_id,e_ack_type,e_whom,e_ack_id);

alter table e_ack
	add constraint e_ack_par_idx unique  (e_whom,e_ack_type,e_object_type,e_object_id,e_ack_id);

alter table e_ack
	add constraint e_ack_par2_idx unique  (p_dn_partner_key,e_ack_type,e_object_type,e_object_id,e_ack_id);

alter table e_ack
	add constraint e_ack_par3_idx unique  (p_dn_partner_key,e_whom,e_ack_id);

alter table e_text_search_word
	add constraint e_tsw_word_idx unique  (e_word, e_word_id);

alter table h_work_register
	add constraint h_workreg_ben_idx unique  (h_benefit_type_id, p_partner_key, h_work_register_id);

alter table h_benefit_type_sched
	add constraint h_bts_partner_idx unique  (p_partner_key, h_benefit_type_id, h_benefit_type_sched_id);

alter table h_benefit_type_sched
	add constraint h_bts_group_idx unique  (h_group_id, h_benefit_type_id, h_benefit_type_sched_id);

alter table r_group
	add constraint r_grp_modfile_idx unique  (r_group_module, r_group_file, r_group_name);

alter table r_group_param
	add constraint r_param_cmp_idx unique  (r_param_cmp_module, r_param_cmp_file, r_group_name, r_param_name);

alter table r_saved_paramset
	add constraint r_ps_modfile_idx unique  (r_module, r_file, r_paramset_id);

alter table a_fund
	add constraint a_fund_parent_idx unique  (a_parent_fund, a_fund, a_ledger_number);

alter table a_fund
	add constraint a_fund_legacy_idx unique  (a_legacy_code, a_fund, a_ledger_number);

alter table a_fund
	add constraint a_fund_bal_idx unique  (a_bal_fund, a_fund, a_ledger_number);

alter table a_account
	add constraint a_acct_parent_idx unique  (a_parent_account_code, a_account_code, a_ledger_number);

alter table a_account
	add constraint a_acct_legacy_idx unique  (a_legacy_code, a_account_code, a_ledger_number);

alter table a_transaction
	add constraint a_trx_donor_id_idx unique  (p_ext_partner_id, a_ledger_number, a_batch_number, a_journal_number, a_transaction_number);

alter table a_transaction
	add constraint a_trx_recip_id_idx unique  (p_int_partner_id, a_ledger_number, a_batch_number, a_journal_number, a_transaction_number);

alter table a_transaction_tmp
	add constraint a_trxt_donor_id_idx unique  (p_ext_partner_id, a_ledger_number, a_batch_number, a_journal_number, a_transaction_number);

alter table a_transaction_tmp
	add constraint a_trxt_recip_id_idx unique  (p_int_partner_id, a_ledger_number, a_batch_number, a_journal_number, a_transaction_number);

alter table a_dimension
	add constraint a_dim_legacy_idx unique  (a_legacy_code, a_dimension, a_ledger_number);

alter table a_dimension
	add constraint a_dim_fund_idx unique  (a_dim_fund, a_dimension, a_ledger_number);

alter table a_dimension
	add constraint a_dim_fund_class_idx unique  (a_dim_fund_class, a_dim_fund, a_dimension, a_ledger_number);

alter table a_dimension_item
	add constraint a_dim_item_legacy_idx unique  (a_legacy_code, a_dimension, a_ledger_number, a_dimension_item);

alter table a_dimension_item
	add constraint a_dim_item_fund_idx unique  (a_dim_item_fund, a_dimension, a_ledger_number, a_dimension_item);

alter table a_dimension_item
	add constraint a_dim_item_fund_class_idx unique  (a_dim_fund_class, a_dim_fund, a_dimension, a_ledger_number, a_dimension_item);

alter table a_payroll_period
	add constraint a_payperiod_idx unique  (a_period, a_ledger_number, a_payroll_group_id, a_payroll_period);

alter table a_payroll_import
	add constraint a_payrolli_payee_idx unique  (a_ledger_number, p_payee_partner_key, a_payroll_id);

alter table a_payroll_import
	add constraint a_payrolli_fund_idx unique  (a_ledger_number, a_fund, a_payroll_id);

alter table a_subtrx_gift
	add constraint a_gifttrx_donor_id_idx unique  (p_donor_partner_id, a_ledger_number, a_batch_number, a_gift_number);

alter table a_subtrx_gift
	add constraint a_gifttrx_recip_id_idx unique  (p_recip_partner_id, a_ledger_number, a_batch_number, a_gift_number);

alter table a_subtrx_gift_group
	add constraint a_gifttrxgrp_donor_id_idx unique  (p_donor_partner_id, a_ledger_number, a_batch_number, a_gift_number);

alter table a_subtrx_gift_group
	add constraint a_gifttrxgrp_ack_id_idx unique  (p_ack_partner_id, a_ledger_number, a_batch_number, a_gift_number);

alter table a_subtrx_gift_group
	add constraint a_gifttrxgrp_pass_id_idx unique  (p_pass_partner_id, a_ledger_number, a_batch_number, a_gift_number);

alter table a_subtrx_gift_item
	add constraint a_gifttrxi_recip_id_idx unique  (p_recip_partner_id, a_ledger_number, a_batch_number, a_gift_number, a_split_number);

alter table a_subtrx_gift_item
	add constraint a_gifttrxi_mcode_idx unique  (a_motivational_code, a_ledger_number, a_batch_number, a_gift_number, a_split_number);

alter table a_subtrx_gift_item
	add constraint a_gifttrxi_donor_idx unique  (p_dn_donor_partner_id, a_ledger_number, a_batch_number, a_gift_number, a_split_number);

alter table a_subtrx_gift_item
	add constraint a_gifttrxi_ack_idx unique  (p_dn_ack_partner_id, a_ledger_number, a_batch_number, a_gift_number, a_split_number);

alter table a_subtrx_gift_item
	add constraint a_gifttrxi_pass_idx unique  (p_dn_pass_partner_id, a_ledger_number, a_batch_number, a_gift_number, a_split_number);

alter table a_subtrx_gift_item
	add constraint a_gifttrxi_rcpt_idx unique  (a_dn_receipt_number, a_ledger_number, a_batch_number, a_gift_number, a_split_number);

alter table a_subtrx_gift_item
	add constraint a_gifttrxi_src_idx unique  (i_eg_source_key, a_ledger_number, a_batch_number, a_gift_number, a_split_number);

alter table a_subtrx_gift_item
	add constraint a_gifttrxi_datetype_idx unique  (a_dn_gift_received_date, a_dn_gift_postmark_date, a_dn_gift_type, a_ledger_number, a_batch_number, a_gift_number, a_split_number);

alter table a_subtrx_gift_item
	add constraint a_gifttrxi_hash_idx unique  (a_account_hash, a_check_front_image, a_check_back_image, a_ledger_number, a_batch_number, a_gift_number, a_split_number);

alter table a_motivational_code
	add constraint a_motiv_code_list unique  (m_list_code, a_ledger_number, a_motivational_code);

alter table a_giving_pattern
	add constraint a_givingp_review_idx unique  (a_review, a_ledger_number, p_donor_partner_key, a_fund, a_pattern_id, a_history_id);

alter table a_giving_pattern
	add constraint a_givingp_actual_idx unique  (a_actual_fund, a_ledger_number, p_donor_partner_key, a_fund, a_pattern_id, a_history_id);

alter table a_giving_pattern_allocation
	add constraint a_givingpa_review_idx unique  (a_review, a_ledger_number, p_donor_partner_key, a_fund, a_pattern_id, a_history_id);

alter table a_giving_pattern_allocation
	add constraint a_givingpa_actual_idx unique  (a_actual_fund, a_ledger_number, p_donor_partner_key, a_fund, a_pattern_id, a_history_id);

alter table a_giving_pattern_flag
	add constraint a_givingf_review_idx unique  (a_review, a_ledger_number, p_donor_partner_key, a_fund, a_pattern_id, a_history_id);

alter table a_subtrx_cashdisb
	add constraint a_subtrx_cashdisb_acct_idx unique  (a_cash_account_code, a_ledger_number, a_batch_number, a_disbursement_id, a_line_item);

alter table a_subtrx_deposit
	add constraint a_subtrx_dep_acct_idx unique  (a_account_code, a_ledger_number, a_batch_number);

alter table i_eg_gift_import
	add constraint i_eg_kdonor_idx unique  (p_donor_partner_key, a_ledger_number, i_eg_trx_uuid, i_eg_desig_uuid, i_eg_line_item);

alter table i_eg_gift_import
	add constraint i_eg_edonor_idx unique  (i_eg_donor_uuid, i_eg_donor_alt_id, i_eg_donormap_future, i_eg_donormap_confidence, p_donor_partner_key, a_ledger_number, i_eg_trx_uuid, i_eg_desig_uuid, i_eg_line_item);

alter table i_eg_gift_import
	add constraint i_eg_kfund_idx unique  (a_fund, a_account_code, a_ledger_number, i_eg_trx_uuid, i_eg_desig_uuid, i_eg_line_item);

alter table i_eg_gift_import
	add constraint i_eg_egift_idx unique  (i_eg_gift_uuid, a_ledger_number, i_eg_trx_uuid, i_eg_desig_uuid, i_eg_line_item);

alter table i_eg_gift_import
	add constraint i_eg_edeposit_idx unique  (i_eg_deposit_uuid, a_ledger_number, i_eg_trx_uuid, i_eg_desig_uuid, i_eg_line_item);

alter table i_eg_gift_import
	add constraint i_eg_kgiftbatch_idx unique  (a_batch_number, a_ledger_number, i_eg_trx_uuid, i_eg_desig_uuid, i_eg_line_item);

alter table i_eg_gift_import
	add constraint i_eg_kfeebatch_idx unique  (a_batch_number_fees, a_ledger_number, i_eg_trx_uuid, i_eg_desig_uuid, i_eg_line_item);

alter table i_eg_gift_import
	add constraint i_eg_kdepbatch_idx unique  (a_batch_number_deposit, a_ledger_number, i_eg_trx_uuid, i_eg_desig_uuid, i_eg_line_item);

alter table i_eg_gift_import
	add constraint i_eg_stats_idx unique  (i_eg_gift_trx_date, i_eg_status, i_eg_donormap_confidence, i_eg_fundmap_confidence, i_eg_acctmap_confidence, a_batch_number, i_eg_gift_amount, a_ledger_number, i_eg_trx_uuid, i_eg_desig_uuid, i_eg_line_item);

alter table i_eg_gift_import
	add constraint i_eg_postproc_idx unique  (i_eg_postprocess, a_ledger_number, i_eg_trx_uuid, i_eg_desig_uuid, i_eg_line_item);

alter table c_chat
	add constraint c_public_idx unique  (c_public, c_chat_id);

alter table t_project
	add constraint t_parent_idx unique  (t_parent_project_id, t_project_id);

alter table t_sprint
	add constraint t_sprint_idx unique  (t_sprint_id);

alter table t_sprint_time
	add constraint t_time_sprint_idx unique  (t_sprint_id, t_time_id);

alter table t_sprint_time
	add constraint t_time_proj_idx unique  (t_project_id, t_sprint_id, t_time_id);

alter table t_task
	add constraint t_task_sprint_idx unique  (t_sprint_id, t_task_id);

alter table t_task
	add constraint t_task_proj_idx unique  (t_project_id, t_sprint_id, t_task_id);

alter table s_request
	add constraint s_objkey12_idx unique  (s_object_key_1, s_object_key_2, s_request_id);

alter table s_request
	add constraint s_objkey21_idx unique  (s_object_key_2, s_object_key_1, s_request_id);

alter table s_audit
	add constraint s_audit_name_idx unique  (s_table, s_key, s_attrname, s_sequence);

alter table s_audit
	add constraint s_audit_strval_idx unique  (s_table, s_attrname, s_valuestring, s_key, s_sequence);

alter table s_audit
	add constraint s_audit_intval_idx unique  (s_table, s_attrname, s_valueint, s_key, s_sequence);
