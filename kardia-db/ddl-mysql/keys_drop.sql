use Kardia_DB;



alter table p_partner
	drop primary key;


alter table p_partner
	drop index p_given_name_idx;


alter table p_partner
	drop index p_surname_clustered_idx;


alter table p_partner
	drop index p_org_name_idx;


alter table p_partner
	drop index p_legacy_key_1_idx;


alter table p_partner
	drop index p_legacy_key_2_idx;


alter table p_partner
	drop index p_parent_key_idx;


alter table p_partner
	drop index p_fund_idx;


alter table p_partner
	drop index p_merged_with_idx;


alter table p_partner_key_cnt
	drop primary key;


alter table p_person
	drop primary key;


alter table p_location
	drop primary key;


alter table p_location
	drop index p_postal_sort_clustered_idx;


alter table p_location
	drop index p_location_state_idx;


alter table p_location
	drop index p_location_zip_idx;


alter table p_location
	drop index p_location_city_idx;


alter table p_address_format
	drop primary key;


alter table p_address_format_set
	drop primary key;


alter table p_contact_info
	drop primary key;


alter table p_contact_info
	drop index p_contact_idx;


alter table p_contact_usage
	drop primary key;


alter table p_partner_relationship
	drop primary key;


alter table p_church
	drop primary key;


alter table p_donor
	drop primary key;


alter table p_payee
	drop primary key;


alter table p_staff
	drop primary key;


alter table p_staff
	drop index p_staff_login_idx;


alter table p_staff
	drop index p_staff_weblogin_idx;


alter table p_banking_details
	drop primary key;


alter table p_banking_details
	drop index p_bankd_partner_idx;


alter table p_banking_details
	drop index p_bankd_bpartner_idx;


alter table p_banking_details
	drop index p_bankd_acct_idx;


alter table p_contact_usage_type
	drop primary key;


alter table p_partner_relationship_type
	drop primary key;


alter table p_bulk_postal_code
	drop primary key;


alter table p_zipranges
	drop primary key;


alter table p_country
	drop primary key;


alter table p_pol_division
	drop primary key;


alter table p_banking_type
	drop primary key;


alter table p_title
	drop primary key;


alter table p_gazetteer
	drop primary key;


alter table p_gazetteer
	drop index p_gaz_altid_idx;


alter table p_gazetteer
	drop index p_gaz_state_idx;


alter table p_gazetteer
	drop index p_gaz_name_clustered_idx;


alter table p_acquisition_code
	drop primary key;


alter table p_partner_sort_tmp
	drop primary key;


alter table p_partner_search
	drop primary key;


alter table p_partner_search_stage
	drop primary key;


alter table p_partner_search_results
	drop primary key;


alter table p_search_stage_criteria
	drop primary key;


alter table p_dup_check_tmp
	drop primary key;


alter table p_nondup
	drop primary key;


alter table p_dup
	drop primary key;


alter table p_merge
	drop primary key;


alter table p_notification
	drop primary key;


alter table p_notification
	drop index p_notify_recip_idx;


alter table p_notification
	drop index p_notify_source_idx;


alter table p_notification
	drop index p_notify_type_idx;


alter table p_notification_type
	drop primary key;


alter table p_notification_method
	drop primary key;


alter table p_notification_pref
	drop primary key;


alter table m_list
	drop primary key;


alter table m_list_membership
	drop primary key;


alter table m_list_document
	drop primary key;


alter table e_contact_autorecord
	drop primary key;


alter table e_contact_history_type
	drop primary key;


alter table e_contact_history
	drop primary key;


alter table e_contact_history
	drop index e_cnt_hist_type_idx;


alter table e_contact_history
	drop index e_cnt_hist_par_idx;


alter table e_contact_history
	drop index e_cnt_hist_locpar_idx;


alter table e_contact_history
	drop index e_cnt_hist_whom_idx;


alter table e_engagement_track
	drop primary key;


alter table e_engagement_track
	drop index e_trk_name_idx;


alter table e_engagement_track_collab
	drop primary key;


alter table e_engagement_step
	drop primary key;


