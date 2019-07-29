use Kardia_DB;


alter table p_partner
	add constraint p_partner_pk primary key  (p_partner_key);

alter table p_partner
	add constraint p_surname_clustered_idx unique  (p_surname, p_given_name, p_org_name, p_partner_key);

alter table p_partner_key_cnt
	add constraint p_partner_key_cnt_pk primary key  (p_partner_key);

alter table p_person
	add constraint p_person_clustered_pk primary key  (p_partner_key);

alter table p_location
	add constraint p_location_pk primary key  (p_partner_key, p_location_id, p_revision_id);

alter table p_location
	add constraint p_postal_sort_clustered_idx unique  (p_country_code, p_bulk_postal_code, p_postal_code, p_partner_key, p_location_id, p_revision_id);

alter table p_address_format
	add constraint p_af_pk primary key  (p_address_set, p_country_code);

alter table p_address_format_set
	add constraint p_afs_pk primary key  (p_address_set);

alter table p_contact_info
	add constraint p_contact_info_pk primary key  (p_partner_key, p_contact_id);

alter table p_contact_usage
	add constraint p_contact_usg_pk primary key  (p_partner_key, p_contact_usage_type_code, p_contact_or_location, p_contact_location_id);

alter table p_contact_usage_type
	add constraint p_contact_ut_pk primary key  (p_contact_usage_type_code);

alter table p_partner_relationship
	add constraint p_partner_relationship_pk primary key  (p_partner_key, p_relation_type, p_relation_key);

alter table p_partner_relationship_type
	add constraint p_relat_type_pk primary key  (p_relation_type);

alter table p_church
	add constraint p_church_pk primary key  (p_partner_key);

alter table p_donor
	add constraint p_donor_pk primary key  (p_partner_key, a_gl_ledger_number);

alter table p_payee
	add constraint p_payee_pk primary key  (p_partner_key, a_gl_ledger_number);

alter table p_staff
	add constraint p_staff_pk primary key  (p_partner_key);

alter table p_bulk_postal_code
	add constraint p_bulk_code_pk primary key  (p_country_code,p_bulk_postal_code,p_bulk_code);

alter table p_zipranges
	add constraint p_bulk_code_pk primary key  (p_first_zip,p_last_zip);

alter table p_country
	add constraint p_country_code_pk primary key  (p_country_code);

alter table p_pol_division
	add constraint p_poldiv_pk primary key  (p_country_code, p_pol_division);

alter table p_banking_details
	add constraint p_banking_details_pk primary key  (p_banking_details_key);

alter table p_banking_type
	add constraint p_banking_type_pk primary key  (p_banking_type);

alter table p_title
	add constraint p_title_pk primary key  (p_title);

alter table p_gazetteer
	add constraint p_gazetteer_pk primary key  (p_country_code, p_feature_type, p_feature_id);

alter table p_gazetteer
	add constraint p_gaz_name_clustered_idx unique  (p_feature_name, p_country_code, p_feature_type, p_feature_id);

alter table p_dup_check_tmp
	add constraint p_dupcheck_pk primary key  (p_partner_key,s_username);

alter table p_partner_sort_tmp
	add constraint p_sort_pk primary key  (p_partner_key,s_username,p_sort_session_id);

alter table p_acquisition_code
	add constraint p_acqcode_pk primary key  (p_acquisition_code);

alter table p_partner_search
	add constraint p_search_pk primary key  (p_search_id);

alter table p_partner_search_stage
	add constraint p_searchstage_pk primary key  (p_search_id,p_search_stage_id);

alter table p_partner_search_results
	add constraint p_searchres_pk primary key  (p_partner_key,s_username,p_search_session_id,p_search_stage_id);

alter table p_search_stage_criteria
	add constraint p_stage_criteria_pk primary key  (p_search_id,p_search_stage_id,p_criteria_name);

alter table m_list
	add constraint m_list_pk primary key  (m_list_code);

alter table m_list_membership
	add constraint m_list_membership_clustered_pk primary key  (m_list_code, p_partner_key, m_hist_id);

