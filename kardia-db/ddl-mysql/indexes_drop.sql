use Kardia_DB;



/* p_partner */
alter table p_partner drop index p_cost_ctr_idx;
alter table p_partner drop index p_given_name_idx;
alter table p_partner drop index p_legacy_key_1_idx;
alter table p_partner drop index p_legacy_key_2_idx;
alter table p_partner drop index p_merged_with_idx;
alter table p_partner drop index p_org_name_idx;
alter table p_partner drop index p_parent_key_idx;
/* drop index p_partner.p_partner_pk */ 
/* go */
/* drop index p_partner.p_surname_clustered_idx */ 
/* go */


/* p_partner_key_cnt */
/* drop index p_partner_key_cnt.p_partner_key_cnt_pk */ 
/* go */


/* p_person */
/* drop index p_person.p_person_clustered_pk */ 
/* go */


/* p_location */
alter table p_location drop index p_location_city_idx;
/* drop index p_location.p_location_pk */ 
/* go */
alter table p_location drop index p_location_rev_idx;
alter table p_location drop index p_location_state_idx;
alter table p_location drop index p_location_zip_idx;
/* drop index p_location.p_postal_sort_clustered_idx */ 
/* go */


/* p_address_format */
alter table p_address_format drop index p_af_country_idx;
/* drop index p_address_format.p_af_pk */ 
/* go */


/* p_address_format_set */
/* drop index p_address_format_set.p_afs_pk */ 
/* go */


/* p_contact_info */
/* drop index p_contact_info.p_contact_info_pk */ 
/* go */


/* p_partner_relationship */
/* drop index p_partner_relationship.p_partner_relationship_pk */ 
/* go */


/* p_church */
/* drop index p_church.p_church_pk */ 
/* go */


/* p_donor */
alter table p_donor drop index p_dnr_gl_acct_idx;
/* drop index p_donor.p_donor_pk */ 
/* go */


/* p_payee */
alter table p_payee drop index p_gl_acct_idx;
/* drop index p_payee.p_payee_pk */ 
/* go */


/* p_staff */
alter table p_staff drop index p_staff_login_idx;
/* drop index p_staff.p_staff_pk */ 
/* go */
alter table p_staff drop index p_staff_weblogin_idx;


/* p_bulk_postal_code */
/* drop index p_bulk_postal_code.p_bulk_code_pk */ 
/* go */


/* p_zipranges */
/* drop index p_zipranges.p_bulk_code_pk */ 
/* go */


/* p_country */
/* drop index p_country.p_country_code_pk */ 
/* go */


/* p_banking_details */
/* drop index p_banking_details.p_banking_details_pk */ 
/* go */


/* p_title */
/* drop index p_title.p_title_pk */ 
/* go */


/* p_gazetteer */
alter table p_gazetteer drop index p_gaz_altid_idx;
alter table p_gazetteer drop index p_gaz_id_idx;
/* drop index p_gazetteer.p_gaz_name_clustered_idx */ 
/* go */
alter table p_gazetteer drop index p_gaz_state_idx;
alter table p_gazetteer drop index p_gaz_type_idx;
/* drop index p_gazetteer.p_gazetteer_pk */ 
/* go */


/* p_dup_check_tmp */
alter table p_dup_check_tmp drop index p_dc_username_idx;
/* drop index p_dup_check_tmp.p_dupcheck_pk */ 
/* go */


/* p_partner_sort_tmp */
/* drop index p_partner_sort_tmp.p_sort_pk */ 
/* go */


/* m_list */
/* drop index m_list.m_list_pk */ 
/* go */


/* m_list_membership */
/* drop index m_list_membership.m_list_membership_clustered_pk */ 
/* go */
alter table m_list_membership drop index m_lists_by_partner;


/* r_group */
alter table r_group drop index r_grp_modfile_idx;
/* drop index r_group.r_grp_pk */ 
/* go */


/* r_group_report */
alter table r_group_report drop index r_rpt_partner_idx;
/* drop index r_group_report.r_rpt_pk */ 
/* go */


/* r_group_param */
alter table r_group_param drop index r_param_cmp_idx;
/* drop index r_group_param.r_param_pk */ 
/* go */


/* r_group_report_param */
alter table r_group_report_param drop index r_rparam_param_idx;
alter table r_group_report_param drop index r_rparam_partner_idx;
/* drop index r_group_report_param.r_rparam_pk */ 
/* go */
alter table r_group_report_param drop index r_rparam_value_idx;


/* r_saved_paramset */
alter table r_saved_paramset drop index r_ps_modfile_idx;
/* drop index r_saved_paramset.r_ps_pk */ 
/* go */


