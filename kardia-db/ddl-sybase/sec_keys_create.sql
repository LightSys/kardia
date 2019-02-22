use Kardia_DB
go


alter table p_partner
	add constraint p_given_name_idx unique nonclustered (p_given_name, p_partner_key)
go

alter table p_partner
	add constraint p_org_name_idx unique nonclustered (p_org_name, p_partner_key)
go

alter table p_partner
	add constraint p_legacy_key_1_idx unique nonclustered (p_legacy_key_1, p_partner_key)
go

alter table p_partner
	add constraint p_legacy_key_2_idx unique nonclustered (p_legacy_key_2, p_partner_key)
go

alter table p_partner
	add constraint p_parent_key_idx unique nonclustered (p_parent_key, p_partner_key)
go

alter table p_partner
	add constraint p_cost_ctr_idx unique nonclustered (p_cost_center, p_partner_key)
go

alter table p_partner
	add constraint p_merged_with_idx unique nonclustered (p_merged_with, p_partner_key)
go

alter table p_location
	add constraint p_location_state_idx unique nonclustered (p_state_province, p_postal_code, p_partner_key, p_location_id, p_revision_id)
go

alter table p_location
	add constraint p_location_zip_idx unique nonclustered (p_postal_code, p_state_province, p_partner_key, p_location_id, p_revision_id)
go

alter table p_location
	add constraint p_location_city_idx unique nonclustered (p_city, p_state_province, p_partner_key, p_location_id, p_revision_id)
go

alter table p_staff
	add constraint p_staff_login_idx unique nonclustered (p_kardia_login, p_partner_key)
go

alter table p_staff
	add constraint p_staff_weblogin_idx unique nonclustered (p_kardiaweb_login, p_partner_key)
go

alter table p_banking_details
	add constraint p_bankd_partner_idx unique nonclustered (p_partner_id, p_banking_details_key)
go

alter table p_banking_details
	add constraint p_bankd_bpartner_idx unique nonclustered (p_bank_partner_id, p_banking_details_key)
go

alter table p_banking_details
	add constraint p_bankd_acct_idx unique nonclustered (a_ledger_number, a_account_code, p_banking_details_key)
go

alter table p_gazetteer
	add constraint p_gaz_altid_idx unique nonclustered (p_alt_feature_id, p_country_code, p_feature_type, p_feature_id)
go

alter table p_gazetteer
	add constraint p_gaz_state_idx unique nonclustered (p_state_province, p_country_code, p_feature_type, p_feature_id)
go

alter table e_contact_history
	add constraint e_cnt_hist_type_idx unique nonclustered (e_contact_history_type, p_partner_key, e_contact_history_id)
go

alter table e_contact_history
	add constraint e_cnt_hist_par_idx unique nonclustered (p_partner_key, e_contact_history_type, e_contact_history_id)
go

alter table e_contact_history
	add constraint e_cnt_hist_locpar_idx unique nonclustered (p_location_partner_key, e_contact_history_type, e_contact_history_id)
go

alter table e_contact_history
	add constraint e_cnt_hist_whom_idx unique nonclustered (e_whom, p_partner_key, e_contact_history_type, e_contact_history_id)
go

alter table e_activity
	add constraint e_act_type_idx unique nonclustered (e_activity_type, e_activity_group_id, e_activity_id)
go

alter table e_activity
	add constraint e_act_par_idx unique nonclustered (p_partner_key, e_activity_group_id, e_activity_id)
go

alter table e_activity
	add constraint e_act_sort_idx unique nonclustered (e_sort_key, e_activity_group_id, e_activity_id)
go

alter table e_engagement_track
	add constraint e_trk_name_idx unique nonclustered (e_track_name, e_track_id)
go

alter table e_engagement_step
	add constraint e_step_name_idx unique nonclustered (e_step_name, e_track_id, e_step_id)
go

alter table e_partner_engagement
	add constraint e_pareng_trackstep_idx unique nonclustered (e_track_id, e_step_id, p_partner_key, e_engagement_id, e_hist_id)
go

alter table e_partner_engagement
	add constraint e_pareng_start_idx unique nonclustered (e_started_by, p_partner_key, e_engagement_id, e_hist_id)
go

alter table e_tag_activity
	add constraint e_tagact_tagid_idx unique nonclustered (e_tag_id, p_partner_key, e_tag_activity_group, e_tag_activity_id)
go

alter table e_tag_activity
	add constraint e_tagact_ptnr_idx unique nonclustered (p_partner_key, e_tag_id, e_tag_activity_group, e_tag_activity_id)
go

alter table e_document_type
	add constraint e_doctype_parent_idx unique nonclustered (e_parent_doc_type_id, e_doc_type_id)