alter table e_contact_autorecord
	add constraint e_autorec_pk primary key  (p_partner_key, e_collaborator_id, e_contact_history_type, e_contact_id);

alter table e_contact_history_type
	add constraint e_cnt_hist_type_pk primary key  (e_contact_history_type);

alter table e_contact_history
	add constraint e_cnt_hist_pk primary key  (e_contact_history_id);

alter table e_activity
	add constraint e_act_pk primary key  (e_activity_group_id, e_activity_id);

alter table e_engagement_track
	add constraint e_trk_pk primary key  (e_track_id);

alter table e_engagement_track_collab
	add constraint e_trkcoll_pk primary key  (e_track_id, p_collab_partner_key);

alter table e_engagement_step
	add constraint e_step_pk primary key  (e_track_id, e_step_id);

alter table e_engagement_step_collab
	add constraint e_stepcoll_pk primary key  (e_track_id, e_step_id, p_collab_partner_key);

alter table e_engagement_step_req
	add constraint e_req_pk primary key  (e_track_id, e_step_id, e_req_id);

alter table e_partner_engagement
	add constraint e_pareng_pk primary key  (p_partner_key, e_engagement_id, e_hist_id);

alter table e_partner_engagement_req
	add constraint e_parreq_pk primary key  (p_partner_key, e_engagement_id, e_hist_id, e_req_item_id);

alter table e_tag_type
	add constraint e_tagtype_pk primary key  (e_tag_id);

alter table e_tag_type_relationship
	add constraint e_tagtyperel_pk primary key  (e_tag_id, e_rel_tag_id);

alter table e_tag
	add constraint e_tag_pk primary key  (e_tag_id, p_partner_key);

alter table e_tag_activity
	add constraint e_tagact_pk primary key  (e_tag_activity_group, e_tag_activity_id);

alter table e_tag_source
	add constraint e_tagsrc_pk primary key  (e_tag_id, e_tag_source_type, e_tag_source_key);

alter table e_document_type
	add constraint e_doctype_pk primary key  (e_doc_type_id);

alter table e_document
	add constraint e_doc_pk primary key  (e_document_id);

alter table e_document_comment
	add constraint e_doccom_pk primary key  (e_document_id, e_doc_comment_id);

alter table e_partner_document
	add constraint e_pardoc_pk primary key  (e_document_id, p_partner_key, e_pardoc_assoc_id);

alter table e_workflow_type
	add constraint e_work_pk primary key  (e_workflow_id);

alter table e_workflow_type_step
	add constraint e_workstep_pk primary key  (e_workflow_step_id);

alter table e_workflow
	add constraint e_workinst_pk primary key  (e_workflow_instance_id);

alter table e_collaborator_type
	add constraint e_collabtype_pk primary key  (e_collab_type_id);

alter table e_collaborator
	add constraint e_collab_pk primary key  (e_collaborator, p_partner_key);

alter table e_todo_type
	add constraint e_todotype_pk primary key  (e_todo_type_id);

alter table e_todo
	add constraint e_todo_pk primary key  (e_todo_id);

alter table e_data_item_type
	add constraint e_ditype_pk primary key  (e_data_item_type_id);

alter table e_data_item_group
	add constraint e_digrp_pk primary key  (e_data_item_group_id);

alter table e_data_item
	add constraint e_dataitem_pk primary key  (e_data_item_id);

alter table e_highlights
	add constraint e_h_pk primary key  (e_highlight_user, e_highlight_partner, e_highlight_id);

alter table e_data_highlight
	add constraint e_dh_pk primary key  (e_highlight_subject, e_highlight_object_type, e_highlight_object_id);

alter table e_ack
	add constraint e_ack_pk primary key  (e_ack_id);

alter table e_ack_type
	add constraint e_ackt_pk primary key  (e_ack_type);

alter table e_trackactivity
	add constraint e_trkact_pk primary key  (p_partner_key,e_username,e_sort_key);

alter table e_text_expansion
	add constraint e_exp_pk primary key  (e_exp_tag);

