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


alter table m_list
	drop constraint m_list_pk
go


alter table m_list_membership
	drop constraint m_list_membership_clustered_pk
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
