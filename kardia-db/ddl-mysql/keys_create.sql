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

alter table p_contact_info
	add constraint p_contact_info_pk primary key  (p_partner_key, p_contact_id);

alter table p_partner_relationship
	add constraint p_partner_relationship_pk primary key  (p_partner_key, p_relation_type, p_relation_key);

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

alter table p_banking_details
	add constraint p_banking_details_pk primary key  (p_banking_details_key);

alter table p_title
	add constraint p_title_pk primary key  (p_title);

alter table m_list
	add constraint m_list_pk primary key  (m_list_code);

alter table m_list_membership
	add constraint m_list_membership_clustered_pk primary key  (m_list_code, p_partner_key);

alter table r_group
	add constraint r_grp_pk primary key  (r_group_name);

alter table r_group_report
	add constraint r_rpt_pk primary key  (r_group_name, r_delivery_method, p_recipient_partner_key, r_report_id);

alter table r_group_param
	add constraint r_param_pk primary key  (r_group_name, r_param_name);

alter table r_group_report_param
	add constraint r_rparam_pk primary key  (r_group_name, r_delivery_method, p_recipient_partner_key, r_report_id, r_param_name);

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
	add constraint a_payperiod_pk primary key  (a_payroll_period, a_ledger_number);

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

alter table a_subtrx_cashdisb
	add constraint a_subtrx_cashdisb_pk primary key  (a_ledger_number, a_batch_number, a_disbursement_id, a_line_item);

alter table a_subtrx_xfer
	add constraint a_subtrx_xfer_pk primary key  (a_ledger_number, a_batch_number, a_journal_number);

alter table a_subtrx_deposit
	add constraint a_subtrx_deposit_pk primary key  (a_ledger_number, a_batch_number);

alter table a_subtrx_cashxfer
	add constraint a_subtrx_cashxfer_pk primary key  (a_ledger_number, a_batch_number, a_journal_number);

alter table c_message
	add constraint c_message_pk primary key  (c_chat_id, c_message_id);

alter table c_chat
	add constraint c_chat_pk primary key  (c_chat_id);

alter table c_member
	add constraint c_member_pk primary key  (c_chat_id, s_username);

alter table s_user_data
	add constraint s_user_data_pk primary key  (s_username);

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