/* r_saved_param */
/* drop index r_saved_param.r_psparam_pk */ 
/* go */


/* a_config */
/* drop index a_config.a_config_pk */ 
/* go */


/* a_analysis_attr */
/* drop index a_analysis_attr.a_an_attr_pk */ 
/* go */


/* a_analysis_attr_value */
/* drop index a_analysis_attr_value.a_an_attr_val_pk */ 
/* go */


/* a_cc_analysis_attr */
/* drop index a_cc_analysis_attr.a_cc_an_attr_pk */ 
/* go */


/* a_acct_analysis_attr */
/* drop index a_acct_analysis_attr.a_acct_an_attr_pk */ 
/* go */


/* a_cost_center */
alter table a_cost_center drop index a_cc_bal_idx;
alter table a_cost_center drop index a_cc_ledger_number_idx;
alter table a_cost_center drop index a_cc_legacy_idx;
alter table a_cost_center drop index a_cc_parent_idx;
/* drop index a_cost_center.a_cost_center_pk */ 
/* go */


/* a_account */
/* drop index a_account.a_account_pk */ 
/* go */
alter table a_account drop index a_acct_ledger_number_idx;
alter table a_account drop index a_acct_legacy_idx;
alter table a_account drop index a_acct_parent_idx;


/* a_account_usage */
/* drop index a_account_usage.a_account_usage_pk */ 
/* go */
alter table a_account_usage drop index a_acctusg_acct_idx;
alter table a_account_usage drop index a_acctusg_ledger_number_idx;


/* a_account_usage_type */
/* drop index a_account_usage_type.a_account_usage_type_pk */ 
/* go */


/* a_account_category */
/* drop index a_account_category.a_account_category_pk */ 
/* go */


/* a_cc_acct */
/* drop index a_cc_acct.a_cc_acct_pk */ 
/* go */


/* a_period */
/* drop index a_period.a_period_pk */ 
/* go */


/* a_period_usage */
/* drop index a_period_usage.a_account_usage_pk */ 
/* go */


/* a_period_usage_type */
/* drop index a_period_usage_type.a_period_usage_type_pk */ 
/* go */


/* a_ledger */
/* drop index a_ledger.a_ledger_pk */ 
/* go */


/* a_batch */
alter table a_batch drop index a_batch_ledger_idx;
/* drop index a_batch.a_batch_pk */ 
/* go */
alter table a_batch drop index a_corr_batch_idx;


/* a_transaction */
/* drop index a_transaction.a_transaction_pk */ 
/* go */
alter table a_transaction drop index a_trx_batch_idx;
/* drop index a_transaction.a_trx_cc_clustered_idx */ 
/* go */
alter table a_transaction drop index a_trx_cc_quicksum_idx;
alter table a_transaction drop index a_trx_ccperiod_idx;
alter table a_transaction drop index a_trx_donor_id_idx;
alter table a_transaction drop index a_trx_journal_idx;
alter table a_transaction drop index a_trx_period_idx;
alter table a_transaction drop index a_trx_recip_id_idx;
alter table a_transaction drop index a_trx_transaction_idx;


/* a_transaction_tmp */
/* drop index a_transaction_tmp.a_transaction_tmp_pk */ 
/* go */
alter table a_transaction_tmp drop index a_trxt_batch_idx;
/* drop index a_transaction_tmp.a_trxt_cc_clustered_idx */ 
/* go */
alter table a_transaction_tmp drop index a_trxt_cc_quicksum_idx;
alter table a_transaction_tmp drop index a_trxt_donor_id_idx;
alter table a_transaction_tmp drop index a_trxt_journal_idx;
alter table a_transaction_tmp drop index a_trxt_recip_id_idx;
alter table a_transaction_tmp drop index a_trxt_transaction_idx;


/* a_account_class */
/* drop index a_account_class.a_account_class_pk */ 
/* go */


/* a_cost_center_class */
/* drop index a_cost_center_class.a_costctr_class_pk */ 
/* go */


/* a_reporting_level */
/* drop index a_reporting_level.a_level_pk */ 
/* go */


/* a_cost_center_prefix */
alter table a_cost_center_prefix drop index a_cc_pfx_ledger_number_idx;
/* drop index a_cost_center_prefix.a_cost_center_prefix_pk */ 
/* go */


/* a_cc_staff */
/* drop index a_cc_staff.a_cc_staff_pk */ 
/* go */


/* a_ledger_office */
/* drop index a_ledger_office.a_lo_pk */ 
/* go */


