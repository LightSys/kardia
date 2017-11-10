use Kardia_DB
go



alter table p_partner
	drop constraint p_partner_pk
go


alter table p_partner
	drop constraint p_given_name_idx
go


alter table p_partner
	drop constraint p_surname_clustered_idx
go


alter table p_partner
	drop constraint p_org_name_idx
go


alter table p_partner
	drop constraint p_legacy_key_1_idx
go


alter table p_partner
	drop constraint p_legacy_key_2_idx
go


alter table p_partner
	drop constraint p_parent_key_idx
go


alter table p_partner
	drop constraint p_cost_ctr_idx
go


alter table p_partner
	drop constraint p_merged_with_idx
go


alter table p_partner_key_cnt
	drop constraint p_partner_key_cnt_pk
go


alter table p_person
	drop constraint p_person_clustered_pk
go


alter table p_location
	drop constraint p_location_pk
go


alter table p_location
	drop constraint p_postal_sort_clustered_idx
go


alter table p_location
	drop constraint p_location_state_idx
go


alter table p_location
	drop constraint p_location_zip_idx
go


alter table p_location
	drop constraint p_location_city_idx
go


alter table p_address_format
	drop constraint p_af_pk
go


alter table p_address_format_set
	drop constraint p_afs_pk
go


alter table p_contact_info
	drop constraint p_contact_info_pk
go


alter table p_partner_relationship
	drop constraint p_partner_relationship_pk
go


alter table p_partner_relationship_type
	drop constraint p_relat_type_pk
go


alter table p_church
	drop constraint p_church_pk
go


alter table p_donor
	drop constraint p_donor_pk
go


alter table p_payee
	drop constraint p_payee_pk
go


alter table p_staff
	drop constraint p_staff_pk
go


alter table p_staff
	drop constraint p_staff_login_idx
go


alter table p_staff
	drop constraint p_staff_weblogin_idx
go


alter table p_bulk_postal_code
	drop constraint p_bulk_code_pk
go


alter table p_zipranges
	drop constraint p_bulk_code_pk
go


alter table p_country
	drop constraint p_country_code_pk
go


alter table p_banking_details
	drop constraint p_banking_details_pk
go


alter table p_banking_details
	drop constraint p_bankd_partner_idx
go


alter table p_banking_details
	drop constraint p_bankd_bpartner_idx
go


alter table p_banking_details
	drop constraint p_bankd_acct_idx
go


alter table p_banking_type
	drop constraint p_banking_type_pk
go


alter table p_title
	drop constraint p_title_pk
go


alter table p_gazetteer
	drop constraint p_gazetteer_pk
go


alter table p_gazetteer
	drop constraint p_gaz_altid_idx
go


alter table p_gazetteer
	drop constraint p_gaz_state_idx
go


alter table p_gazetteer
	drop constraint p_gaz_name_clustered_idx
go


alter table p_dup_check_tmp
	drop constraint p_dupcheck_pk
go


alter table p_partner_sort_tmp
	drop constraint p_sort_pk
go


alter table p_acquisition_code
	drop constraint p_acqcode_pk
go


alter table p_partner_search
	drop constraint p_search_pk
go


alter table p_partner_search_stage
	drop constraint p_searchstage_pk
go


alter table p_partner_search_results
	drop constraint p_searchres_pk
go


alter table p_search_stage_criteria
	drop constraint p_stage_criteria_pk
go


alter table m_list
	drop constraint m_list_pk
go


alter table m_list_membership
	drop constraint m_list_membership_clustered_pk
go


alter table e_contact_autorecord
	drop constraint e_autorec_pk
go


alter table e_contact_history_type
	drop constraint e_cnt_hist_type_pk
go


alter table e_contact_history
	drop constraint e_cnt_hist_pk
go


alter table e_contact_history
	drop constraint e_cnt_hist_type_idx
go


alter table e_contact_history
	drop constraint e_cnt_hist_par_idx
go


alter table e_contact_history
	drop constraint e_cnt_hist_locpar_idx
go


alter table e_contact_history
	drop constraint e_cnt_hist_whom_idx
go


alter table e_activity
	drop constraint e_act_pk
go


alter table e_activity
	drop constraint e_act_type_idx
go


alter table e_activity
	drop constraint e_act_par_idx
go


