use Kardia_DB
go


print "working on table p_partner"

alter table p_partner
	add constraint p_partner_pk primary key nonclustered (p_partner_key)
go

alter table p_partner
	add constraint p_surname_clustered_idx unique clustered (p_surname, p_given_name, p_org_name, p_partner_key)
go

print "working on table p_partner_key_cnt"

alter table p_partner_key_cnt
	add constraint p_partner_key_cnt_pk primary key clustered (p_partner_key)
go

print "working on table p_person"

alter table p_person
	add constraint p_person_clustered_pk primary key clustered (p_partner_key)
go

print "working on table p_location"

alter table p_location
	add constraint p_location_pk primary key nonclustered (p_partner_key, p_location_id, p_revision_id)
go

alter table p_location
	add constraint p_postal_sort_clustered_idx unique clustered (p_country_code, p_bulk_postal_code, p_postal_code, p_partner_key, p_location_id, p_revision_id)
go

print "working on table p_address_format"

alter table p_address_format
	add constraint p_af_pk primary key clustered (p_address_set, p_country_code)
go

print "working on table p_address_format_set"

alter table p_address_format_set
	add constraint p_afs_pk primary key clustered (p_address_set)
go

print "working on table p_contact_info"

alter table p_contact_info
	add constraint p_contact_info_pk primary key clustered (p_partner_key, p_contact_id)
go

print "working on table p_partner_relationship"

alter table p_partner_relationship
	add constraint p_partner_relationship_pk primary key clustered (p_partner_key, p_relation_type, p_relation_key)
go

print "working on table p_church"

alter table p_church
	add constraint p_church_pk primary key clustered (p_partner_key)
go

print "working on table p_donor"

alter table p_donor
	add constraint p_donor_pk primary key clustered (p_partner_key, a_gl_ledger_number)
go

print "working on table p_payee"

alter table p_payee
	add constraint p_payee_pk primary key clustered (p_partner_key, a_gl_ledger_number)
go

print "working on table p_staff"

alter table p_staff
	add constraint p_staff_pk primary key clustered (p_partner_key)
go

print "working on table p_bulk_postal_code"

alter table p_bulk_postal_code
	add constraint p_bulk_code_pk primary key clustered (p_country_code,p_bulk_postal_code,p_bulk_code)
go

print "working on table p_zipranges"

alter table p_zipranges
	add constraint p_bulk_code_pk primary key clustered (p_first_zip,p_last_zip)
go

print "working on table p_country"

alter table p_country
	add constraint p_country_code_pk primary key clustered (p_country_code)
go

print "working on table p_banking_details"

alter table p_banking_details
	add constraint p_banking_details_pk primary key clustered (p_banking_details_key)
go

print "working on table p_title"

alter table p_title
	add constraint p_title_pk primary key clustered (p_title)
go

print "working on table p_gazetteer"

alter table p_gazetteer
	add constraint p_gazetteer_pk primary key nonclustered (p_country_code, p_feature_type, p_feature_id)
go

alter table p_gazetteer
	add constraint p_gaz_name_clustered_idx unique clustered (p_feature_name, p_country_code, p_feature_type, p_feature_id)
go

print "working on table p_dup_check_tmp"

alter table p_dup_check_tmp
	add constraint p_dupcheck_pk primary key clustered (p_partner_key,s_username)
go

print "working on table p_partner_sort_tmp"

alter table p_partner_sort_tmp
	add constraint p_sort_pk primary key clustered (p_partner_key,s_username,p_sort_session_id)
go

print "working on table m_list"

alter table m_list
	add constraint m_list_pk primary key clustered (m_list_code)
go

print "working on table m_list_membership"

alter table m_list_membership
	add constraint m_list_membership_clustered_pk primary key clustered (m_list_code, p_partner_key)
go

print "working on table r_group"

alter table r_group
	add constraint r_grp_pk primary key clustered (r_group_name)
go

print "working on table r_group_report"

alter table r_group_report
	add constraint r_rpt_pk primary key clustered (r_group_name, r_delivery_method, p_recipient_partner_key, r_report_id)
go

print "working on table r_group_param"

alter table r_group_param
	add constraint r_param_pk primary key clustered (r_group_name, r_param_name)
go

print "working on table r_group_report_param"

alter table r_group_report_param
	add constraint r_rparam_pk primary key clustered (r_group_name, r_delivery_method, p_recipient_partner_key, r_report_id, r_param_name)
go

print "working on table r_saved_paramset"

alter table r_saved_paramset
	add constraint r_ps_pk primary key clustered (r_paramset_id)
