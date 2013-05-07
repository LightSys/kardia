use Kardia_DB;



/* p_partner */
create  index p_cost_ctr_idx on p_partner (p_cost_center, p_partner_key);
create  index p_given_name_idx on p_partner (p_given_name, p_partner_key);
create  index p_legacy_key_1_idx on p_partner (p_legacy_key_1, p_partner_key);
create  index p_legacy_key_2_idx on p_partner (p_legacy_key_2, p_partner_key);
create  index p_merged_with_idx on p_partner (p_merged_with, p_partner_key);
create  index p_org_name_idx on p_partner (p_org_name, p_partner_key);
create  index p_parent_key_idx on p_partner (p_parent_key, p_partner_key);
/* create  index p_partner_pk on p_partner (p_partner_key)*/ 
/* go */
/* create  index p_surname_clustered_idx on p_partner (p_surname, p_given_name, p_org_name, p_partner_key)*/ 
/* go */


/* p_partner_key_cnt */
/* create  index p_partner_key_cnt_pk on p_partner_key_cnt (p_partner_key)*/ 
/* go */


/* p_person */
/* create  index p_person_clustered_pk on p_person (p_partner_key)*/ 
/* go */


/* p_location */
create  index p_location_city_idx on p_location (p_city, p_state_province, p_partner_key, p_location_id, p_revision_id);
/* create  index p_location_pk on p_location (p_partner_key, p_location_id, p_revision_id)*/ 
/* go */
create  index p_location_rev_idx on p_location (p_partner_key, p_revision_id, p_location_id);
create  index p_location_state_idx on p_location (p_state_province, p_postal_code, p_partner_key, p_location_id, p_revision_id);
create  index p_location_zip_idx on p_location (p_postal_code, p_state_province, p_partner_key, p_location_id, p_revision_id);
/* create  index p_postal_sort_clustered_idx on p_location (p_country_code, p_bulk_postal_code, p_postal_code, p_partner_key, p_location_id, p_revision_id)*/ 
/* go */


/* p_address_format */
create  index p_af_country_idx on p_address_format (p_country_code, p_address_set);
/* create  index p_af_pk on p_address_format (p_address_set, p_country_code)*/ 
/* go */


/* p_address_format_set */
/* create  index p_afs_pk on p_address_format_set (p_address_set)*/ 
/* go */


/* p_contact_info */
/* create  index p_contact_info_pk on p_contact_info (p_partner_key, p_contact_id)*/ 
/* go */


/* p_partner_relationship */
/* create  index p_partner_relationship_pk on p_partner_relationship (p_partner_key, p_relation_type, p_relation_key)*/ 
/* go */


/* p_church */
/* create  index p_church_pk on p_church (p_partner_key)*/ 
/* go */


/* p_donor */
create  index p_dnr_gl_acct_idx on p_donor (a_gl_account_code, a_gl_ledger_number, p_partner_key);
/* create  index p_donor_pk on p_donor (p_partner_key, a_gl_ledger_number)*/ 
/* go */


/* p_payee */
create  index p_gl_acct_idx on p_payee (a_gl_account_code, a_gl_ledger_number, p_partner_key);
/* create  index p_payee_pk on p_payee (p_partner_key, a_gl_ledger_number)*/ 
/* go */


/* p_staff */
create  index p_staff_login_idx on p_staff (p_kardia_login, p_partner_key);
/* create  index p_staff_pk on p_staff (p_partner_key)*/ 
/* go */
create  index p_staff_weblogin_idx on p_staff (p_kardiaweb_login, p_partner_key);


/* p_bulk_postal_code */
/* create  index p_bulk_code_pk on p_bulk_postal_code (p_country_code,p_bulk_postal_code,p_bulk_code)*/ 
/* go */


/* p_zipranges */
/* create  index p_bulk_code_pk on p_zipranges (p_first_zip,p_last_zip)*/ 
/* go */


/* p_country */
/* create  index p_country_code_pk on p_country (p_country_code)*/ 
/* go */


/* p_banking_details */
/* create  index p_banking_details_pk on p_banking_details (p_banking_details_key)*/ 
/* go */