go

alter table e_document_type
	add constraint e_doctype_label_idx unique nonclustered (e_doc_type_label, e_doc_type_id)
go

alter table e_document
	add constraint e_doc_work_idx unique nonclustered (e_workflow_instance_id, e_document_id)
go

alter table e_document
	add constraint e_doc_type_idx unique nonclustered (e_doc_type_id, e_document_id)
go

alter table e_document
	add constraint e_doc_curpath_idx unique nonclustered (e_current_folder, e_current_filename, e_document_id)
go

alter table e_document_comment
	add constraint e_doccom_collab_idx unique nonclustered (e_collaborator, e_document_id, e_doc_comment_id)
go

alter table e_document_comment
	add constraint e_doccom_tgtcollab_idx unique nonclustered (e_target_collaborator, e_document_id, e_doc_comment_id)
go

alter table e_document_comment
	add constraint e_doccom_work_idx unique nonclustered (e_workflow_state_id, e_document_id, e_doc_comment_id)
go

alter table e_workflow_type_step
	add constraint e_workstep_type_idx unique nonclustered (e_workflow_id, e_workflow_step_id)
go

alter table e_workflow_type_step
	add constraint e_workstep_trig_idx unique nonclustered (e_workflow_step_trigger_type, e_workflow_step_trigger, e_workflow_step_id)
go

alter table e_workflow
	add constraint e_workinst_type_idx unique nonclustered (e_workflow_id, e_workflow_instance_id)
go

alter table e_workflow
	add constraint e_workinst_trig_idx unique nonclustered (e_workflow_trigger_type, e_workflow_trigger_id, e_workflow_instance_id)
go

alter table e_workflow
	add constraint e_workinst_steptrig_idx unique nonclustered (e_workflow_step_trigger_id, e_workflow_instance_id)
go

alter table e_collaborator
	add constraint e_collab_type_idx unique nonclustered (e_collab_type_id, e_collaborator, p_partner_key)
go

alter table e_todo
	add constraint e_todo_type_idx unique nonclustered (e_todo_type_id, e_todo_id)
go

alter table e_todo
	add constraint e_todo_collab_idx unique nonclustered (e_todo_collaborator, e_todo_id)
go

alter table e_todo
	add constraint e_todo_par_idx unique nonclustered (e_todo_partner, e_todo_id)
go

alter table e_todo
	add constraint e_todo_eng_idx unique nonclustered (e_todo_engagement_id, e_todo_id)
go

alter table e_todo
	add constraint e_todo_doc_idx unique nonclustered (e_todo_document_id, e_todo_id)
go

alter table e_todo
	add constraint e_todo_reqitem_idx unique nonclustered (e_todo_req_item_id, e_todo_id)
go

alter table e_data_item_type
	add constraint e_ditype_parent_idx unique nonclustered (e_parent_data_item_type_id, e_data_item_type_id)
go

alter table e_data_item_group
	add constraint e_digrp_type_idx unique nonclustered (e_data_item_type_id, e_data_item_group_id)
go

alter table e_data_item
	add constraint e_dataitem_type_idx unique nonclustered (e_data_item_type_id, e_data_item_id)
go

alter table e_data_item
	add constraint e_dataitem_group_idx unique nonclustered (e_data_item_group_id, e_data_item_id)
go

alter table e_highlights
	add constraint e_h_nt_idx unique nonclustered (e_highlight_type, e_highlight_name, e_highlight_user, e_highlight_partner, e_highlight_id)
go

alter table e_ack
	add constraint e_ack_obj_idx unique nonclustered (e_object_type,e_object_id,e_ack_type,e_whom,e_ack_id)
go

alter table e_ack
	add constraint e_ack_par_idx unique nonclustered (e_whom,e_ack_type,e_object_type,e_object_id,e_ack_id)
go

alter table e_ack
	add constraint e_ack_par2_idx unique nonclustered (p_dn_partner_key,e_ack_type,e_object_type,e_object_id,e_ack_id)
go

alter table e_ack
	add constraint e_ack_par3_idx unique nonclustered (p_dn_partner_key,e_whom,e_ack_id)
go

alter table e_text_search_word
	add constraint e_tsw_word_idx unique nonclustered (e_word, e_word_id)
go

alter table h_work_register
	add constraint h_workreg_ben_idx unique nonclustered (h_benefit_type_id, p_partner_key, h_work_register_id)
go

alter table h_benefit_type_sched
	add constraint h_bts_partner_idx unique nonclustered (p_partner_key, h_benefit_type_id, h_benefit_type_sched_id)
go

alter table h_benefit_type_sched
	add constraint h_bts_group_idx unique nonclustered (h_group_id, h_benefit_type_id, h_benefit_type_sched_id)