go

print "working on table r_saved_param"

alter table r_saved_param
	add constraint r_psparam_pk primary key clustered (r_paramset_id, r_param_name)
go

print "working on table a_config"

alter table a_config
	add constraint a_config_pk primary key clustered (a_ledger_number, a_config_name)
go

print "working on table a_analysis_attr"

alter table a_analysis_attr
	add constraint a_an_attr_pk primary key clustered (a_ledger_number, a_attr_code)
go

print "working on table a_analysis_attr_value"

alter table a_analysis_attr_value
	add constraint a_an_attr_val_pk primary key clustered (a_ledger_number, a_attr_code, a_value)
go

print "working on table a_cc_analysis_attr"

alter table a_cc_analysis_attr
	add constraint a_cc_an_attr_pk primary key clustered (a_ledger_number, a_attr_code, a_cost_center)
go

print "working on table a_acct_analysis_attr"

alter table a_acct_analysis_attr
	add constraint a_acct_an_attr_pk primary key clustered (a_ledger_number, a_attr_code, a_account_code)
go

print "working on table a_cost_center"

alter table a_cost_center
	add constraint a_cost_center_pk primary key clustered (a_cost_center, a_ledger_number)
go

print "working on table a_account"

alter table a_account
	add constraint a_account_pk primary key clustered (a_account_code, a_ledger_number)
go

print "working on table a_account_usage"

alter table a_account_usage
	add constraint a_account_usage_pk primary key clustered (a_acct_usage_code, a_ledger_number, a_account_code)
go

print "working on table a_account_usage_type"

alter table a_account_usage_type
	add constraint a_account_usage_type_pk primary key clustered (a_acct_usage_code)
go

print "working on table a_account_category"

alter table a_account_category
	add constraint a_account_category_pk primary key clustered (a_account_category, a_ledger_number)
go

print "working on table a_cc_acct"

alter table a_cc_acct
	add constraint a_cc_acct_pk primary key clustered (a_ledger_number, a_period, a_cost_center, a_account_code)
go

print "working on table a_period"

alter table a_period
	add constraint a_period_pk primary key clustered (a_period, a_ledger_number)
go

print "working on table a_period_usage"

alter table a_period_usage
	add constraint a_account_usage_pk primary key clustered (a_period_usage_code, a_ledger_number, a_period)
go

print "working on table a_period_usage_type"

alter table a_period_usage_type
	add constraint a_period_usage_type_pk primary key clustered (a_period_usage_code)
go

print "working on table a_ledger"

alter table a_ledger
	add constraint a_ledger_pk primary key clustered (a_ledger_number)
go

print "working on table a_batch"

alter table a_batch
	add constraint a_batch_pk primary key clustered (a_batch_number, a_ledger_number)
go

print "working on table a_transaction"

alter table a_transaction
	add constraint a_transaction_pk primary key nonclustered (a_ledger_number, a_batch_number, a_journal_number, a_transaction_number)
go

alter table a_transaction
	add constraint a_trx_cc_clustered_idx unique clustered (a_cost_center, a_account_code, a_ledger_number, a_batch_number, a_journal_number, a_transaction_number)
go

print "working on table a_transaction_tmp"

alter table a_transaction_tmp
	add constraint a_transaction_tmp_pk primary key nonclustered (a_ledger_number, a_batch_number, a_journal_number, a_transaction_number)
go

alter table a_transaction_tmp
	add constraint a_trxt_cc_clustered_idx unique clustered (a_cost_center, a_account_code, a_ledger_number, a_batch_number, a_journal_number, a_transaction_number)
go

print "working on table a_account_class"

alter table a_account_class
	add constraint a_account_class_pk primary key clustered (a_account_class, a_ledger_number)
go

print "working on table a_cost_center_class"

alter table a_cost_center_class
	add constraint a_costctr_class_pk primary key clustered (a_cost_center_class, a_ledger_number)
go

print "working on table a_reporting_level"

alter table a_reporting_level
	add constraint a_level_pk primary key clustered (a_reporting_level, a_ledger_number)
go

print "working on table a_cost_center_prefix"

alter table a_cost_center_prefix
	add constraint a_cost_center_prefix_pk primary key clustered (a_cost_center_prefix, a_ledger_number)
go

print "working on table a_cc_staff"

alter table a_cc_staff
	add constraint a_cc_staff_pk primary key clustered (a_ledger_number, a_cost_center, p_staff_partner_key)
go

print "working on table a_ledger_office"

