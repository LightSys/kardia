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
	drop index p_cost_ctr_idx;


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


alter table p_contact_info
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


alter table p_bulk_postal_code
	drop primary key;


alter table p_zipranges
	drop primary key;


alter table p_country
	drop primary key;


alter table p_banking_details
	drop primary key;


alter table p_title
	drop primary key;


alter table m_list
	drop primary key;


alter table m_list_membership
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


alter table a_config
	drop primary key;


alter table a_analysis_attr
	drop primary key;


alter table a_analysis_attr_value
	drop primary key;


alter table a_cc_analysis_attr
	drop primary key;


alter table a_acct_analysis_attr
	drop primary key;


alter table a_cost_center
	drop primary key;


alter table a_cost_center
	drop index a_cc_parent_idx;


alter table a_cost_center
	drop index a_cc_legacy_idx;


alter table a_cost_center
	drop index a_cc_bal_idx;


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


alter table a_cc_acct
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
	drop index a_trx_cc_clustered_idx;


alter table a_transaction
	drop index a_trx_donor_id_idx;


alter table a_transaction
	drop index a_trx_recip_id_idx;


alter table a_transaction_tmp
	drop primary key;


alter table a_transaction_tmp
	drop index a_trxt_cc_clustered_idx;


alter table a_transaction_tmp
	drop index a_trxt_donor_id_idx;


alter table a_transaction_tmp
	drop index a_trxt_recip_id_idx;


alter table a_account_class
	drop primary key;


alter table a_cost_center_class
	drop primary key;


alter table a_reporting_level
	drop primary key;


alter table a_cost_center_prefix
	drop primary key;


alter table a_cc_staff
	drop primary key;


alter table a_ledger_office
	drop primary key;


alter table a_payroll
	drop primary key;


alter table a_payroll_group
	drop primary key;


alter table a_payroll_import
	drop primary key;


alter table a_payroll_import
	drop index a_payrolli_payee_idx;


alter table a_payroll_import
	drop index a_payrolli_cc_idx;


alter table a_payroll_item
	drop primary key;


alter table a_payroll_item_import
	drop primary key;


alter table a_payroll_item_type
	drop primary key;


alter table a_payroll_item_class
	drop primary key;


alter table a_payroll_form_group
	drop primary key;


alter table a_tax_filingstatus
	drop primary key;


alter table a_tax_table
	drop primary key;


alter table a_tax_allowance_table
	drop primary key;


alter table a_cc_admin_fee
	drop primary key;


alter table a_admin_fee_type
	drop primary key;


alter table a_admin_fee_type_tmp
	drop primary key;


alter table a_admin_fee_type_item
	drop primary key;


alter table a_admin_fee_type_item_tmp
	drop primary key;


alter table a_cc_receipting
	drop primary key;


alter table a_cc_receipting_accts
	drop primary key;


alter table a_subtrx_gift
	drop primary key;


alter table a_subtrx_gift
	drop index a_gifttrx_cc_clustered_idx;


alter table a_subtrx_gift
	drop index a_gifttrx_donor_id_idx;


alter table a_subtrx_gift
	drop index a_gifttrx_recip_id_idx;


alter table a_subtrx_gift_group
	drop primary key;


alter table a_subtrx_gift_group
	drop index a_gifttrxgrp_donor_id_idx;


alter table a_subtrx_gift_item
	drop primary key;


alter table a_subtrx_gift_item
	drop index a_gifttrxi_cc_clustered_idx;


alter table a_subtrx_gift_item
	drop index a_gifttrxi_recip_id_idx;


alter table a_subtrx_gift_item
	drop index a_gifttrxi_mcode_idx;


alter table a_subtrx_gift_rcptcnt
	drop primary key;


alter table a_cc_auto_subscribe
	drop primary key;


alter table a_motivational_code
	drop primary key;


alter table a_motivational_code
	drop index a_motiv_code_list;


alter table a_subtrx_cashdisb
	drop primary key;


alter table a_subtrx_cashdisb
	drop index a_subtrx_cashdisb_acct_idx;


alter table a_subtrx_xfer
	drop primary key;


alter table a_subtrx_deposit
	drop primary key;


alter table a_subtrx_deposit
	drop index a_subtrx_dep_acct_idx;


alter table a_subtrx_cashxfer
	drop primary key;


alter table c_message
	drop primary key;


alter table c_chat
	drop primary key;


alter table c_chat
	drop index c_public_idx;


alter table c_member
	drop primary key;


alter table s_user_data
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