go

alter table r_group
	add constraint r_grp_modfile_idx unique nonclustered (r_group_module, r_group_file, r_group_name)
go

alter table r_group_param
	add constraint r_param_cmp_idx unique nonclustered (r_param_cmp_module, r_param_cmp_file, r_group_name, r_param_name)
go

alter table r_saved_paramset
	add constraint r_ps_modfile_idx unique nonclustered (r_module, r_file, r_paramset_id)
go

alter table a_cost_center
	add constraint a_cc_parent_idx unique nonclustered (a_parent_cost_center, a_cost_center, a_ledger_number)
go

alter table a_cost_center
	add constraint a_cc_legacy_idx unique nonclustered (a_legacy_code, a_cost_center, a_ledger_number)
go

alter table a_cost_center
	add constraint a_cc_bal_idx unique nonclustered (a_bal_cost_center, a_cost_center, a_ledger_number)
go

alter table a_account
	add constraint a_acct_parent_idx unique nonclustered (a_parent_account_code, a_account_code, a_ledger_number)
go

alter table a_account
	add constraint a_acct_legacy_idx unique nonclustered (a_legacy_code, a_account_code, a_ledger_number)
go

alter table a_transaction
	add constraint a_trx_donor_id_idx unique nonclustered (p_ext_partner_id, a_ledger_number, a_batch_number, a_journal_number, a_transaction_number)
go

alter table a_transaction
	add constraint a_trx_recip_id_idx unique nonclustered (p_int_partner_id, a_ledger_number, a_batch_number, a_journal_number, a_transaction_number)
go

alter table a_transaction_tmp
	add constraint a_trxt_donor_id_idx unique nonclustered (p_ext_partner_id, a_ledger_number, a_batch_number, a_journal_number, a_transaction_number)
go

alter table a_transaction_tmp
	add constraint a_trxt_recip_id_idx unique nonclustered (p_int_partner_id, a_ledger_number, a_batch_number, a_journal_number, a_transaction_number)
go

alter table a_payroll_period
	add constraint a_payperiod_idx unique nonclustered (a_period, a_ledger_number, a_payroll_group_id, a_payroll_period)
go

alter table a_payroll_import
	add constraint a_payrolli_payee_idx unique nonclustered (a_ledger_number, p_payee_partner_key, a_payroll_id)
go

alter table a_payroll_import
	add constraint a_payrolli_cc_idx unique nonclustered (a_ledger_number, a_cost_center, a_payroll_id)
go

alter table a_subtrx_gift
	add constraint a_gifttrx_donor_id_idx unique nonclustered (p_donor_partner_id, a_ledger_number, a_batch_number, a_gift_number)
go

alter table a_subtrx_gift
	add constraint a_gifttrx_recip_id_idx unique nonclustered (p_recip_partner_id, a_ledger_number, a_batch_number, a_gift_number)
go

alter table a_subtrx_gift_group
	add constraint a_gifttrxgrp_donor_id_idx unique nonclustered (p_donor_partner_id, a_ledger_number, a_batch_number, a_gift_number)
go

alter table a_subtrx_gift_group
	add constraint a_gifttrxgrp_ack_id_idx unique nonclustered (p_ack_partner_id, a_ledger_number, a_batch_number, a_gift_number)
go

alter table a_subtrx_gift_item
	add constraint a_gifttrxi_recip_id_idx unique nonclustered (p_recip_partner_id, a_ledger_number, a_batch_number, a_gift_number, a_split_number)
go

alter table a_subtrx_gift_item
	add constraint a_gifttrxi_mcode_idx unique nonclustered (a_motivational_code, a_ledger_number, a_batch_number, a_gift_number, a_split_number)
go

alter table a_subtrx_gift_item
	add constraint a_gifttrxi_donor_idx unique nonclustered (p_dn_donor_partner_id, a_ledger_number, a_batch_number, a_gift_number, a_split_number)
go

alter table a_subtrx_gift_item
	add constraint a_gifttrxi_rcpt_idx unique nonclustered (a_dn_receipt_number, a_ledger_number, a_batch_number, a_gift_number, a_split_number)
go

alter table a_subtrx_gift_item
	add constraint a_gifttrxi_src_idx unique nonclustered (i_eg_source_key, a_ledger_number, a_batch_number, a_gift_number, a_split_number)
go

alter table a_motivational_code
	add constraint a_motiv_code_list unique nonclustered (m_list_code, a_ledger_number, a_motivational_code)
go

alter table a_giving_pattern
	add constraint a_givingp_review_idx unique nonclustered (a_review, a_ledger_number, p_donor_partner_key, a_cost_center, a_pattern_id, a_history_id)