alter table a_ledger_office
	add constraint a_lo_pk primary key clustered (a_ledger_number, p_office_partner_key)
go

print "working on table a_payroll"

alter table a_payroll
	add constraint a_payroll_pk primary key clustered (a_ledger_number, a_payroll_group_id, a_payroll_id)
go

print "working on table a_payroll_period"

alter table a_payroll_period
	add constraint a_payperiod_pk primary key clustered (a_ledger_number, a_payroll_group_id, a_payroll_period)
go

print "working on table a_payroll_group"

alter table a_payroll_group
	add constraint a_payroll_grp_pk primary key clustered (a_ledger_number, a_payroll_group_id)
go

print "working on table a_payroll_import"

alter table a_payroll_import
	add constraint a_payrolli_pk primary key clustered (a_payroll_id)
go

print "working on table a_payroll_item"

alter table a_payroll_item
	add constraint a_payroll_i_pk primary key clustered (a_ledger_number, a_payroll_group_id, a_payroll_id, a_payroll_item_id)
go

print "working on table a_payroll_item_import"

alter table a_payroll_item_import
	add constraint a_payrolli_i_pk primary key clustered (a_payroll_id, a_payroll_item_id)
go

print "working on table a_payroll_item_type"

alter table a_payroll_item_type
	add constraint a_payroll_it_pk primary key clustered (a_ledger_number, a_payroll_item_type_code)
go

print "working on table a_payroll_item_class"

alter table a_payroll_item_class
	add constraint a_payroll_ic_pk primary key clustered (a_payroll_item_class_code)
go

print "working on table a_payroll_form_group"

alter table a_payroll_form_group
	add constraint a_payroll_f_pk primary key clustered (a_ledger_number, a_payroll_form_group_name, a_payroll_form_sequence)
go

print "working on table a_tax_filingstatus"

alter table a_tax_filingstatus
	add constraint a_filingstatus_pk primary key clustered (a_ledger_number, a_payroll_item_type_code, a_filing_status)
go

print "working on table a_tax_table"

alter table a_tax_table
	add constraint a_taxtable_pk primary key nonclustered (a_tax_entry_id)
go

print "working on table a_tax_allowance_table"

alter table a_tax_allowance_table
	add constraint a_taxalltable_pk primary key clustered (a_tax_allowance_entry_id)
go

print "working on table a_cc_admin_fee"

alter table a_cc_admin_fee
	add constraint a_cc_admin_fee_pk primary key clustered (a_cost_center, a_ledger_number)
go

print "working on table a_admin_fee_type"

alter table a_admin_fee_type
	add constraint a_admin_fee_type_pk primary key clustered (a_ledger_number, a_admin_fee_type, a_admin_fee_subtype)
go

print "working on table a_admin_fee_type_tmp"

alter table a_admin_fee_type_tmp
	add constraint a_admin_fee_type_tmp_pk primary key clustered (a_ledger_number, a_admin_fee_type, a_admin_fee_subtype)
go

print "working on table a_admin_fee_type_item"

alter table a_admin_fee_type_item
	add constraint a_admin_fee_type_item_pk primary key clustered (a_ledger_number, a_admin_fee_type, a_admin_fee_subtype, a_dest_cost_center)
go

print "working on table a_admin_fee_type_item_tmp"

alter table a_admin_fee_type_item_tmp
	add constraint a_admin_fee_type_item_tmp_pk primary key clustered (a_ledger_number, a_admin_fee_type, a_admin_fee_subtype, a_dest_cost_center)
go

print "working on table a_cc_receipting"

alter table a_cc_receipting
	add constraint a_cc_receipting_pk primary key clustered (a_cost_center, a_ledger_number)
go

print "working on table a_cc_receipting_accts"

alter table a_cc_receipting_accts
	add constraint a_cc_rcptacct_pk primary key clustered (a_cost_center, a_ledger_number,a_account_code)
go

print "working on table a_receipt_type"

alter table a_receipt_type
	add constraint a_rcpttype_pk primary key clustered (a_receipt_type)
go

print "working on table a_subtrx_gift"

alter table a_subtrx_gift
	add constraint a_gifttrx_pk primary key nonclustered (a_ledger_number, a_batch_number, a_gift_number)
go

alter table a_subtrx_gift
	add constraint a_gifttrx_cc_clustered_idx unique clustered (a_cost_center, a_account_code, a_ledger_number, a_batch_number, a_gift_number)
go

print "working on table a_subtrx_gift_group"