alter table e_engagement_step
	drop index e_step_name_idx;


alter table e_engagement_step_collab
	drop primary key;


alter table e_engagement_step_req
	drop primary key;


alter table e_partner_engagement
	drop primary key;


alter table e_partner_engagement
	drop index e_pareng_trackstep_idx;


alter table e_partner_engagement
	drop index e_pareng_start_idx;


alter table e_partner_engagement_req
	drop primary key;


alter table e_tag_type
	drop primary key;


alter table e_tag_type_relationship
	drop primary key;


alter table e_tag
	drop primary key;


alter table e_tag_activity
	drop primary key;


alter table e_tag_activity
	drop index e_tagact_tagid_idx;


alter table e_tag_activity
	drop index e_tagact_ptnr_idx;


alter table e_tag_source
	drop primary key;


alter table e_document_type
	drop primary key;


alter table e_document_type
	drop index e_doctype_parent_idx;


alter table e_document_type
	drop index e_doctype_label_idx;


alter table e_document
	drop primary key;


alter table e_document
	drop index e_doc_work_idx;


alter table e_document
	drop index e_doc_type_idx;


alter table e_document
	drop index e_doc_curpath_idx;


alter table e_document_comment
	drop primary key;


alter table e_document_comment
	drop index e_doccom_collab_idx;


alter table e_document_comment
	drop index e_doccom_tgtcollab_idx;


alter table e_document_comment
	drop index e_doccom_work_idx;


alter table e_partner_document
	drop primary key;


alter table e_text_expansion
	drop primary key;


alter table e_workflow_type
	drop primary key;


alter table e_workflow_type_step
	drop primary key;


alter table e_workflow_type_step
	drop index e_workstep_type_idx;


alter table e_workflow_type_step
	drop index e_workstep_trig_idx;


alter table e_workflow
	drop primary key;


alter table e_workflow
	drop index e_workinst_type_idx;


alter table e_workflow
	drop index e_workinst_trig_idx;


alter table e_workflow
	drop index e_workinst_steptrig_idx;


alter table e_collaborator_type
	drop primary key;


alter table e_collaborator
	drop primary key;


alter table e_collaborator
	drop index e_collab_type_idx;


alter table e_todo_type
	drop primary key;


alter table e_todo
	drop primary key;


alter table e_todo
	drop index e_todo_type_idx;


alter table e_todo
	drop index e_todo_collab_idx;


alter table e_todo
	drop index e_todo_par_idx;


alter table e_todo
	drop index e_todo_eng_idx;


alter table e_todo
	drop index e_todo_doc_idx;


alter table e_todo
	drop index e_todo_reqitem_idx;


alter table e_data_item_type
	drop primary key;


alter table e_data_item_type
	drop index e_ditype_parent_idx;


alter table e_data_item_type_value
	drop primary key;


alter table e_data_item_group
	drop primary key;


alter table e_data_item_group
	drop index e_digrp_type_idx;


alter table e_data_item
	drop primary key;


alter table e_data_item
	drop index e_dataitem_type_idx;


alter table e_data_item
	drop index e_dataitem_group_idx;


alter table e_highlights
	drop primary key;


alter table e_highlights
	drop index e_h_nt_idx;


alter table e_data_highlight
	drop primary key;


alter table e_activity
	drop primary key;


alter table e_activity
	drop index e_act_type_idx;


alter table e_activity
	drop index e_act_par_idx;


alter table e_activity
	drop index e_act_sort_idx;


alter table e_trackactivity
	drop primary key;


alter table e_ack
	drop primary key;


alter table e_ack
	drop index e_ack_obj_idx;


alter table e_ack
	drop index e_ack_par_idx;


alter table e_ack
	drop index e_ack_par2_idx;


alter table e_ack
	drop index e_ack_par3_idx;


alter table e_ack_type
	drop primary key;


alter table e_text_search_word
	drop primary key;


alter table e_text_search_word
	drop index e_tsw_word_idx;


alter table e_text_search_rel
	drop primary key;


alter table e_text_search_occur
	drop primary key;


alter table h_staff
	drop primary key;


alter table h_group
	drop primary key;


