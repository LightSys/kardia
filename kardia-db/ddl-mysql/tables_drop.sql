use Kardia_DB;

drop table ra;


/* p_partner */
drop table p_partner;


/* p_partner_key_cnt */
drop table p_partner_key_cnt;


/* p_person */
drop table p_person;


/* p_location */
drop table p_location;


/* p_address_format */
drop table p_address_format;


/* p_address_format_set */
drop table p_address_format_set;


/* p_contact_info */
drop table p_contact_info;


/* p_partner_relationship */
drop table p_partner_relationship;


/* p_church */
drop table p_church;


/* p_donor */
drop table p_donor;


/* p_payee */
drop table p_payee;


/* p_staff */
drop table p_staff;


/* p_bulk_postal_code */
drop table p_bulk_postal_code;


/* p_zipranges */
drop table p_zipranges;


/* p_country */
drop table p_country;


/* p_banking_details */
drop table p_banking_details;


/* p_title */
drop table p_title;


/* p_gazetteer */
drop table p_gazetteer;


/* p_dup_check_tmp */
drop table p_dup_check_tmp;


/* p_partner_sort_tmp */
drop table p_partner_sort_tmp;


/* p_acquisition_code */
drop table p_acquisition_code;


/* m_list */
drop table m_list;


/* m_list_membership */
drop table m_list_membership;


/* e_contact_autorecord */
drop table e_contact_autorecord;


/* e_contact_history_type */
drop table e_contact_history_type;


/* e_contact_history */
drop table e_contact_history;


/* e_activity */
drop table e_activity;


/* e_engagement_track */
drop table e_engagement_track;


/* e_engagement_track_collab */
drop table e_engagement_track_collab;


/* e_engagement_step */
drop table e_engagement_step;


/* e_engagement_step_collab */
drop table e_engagement_step_collab;


/* e_engagement_step_req */
drop table e_engagement_step_req;


/* e_partner_engagement */
drop table e_partner_engagement;


/* e_partner_engagement_req */
drop table e_partner_engagement_req;


/* e_tag_type */
drop table e_tag_type;


/* e_tag_type_relationship */
drop table e_tag_type_relationship;


/* e_tag */
drop table e_tag;


/* e_tag_activity */
drop table e_tag_activity;


/* e_document_type */
drop table e_document_type;


/* e_document */
drop table e_document;


/* e_document_comment */
drop table e_document_comment;


/* e_partner_document */
drop table e_partner_document;


/* e_workflow_type */
drop table e_workflow_type;


/* e_workflow_type_step */
drop table e_workflow_type_step;


/* e_workflow */
drop table e_workflow;


/* e_collaborator_type */
drop table e_collaborator_type;


/* e_collaborator */
drop table e_collaborator;


/* e_todo_type */
drop table e_todo_type;


/* e_todo */
drop table e_todo;


/* e_data_item_type */
drop table e_data_item_type;


/* e_data_item_group */
drop table e_data_item_group;


/* e_data_item */
drop table e_data_item;


/* r_group */
drop table r_group;


/* r_group_report */
drop table r_group_report;


/* r_group_param */
drop table r_group_param;


/* r_group_report_param */
drop table r_group_report_param;


/* r_saved_paramset */
drop table r_saved_paramset;


/* r_saved_param */
drop table r_saved_param;


/* a_config */
drop table a_config;


/* a_analysis_attr */
drop table a_analysis_attr;


/* a_analysis_attr_value */
drop table a_analysis_attr_value;


/* a_cc_analysis_attr */
drop table a_cc_analysis_attr;


/* a_acct_analysis_attr */
drop table a_acct_analysis_attr;


/* a_cost_center */
drop table a_cost_center;


/* a_account */
drop table a_account;


/* a_account_usage */
drop table a_account_usage;


/* a_account_usage_type */
drop table a_account_usage_type;


/* a_account_category */
drop table a_account_category;


/* a_cc_acct */
drop table a_cc_acct;