alter table e_activity
	drop constraint e_act_sort_idx
go


alter table e_engagement_track
	drop constraint e_trk_pk
go


alter table e_engagement_track
	drop constraint e_trk_name_idx
go


alter table e_engagement_track_collab
	drop constraint e_trkcoll_pk
go


alter table e_engagement_step
	drop constraint e_step_pk
go


alter table e_engagement_step
	drop constraint e_step_name_idx
go


alter table e_engagement_step_collab
	drop constraint e_stepcoll_pk
go


alter table e_engagement_step_req
	drop constraint e_req_pk
go


alter table e_partner_engagement
	drop constraint e_pareng_pk
go


alter table e_partner_engagement
	drop constraint e_pareng_trackstep_idx
go


alter table e_partner_engagement
	drop constraint e_pareng_start_idx
go


alter table e_partner_engagement_req
	drop constraint e_parreq_pk
go


alter table e_tag_type
	drop constraint e_tagtype_pk
go


alter table e_tag_type_relationship
	drop constraint e_tagtyperel_pk
go


alter table e_tag
	drop constraint e_tag_pk
go


alter table e_tag_activity
	drop constraint e_tagact_pk
go


alter table e_tag_activity
	drop constraint e_tagact_tagid_idx
go


alter table e_tag_activity
	drop constraint e_tagact_ptnr_idx
go


alter table e_document_type
	drop constraint e_doctype_pk
go


alter table e_document_type
	drop constraint e_doctype_parent_idx
go


alter table e_document_type
	drop constraint e_doctype_label_idx
go


alter table e_document
	drop constraint e_doc_pk
go


alter table e_document
	drop constraint e_doc_work_idx
go


alter table e_document
	drop constraint e_doc_type_idx
go


alter table e_document
	drop constraint e_doc_curpath_idx
go


alter table e_document_comment
	drop constraint e_doccom_pk
go


alter table e_document_comment
	drop constraint e_doccom_collab_idx
go


alter table e_document_comment
	drop constraint e_doccom_tgtcollab_idx
go


alter table e_document_comment
	drop constraint e_doccom_work_idx
go


alter table e_partner_document
	drop constraint e_pardoc_pk
go


alter table e_workflow_type
	drop constraint e_work_pk
go


alter table e_workflow_type_step
	drop constraint e_workstep_pk
go


alter table e_workflow_type_step
	drop constraint e_workstep_type_idx
go


alter table e_workflow_type_step
	drop constraint e_workstep_trig_idx
go


alter table e_workflow
	drop constraint e_workinst_pk
go


alter table e_workflow
	drop constraint e_workinst_type_idx
go


alter table e_workflow
	drop constraint e_workinst_trig_idx
go


alter table e_workflow
	drop constraint e_workinst_steptrig_idx
go


alter table e_collaborator_type
	drop constraint e_collabtype_pk
go


alter table e_collaborator
	drop constraint e_collab_pk
go


alter table e_collaborator
	drop constraint e_collab_type_idx
go


alter table e_todo_type
	drop constraint e_todotype_pk
go


alter table e_todo
	drop constraint e_todo_pk
go


alter table e_todo
	drop constraint e_todo_type_idx
go


alter table e_todo
	drop constraint e_todo_collab_idx
go


alter table e_todo
	drop constraint e_todo_par_idx
go


alter table e_todo
	drop constraint e_todo_eng_idx
go


alter table e_todo
	drop constraint e_todo_doc_idx
go


alter table e_todo
	drop constraint e_todo_reqitem_idx
go


alter table e_data_item_type
	drop constraint e_ditype_pk
go


alter table e_data_item_type
	drop constraint e_ditype_parent_idx
go


alter table e_data_item_group
	drop constraint e_digrp_pk
go


alter table e_data_item_group
	drop constraint e_digrp_type_idx
go


alter table e_data_item
	drop constraint e_dataitem_pk
go


alter table e_data_item
	drop constraint e_dataitem_type_idx
go


alter table e_data_item
	drop constraint e_dataitem_group_idx
go


alter table e_highlights
	drop constraint e_h_pk
go


alter table e_highlights
	drop constraint e_h_nt_idx
go


alter table e_data_highlight
	drop constraint e_dh_pk
go


alter table e_ack
	drop constraint e_ack_pk
go