alter table h_group_member
	drop primary key;


alter table h_holidays
	drop primary key;


alter table h_work_register
	drop primary key;


alter table h_work_register
	drop index h_workreg_ben_idx;


alter table h_work_register_times
	drop primary key;


alter table h_benefit_period
	drop primary key;


alter table h_benefit_type
	drop primary key;


alter table h_benefit_type_sched
	drop primary key;


alter table h_benefit_type_sched
	drop index h_bts_partner_idx;


alter table h_benefit_type_sched
	drop index h_bts_group_idx;


alter table h_benefits
	drop primary key;


alter table r_group_sched
	drop primary key;


alter table r_group_sched_param
	drop primary key;


alter table r_group_sched_report
	drop primary key;


alter table r_group
	drop primary key;


alter table r_group
	drop index r_grp_modfile_idx;


alter table r_group_report
	drop primary key;


alter table r_group_param
	drop primary key;


alter table r_group_param
	drop index r_param_cmp_idx;


alter table r_group_report_param
	drop primary key;


alter table r_saved_paramset
	drop primary key;


alter table r_saved_paramset
	drop index r_ps_modfile_idx;


alter table r_saved_param
	drop primary key;


alter table a_config
	drop primary key;


alter table a_analysis_attr
	drop primary key;


alter table a_analysis_attr_value
	drop primary key;


alter table a_fund_analysis_attr
	drop primary key;


alter table a_acct_analysis_attr
	drop primary key;


alter table a_fund
	drop primary key;


alter table a_fund
	drop index a_fund_parent_idx;


alter table a_fund
	drop index a_fund_legacy_idx;


alter table a_fund
	drop index a_fund_bal_idx;


alter table a_account
	drop primary key;


alter table a_account
	drop index a_acct_parent_idx;


alter table a_account
	drop index a_acct_legacy_idx;


alter table a_account_usage
	drop primary key;


alter table a_account_usage_type
	drop primary key;


alter table a_account_category
	drop primary key;


alter table a_fund_acct
	drop primary key;


alter table a_period
	drop primary key;


alter table a_period_usage
	drop primary key;


alter table a_period_usage_type
	drop primary key;


alter table a_ledger
	drop primary key;


alter table a_batch
	drop primary key;


alter table a_transaction
	drop primary key;


alter table a_transaction
	drop index a_trx_fund_clustered_idx;


alter table a_transaction
	drop index a_trx_donor_id_idx;


alter table a_transaction
	drop index a_trx_recip_id_idx;


alter table a_transaction_tmp
	drop primary key;


alter table a_transaction_tmp
	drop index a_trxt_fund_clustered_idx;


alter table a_transaction_tmp
	drop index a_trxt_donor_id_idx;


alter table a_transaction_tmp
	drop index a_trxt_recip_id_idx;


alter table a_account_class
	drop primary key;


alter table a_fund_class
	drop primary key;


alter table a_reporting_level
	drop primary key;


alter table a_fund_prefix
	drop primary key;


alter table a_fund_staff
	drop primary key;


alter table a_ledger_office
	drop primary key;


alter table a_currency
	drop primary key;


alter table a_currency_exch_rate
	drop primary key;


alter table a_bank_recon
	drop primary key;


alter table a_bank_recon_item
	drop primary key;


alter table a_bank_recon_accts
	drop primary key;


alter table a_dimension
	drop primary key;


alter table a_dimension
	drop index a_dim_legacy_idx;


alter table a_dimension
	drop index a_dim_fund_idx;


alter table a_dimension
	drop index a_dim_fund_class_idx;


alter table a_dimension_item
	drop primary key;


alter table a_dimension_item
	drop index a_dim_item_legacy_idx;


alter table a_dimension_item
	drop index a_dim_item_fund_idx;


alter table a_dimension_item
	drop index a_dim_item_fund_class_idx;


alter table a_payroll
	drop primary key;


alter table a_payroll_period
	drop primary key;


alter table a_payroll_period
	drop index a_payperiod_idx;


alter table a_payroll_period_payee
	drop primary key;


alter table a_payroll_group
	drop primary key;