/* a_payroll */
alter table a_payroll drop index a_payroll_cc_idx;
alter table a_payroll drop index a_payroll_payee_idx;
/* drop index a_payroll.a_payroll_pk */ 
/* go */


/* a_payroll_period */
alter table a_payroll_period drop index a_payperiod_idx;
/* drop index a_payroll_period.a_payperiod_pk */ 
/* go */


/* a_payroll_group */
/* drop index a_payroll_group.a_payroll_grp_pk */ 
/* go */


/* a_payroll_import */
alter table a_payroll_import drop index a_payrolli_cc_idx;
alter table a_payroll_import drop index a_payrolli_payee_idx;
/* drop index a_payroll_import.a_payrolli_pk */ 
/* go */


/* a_payroll_item */
/* drop index a_payroll_item.a_payroll_i_pk */ 
/* go */


/* a_payroll_item_import */
/* drop index a_payroll_item_import.a_payrolli_i_pk */ 
/* go */


/* a_payroll_item_type */
/* drop index a_payroll_item_type.a_payroll_it_pk */ 
/* go */


/* a_payroll_item_class */
/* drop index a_payroll_item_class.a_payroll_ic_pk */ 
/* go */


/* a_payroll_form_group */
/* drop index a_payroll_form_group.a_payroll_f_pk */ 
/* go */


/* a_tax_filingstatus */
/* drop index a_tax_filingstatus.a_filingstatus_pk */ 
/* go */


/* a_tax_table */
/* drop index a_tax_table.a_taxtable_clustered_idx */ 
/* go */
/* drop index a_tax_table.a_taxtable_pk */ 
/* go */


/* a_tax_allowance_table */
/* drop index a_tax_allowance_table.a_taxalltable_pk */ 
/* go */


/* a_cc_admin_fee */
/* drop index a_cc_admin_fee.a_cc_admin_fee_pk */ 
/* go */


/* a_admin_fee_type */
/* drop index a_admin_fee_type.a_admin_fee_type_pk */ 
/* go */


/* a_admin_fee_type_tmp */
/* drop index a_admin_fee_type_tmp.a_admin_fee_type_tmp_pk */ 
/* go */


/* a_admin_fee_type_item */
/* drop index a_admin_fee_type_item.a_admin_fee_type_item_pk */ 
/* go */
alter table a_admin_fee_type_item drop index a_afti_ledger_number_idx;


/* a_admin_fee_type_item_tmp */
/* drop index a_admin_fee_type_item_tmp.a_admin_fee_type_item_tmp_pk */ 
/* go */
alter table a_admin_fee_type_item_tmp drop index a_afti_tmp_ledger_number_idx;


/* a_cc_receipting */
/* drop index a_cc_receipting.a_cc_receipting_pk */ 
/* go */
alter table a_cc_receipting drop index a_ccr_ledger_number_idx;


/* a_cc_receipting_accts */
/* drop index a_cc_receipting_accts.a_cc_rcptacct_pk */ 
/* go */
alter table a_cc_receipting_accts drop index a_ccra_acct_number_idx;
alter table a_cc_receipting_accts drop index a_ccra_ledger_number_idx;


/* a_receipt_type */
/* drop index a_receipt_type.a_rcpttype_pk */ 
/* go */


/* a_subtrx_gift */
alter table a_subtrx_gift drop index a_gifttrx_batch_idx;
/* drop index a_subtrx_gift.a_gifttrx_cc_clustered_idx */ 
/* go */
alter table a_subtrx_gift drop index a_gifttrx_donor_id_idx;
alter table a_subtrx_gift drop index a_gifttrx_gift_idx;
/* drop index a_subtrx_gift.a_gifttrx_pk */ 
/* go */
alter table a_subtrx_gift drop index a_gifttrx_recip_id_idx;


/* a_subtrx_gift_group */
alter table a_subtrx_gift_group drop index a_gifttrxgrp_batch_idx;
alter table a_subtrx_gift_group drop index a_gifttrxgrp_donor_id_idx;
alter table a_subtrx_gift_group drop index a_gifttrxgrp_gift_idx;
/* drop index a_subtrx_gift_group.a_gifttrxgrp_pk */ 
/* go */


/* a_subtrx_gift_item */
/* drop index a_subtrx_gift_item.a_gifttrx_pk */ 
/* go */
/* drop index a_subtrx_gift_item.a_gifttrxi_cc_clustered_idx */ 
/* go */
alter table a_subtrx_gift_item drop index a_gifttrxi_donor_idx;
alter table a_subtrx_gift_item drop index a_gifttrxi_gift_idx;
alter table a_subtrx_gift_item drop index a_gifttrxi_mcode_idx;
alter table a_subtrx_gift_item drop index a_gifttrxi_rcpt_idx;
alter table a_subtrx_gift_item drop index a_gifttrxi_recip_id_idx;