alter table e_text_search_word
	add constraint e_tsw_pk primary key  (e_word_id);

alter table e_text_search_rel
	add constraint e_tsr_pk primary key  (e_word_id, e_target_word_id);

alter table e_text_search_occur
	add constraint e_tso_pk primary key  (e_word_id, e_document_id, e_sequence);

alter table h_staff
	add constraint h_staff_pk primary key  (p_partner_key);

alter table h_group
	add constraint h_group_pk primary key  (h_group_id);

alter table h_group_member
	add constraint h_groupm_pk primary key  (h_group_id, p_partner_key);

alter table h_holidays
	add constraint h_holiday_pk primary key  (h_holiday_id);

alter table h_work_register
	add constraint h_workreg_pk primary key  (p_partner_key, h_work_register_id);

alter table h_work_register_times
	add constraint h_workregt_pk primary key  (p_partner_key, h_work_register_time_id);

alter table h_benefit_period
	add constraint h_benper_pk primary key  (h_benefit_period_id);

alter table h_benefit_type
	add constraint h_bentype_pk primary key  (h_benefit_type_id);

alter table h_benefit_type_sched
	add constraint h_bentypesch_pk primary key  (h_benefit_type_id, h_benefit_type_sched_id);

alter table h_benefits
	add constraint h_ben_pk primary key  (h_benefit_type_id, p_partner_key, h_benefit_period_id);

alter table r_group
	add constraint r_grp_pk primary key  (r_group_name);

alter table r_group_report
	add constraint r_rpt_pk primary key  (r_group_name, r_delivery_method, p_recipient_partner_key, r_report_id);

alter table r_group_param
	add constraint r_param_pk primary key  (r_group_name, r_param_name);

alter table r_group_report_param
	add constraint r_rparam_pk primary key  (r_group_name, r_delivery_method, p_recipient_partner_key, r_report_id, r_param_name);

alter table r_saved_paramset
	add constraint r_ps_pk primary key  (r_paramset_id);

alter table r_saved_param
	add constraint r_psparam_pk primary key  (r_paramset_id, r_param_name);

alter table a_config
	add constraint a_config_pk primary key  (a_ledger_number, a_config_name);

alter table a_analysis_attr
	add constraint a_an_attr_pk primary key  (a_ledger_number, a_attr_code);

alter table a_analysis_attr_value
	add constraint a_an_attr_val_pk primary key  (a_ledger_number, a_attr_code, a_value);

alter table a_cc_analysis_attr
	add constraint a_cc_an_attr_pk primary key  (a_ledger_number, a_attr_code, a_cost_center);

alter table a_acct_analysis_attr
	add constraint a_acct_an_attr_pk primary key  (a_ledger_number, a_attr_code, a_account_code);

alter table a_cost_center
	add constraint a_cost_center_pk primary key  (a_cost_center, a_ledger_number);

alter table a_account
	add constraint a_account_pk primary key  (a_account_code, a_ledger_number);

alter table a_account_usage
	add constraint a_account_usage_pk primary key  (a_acct_usage_code, a_ledger_number, a_account_code);

alter table a_account_usage_type
	add constraint a_account_usage_type_pk primary key  (a_acct_usage_code);

alter table a_account_category
	add constraint a_account_category_pk primary key  (a_account_category, a_ledger_number);

alter table a_cc_acct
	add constraint a_cc_acct_pk primary key  (a_ledger_number, a_period, a_cost_center, a_account_code);

alter table a_period
	add constraint a_period_pk primary key  (a_period, a_ledger_number);

alter table a_period_usage
	add constraint a_account_usage_pk primary key  (a_period_usage_code, a_ledger_number, a_period);

alter table a_period_usage_type
	add constraint a_period_usage_type_pk primary key  (a_period_usage_code);

alter table a_ledger
	add constraint a_ledger_pk primary key  (a_ledger_number);

alter table a_batch
	add constraint a_batch_pk primary key  (a_batch_number, a_ledger_number);

alter table a_transaction
	add constraint a_transaction_pk primary key  (a_ledger_number, a_batch_number, a_journal_number, a_transaction_number);