alter table a_payroll_import
	drop primary key;


alter table a_payroll_import
	drop index a_payrolli_payee_idx;


alter table a_payroll_import
	drop index a_payrolli_fund_idx;


alter table a_payroll_item
	drop primary key;


alter table a_payroll_item_import
	drop primary key;


alter table a_payroll_item_type
	drop primary key;


alter table a_payroll_item_class
	drop primary key;


alter table a_payroll_item_subclass
	drop primary key;


alter table a_payroll_form_group
	drop primary key;


alter table a_tax_filingstatus
	drop primary key;


alter table a_tax_table
	drop primary key;


alter table a_tax_allowance_table
	drop primary key;


alter table a_salary_review
	drop primary key;


alter table a_fund_admin_fee
	drop primary key;


alter table a_admin_fee_type
	drop primary key;


alter table a_admin_fee_type_tmp
	drop primary key;


alter table a_admin_fee_type_item
	drop primary key;


alter table a_admin_fee_type_item_tmp
	drop primary key;


alter table a_fund_receipting
	drop primary key;


alter table a_fund_receipting_accts
	drop primary key;


alter table a_receipt_type
	drop primary key;


alter table a_gift_payment_type
	drop primary key;


alter table a_receipt_mailing
	drop primary key;


alter table a_subtrx_gift
	drop primary key;


alter table a_subtrx_gift
	drop index a_gifttrx_fund_clustered_idx;


alter table a_subtrx_gift
	drop index a_gifttrx_donor_id_idx;


alter table a_subtrx_gift
	drop index a_gifttrx_recip_id_idx;


alter table a_subtrx_gift_group
	drop primary key;


alter table a_subtrx_gift_group
	drop index a_gifttrxgrp_donor_id_idx;


alter table a_subtrx_gift_group
	drop index a_gifttrxgrp_ack_id_idx;


alter table a_subtrx_gift_group
	drop index a_gifttrxgrp_pass_id_idx;


alter table a_subtrx_gift_item
	drop primary key;


alter table a_subtrx_gift_item
	drop index a_gifttrxi_fund_clustered_idx;


alter table a_subtrx_gift_item
	drop index a_gifttrxi_recip_id_idx;


alter table a_subtrx_gift_item
	drop index a_gifttrxi_mcode_idx;


alter table a_subtrx_gift_item
	drop index a_gifttrxi_donor_idx;


alter table a_subtrx_gift_item
	drop index a_gifttrxi_ack_idx;


alter table a_subtrx_gift_item
	drop index a_gifttrxi_pass_idx;


alter table a_subtrx_gift_item
	drop index a_gifttrxi_rcpt_idx;


alter table a_subtrx_gift_item
	drop index a_gifttrxi_src_idx;


alter table a_subtrx_gift_item
	drop index a_gifttrxi_datetype_idx;


alter table a_subtrx_gift_item
	drop index a_gifttrxi_hash_idx;


alter table a_subtrx_gift_intent
	drop primary key;


alter table a_subtrx_gift_rcptcnt
	drop primary key;


alter table a_fund_auto_subscribe
	drop primary key;


alter table a_motivational_code
	drop primary key;


alter table a_motivational_code
	drop index a_motiv_code_list;


alter table a_giving_pattern
	drop primary key;


alter table a_giving_pattern
	drop index a_givingp_review_idx;


alter table a_giving_pattern
	drop index a_givingp_actual_idx;


alter table a_giving_pattern_allocation
	drop primary key;


alter table a_giving_pattern_allocation
	drop index a_givingpa_review_idx;


alter table a_giving_pattern_allocation
	drop index a_givingpa_actual_idx;


alter table a_giving_pattern_flag
	drop primary key;


alter table a_giving_pattern_flag
	drop index a_givingf_review_idx;


alter table a_funding_target
	drop primary key;


alter table a_support_review
	drop primary key;


alter table a_support_review_target
	drop primary key;


alter table a_descriptives
	drop primary key;


alter table a_descriptives_hist
	drop primary key;


alter table a_pledge
	drop primary key;


alter table a_intent_type
	drop primary key;