/* p_title */
/* create  index p_title_pk on p_title (p_title)*/ 
/* go */


/* p_gazetteer */
create  index p_gaz_altid_idx on p_gazetteer (p_alt_feature_id, p_country_code, p_feature_type, p_feature_id);
create  index p_gaz_id_idx on p_gazetteer (p_feature_id, p_country_code, p_feature_type);
/* create  index p_gaz_name_clustered_idx on p_gazetteer (p_feature_name, p_country_code, p_feature_type, p_feature_id)*/ 
/* go */
create  index p_gaz_state_idx on p_gazetteer (p_state_province, p_country_code, p_feature_type, p_feature_id);
create  index p_gaz_type_idx on p_gazetteer (p_feature_type, p_country_code, p_feature_id);
/* create  index p_gazetteer_pk on p_gazetteer (p_country_code, p_feature_type, p_feature_id)*/ 
/* go */


/* p_dup_check_tmp */
create  index p_dc_username_idx on p_dup_check_tmp (s_username, p_partner_key);
/* create  index p_dupcheck_pk on p_dup_check_tmp (p_partner_key,s_username)*/ 
/* go */


/* p_partner_sort_tmp */
/* create  index p_sort_pk on p_partner_sort_tmp (p_partner_key,s_username,p_sort_session_id)*/ 
/* go */


/* m_list */
/* create  index m_list_pk on m_list (m_list_code)*/ 
/* go */


/* m_list_membership */
/* create  index m_list_membership_clustered_pk on m_list_membership (m_list_code, p_partner_key)*/ 
/* go */
create  index m_lists_by_partner on m_list_membership (p_partner_key, m_list_code);


/* r_group */
create  index r_grp_modfile_idx on r_group (r_group_module, r_group_file, r_group_name);
/* create  index r_grp_pk on r_group (r_group_name)*/ 
/* go */


/* r_group_report */
create  index r_rpt_partner_idx on r_group_report (p_recipient_partner_key, r_group_name, r_delivery_method, r_report_id);
/* create  index r_rpt_pk on r_group_report (r_group_name, r_delivery_method, p_recipient_partner_key, r_report_id)*/ 
/* go */


/* r_group_param */
create  index r_param_cmp_idx on r_group_param (r_param_cmp_module, r_param_cmp_file, r_group_name, r_param_name);
/* create  index r_param_pk on r_group_param (r_group_name, r_param_name)*/ 
/* go */


/* r_group_report_param */
create  index r_rparam_param_idx on r_group_report_param (r_group_name, r_param_name, r_delivery_method, p_recipient_partner_key, r_report_id);
create  index r_rparam_partner_idx on r_group_report_param (p_recipient_partner_key, r_group_name, r_delivery_method, r_report_id, r_param_name);
/* create  index r_rparam_pk on r_group_report_param (r_group_name, r_delivery_method, p_recipient_partner_key, r_report_id, r_param_name)*/ 
/* go */
create  index r_rparam_value_idx on r_group_report_param (r_param_name, r_param_value, r_group_name, r_delivery_method, p_recipient_partner_key, r_report_id);


/* r_saved_paramset */
create  index r_ps_modfile_idx on r_saved_paramset (r_module, r_file, r_paramset_id);
/* create  index r_ps_pk on r_saved_paramset (r_paramset_id)*/ 
/* go */


/* r_saved_param */
/* create  index r_psparam_pk on r_saved_param (r_paramset_id, r_param_name)*/ 
/* go */


/* a_config */
/* create  index a_config_pk on a_config (a_ledger_number, a_config_name)*/ 
/* go */


/* a_analysis_attr */
/* create  index a_an_attr_pk on a_analysis_attr (a_ledger_number, a_attr_code)*/ 
/* go */


/* a_analysis_attr_value */
/* create  index a_an_attr_val_pk on a_analysis_attr_value (a_ledger_number, a_attr_code, a_value)*/ 
/* go */


/* a_cc_analysis_attr */
/* create  index a_cc_an_attr_pk on a_cc_analysis_attr (a_ledger_number, a_attr_code, a_cost_center)*/ 
/* go */