alter table a_transaction
	add constraint a_trx_cc_clustered_idx unique  (a_cost_center, a_account_code, a_ledger_number, a_batch_number, a_journal_number, a_transaction_number);

alter table a_transaction_tmp
	add constraint a_transaction_tmp_pk primary key  (a_ledger_number, a_batch_number, a_journal_number, a_transaction_number);

alter table a_transaction_tmp
	add constraint a_trxt_cc_clustered_idx unique  (a_cost_center, a_account_code, a_ledger_number, a_batch_number, a_journal_number, a_transaction_number);

alter table a_account_class
	add constraint a_account_class_pk primary key  (a_account_class, a_ledger_number);

alter table a_cost_center_class
	add constraint a_costctr_class_pk primary key  (a_cost_center_class, a_ledger_number);

alter table a_reporting_level
	add constraint a_level_pk primary key  (a_reporting_level, a_ledger_number);

alter table a_cost_center_prefix
	add constraint a_cost_center_prefix_pk primary key  (a_cost_center_prefix, a_ledger_number);

alter table a_cc_staff
	add constraint a_cc_staff_pk primary key  (a_ledger_number, a_cost_center, p_staff_partner_key);

alter table a_ledger_office
	add constraint a_lo_pk primary key  (a_ledger_number, p_office_partner_key);

alter table a_payroll
	add constraint a_payroll_pk primary key  (a_ledger_number, a_payroll_group_id, a_payroll_id);

alter table a_payroll_period
	add constraint a_payperiod_pk primary key  (a_ledger_number, a_payroll_group_id, a_payroll_period);

alter table a_payroll_group
	add constraint a_payroll_grp_pk primary key  (a_ledger_number, a_payroll_group_id);

alter table a_payroll_import
	add constraint a_payrolli_pk primary key  (a_payroll_id);

alter table a_payroll_item
	add constraint a_payroll_i_pk primary key  (a_ledger_number, a_payroll_group_id, a_payroll_id, a_payroll_item_id);

alter table a_payroll_item_import
	add constraint a_payrolli_i_pk primary key  (a_payroll_id, a_payroll_item_id);

alter table a_payroll_item_type
	add constraint a_payroll_it_pk primary key  (a_ledger_number, a_payroll_item_type_code);

alter table a_payroll_item_class
	add constraint a_payroll_ic_pk primary key  (a_payroll_item_class_code);

alter table a_payroll_form_group
	add constraint a_payroll_f_pk primary key  (a_ledger_number, a_payroll_form_group_name, a_payroll_form_sequence);

alter table a_tax_filingstatus
	add constraint a_filingstatus_pk primary key  (a_ledger_number, a_payroll_item_type_code, a_filing_status);

alter table a_tax_table
	add constraint a_taxtable_pk primary key  (a_tax_entry_id);

alter table a_tax_allowance_table
	add constraint a_taxalltable_pk primary key  (a_tax_allowance_entry_id);

alter table a_salary_review
	add constraint a_salreview_pk primary key  (a_ledger_number, a_payroll_id, a_review);

alter table a_cc_admin_fee
	add constraint a_cc_admin_fee_pk primary key  (a_cost_center, a_ledger_number);

alter table a_admin_fee_type
	add constraint a_admin_fee_type_pk primary key  (a_ledger_number, a_admin_fee_type, a_admin_fee_subtype);

alter table a_admin_fee_type_tmp
	add constraint a_admin_fee_type_tmp_pk primary key  (a_ledger_number, a_admin_fee_type, a_admin_fee_subtype);

alter table a_admin_fee_type_item
	add constraint a_admin_fee_type_item_pk primary key  (a_ledger_number, a_admin_fee_type, a_admin_fee_subtype, a_dest_cost_center);

alter table a_admin_fee_type_item_tmp
	add constraint a_admin_fee_type_item_tmp_pk primary key  (a_ledger_number, a_admin_fee_type, a_admin_fee_subtype, a_dest_cost_center);

alter table a_cc_receipting
	add constraint a_cc_receipting_pk primary key  (a_cost_center, a_ledger_number);

