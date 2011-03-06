use Kardia_DB;



alter table p_partner
	drop constraint p_partner_pk;


alter table p_partner
	drop constraint p_given_name_idx;


alter table p_partner
	drop constraint p_surname_clustered_idx;


alter table p_partner
	drop constraint p_org_name_idx;


alter table p_partner
	drop constraint p_legacy_key_1_idx;


alter table p_partner
	drop constraint p_legacy_key_2_idx;


alter table p_partner
	drop constraint p_parent_key_idx;


alter table p_partner
	drop constraint p_cost_ctr_idx;


alter table p_partner
	drop constraint p_merged_with_idx;


alter table p_person
	drop constraint p_person_clustered_pk;


alter table p_location
	drop constraint p_location_pk;


alter table p_location
	drop constraint p_postal_sort_clustered_idx;


alter table p_location
	drop constraint p_location_state_idx;


alter table p_location
	drop constraint p_location_zip_idx;


alter table p_location
	drop constraint p_location_city_idx;


alter table p_contact_info
	drop constraint p_contact_info_pk;


alter table p_partner_relationship
	drop constraint p_partner_relationship_pk;


alter table p_church
	drop constraint p_church_pk;


alter table p_donor
	drop constraint p_donor_pk;


alter table p_payee
	drop constraint p_payee_pk;


alter table p_bulk_postal_code
	drop constraint p_bulk_code_pk;


alter table p_zipranges
	drop constraint p_bulk_code_pk;


alter table p_country
	drop constraint p_country_code_pk;


alter table p_banking_details
	drop constraint p_banking_details_pk;


alter table m_list
	drop constraint m_list_pk;


alter table m_list_membership
	drop constraint m_list_membership_clustered_pk;


alter table a_analysis_attr
	drop constraint a_an_attr_pk;


alter table a_analysis_attr_value
	drop constraint a_an_attr_val_pk;


alter table a_cc_analysis_attr
	drop constraint a_cc_an_attr_pk;


alter table a_acct_analysis_attr
	drop constraint a_acct_an_attr_pk;


alter table a_cost_center
	drop constraint a_cost_center_pk;


alter table a_cost_center
	drop constraint a_cc_parent_idx;


alter table a_cost_center
	drop constraint a_cc_legacy_idx;


alter table a_cost_center
	drop constraint a_cc_bal_idx;


alter table a_account
	drop constraint a_account_pk;


alter table a_account
	drop constraint a_acct_parent_idx;


alter table a_account
	drop constraint a_acct_legacy_idx;


alter table a_account_usage
	drop constraint a_account_usage_pk;


alter table a_account_usage_type
	drop constraint a_account_usage_type_pk;


alter table a_account_category
	drop constraint a_account_category_pk;


alter table a_cc_acct
	drop constraint a_cc_acct_pk;


alter table a_period
	drop constraint a_period_pk;


alter table a_period_usage
	drop constraint a_account_usage_pk;


alter table a_period_usage_type
	drop constraint a_period_usage_type_pk;


alter table a_ledger
	drop constraint a_ledger_pk;


alter table a_batch
	drop constraint a_batch_pk;


alter table a_transaction
	drop constraint a_transaction_pk;


alter table a_transaction
	drop constraint a_trx_cc_clustered_idx;


alter table a_transaction
	drop constraint a_trx_donor_id_idx;


alter table a_transaction
	drop constraint a_trx_recip_id_idx;


alter table a_transaction_tmp
	drop constraint a_transaction_tmp_pk;


alter table a_transaction_tmp
	drop constraint a_trxt_cc_clustered_idx;


alter table a_transaction_tmp
	drop constraint a_trxt_donor_id_idx;


alter table a_transaction_tmp
	drop constraint a_trxt_recip_id_idx;


alter table a_account_class
	drop constraint a_account_class_pk;


alter table a_cost_center_class
	drop constraint a_costctr_class_pk;


alter table a_reporting_level
	drop constraint a_level_pk;


alter table a_cost_center_prefix
	drop constraint a_cost_center_prefix_pk;


alter table a_payroll
	drop constraint a_payroll_pk;


alter table a_payroll_group
	drop constraint a_payroll_grp_pk;


alter table a_payroll_import
	drop constraint a_payrolli_pk;


alter table a_payroll_import
	drop constraint a_payrolli_payee_idx;


alter table a_payroll_import
	drop constraint a_payrolli_cc_idx;


alter table a_payroll_item
	drop constraint a_payroll_i_pk;


alter table a_payroll_item_import
	drop constraint a_payrolli_i_pk;


alter table a_payroll_item_type
	drop constraint a_payroll_it_pk;


alter table a_payroll_item_class
	drop constraint a_payroll_ic_pk;


alter table a_payroll_form_group
	drop constraint a_payroll_f_pk;


alter table a_tax_filingstatus
	drop constraint a_filingstatus_pk;


alter table a_tax_table
	drop constraint a_taxtable_pk;


alter table a_tax_allowance_table
	drop constraint a_taxalltable_pk;


alter table a_cc_admin_fee
	drop constraint a_cc_admin_fee_pk;


alter table a_admin_fee_type
	drop constraint a_admin_fee_type_pk;


alter table a_admin_fee_type_tmp
	drop constraint a_admin_fee_type_tmp_pk;


alter table a_admin_fee_type_item
	drop constraint a_admin_fee_type_item_pk;


alter table a_admin_fee_type_item_tmp
	drop constraint a_admin_fee_type_item_tmp_pk;


alter table a_cc_receipting
	drop constraint a_cc_receipting_pk;


alter table a_cc_receipting_accts
	drop constraint a_cc_rcptacct_pk;


alter table a_subtrx_gift
	drop constraint a_gifttrx_pk;


alter table a_subtrx_gift
	drop constraint a_gifttrx_cc_clustered_idx;


alter table a_subtrx_gift
	drop constraint a_gifttrx_donor_id_idx;


alter table a_subtrx_gift
	drop constraint a_gifttrx_recip_id_idx;


alter table a_subtrx_gift_group
	drop constraint a_gifttrxgrp_pk;


alter table a_subtrx_gift_group
	drop constraint a_gifttrxgrp_cc_clustered_idx;


alter table a_subtrx_gift_group
	drop constraint a_gifttrxgrp_donor_id_idx;


alter table a_subtrx_gift_item
	drop constraint a_gifttrx_pk;


alter table a_subtrx_gift_item
	drop constraint a_gifttrxi_cc_clustered_idx;


alter table a_subtrx_gift_item
	drop constraint a_gifttrxi_recip_id_idx;


alter table a_subtrx_gift_rcptcnt
	drop constraint a_rcptno_pk;


alter table a_cc_auto_subscribe
	drop constraint a_cc_auto_subscribe_pk;


alter table a_subtrx_cashdisb
	drop constraint a_subtrx_cashdisb_pk;


alter table a_subtrx_cashdisb
	drop constraint a_subtrx_cashdisb_acct_idx;


alter table a_subtrx_xfer
	drop constraint a_subtrx_xfer_pk;


alter table a_subtrx_deposit
	drop constraint a_subtrx_deposit_pk;


alter table a_subtrx_deposit
	drop constraint a_subtrx_dep_acct_idx;


alter table a_subtrx_cashxfer
	drop constraint a_subtrx_cashxfer_pk;


alter table s_user_data
	drop constraint s_user_data_pk;


alter table s_subsystem
	drop constraint s_subsystem_pk;


alter table s_process
	drop constraint s_process_pk;


alter table s_process_status
	drop constraint s_procstat_pk;
