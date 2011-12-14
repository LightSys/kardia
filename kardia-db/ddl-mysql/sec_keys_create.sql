use Kardia_DB;


alter table p_partner
	add constraint p_given_name_idx unique  (p_given_name, p_partner_key);

alter table p_partner
	add constraint p_org_name_idx unique  (p_org_name, p_partner_key);

alter table p_partner
	add constraint p_legacy_key_1_idx unique  (p_legacy_key_1, p_partner_key);

alter table p_partner
	add constraint p_legacy_key_2_idx unique  (p_legacy_key_2, p_partner_key);

alter table p_partner
	add constraint p_parent_key_idx unique  (p_parent_key, p_partner_key);

alter table p_partner
	add constraint p_cost_ctr_idx unique  (p_cost_center, p_partner_key);

alter table p_partner
	add constraint p_merged_with_idx unique  (p_merged_with, p_partner_key);

alter table p_location
	add constraint p_location_state_idx unique  (p_state_province, p_postal_code, p_partner_key, p_location_id, p_revision_id);

alter table p_location
	add constraint p_location_zip_idx unique  (p_postal_code, p_state_province, p_partner_key, p_location_id, p_revision_id);

alter table p_location
	add constraint p_location_city_idx unique  (p_city, p_state_province, p_partner_key, p_location_id, p_revision_id);

alter table p_staff
	add constraint p_staff_login_idx unique  (p_kardia_login, p_partner_key);

alter table p_staff
	add constraint p_staff_weblogin_idx unique  (p_kardiaweb_login, p_partner_key);

alter table r_group
	add constraint r_grp_modfile_idx unique  (r_group_module, r_group_file, r_group_name);

alter table r_group_param
	add constraint r_param_cmp_idx unique  (r_param_cmp_module, r_param_cmp_file, r_group_name, r_param_name);

alter table a_cost_center
	add constraint a_cc_parent_idx unique  (a_parent_cost_center, a_cost_center, a_ledger_number);

alter table a_cost_center
	add constraint a_cc_legacy_idx unique  (a_legacy_code, a_cost_center, a_ledger_number);

alter table a_cost_center
	add constraint a_cc_bal_idx unique  (a_bal_cost_center, a_cost_center, a_ledger_number);

alter table a_account
	add constraint a_acct_parent_idx unique  (a_parent_account_code, a_account_code, a_ledger_number);

alter table a_account
	add constraint a_acct_legacy_idx unique  (a_legacy_code, a_account_code, a_ledger_number);

alter table a_transaction
	add constraint a_trx_donor_id_idx unique  (p_ext_partner_id, a_ledger_number, a_batch_number, a_journal_number, a_transaction_number);

alter table a_transaction
	add constraint a_trx_recip_id_idx unique  (p_int_partner_id, a_ledger_number, a_batch_number, a_journal_number, a_transaction_number);

alter table a_transaction_tmp
	add constraint a_trxt_donor_id_idx unique  (p_ext_partner_id, a_ledger_number, a_batch_number, a_journal_number, a_transaction_number);

alter table a_transaction_tmp
	add constraint a_trxt_recip_id_idx unique  (p_int_partner_id, a_ledger_number, a_batch_number, a_journal_number, a_transaction_number);

alter table a_payroll_import
	add constraint a_payrolli_payee_idx unique  (a_ledger_number, p_payee_partner_key, a_payroll_id);

alter table a_payroll_import
	add constraint a_payrolli_cc_idx unique  (a_ledger_number, a_cost_center, a_payroll_id);

alter table a_subtrx_gift
	add constraint a_gifttrx_donor_id_idx unique  (p_donor_partner_id, a_ledger_number, a_batch_number, a_gift_number);

alter table a_subtrx_gift
	add constraint a_gifttrx_recip_id_idx unique  (p_recip_partner_id, a_ledger_number, a_batch_number, a_gift_number);

alter table a_subtrx_gift_group
	add constraint a_gifttrxgrp_donor_id_idx unique  (p_donor_partner_id, a_ledger_number, a_batch_number, a_gift_number);

alter table a_subtrx_gift_item
	add constraint a_gifttrxi_recip_id_idx unique  (p_recip_partner_id, a_ledger_number, a_batch_number, a_gift_number, a_split_number);

alter table a_subtrx_gift_item
	add constraint a_gifttrxi_mcode_idx unique  (a_motivational_code, a_ledger_number, a_batch_number, a_gift_number, a_split_number);

alter table a_motivational_code
	add constraint a_motiv_code_list unique  (m_list_code, a_ledger_number, a_motivational_code);

alter table a_subtrx_cashdisb
	add constraint a_subtrx_cashdisb_acct_idx unique  (a_cash_account_code, a_ledger_number, a_batch_number, a_disbursement_id, a_line_item);

alter table a_subtrx_deposit
	add constraint a_subtrx_dep_acct_idx unique  (a_account_code, a_ledger_number, a_batch_number);

alter table c_chat
	add constraint c_public_idx unique  (c_public, c_chat_id);