alter table a_cc_receipting_accts
	add constraint a_cc_rcptacct_pk primary key  (a_cost_center, a_ledger_number,a_account_code);

alter table a_receipt_type
	add constraint a_rcpttype_pk primary key  (a_receipt_type);

alter table a_subtrx_gift
	add constraint a_gifttrx_pk primary key  (a_ledger_number, a_batch_number, a_gift_number);

alter table a_subtrx_gift
	add constraint a_gifttrx_cc_clustered_idx unique  (a_cost_center, a_account_code, a_ledger_number, a_batch_number, a_gift_number);

alter table a_subtrx_gift_group
	add constraint a_gifttrxgrp_pk primary key  (a_ledger_number, a_batch_number, a_gift_number);

alter table a_subtrx_gift_item
	add constraint a_gifttrx_pk primary key  (a_ledger_number, a_batch_number, a_gift_number, a_split_number);

alter table a_subtrx_gift_item
	add constraint a_gifttrxi_cc_clustered_idx unique  (a_cost_center, a_account_code, a_ledger_number, a_batch_number, a_gift_number, a_split_number);

alter table a_subtrx_gift_rcptcnt
	add constraint a_rcptno_pk primary key  (a_ledger_number);

alter table a_cc_auto_subscribe
	add constraint a_cc_auto_subscribe_pk primary key  (a_cost_center, a_ledger_number, m_list_code);

alter table a_motivational_code
	add constraint a_motivational_code_pk primary key  (a_ledger_number, a_motivational_code);

alter table a_giving_pattern
	add constraint a_givingp_pk primary key  (a_ledger_number, p_donor_partner_key, a_cost_center, a_pattern_id, a_history_id);

alter table a_giving_pattern_allocation
	add constraint a_givingpa_pk primary key  (a_ledger_number, p_donor_partner_key, a_cost_center, a_pattern_id, a_history_id);

alter table a_giving_pattern_flag
	add constraint a_givingf_pk primary key  (a_ledger_number, p_donor_partner_key, a_cost_center, a_pattern_id, a_history_id);

alter table a_funding_target
	add constraint a_target_pk primary key  (a_ledger_number, a_cost_center, a_target_id);

alter table a_support_review
	add constraint a_supportreview_pk primary key  (a_ledger_number, a_review);

alter table a_support_review_target
	add constraint a_supptgt_pk primary key  (a_ledger_number, a_cost_center, a_target_id, a_review);

alter table a_descriptives
	add constraint a_descr_pk primary key  (a_ledger_number, p_donor_partner_key, a_cost_center);

alter table a_descriptives_hist
	add constraint a_descrhist_pk primary key  (a_ledger_number, p_donor_partner_key, a_cost_center, a_hist_id);

alter table a_subtrx_cashdisb
	add constraint a_subtrx_cashdisb_pk primary key  (a_ledger_number, a_batch_number, a_disbursement_id, a_line_item);

alter table a_subtrx_payable
	add constraint a_subtrx_payable_pk primary key  (a_ledger_number, a_payable_id);

alter table a_subtrx_payable_item
	add constraint a_subtrx_payable_item_pk primary key  (a_ledger_number, a_payable_id, a_line_item);

alter table a_subtrx_xfer
	add constraint a_subtrx_xfer_pk primary key  (a_ledger_number, a_batch_number, a_journal_number);

alter table a_subtrx_deposit
	add constraint a_subtrx_deposit_pk primary key  (a_ledger_number, a_batch_number);

alter table a_subtrx_cashxfer
	add constraint a_subtrx_cashxfer_pk primary key  (a_ledger_number, a_batch_number, a_journal_number);

alter table i_eg_gift_import
	add constraint i_eg_gift_import_pk primary key  (a_ledger_number, i_eg_trx_uuid, i_eg_desig_uuid);

alter table i_eg_gift_trx_fees
	add constraint i_eg_gift_trx_fees_pk primary key  (a_ledger_number, i_eg_fees_id);