go

alter table a_giving_pattern
	add constraint a_givingp_actual_idx unique nonclustered (a_actual_cost_center, a_ledger_number, p_donor_partner_key, a_cost_center, a_pattern_id, a_history_id)
go

alter table a_giving_pattern_allocation
	add constraint a_givingpa_review_idx unique nonclustered (a_review, a_ledger_number, p_donor_partner_key, a_cost_center, a_pattern_id, a_history_id)
go

alter table a_giving_pattern_allocation
	add constraint a_givingpa_actual_idx unique nonclustered (a_actual_cost_center, a_ledger_number, p_donor_partner_key, a_cost_center, a_pattern_id, a_history_id)
go

alter table a_giving_pattern_flag
	add constraint a_givingf_review_idx unique nonclustered (a_review, a_ledger_number, p_donor_partner_key, a_cost_center, a_pattern_id, a_history_id)
go

alter table a_subtrx_cashdisb
	add constraint a_subtrx_cashdisb_acct_idx unique nonclustered (a_cash_account_code, a_ledger_number, a_batch_number, a_disbursement_id, a_line_item)
go

alter table a_subtrx_deposit
	add constraint a_subtrx_dep_acct_idx unique nonclustered (a_account_code, a_ledger_number, a_batch_number)
go

alter table i_eg_gift_import
	add constraint i_eg_kdonor_idx unique nonclustered (p_donor_partner_key, a_ledger_number, i_eg_trx_uuid, i_eg_desig_uuid)
go

alter table i_eg_gift_import
	add constraint i_eg_edonor_idx unique nonclustered (i_eg_donor_uuid, a_ledger_number, i_eg_trx_uuid, i_eg_desig_uuid)
go

alter table i_eg_gift_import
	add constraint i_eg_kfund_idx unique nonclustered (a_cost_center, a_account_code, a_ledger_number, i_eg_trx_uuid, i_eg_desig_uuid)
go

alter table i_eg_gift_import
	add constraint i_eg_efund_idx unique nonclustered (i_eg_desig_name, a_ledger_number, i_eg_trx_uuid, i_eg_desig_uuid)
go

alter table i_eg_gift_import
	add constraint i_eg_egift_idx unique nonclustered (i_eg_gift_uuid, a_ledger_number, i_eg_trx_uuid, i_eg_desig_uuid)
go

alter table i_eg_gift_import
	add constraint i_eg_edeposit_idx unique nonclustered (i_eg_deposit_uuid, a_ledger_number, i_eg_trx_uuid, i_eg_desig_uuid)
go

alter table i_eg_gift_import
	add constraint i_eg_kgiftbatch_idx unique nonclustered (a_batch_number, a_ledger_number, i_eg_trx_uuid, i_eg_desig_uuid)
go

alter table i_eg_gift_import
	add constraint i_eg_kfeebatch_idx unique nonclustered (a_batch_number_fees, a_ledger_number, i_eg_trx_uuid, i_eg_desig_uuid)
go

alter table i_eg_gift_import
	add constraint i_eg_kdepbatch_idx unique nonclustered (a_batch_number_deposit, a_ledger_number, i_eg_trx_uuid, i_eg_desig_uuid)
go

alter table c_chat
	add constraint c_public_idx unique nonclustered (c_public, c_chat_id)
go

alter table t_sprint
	add constraint t_sprint_proj_idx unique nonclustered (t_project_id, t_sprint_id)
go

alter table t_sprint_time
	add constraint t_time_sprint_idx unique nonclustered (t_sprint_id, t_time_id)
go

alter table t_sprint_time
	add constraint t_time_proj_idx unique nonclustered (t_project_id, t_sprint_id, t_time_id)
go

alter table t_task
	add constraint t_task_sprint_idx unique nonclustered (t_sprint_id, t_task_id)
go

alter table t_task
	add constraint t_task_proj_idx unique nonclustered (t_project_id, t_sprint_id, t_task_id)
go

alter table s_request
	add constraint s_objkey12_idx unique nonclustered (s_object_key_1, s_object_key_2, s_request_id)
go

alter table s_request
	add constraint s_objkey21_idx unique nonclustered (s_object_key_2, s_object_key_1, s_request_id)
go

alter table s_audit
	add constraint s_audit_name_idx unique nonclustered (s_table, s_key, s_attrname, s_sequence)
go

alter table s_audit
	add constraint s_audit_strval_idx unique nonclustered (s_table, s_attrname, s_valuestring, s_key, s_sequence)
go

alter table s_audit
	add constraint s_audit_intval_idx unique nonclustered (s_table, s_attrname, s_valueint, s_key, s_sequence)
go