/* a_acct_analysis_attr */
/* create  index a_acct_an_attr_pk on a_acct_analysis_attr (a_ledger_number, a_attr_code, a_account_code)*/ 
/* go */


/* a_cost_center */
create  index a_cc_bal_idx on a_cost_center (a_bal_cost_center, a_cost_center, a_ledger_number);
create  index a_cc_ledger_number_idx on a_cost_center (a_ledger_number, a_cost_center);
create  index a_cc_legacy_idx on a_cost_center (a_legacy_code, a_cost_center, a_ledger_number);
create  index a_cc_parent_idx on a_cost_center (a_parent_cost_center, a_cost_center, a_ledger_number);
/* create  index a_cost_center_pk on a_cost_center (a_cost_center, a_ledger_number)*/ 
/* go */


/* a_account */
/* create  index a_account_pk on a_account (a_account_code, a_ledger_number)*/ 
/* go */
create  index a_acct_ledger_number_idx on a_account (a_ledger_number, a_account_code);
create  index a_acct_legacy_idx on a_account (a_legacy_code, a_account_code, a_ledger_number);
create  index a_acct_parent_idx on a_account (a_parent_account_code, a_account_code, a_ledger_number);


/* a_account_usage */
/* create  index a_account_usage_pk on a_account_usage (a_acct_usage_code, a_ledger_number, a_account_code)*/ 
/* go */
create  index a_acctusg_acct_idx on a_account_usage (a_account_code, a_ledger_number, a_acct_usage_code);
create  index a_acctusg_ledger_number_idx on a_account_usage (a_ledger_number, a_acct_usage_code, a_account_code);


/* a_account_usage_type */
/* create  index a_account_usage_type_pk on a_account_usage_type (a_acct_usage_code)*/ 
/* go */


/* a_account_category */
/* create  index a_account_category_pk on a_account_category (a_account_category, a_ledger_number)*/ 
/* go */


/* a_cc_acct */
/* create  index a_cc_acct_pk on a_cc_acct (a_ledger_number, a_period, a_cost_center, a_account_code)*/ 
/* go */


/* a_period */
/* create  index a_period_pk on a_period (a_period, a_ledger_number)*/ 
/* go */


/* a_period_usage */
/* create  index a_account_usage_pk on a_period_usage (a_period_usage_code, a_ledger_number, a_period)*/ 
/* go */


/* a_period_usage_type */
/* create  index a_period_usage_type_pk on a_period_usage_type (a_period_usage_code)*/ 
/* go */


/* a_ledger */
/* create  index a_ledger_pk on a_ledger (a_ledger_number)*/ 
/* go */


/* a_batch */
create  index a_batch_ledger_idx on a_batch (a_ledger_number, a_batch_number);
/* create  index a_batch_pk on a_batch (a_batch_number, a_ledger_number)*/ 
/* go */
create  index a_corr_batch_idx on a_batch (a_ledger_number, a_corrects_batch_number, a_batch_number);


/* a_transaction */
/* create  index a_transaction_pk on a_transaction (a_ledger_number, a_batch_number, a_journal_number, a_transaction_number)*/ 
/* go */
create  index a_trx_batch_idx on a_transaction (a_batch_number, a_ledger_number, a_journal_number, a_transaction_number);
/* create  index a_trx_cc_clustered_idx on a_transaction (a_cost_center, a_account_code, a_ledger_number, a_batch_number, a_journal_number, a_transaction_number)*/ 
/* go */
create  index a_trx_cc_quicksum_idx on a_transaction (a_ledger_number, a_cost_center, a_effective_date, a_posted, a_amount, a_batch_number, a_journal_number, a_transaction_number);
create  index a_trx_ccperiod_idx on a_transaction (a_ledger_number, a_cost_center, a_period, a_batch_number, a_journal_number, a_transaction_number);
create  index a_trx_donor_id_idx on a_transaction (p_ext_partner_id, a_ledger_number, a_batch_number, a_journal_number, a_transaction_number);
create  index a_trx_journal_idx on a_transaction (a_journal_number, a_ledger_number, a_batch_number, a_transaction_number);
create  index a_trx_period_idx on a_transaction (a_ledger_number, a_period, a_cost_center, a_batch_number, a_journal_number, a_transaction_number);
create  index a_trx_recip_id_idx on a_transaction (p_int_partner_id, a_ledger_number, a_batch_number, a_journal_number, a_transaction_number);
create  index a_trx_transaction_idx on a_transaction (a_transaction_number, a_ledger_number, a_batch_number, a_journal_number);