alter table a_subtrx_gift_group
	add constraint a_gifttrxgrp_pk primary key clustered (a_ledger_number, a_batch_number, a_gift_number)
go

print "working on table a_subtrx_gift_item"

alter table a_subtrx_gift_item
	add constraint a_gifttrx_pk primary key nonclustered (a_ledger_number, a_batch_number, a_gift_number, a_split_number)
go

alter table a_subtrx_gift_item
	add constraint a_gifttrxi_cc_clustered_idx unique clustered (a_cost_center, a_account_code, a_ledger_number, a_batch_number, a_gift_number, a_split_number)
go

print "working on table a_subtrx_gift_rcptcnt"

alter table a_subtrx_gift_rcptcnt
	add constraint a_rcptno_pk primary key clustered (a_ledger_number)
go

print "working on table a_cc_auto_subscribe"

alter table a_cc_auto_subscribe
	add constraint a_cc_auto_subscribe_pk primary key clustered (a_cost_center, a_ledger_number, m_list_code)
go

print "working on table a_motivational_code"

alter table a_motivational_code
	add constraint a_motivational_code_pk primary key clustered (a_ledger_number, a_motivational_code)
go

print "working on table a_subtrx_cashdisb"

alter table a_subtrx_cashdisb
	add constraint a_subtrx_cashdisb_pk primary key clustered (a_ledger_number, a_batch_number, a_disbursement_id, a_line_item)
go

print "working on table a_subtrx_xfer"

alter table a_subtrx_xfer
	add constraint a_subtrx_xfer_pk primary key clustered (a_ledger_number, a_batch_number, a_journal_number)
go

print "working on table a_subtrx_deposit"

alter table a_subtrx_deposit
	add constraint a_subtrx_deposit_pk primary key clustered (a_ledger_number, a_batch_number)
go

print "working on table a_subtrx_cashxfer"

alter table a_subtrx_cashxfer
	add constraint a_subtrx_cashxfer_pk primary key clustered (a_ledger_number, a_batch_number, a_journal_number)
go

print "working on table i_eg_gift_import"

alter table i_eg_gift_import
	add constraint i_eg_gift_import_pk primary key clustered (a_ledger_number, i_eg_trx_uuid)
go

print "working on table c_message"

alter table c_message
	add constraint c_message_pk primary key clustered (c_chat_id, c_message_id)
go

print "working on table c_chat"

alter table c_chat
	add constraint c_chat_pk primary key clustered (c_chat_id)
go

print "working on table c_member"

alter table c_member
	add constraint c_member_pk primary key clustered (c_chat_id, s_username)
go

print "working on table s_user_data"

alter table s_user_data
	add constraint s_user_data_pk primary key clustered (s_username)
go

print "working on table s_user_loginhistory"

alter table s_user_loginhistory
	add constraint s_loginhist_pk primary key clustered (s_username, s_sessionid)
go

print "working on table s_subsystem"

alter table s_subsystem
	add constraint s_subsystem_pk primary key clustered (s_subsystem_code)
go

print "working on table s_process"

alter table s_process
	add constraint s_process_pk primary key clustered (s_subsystem_code, s_process_code)
go

print "working on table s_process_status"

alter table s_process_status
	add constraint s_procstat_pk primary key clustered (s_subsystem_code, s_process_code, s_process_status_code)
go

print "working on table s_motd"

alter table s_motd
	add constraint s_motd_pk primary key clustered (s_motd_id)
go

print "working on table s_motd_viewed"

alter table s_motd_viewed
	add constraint s_motd_viewed_pk primary key clustered (s_motd_id, s_username)
go

print "working on table s_sec_endorsement"

alter table s_sec_endorsement
	add constraint s_end_pk primary key clustered (s_endorsement, s_context, s_subject)
go

print "working on table s_sec_endorsement_type"

alter table s_sec_endorsement_type
	add constraint s_endt_pk primary key clustered (s_endorsement)
go

print "working on table s_sec_endorsement_context"

alter table s_sec_endorsement_context
	add constraint s_endc_pk primary key clustered (s_context)
go

print "working on table s_mykardia"

alter table s_mykardia
	add constraint s_myk_pk primary key clustered (s_username, s_module, s_plugin, s_occurrence)
go

print "working on table s_request"

alter table s_request
	add constraint s_req_pk primary key clustered (s_request_id)
go

print "working on table s_request_type"

alter table s_request_type
	add constraint s_reqtype_pk primary key clustered (s_request_type)
go

print "working on table s_audit"

alter table s_audit
	add constraint s_audit_pk primary key clustered (s_sequence)
go