alter table a_subtrx_cashdisb
	drop primary key;


alter table a_subtrx_cashdisb
	drop index a_subtrx_cashdisb_acct_idx;


alter table a_subtrx_payable
	drop primary key;


alter table a_subtrx_payable_item
	drop primary key;


alter table a_subtrx_xfer
	drop primary key;


alter table a_subtrx_deposit
	drop primary key;


alter table a_subtrx_deposit
	drop index a_subtrx_dep_acct_idx;


alter table a_subtrx_cashxfer
	drop primary key;


alter table a_subtrx_cashxfer
	drop index a_subtrx_cxf_fund_clustered_idx;


alter table i_eg_gift_import
	drop primary key;


alter table i_eg_gift_import
	drop index i_eg_kdonor_idx;


alter table i_eg_gift_import
	drop index i_eg_edonor_idx;


alter table i_eg_gift_import
	drop index i_eg_kfund_idx;


alter table i_eg_gift_import
	drop index i_eg_egift_idx;


alter table i_eg_gift_import
	drop index i_eg_edeposit_idx;


alter table i_eg_gift_import
	drop index i_eg_kgiftbatch_idx;


alter table i_eg_gift_import
	drop index i_eg_kfeebatch_idx;


alter table i_eg_gift_import
	drop index i_eg_kdepbatch_idx;


alter table i_eg_gift_import
	drop index i_eg_stats_idx;


alter table i_eg_gift_import
	drop index i_eg_postproc_idx;


alter table i_eg_gift_trx_fees
	drop primary key;


alter table i_eg_giving_url
	drop primary key;


alter table i_crm_partner_import
	drop primary key;


alter table i_crm_partner_import_option
	drop primary key;


alter table i_crm_import_type
	drop primary key;


alter table i_crm_import_type_option
	drop primary key;


alter table i_disb_import_classify
	drop primary key;


alter table i_disb_import_status
	drop primary key;


alter table c_message
	drop primary key;


alter table c_chat
	drop primary key;


alter table c_chat
	drop index c_public_idx;


alter table c_member
	drop primary key;


alter table t_project
	drop primary key;


alter table t_project
	drop index t_parent_idx;


alter table t_sprint
	drop primary key;


alter table t_sprint
	drop index t_sprint_idx;


alter table t_sprint_project
	drop primary key;


alter table t_sprint_time
	drop primary key;


alter table t_sprint_time
	drop index t_time_sprint_idx;


alter table t_sprint_time
	drop index t_time_proj_idx;


alter table t_task
	drop primary key;


alter table t_task
	drop index t_task_sprint_idx;


alter table t_task
	drop index t_task_proj_idx;


alter table t_participant
	drop primary key;


alter table t_sprint_participant
	drop primary key;


alter table t_assignee
	drop primary key;


alter table t_task_state
	drop primary key;


alter table t_task_history
	drop primary key;


alter table s_config
	drop primary key;


alter table s_user_data
	drop primary key;


alter table s_user_loginhistory
	drop primary key;


alter table s_subsystem
	drop primary key;


alter table s_process
	drop primary key;


alter table s_process_status
	drop primary key;


alter table s_motd
	drop primary key;


alter table s_motd_viewed
	drop primary key;


alter table s_sec_endorsement
	drop primary key;


alter table s_sec_endorsement_type
	drop primary key;


alter table s_sec_endorsement_context
	drop primary key;


alter table s_mykardia
	drop primary key;


alter table s_request
	drop primary key;


alter table s_request
	drop index s_objkey12_idx;


alter table s_request
	drop index s_objkey21_idx;


alter table s_request_type
	drop primary key;


alter table s_audit
	drop primary key;


alter table s_audit
	drop index s_audit_name_idx;


alter table s_audit
	drop index s_audit_strval_idx;


alter table s_audit
	drop index s_audit_intval_idx;


alter table s_role
	drop primary key;


alter table s_role_exclusivity
	drop primary key;


alter table s_user_role
	drop primary key;


alter table s_global_search
	drop primary key;


alter table s_stats_cache
	drop primary key;


alter table s_document_scanner
	drop primary key;