/* a_transaction_tmp */
/* create  index a_transaction_tmp_pk on a_transaction_tmp (a_ledger_number, a_batch_number, a_journal_number, a_transaction_number)*/ 
/* go */
create  index a_trxt_batch_idx on a_transaction_tmp (a_batch_number, a_ledger_number, a_journal_number, a_transaction_number);
/* create  index a_trxt_cc_clustered_idx on a_transaction_tmp (a_cost_center, a_account_code, a_ledger_number, a_batch_number, a_journal_number, a_transaction_number)*/ 
/* go */
create  index a_trxt_cc_quicksum_idx on a_transaction_tmp (a_ledger_number, a_cost_center, a_effective_date, a_posted, a_amount, a_batch_number, a_journal_number, a_transaction_number);
create  index a_trxt_donor_id_idx on a_transaction_tmp (p_ext_partner_id, a_ledger_number, a_batch_number, a_journal_number, a_transaction_number);
create  index a_trxt_journal_idx on a_transaction_tmp (a_journal_number, a_ledger_number, a_batch_number, a_transaction_number);
create  index a_trxt_recip_id_idx on a_transaction_tmp (p_int_partner_id, a_ledger_number, a_batch_number, a_journal_number, a_transaction_number);
create  index a_trxt_transaction_idx on a_transaction_tmp (a_transaction_number, a_ledger_number, a_batch_number, a_journal_number);


/* a_account_class */
/* create  index a_account_class_pk on a_account_class (a_account_class, a_ledger_number)*/ 
/* go */


/* a_cost_center_class */
/* create  index a_costctr_class_pk on a_cost_center_class (a_cost_center_class, a_ledger_number)*/ 
/* go */


/* a_reporting_level */
/* create  index a_level_pk on a_reporting_level (a_reporting_level, a_ledger_number)*/ 
/* go */


/* a_cost_center_prefix */
create  index a_cc_pfx_ledger_number_idx on a_cost_center_prefix (a_ledger_number, a_cost_center_prefix);
/* create  index a_cost_center_prefix_pk on a_cost_center_prefix (a_cost_center_prefix, a_ledger_number)*/ 
/* go */


/* a_cc_staff */
/* create  index a_cc_staff_pk on a_cc_staff (a_ledger_number, a_cost_center, p_staff_partner_key)*/ 
/* go */


/* a_ledger_office */
/* create  index a_lo_pk on a_ledger_office (a_ledger_number, p_office_partner_key)*/ 
/* go */


/* a_payroll */
create  index a_payroll_cc_idx on a_payroll (a_ledger_number, a_cost_center, a_payroll_group_id, a_payroll_id);
create  index a_payroll_payee_idx on a_payroll (a_ledger_number, p_payee_partner_key, a_payroll_group_id, a_payroll_id);
/* create  index a_payroll_pk on a_payroll (a_ledger_number, a_payroll_group_id, a_payroll_id)*/ 
/* go */


/* a_payroll_period */
create  index a_payperiod_idx on a_payroll_period (a_period, a_ledger_number, a_payroll_group_id, a_payroll_period);
/* create  index a_payperiod_pk on a_payroll_period (a_ledger_number, a_payroll_group_id, a_payroll_period)*/ 
/* go */


/* a_payroll_group */
/* create  index a_payroll_grp_pk on a_payroll_group (a_ledger_number, a_payroll_group_id)*/ 
/* go */


/* a_payroll_import */
create  index a_payrolli_cc_idx on a_payroll_import (a_ledger_number, a_cost_center, a_payroll_id);
create  index a_payrolli_payee_idx on a_payroll_import (a_ledger_number, p_payee_partner_key, a_payroll_id);
/* create  index a_payrolli_pk on a_payroll_import (a_payroll_id)*/ 
/* go */