/* a_subtrx_gift_rcptcnt */
/* drop index a_subtrx_gift_rcptcnt.a_rcptno_pk */ 
/* go */


/* a_cc_auto_subscribe */
alter table a_cc_auto_subscribe drop index a_cc_as_ledger_number_idx;
alter table a_cc_auto_subscribe drop index a_cc_as_listcode_idx;
/* drop index a_cc_auto_subscribe.a_cc_auto_subscribe_pk */ 
/* go */


/* a_motivational_code */
alter table a_motivational_code drop index a_motiv_code_cc;
alter table a_motivational_code drop index a_motiv_code_list;
alter table a_motivational_code drop index a_motiv_code_parent;
/* drop index a_motivational_code.a_motivational_code_pk */ 
/* go */


/* a_subtrx_cashdisb */
alter table a_subtrx_cashdisb drop index a_subtrx_cashdisb_acct_idx;
alter table a_subtrx_cashdisb drop index a_subtrx_cashdisb_batch_idx;
/* drop index a_subtrx_cashdisb.a_subtrx_cashdisb_pk */ 
/* go */


/* a_subtrx_xfer */
/* drop index a_subtrx_xfer.a_subtrx_xfer_pk */ 
/* go */


/* a_subtrx_deposit */
alter table a_subtrx_deposit drop index a_subtrx_dep_acct_idx;
alter table a_subtrx_deposit drop index a_subtrx_dep_batch_idx;
/* drop index a_subtrx_deposit.a_subtrx_deposit_pk */ 
/* go */


/* a_subtrx_cashxfer */
/* drop index a_subtrx_cashxfer.a_subtrx_cashxfer_pk */ 
/* go */


/* i_eg_gift_import */
alter table i_eg_gift_import drop index i_eg_edonor_idx;
alter table i_eg_gift_import drop index i_eg_efund_idx;
alter table i_eg_gift_import drop index i_eg_egift_idx;
/* drop index i_eg_gift_import.i_eg_gift_import_pk */ 
/* go */
alter table i_eg_gift_import drop index i_eg_kbatch_idx;
alter table i_eg_gift_import drop index i_eg_kdonor_idx;
alter table i_eg_gift_import drop index i_eg_kfund_idx;


/* c_message */
/* drop index c_message.c_message_pk */ 
/* go */


/* c_chat */
/* drop index c_chat.c_chat_pk */ 
/* go */
alter table c_chat drop index c_public_idx;


/* c_member */
/* drop index c_member.c_member_pk */ 
/* go */
alter table c_member drop index s_username_idx;


/* s_user_data */
/* drop index s_user_data.s_user_data_pk */ 
/* go */


/* s_user_loginhistory */
/* drop index s_user_loginhistory.s_loginhist_pk */ 
/* go */


/* s_subsystem */
/* drop index s_subsystem.s_subsystem_pk */ 
/* go */


/* s_process */
/* drop index s_process.s_process_pk */ 
/* go */


/* s_process_status */
/* drop index s_process_status.s_procstat_pk */ 
/* go */


/* s_motd */
/* drop index s_motd.s_motd_pk */ 
/* go */


/* s_motd_viewed */
/* drop index s_motd_viewed.s_motd_viewed_pk */ 
/* go */
alter table s_motd_viewed drop index s_motd_viewed_username_idx;


/* s_sec_endorsement */
/* drop index s_sec_endorsement.s_end_pk */ 
/* go */


/* s_sec_endorsement_type */
/* drop index s_sec_endorsement_type.s_endt_pk */ 
/* go */


/* s_sec_endorsement_context */
/* drop index s_sec_endorsement_context.s_endc_pk */ 
/* go */


/* s_mykardia */
/* drop index s_mykardia.s_myk_pk */ 
/* go */


/* s_request */
alter table s_request drop index s_objkey12_idx;
alter table s_request drop index s_objkey21_idx;
/* drop index s_request.s_req_pk */ 
/* go */


/* s_request_type */
/* drop index s_request_type.s_reqtype_pk */ 
/* go */


/* s_audit */
alter table s_audit drop index s_audit_intval_idx;
alter table s_audit drop index s_audit_name_idx;
/* drop index s_audit.s_audit_pk */ 
/* go */
alter table s_audit drop index s_audit_strval_idx;
