use Kardia_DB;


-- RA
update ra set a='a_fund', b='Funds', c=':a_fund_desc' where a='a_cost_center';
update ra set a='a_fund_prefix', b='Fund Prefixes', c=':a_fund_prefix_desc' where a='a_cost_center_prefix';

-- Table names
rename table a_cost_center to a_fund;
rename table a_cost_center_prefix to a_fund_prefix;
rename table a_cost_center_class to a_fund_class;
rename table a_cc_analysis_attr to a_fund_analysis_attr;
rename table a_cc_acct to a_fund_acct;
rename table a_cc_staff to a_fund_staff;
rename table a_cc_admin_fee to a_fund_admin_fee;
rename table a_cc_receipting to a_fund_receipting;
rename table a_cc_receipting_accts to a_fund_receipting_accts;
rename table a_cc_auto_subscribe to a_fund_auto_subscribe;

-- Column names
alter table p_partner change column p_cost_center a_fund varchar(20)  null;
alter table a_analysis_attr change column a_cc_enab a_fund_enab bit not null;
alter table a_fund_analysis_attr change column a_cost_center a_fund char(20) not null;
alter table a_fund change column a_cost_center a_fund char(20) not null;
alter table a_fund change column a_parent_cost_center a_parent_fund char(20) null;
alter table a_fund change column a_bal_cost_center a_bal_fund char(20) not null;
alter table a_fund change column a_cost_center_class a_fund_class char(3) null;
alter table a_fund change column a_cc_desc a_fund_desc char(32) null;
alter table a_fund change column a_cc_comments a_fund_comments varchar(255) null;
alter table a_fund_acct change column a_cost_center a_fund char(20) not null;
alter table a_fund_acct change column a_cc_acct_class a_fund_acct_class char(3) null;
alter table a_transaction change column a_cost_center a_fund char(20) not null;
alter table a_transaction_tmp change column a_cost_center a_fund char(20) not null;
alter table a_fund_class change column a_cost_center_class a_fund_class char(3) not null;
alter table a_fund_class change column a_acct_class_desc a_fund_class_desc varchar(255) not null;
alter table a_fund_prefix change column a_cost_center_prefix a_fund_prefix char(20) not null;
alter table a_fund_prefix change column a_cc_prefix_desc a_fund_prefix_desc char(32) null;
alter table a_fund_prefix change column a_cc_prefix_comments a_fund_prefix_comments varchar(255) null;
alter table a_fund_staff change column a_cost_center a_fund char(20) not null;
alter table a_payroll change column a_cost_center a_fund char(20) not null;
alter table a_payroll_group change column a_cost_center a_fund char(20) not null;
alter table a_payroll_group change column a_liab_cost_center a_liab_fund char(20) null;
alter table a_payroll_group change column a_cash_cost_center a_cash_fund char(20) null;
alter table a_payroll_import change column a_cost_center a_fund char(20) not null;
alter table a_payroll_item change column a_ref_cost_center a_ref_fund char(20) null;
alter table a_payroll_item change column a_xfer_cost_center a_xfer_fund char(20) null;
alter table a_payroll_item_import change column a_ref_cost_center a_ref_fund char(20) null;
alter table a_payroll_item_import change column a_xfer_cost_center a_xfer_fund char(20) null;
alter table a_payroll_item_type change column a_xfer_cost_center a_xfer_fund char(20) null;
alter table a_fund_admin_fee change column a_cost_center a_fund char(20) not null;
alter table a_admin_fee_type_item change column a_dest_cost_center a_dest_fund char(20) not null;
alter table a_admin_fee_type_item_tmp change column a_dest_cost_center a_dest_fund char(20) not null;
alter table a_fund_receipting change column a_cost_center a_fund char(20) not null;
alter table a_fund_receipting_accts change column a_cost_center a_fund char(20) not null;
alter table a_gift_payment_type change column a_payment_cost_center a_payment_fund char(20) null;
alter table a_subtrx_gift change column a_cost_center a_fund char(20) not null;
alter table a_subtrx_gift_item change column a_cost_center a_fund char(20) not null;
alter table a_subtrx_gift_intent change column a_cost_center a_fund char(20) null;
alter table a_fund_auto_subscribe change column a_cost_center a_fund char(20) not null;
alter table a_motivational_code change column a_cost_center a_fund varchar(20) null;
alter table a_giving_pattern change column a_cost_center a_fund char(20) not null;
alter table a_giving_pattern change column a_actual_cost_center a_actual_fund char(20) null;
alter table a_giving_pattern_allocation change column a_cost_center a_fund char(20) not null;
alter table a_giving_pattern_allocation change column a_actual_cost_center a_actual_fund char(20) not null;
alter table a_giving_pattern_flag change column a_cost_center a_fund char(20) not null;
alter table a_funding_target change column a_cost_center a_fund char(20) not null;
alter table a_support_review_target change column a_cost_center a_fund char(20) not null;
alter table a_descriptives change column a_cost_center a_fund char(20) not null;
alter table a_descriptives_hist change column a_cost_center a_fund char(20) not null;
alter table a_pledge change column a_cost_center a_fund char(20) null;
alter table a_subtrx_cashdisb change column a_cost_center a_fund char(20) not null;
alter table a_subtrx_payable_item change column a_cost_center a_fund char(20) not null;
alter table a_subtrx_payable_item change column a_liab_cost_center a_liab_fund char(20) not null;
alter table a_subtrx_xfer change column a_source_cost_center a_source_fund char(20) not null;
alter table a_subtrx_xfer change column a_dest_cost_center a_dest_fund char(20) not null;
alter table a_subtrx_cashxfer change column a_cost_center a_fund char(20) not null;
alter table i_eg_gift_import change column a_cost_center a_fund char(20) null;
alter table i_eg_giving_url change column a_cost_center a_fund char(20) not null;
alter table m_list change column m_charge_cost_ctr a_charge_fund varchar(20) null;
alter table m_list change column m_charge_ledger a_charge_ledger char(10) null;

-- Data
update r_group_report_param set r_param_name = 'fund' where r_param_name = 'costctr';
update r_saved_param set r_param_name = 'fund' where r_param_name = 'costctr';