/* a_payroll_item */
/* create  index a_payroll_i_pk on a_payroll_item (a_ledger_number, a_payroll_group_id, a_payroll_id, a_payroll_item_id)*/ 
/* go */


/* a_payroll_item_import */
/* create  index a_payrolli_i_pk on a_payroll_item_import (a_payroll_id, a_payroll_item_id)*/ 
/* go */


/* a_payroll_item_type */
/* create  index a_payroll_it_pk on a_payroll_item_type (a_ledger_number, a_payroll_item_type_code)*/ 
/* go */


/* a_payroll_item_class */
/* create  index a_payroll_ic_pk on a_payroll_item_class (a_payroll_item_class_code)*/ 
/* go */


/* a_payroll_form_group */
/* create  index a_payroll_f_pk on a_payroll_form_group (a_ledger_number, a_payroll_form_group_name, a_payroll_form_sequence)*/ 
/* go */


/* a_tax_filingstatus */
/* create  index a_filingstatus_pk on a_tax_filingstatus (a_ledger_number, a_payroll_item_type_code, a_filing_status)*/ 
/* go */


/* a_tax_table */
/* create  index a_taxtable_clustered_idx on a_tax_table (a_payroll_item_type, a_ledger_number, a_start_date, a_filing_status, a_payroll_interval, a_minimum_salary)*/ 
/* go */
/* create  index a_taxtable_pk on a_tax_table (a_tax_entry_id)*/ 
/* go */


/* a_tax_allowance_table */
/* create  index a_taxalltable_pk on a_tax_allowance_table (a_tax_allowance_entry_id)*/ 
/* go */


/* a_cc_admin_fee */
/* create  index a_cc_admin_fee_pk on a_cc_admin_fee (a_cost_center, a_ledger_number)*/ 
/* go */


/* a_admin_fee_type */
/* create  index a_admin_fee_type_pk on a_admin_fee_type (a_ledger_number, a_admin_fee_type, a_admin_fee_subtype)*/ 
/* go */


/* a_admin_fee_type_tmp */
/* create  index a_admin_fee_type_tmp_pk on a_admin_fee_type_tmp (a_ledger_number, a_admin_fee_type, a_admin_fee_subtype)*/ 
/* go */


/* a_admin_fee_type_item */
/* create  index a_admin_fee_type_item_pk on a_admin_fee_type_item (a_ledger_number, a_admin_fee_type, a_admin_fee_subtype, a_dest_cost_center)*/ 
/* go */
create  index a_afti_ledger_number_idx on a_admin_fee_type_item (a_ledger_number, a_dest_cost_center, a_admin_fee_type, a_admin_fee_subtype);


/* a_admin_fee_type_item_tmp */
/* create  index a_admin_fee_type_item_tmp_pk on a_admin_fee_type_item_tmp (a_ledger_number, a_admin_fee_type, a_admin_fee_subtype, a_dest_cost_center)*/ 
/* go */
create  index a_afti_tmp_ledger_number_idx on a_admin_fee_type_item_tmp (a_ledger_number, a_dest_cost_center, a_admin_fee_type, a_admin_fee_subtype);


/* a_cc_receipting */
/* create  index a_cc_receipting_pk on a_cc_receipting (a_cost_center, a_ledger_number)*/ 
/* go */
create  index a_ccr_ledger_number_idx on a_cc_receipting (a_ledger_number, a_cost_center);


/* a_cc_receipting_accts */
/* create  index a_cc_rcptacct_pk on a_cc_receipting_accts (a_cost_center, a_ledger_number,a_account_code)*/ 
/* go */
create  index a_ccra_acct_number_idx on a_cc_receipting_accts (a_ledger_number, a_account_code, a_cost_center);
create  index a_ccra_ledger_number_idx on a_cc_receipting_accts (a_ledger_number, a_cost_center, a_account_code);


/* a_receipt_type */
/* create  index a_rcpttype_pk on a_receipt_type (a_receipt_type)*/ 
/* go */