alter table e_ack
	drop constraint e_ack_obj_idx
go


alter table e_ack
	drop constraint e_ack_par_idx
go


alter table e_ack
	drop constraint e_ack_par2_idx
go


alter table e_ack
	drop constraint e_ack_par3_idx
go


alter table e_ack_type
	drop constraint e_ackt_pk
go


alter table e_trackactivity
	drop constraint e_trkact_pk
go


alter table e_text_expansion
	drop constraint e_exp_pk
go


alter table e_text_search_word
	drop constraint e_tsw_pk
go


alter table e_text_search_word
	drop constraint e_tsw_word_idx
go


alter table e_text_search_rel
	drop constraint e_tsr_pk
go


alter table e_text_search_occur
	drop constraint e_tso_pk
go


alter table h_staff
	drop constraint h_staff_pk
go


alter table h_group
	drop constraint h_group_pk
go


alter table h_group_member
	drop constraint h_groupm_pk
go


alter table h_holidays
	drop constraint h_holiday_pk
go


alter table h_work_register
	drop constraint h_workreg_pk
go


alter table h_work_register
	drop constraint h_workreg_ben_idx
go


alter table h_work_register_times
	drop constraint h_workregt_pk
go


alter table h_benefit_period
	drop constraint h_benper_pk
go


alter table h_benefit_type
	drop constraint h_bentype_pk
go


alter table h_benefit_type_sched
	drop constraint h_bentypesch_pk
go


alter table h_benefit_type_sched
	drop constraint h_bts_partner_idx
go


alter table h_benefit_type_sched
	drop constraint h_bts_group_idx
go


alter table h_benefits
	drop constraint h_ben_pk
go


alter table r_group
	drop constraint r_grp_pk
go


alter table r_group
	drop constraint r_grp_modfile_idx
go


alter table r_group_report
	drop constraint r_rpt_pk
go


alter table r_group_param
	drop constraint r_param_pk
go


alter table r_group_param
	drop constraint r_param_cmp_idx
go


alter table r_group_report_param
	drop constraint r_rparam_pk
go


alter table r_saved_paramset
	drop constraint r_ps_pk
go


alter table r_saved_paramset
	drop constraint r_ps_modfile_idx
go


alter table r_saved_param
	drop constraint r_psparam_pk
go


alter table a_config
	drop constraint a_config_pk
go


alter table a_analysis_attr
	drop constraint a_an_attr_pk
go


alter table a_analysis_attr_value
	drop constraint a_an_attr_val_pk
go


alter table a_cc_analysis_attr
	drop constraint a_cc_an_attr_pk
go


alter table a_acct_analysis_attr
	drop constraint a_acct_an_attr_pk
go


alter table a_cost_center
	drop constraint a_cost_center_pk
go


alter table a_cost_center
	drop constraint a_cc_parent_idx
go


alter table a_cost_center
	drop constraint a_cc_legacy_idx
go


alter table a_cost_center
	drop constraint a_cc_bal_idx
go


alter table a_account
	drop constraint a_account_pk
go


alter table a_account
	drop constraint a_acct_parent_idx
go


alter table a_account
	drop constraint a_acct_legacy_idx
go


alter table a_account_usage
	drop constraint a_account_usage_pk
go


alter table a_account_usage_type
	drop constraint a_account_usage_type_pk
go


alter table a_account_category
	drop constraint a_account_category_pk
go


alter table a_cc_acct
	drop constraint a_cc_acct_pk
go


alter table a_period
	drop constraint a_period_pk
go


alter table a_period_usage
	drop constraint a_account_usage_pk
go


alter table a_period_usage_type
	drop constraint a_period_usage_type_pk
go


alter table a_ledger
	drop constraint a_ledger_pk
go


alter table a_batch
	drop constraint a_batch_pk
go


alter table a_transaction
	drop constraint a_transaction_pk
go


alter table a_transaction
	drop constraint a_trx_cc_clustered_idx
go


alter table a_transaction
	drop constraint a_trx_donor_id_idx
go


alter table a_transaction
	drop constraint a_trx_recip_id_idx
go


alter table a_transaction_tmp
	drop constraint a_transaction_tmp_pk
go


alter table a_transaction_tmp
	drop constraint a_trxt_cc_clustered_idx
go


alter table a_transaction_tmp
	drop constraint a_trxt_donor_id_idx