alter table i_eg_giving_url
	add constraint i_eg_giving_url_pk primary key  (a_ledger_number, a_cost_center);

alter table i_crm_partner_import
	add constraint i_crm_partner_import_pk primary key  (i_crm_import_id, i_crm_import_session_id);

alter table i_crm_partner_import_option
	add constraint i_crm_partner_import_opt_pk primary key  (i_crm_import_id, i_crm_import_session_id, i_crm_import_type_option_id);

alter table i_crm_import_type
	add constraint i_crm_import_type_pk primary key  (i_crm_import_type_id);

alter table i_crm_import_type_option
	add constraint i_crm_import_type_option_pk primary key  (i_crm_import_type_id,i_crm_import_type_option_id);

alter table i_disb_import_classify
	add constraint i_disb_import_pk primary key  (a_ledger_number, i_disb_classify_item);

alter table i_disb_import_status
	add constraint i_disb_legacy_pk primary key  (a_ledger_number, i_disb_legacy_key);

alter table c_message
	add constraint c_message_pk primary key  (c_chat_id, c_message_id);

alter table c_chat
	add constraint c_chat_pk primary key  (c_chat_id);

alter table c_member
	add constraint c_member_pk primary key  (c_chat_id, s_username);

alter table t_project
	add constraint t_project_pk primary key  (t_project_id);

alter table t_sprint
	add constraint t_sprint_pk primary key  (t_sprint_id);

alter table t_sprint_time
	add constraint t_sprint_time_pk primary key  (t_time_id);

alter table t_task
	add constraint t_task_pk primary key  (t_task_id);

alter table t_participant
	add constraint t_participant_pk primary key  (p_partner_key, t_project_id);

alter table t_sprint_participant
	add constraint t_sprint_participant_pk primary key  (p_partner_key, t_sprint_id);

alter table t_assignee
	add constraint t_assignee_pk primary key  (p_partner_key, t_task_id);

alter table t_task_state
	add constraint t_tstate_pk primary key  (t_task_state_id);

alter table t_task_history
	add constraint t_history_pk primary key  (t_task_id, t_history_id);

alter table s_config
	add constraint s_config_pk primary key  (s_config_name);

alter table s_user_data
	add constraint s_user_data_pk primary key  (s_username);

alter table s_user_loginhistory
	add constraint s_loginhist_pk primary key  (s_username, s_sessionid);

alter table s_subsystem
	add constraint s_subsystem_pk primary key  (s_subsystem_code);

alter table s_process
	add constraint s_process_pk primary key  (s_subsystem_code, s_process_code);

alter table s_process_status
	add constraint s_procstat_pk primary key  (s_subsystem_code, s_process_code, s_process_status_code);

alter table s_motd
	add constraint s_motd_pk primary key  (s_motd_id);

alter table s_motd_viewed
	add constraint s_motd_viewed_pk primary key  (s_motd_id, s_username);

alter table s_sec_endorsement
	add constraint s_end_pk primary key  (s_endorsement, s_context, s_subject);

alter table s_sec_endorsement_type
	add constraint s_endt_pk primary key  (s_endorsement);

alter table s_sec_endorsement_context
	add constraint s_endc_pk primary key  (s_context);

alter table s_mykardia
	add constraint s_myk_pk primary key  (s_username, s_module, s_plugin, s_occurrence);

alter table s_request
	add constraint s_req_pk primary key  (s_request_id);

alter table s_request_type
	add constraint s_reqtype_pk primary key  (s_request_type);

alter table s_audit
	add constraint s_audit_pk primary key  (s_sequence);

alter table s_role
	add constraint s_role_pk primary key  (s_role_id);

alter table s_role_exclusivity
	add constraint s_role_ex_pk primary key  (s_role1_id, s_role2_id);

alter table s_user_role
	add constraint s_user_role_pk primary key  (s_role_id, s_username);

alter table s_global_search
	add constraint s_global_search_pk primary key  (s_search_id, s_username, s_search_res_id);

alter table s_stats_cache
	add constraint s_stats_cache_pk primary key  (s_stat_type, s_stat_group, s_stat);