/* a_period */
drop table a_period;


/* a_period_usage */
drop table a_period_usage;


/* a_period_usage_type */
drop table a_period_usage_type;


/* a_ledger */
drop table a_ledger;


/* a_batch */
drop table a_batch;


/* a_transaction */
drop table a_transaction;


/* a_transaction_tmp */
drop table a_transaction_tmp;


/* a_account_class */
drop table a_account_class;


/* a_cost_center_class */
drop table a_cost_center_class;


/* a_reporting_level */
drop table a_reporting_level;


/* a_cost_center_prefix */
drop table a_cost_center_prefix;


/* a_cc_staff */
drop table a_cc_staff;


/* a_ledger_office */
drop table a_ledger_office;


/* a_payroll */
drop table a_payroll;


/* a_payroll_period */
drop table a_payroll_period;


/* a_payroll_group */
drop table a_payroll_group;


/* a_payroll_import */
drop table a_payroll_import;


/* a_payroll_item */
drop table a_payroll_item;


/* a_payroll_item_import */
drop table a_payroll_item_import;


/* a_payroll_item_type */
drop table a_payroll_item_type;


/* a_payroll_item_class */
drop table a_payroll_item_class;


/* a_payroll_form_group */
drop table a_payroll_form_group;


/* a_tax_filingstatus */
drop table a_tax_filingstatus;


/* a_tax_table */
drop table a_tax_table;


/* a_tax_allowance_table */
drop table a_tax_allowance_table;


/* a_cc_admin_fee */
drop table a_cc_admin_fee;


/* a_admin_fee_type */
drop table a_admin_fee_type;


/* a_admin_fee_type_tmp */
drop table a_admin_fee_type_tmp;


/* a_admin_fee_type_item */
drop table a_admin_fee_type_item;


/* a_admin_fee_type_item_tmp */
drop table a_admin_fee_type_item_tmp;


/* a_cc_receipting */
drop table a_cc_receipting;


/* a_cc_receipting_accts */
drop table a_cc_receipting_accts;


/* a_receipt_type */
drop table a_receipt_type;


/* a_subtrx_gift */
drop table a_subtrx_gift;


/* a_subtrx_gift_group */
drop table a_subtrx_gift_group;


/* a_subtrx_gift_item */
drop table a_subtrx_gift_item;


/* a_subtrx_gift_rcptcnt */
drop table a_subtrx_gift_rcptcnt;


/* a_cc_auto_subscribe */
drop table a_cc_auto_subscribe;


/* a_motivational_code */
drop table a_motivational_code;


/* a_giving_pattern */
drop table a_giving_pattern;


/* a_subtrx_cashdisb */
drop table a_subtrx_cashdisb;


/* a_subtrx_xfer */
drop table a_subtrx_xfer;


/* a_subtrx_deposit */
drop table a_subtrx_deposit;


/* a_subtrx_cashxfer */
drop table a_subtrx_cashxfer;


/* i_eg_gift_import */
drop table i_eg_gift_import;


/* i_eg_giving_url */
drop table i_eg_giving_url;


/* c_message */
drop table c_message;


/* c_chat */
drop table c_chat;


/* c_member */
drop table c_member;


/* s_config */
drop table s_config;


/* s_user_data */
drop table s_user_data;


/* s_user_loginhistory */
drop table s_user_loginhistory;


/* s_subsystem */
drop table s_subsystem;


/* s_process */
drop table s_process;


/* s_process_status */
drop table s_process_status;


/* s_motd */
drop table s_motd;


/* s_motd_viewed */
drop table s_motd_viewed;


/* s_sec_endorsement */
drop table s_sec_endorsement;


/* s_sec_endorsement_type */
drop table s_sec_endorsement_type;


/* s_sec_endorsement_context */
drop table s_sec_endorsement_context;


/* s_mykardia */
drop table s_mykardia;


/* s_request */
drop table s_request;


/* s_request_type */
drop table s_request_type;


/* s_audit */
drop table s_audit;