/* a_subtrx_gift */
create  index a_gifttrx_batch_idx on a_subtrx_gift (a_batch_number, a_ledger_number, a_gift_number);
/* create  index a_gifttrx_cc_clustered_idx on a_subtrx_gift (a_cost_center, a_account_code, a_ledger_number, a_batch_number, a_gift_number)*/ 
/* go */
create  index a_gifttrx_donor_id_idx on a_subtrx_gift (p_donor_partner_id, a_ledger_number, a_batch_number, a_gift_number);
create  index a_gifttrx_gift_idx on a_subtrx_gift (a_gift_number, a_ledger_number, a_batch_number);
/* create  index a_gifttrx_pk on a_subtrx_gift (a_ledger_number, a_batch_number, a_gift_number)*/ 
/* go */
create  index a_gifttrx_recip_id_idx on a_subtrx_gift (p_recip_partner_id, a_ledger_number, a_batch_number, a_gift_number);


/* a_subtrx_gift_group */
create  index a_gifttrxgrp_batch_idx on a_subtrx_gift_group (a_batch_number, a_ledger_number, a_gift_number);
create  index a_gifttrxgrp_donor_id_idx on a_subtrx_gift_group (p_donor_partner_id, a_ledger_number, a_batch_number, a_gift_number);
create  index a_gifttrxgrp_gift_idx on a_subtrx_gift_group (a_gift_number, a_ledger_number, a_batch_number);
/* create  index a_gifttrxgrp_pk on a_subtrx_gift_group (a_ledger_number, a_batch_number, a_gift_number)*/ 
/* go */


/* a_subtrx_gift_item */
/* create  index a_gifttrx_pk on a_subtrx_gift_item (a_ledger_number, a_batch_number, a_gift_number, a_split_number)*/ 
/* go */
/* create  index a_gifttrxi_cc_clustered_idx on a_subtrx_gift_item (a_cost_center, a_account_code, a_ledger_number, a_batch_number, a_gift_number, a_split_number)*/ 
/* go */
create  index a_gifttrxi_donor_idx on a_subtrx_gift_item (p_dn_donor_partner_id, a_ledger_number, a_batch_number, a_gift_number, a_split_number);
create  index a_gifttrxi_gift_idx on a_subtrx_gift_item (a_gift_number, a_ledger_number, a_batch_number, a_split_number);
create  index a_gifttrxi_mcode_idx on a_subtrx_gift_item (a_motivational_code, a_ledger_number, a_batch_number, a_gift_number, a_split_number);
create  index a_gifttrxi_rcpt_idx on a_subtrx_gift_item (a_dn_receipt_number, a_ledger_number, a_batch_number, a_gift_number, a_split_number);
create  index a_gifttrxi_recip_id_idx on a_subtrx_gift_item (p_recip_partner_id, a_ledger_number, a_batch_number, a_gift_number, a_split_number);


/* a_subtrx_gift_rcptcnt */
/* create  index a_rcptno_pk on a_subtrx_gift_rcptcnt (a_ledger_number)*/ 
/* go */


/* a_cc_auto_subscribe */
create  index a_cc_as_ledger_number_idx on a_cc_auto_subscribe (a_ledger_number, a_cost_center, m_list_code);
create  index a_cc_as_listcode_idx on a_cc_auto_subscribe (m_list_code, a_cost_center, a_ledger_number);
/* create  index a_cc_auto_subscribe_pk on a_cc_auto_subscribe (a_cost_center, a_ledger_number, m_list_code)*/ 
/* go */


/* a_motivational_code */
create  index a_motiv_code_cc on a_motivational_code (a_ledger_number, a_cost_center, a_account_code, a_motivational_code);
create  index a_motiv_code_list on a_motivational_code (m_list_code, a_ledger_number, a_motivational_code);
create  index a_motiv_code_parent on a_motivational_code (a_ledger_number, a_parent_motivational_code, a_motivational_code);
/* create  index a_motivational_code_pk on a_motivational_code (a_ledger_number, a_motivational_code)*/ 
/* go */