go


alter table a_transaction_tmp
	drop constraint a_trxt_recip_id_idx
go


alter table a_account_class
	drop constraint a_account_class_pk
go


alter table a_cost_center_class
	drop constraint a_costctr_class_pk
go


alter table a_reporting_level
	drop constraint a_level_pk
go


alter table a_cost_center_prefix
	drop constraint a_cost_center_prefix_pk
go


alter table a_cc_staff
	drop constraint a_cc_staff_pk
go


alter table a_ledger_office
	drop constraint a_lo_pk
go


alter table a_payroll
	drop constraint a_payroll_pk
go


alter table a_payroll_period
	drop constraint a_payperiod_pk
go


alter table a_payroll_period
	drop constraint a_payperiod_idx
go


alter table a_payroll_group
	drop constraint a_payroll_grp_pk
go


alter table a_payroll_import
	drop constraint a_payrolli_pk
go


alter table a_payroll_import
	drop constraint a_payrolli_payee_idx
go


alter table a_payroll_import
	drop constraint a_payrolli_cc_idx
go


alter table a_payroll_item
	drop constraint a_payroll_i_pk
go


alter table a_payroll_item_import
	drop constraint a_payrolli_i_pk
go


alter table a_payroll_item_type
	drop constraint a_payroll_it_pk
go


alter table a_payroll_item_class
	drop constraint a_payroll_ic_pk
go


alter table a_payroll_form_group
	drop constraint a_payroll_f_pk
go


alter table a_tax_filingstatus
	drop constraint a_filingstatus_pk
go


alter table a_tax_table
	drop constraint a_taxtable_pk
go


alter table a_tax_allowance_table
	drop constraint a_taxalltable_pk
go


alter table a_salary_review
	drop constraint a_salreview_pk
go


alter table a_cc_admin_fee
	drop constraint a_cc_admin_fee_pk
go


alter table a_admin_fee_type
	drop constraint a_admin_fee_type_pk
go


alter table a_admin_fee_type_tmp
	drop constraint a_admin_fee_type_tmp_pk
go


alter table a_admin_fee_type_item
	drop constraint a_admin_fee_type_item_pk
go


alter table a_admin_fee_type_item_tmp
	drop constraint a_admin_fee_type_item_tmp_pk
go


alter table a_cc_receipting
	drop constraint a_cc_receipting_pk
go


alter table a_cc_receipting_accts
	drop constraint a_cc_rcptacct_pk
go


alter table a_receipt_type
	drop constraint a_rcpttype_pk
go


alter table a_subtrx_gift
	drop constraint a_gifttrx_pk
go


alter table a_subtrx_gift
	drop constraint a_gifttrx_cc_clustered_idx
go


alter table a_subtrx_gift
	drop constraint a_gifttrx_donor_id_idx
go


alter table a_subtrx_gift
	drop constraint a_gifttrx_recip_id_idx
go


alter table a_subtrx_gift_group
	drop constraint a_gifttrxgrp_pk
go


alter table a_subtrx_gift_group
	drop constraint a_gifttrxgrp_donor_id_idx
go


alter table a_subtrx_gift_item
	drop constraint a_gifttrx_pk
go


alter table a_subtrx_gift_item
	drop constraint a_gifttrxi_cc_clustered_idx
go


alter table a_subtrx_gift_item
	drop constraint a_gifttrxi_recip_id_idx
go


alter table a_subtrx_gift_item
	drop constraint a_gifttrxi_mcode_idx
go


alter table a_subtrx_gift_item
	drop constraint a_gifttrxi_donor_idx
go


alter table a_subtrx_gift_item
	drop constraint a_gifttrxi_rcpt_idx
go


alter table a_subtrx_gift_rcptcnt
	drop constraint a_rcptno_pk
go


alter table a_cc_auto_subscribe
	drop constraint a_cc_auto_subscribe_pk
go


alter table a_motivational_code
	drop constraint a_motivational_code_pk
go


alter table a_motivational_code
	drop constraint a_motiv_code_list
go


alter table a_giving_pattern
	drop constraint a_givingp_pk
go


alter table a_giving_pattern
	drop constraint a_givingp_review_idx
go


alter table a_giving_pattern
	drop constraint a_givingp_actual_idx
go