/* a_subtrx_cashdisb */
create  index a_subtrx_cashdisb_acct_idx on a_subtrx_cashdisb (a_cash_account_code, a_ledger_number, a_batch_number, a_disbursement_id, a_line_item);
create  index a_subtrx_cashdisb_batch_idx on a_subtrx_cashdisb (a_batch_number, a_ledger_number, a_disbursement_id, a_line_item);
/* create  index a_subtrx_cashdisb_pk on a_subtrx_cashdisb (a_ledger_number, a_batch_number, a_disbursement_id, a_line_item)*/ 
/* go */


/* a_subtrx_xfer */
/* create  index a_subtrx_xfer_pk on a_subtrx_xfer (a_ledger_number, a_batch_number, a_journal_number)*/ 
/* go */


/* a_subtrx_deposit */
create  index a_subtrx_dep_acct_idx on a_subtrx_deposit (a_account_code, a_ledger_number, a_batch_number);
create  index a_subtrx_dep_batch_idx on a_subtrx_deposit (a_batch_number, a_ledger_number);
/* create  index a_subtrx_deposit_pk on a_subtrx_deposit (a_ledger_number, a_batch_number)*/ 
/* go */


/* a_subtrx_cashxfer */
/* create  index a_subtrx_cashxfer_pk on a_subtrx_cashxfer (a_ledger_number, a_batch_number, a_journal_number)*/ 
/* go */


/* c_message */
/* create  index c_message_pk on c_message (c_chat_id, c_message_id)*/ 
/* go */


/* c_chat */
/* create  index c_chat_pk on c_chat (c_chat_id)*/ 
/* go */
create  index c_public_idx on c_chat (c_public, c_chat_id);


/* c_member */
/* create  index c_member_pk on c_member (c_chat_id, s_username)*/ 
/* go */
create  index s_username_idx on c_member (s_username, c_chat_id);


/* s_user_data */
/* create  index s_user_data_pk on s_user_data (s_username)*/ 
/* go */


/* s_user_loginhistory */
/* create  index s_loginhist_pk on s_user_loginhistory (s_username, s_sessionid)*/ 
/* go */


/* s_subsystem */
/* create  index s_subsystem_pk on s_subsystem (s_subsystem_code)*/ 
/* go */


/* s_process */
/* create  index s_process_pk on s_process (s_subsystem_code, s_process_code)*/ 
/* go */


/* s_process_status */
/* create  index s_procstat_pk on s_process_status (s_subsystem_code, s_process_code, s_process_status_code)*/ 
/* go */


/* s_motd */
/* create  index s_motd_pk on s_motd (s_motd_id)*/ 
/* go */


/* s_motd_viewed */
/* create  index s_motd_viewed_pk on s_motd_viewed (s_motd_id, s_username)*/ 
/* go */
create  index s_motd_viewed_username_idx on s_motd_viewed (s_username, s_motd_id);


/* s_sec_endorsement */
/* create  index s_end_pk on s_sec_endorsement (s_endorsement, s_context, s_subject)*/ 
/* go */


/* s_sec_endorsement_type */
/* create  index s_endt_pk on s_sec_endorsement_type (s_endorsement)*/ 
/* go */


/* s_sec_endorsement_context */
/* create  index s_endc_pk on s_sec_endorsement_context (s_context)*/ 
/* go */


/* s_mykardia */
/* create  index s_myk_pk on s_mykardia (s_username, s_module, s_plugin, s_occurrence)*/ 
/* go */


/* s_request */
create  index s_objkey12_idx on s_request (s_object_key_1, s_object_key_2, s_request_id);
create  index s_objkey21_idx on s_request (s_object_key_2, s_object_key_1, s_request_id);
/* create  index s_req_pk on s_request (s_request_id)*/ 
/* go */


/* s_request_type */
/* create  index s_reqtype_pk on s_request_type (s_request_type)*/ 
/* go */


/* s_audit */
create  index s_audit_intval_idx on s_audit (s_table, s_attrname, s_valueint, s_key, s_sequence);
create  index s_audit_name_idx on s_audit (s_table, s_key, s_attrname, s_sequence);
/* create  index s_audit_pk on s_audit (s_sequence)*/ 
/* go */
create  index s_audit_strval_idx on s_audit (s_table, s_attrname, s_valuestring, s_key, s_sequence);