alter table a_giving_pattern_allocation
	drop constraint a_givingpa_pk
go


alter table a_giving_pattern_allocation
	drop constraint a_givingpa_review_idx
go


alter table a_giving_pattern_allocation
	drop constraint a_givingpa_actual_idx
go


alter table a_giving_pattern_flag
	drop constraint a_givingf_pk
go


alter table a_giving_pattern_flag
	drop constraint a_givingf_review_idx
go


alter table a_funding_target
	drop constraint a_target_pk
go


alter table a_support_review
	drop constraint a_supportreview_pk
go


alter table a_support_review_target
	drop constraint a_supptgt_pk
go


alter table a_descriptives
	drop constraint a_descr_pk
go


alter table a_subtrx_cashdisb
	drop constraint a_subtrx_cashdisb_pk
go


alter table a_subtrx_cashdisb
	drop constraint a_subtrx_cashdisb_acct_idx
go


alter table a_subtrx_xfer
	drop constraint a_subtrx_xfer_pk
go


alter table a_subtrx_deposit
	drop constraint a_subtrx_deposit_pk
go


alter table a_subtrx_deposit
	drop constraint a_subtrx_dep_acct_idx
go


alter table a_subtrx_cashxfer
	drop constraint a_subtrx_cashxfer_pk
go


alter table i_eg_gift_import
	drop constraint i_eg_gift_import_pk
go


alter table i_eg_gift_import
	drop constraint i_eg_kdonor_idx
go


alter table i_eg_gift_import
	drop constraint i_eg_edonor_idx
go


alter table i_eg_gift_import
	drop constraint i_eg_kfund_idx
go


alter table i_eg_gift_import
	drop constraint i_eg_efund_idx
go


alter table i_eg_gift_import
	drop constraint i_eg_egift_idx
go


alter table i_eg_gift_import
	drop constraint i_eg_edeposit_idx
go


alter table i_eg_gift_import
	drop constraint i_eg_kgiftbatch_idx
go


alter table i_eg_gift_import
	drop constraint i_eg_kfeebatch_idx
go


alter table i_eg_gift_import
	drop constraint i_eg_kdepbatch_idx
go


alter table i_eg_giving_url
	drop constraint i_eg_giving_url_pk
go


alter table i_crm_partner_import
	drop constraint i_crm_partner_import_pk
go


alter table i_crm_partner_import_option
	drop constraint i_crm_partner_import_opt_pk
go


alter table i_crm_import_type
	drop constraint i_crm_import_type_pk
go


alter table i_crm_import_type_option
	drop constraint i_crm_import_type_option_pk
go


alter table i_disb_import_classify
	drop constraint i_disb_import_pk
go


alter table i_disb_import_status
	drop constraint i_disb_legacy_pk
go


alter table c_message
	drop constraint c_message_pk
go


alter table c_chat
	drop constraint c_chat_pk
go


alter table c_chat
	drop constraint c_public_idx
go


alter table c_member
	drop constraint c_member_pk
go


alter table s_config
	drop constraint s_config_pk
go


alter table s_user_data
	drop constraint s_user_data_pk
go


alter table s_user_loginhistory
	drop constraint s_loginhist_pk
go


alter table s_subsystem
	drop constraint s_subsystem_pk
go


alter table s_process
	drop constraint s_process_pk
go


alter table s_process_status
	drop constraint s_procstat_pk
go


alter table s_motd
	drop constraint s_motd_pk
go


alter table s_motd_viewed
	drop constraint s_motd_viewed_pk
go


alter table s_sec_endorsement
	drop constraint s_end_pk
go


alter table s_sec_endorsement_type
	drop constraint s_endt_pk
go


alter table s_sec_endorsement_context
	drop constraint s_endc_pk
go


alter table s_mykardia
	drop constraint s_myk_pk
go


alter table s_request
	drop constraint s_req_pk
go


alter table s_request
	drop constraint s_objkey12_idx
go


alter table s_request
	drop constraint s_objkey21_idx
go


alter table s_request_type
	drop constraint s_reqtype_pk
go


alter table s_audit
	drop constraint s_audit_pk
go


alter table s_audit
	drop constraint s_audit_name_idx
go


alter table s_audit
	drop constraint s_audit_strval_idx
go


alter table s_audit
	drop constraint s_audit_intval_idx
go
