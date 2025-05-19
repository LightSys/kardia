use Kardia_DB;

drop table ra;


/* p_partner */
drop table if exists p_partner;


/* p_partner_key_cnt */
drop table if exists p_partner_key_cnt;


/* p_person */
drop table if exists p_person;


/* p_location */
drop table if exists p_location;


/* p_address_format */
drop table if exists p_address_format;


/* p_address_format_set */
drop table if exists p_address_format_set;


/* p_contact_info */
drop table if exists p_contact_info;


/* p_contact_usage */
drop table if exists p_contact_usage;


/* p_partner_relationship */
drop table if exists p_partner_relationship;


/* p_church */
drop table if exists p_church;


/* p_donor */
drop table if exists p_donor;


/* p_payee */
drop table if exists p_payee;


/* p_staff */
drop table if exists p_staff;


/* p_banking_details */
drop table if exists p_banking_details;


/* p_contact_usage_type */
drop table if exists p_contact_usage_type;


/* p_partner_relationship_type */
drop table if exists p_partner_relationship_type;


/* p_bulk_postal_code */
drop table if exists p_bulk_postal_code;


/* p_zipranges */
drop table if exists p_zipranges;


/* p_country */
drop table if exists p_country;


/* p_pol_division */
drop table if exists p_pol_division;


/* p_banking_type */
drop table if exists p_banking_type;


/* p_title */
drop table if exists p_title;


/* p_gazetteer */
drop table if exists p_gazetteer;


/* p_acquisition_code */
drop table if exists p_acquisition_code;


/* p_partner_sort_tmp */
drop table if exists p_partner_sort_tmp;


/* p_partner_search */
drop table if exists p_partner_search;


/* p_partner_search_stage */
drop table if exists p_partner_search_stage;


/* p_partner_search_results */
drop table if exists p_partner_search_results;


/* p_search_stage_criteria */
drop table if exists p_search_stage_criteria;


/* p_dup_check_tmp */
drop table if exists p_dup_check_tmp;


/* p_nondup */
drop table if exists p_nondup;


/* p_dup */
drop table if exists p_dup;


/* p_merge */
drop table if exists p_merge;


/* p_notification */
drop table if exists p_notification;


/* p_notification_type */
drop table if exists p_notification_type;


/* p_notification_method */
drop table if exists p_notification_method;


/* p_notification_pref */
drop table if exists p_notification_pref;


/* m_list */
drop table if exists m_list;


/* m_list_membership */
drop table if exists m_list_membership;


/* m_list_document */
drop table if exists m_list_document;


/* e_contact_autorecord */
drop table if exists e_contact_autorecord;


/* e_contact_history_type */
drop table if exists e_contact_history_type;


/* e_contact_history */
drop table if exists e_contact_history;


/* e_engagement_track */
drop table if exists e_engagement_track;


/* e_engagement_track_collab */
drop table if exists e_engagement_track_collab;


/* e_engagement_step */
drop table if exists e_engagement_step;


/* e_engagement_step_collab */
drop table if exists e_engagement_step_collab;


/* e_engagement_step_req */
drop table if exists e_engagement_step_req;


/* e_partner_engagement */
drop table if exists e_partner_engagement;


/* e_partner_engagement_req */
drop table if exists e_partner_engagement_req;


/* e_tag_type */
drop table if exists e_tag_type;


/* e_tag_type_relationship */
drop table if exists e_tag_type_relationship;


/* e_tag */
drop table if exists e_tag;


/* e_tag_activity */
drop table if exists e_tag_activity;


/* e_tag_source */
drop table if exists e_tag_source;


/* e_document_type */
drop table if exists e_document_type;


/* e_document */
drop table if exists e_document;


/* e_document_comment */
drop table if exists e_document_comment;


/* e_partner_document */
drop table if exists e_partner_document;


/* e_text_expansion */
drop table if exists e_text_expansion;


/* e_workflow_type */
drop table if exists e_workflow_type;


/* e_workflow_type_step */
drop table if exists e_workflow_type_step;


/* e_workflow */
drop table if exists e_workflow;


/* e_collaborator_type */
drop table if exists e_collaborator_type;


/* e_collaborator */
drop table if exists e_collaborator;


/* e_todo_type */
drop table if exists e_todo_type;


/* e_todo */
drop table if exists e_todo;


/* e_data_item_type */
drop table if exists e_data_item_type;


/* e_data_item_type_value */
drop table if exists e_data_item_type_value;


/* e_data_item_group */
drop table if exists e_data_item_group;


/* e_data_item */
drop table if exists e_data_item;


/* e_highlights */
drop table if exists e_highlights;


/* e_data_highlight */
drop table if exists e_data_highlight;


/* e_activity */
drop table if exists e_activity;


/* e_trackactivity */
drop table if exists e_trackactivity;


/* e_ack */
drop table if exists e_ack;


/* e_ack_type */
drop table if exists e_ack_type;


/* e_text_search_word */
drop table if exists e_text_search_word;


/* e_text_search_rel */
drop table if exists e_text_search_rel;


/* e_text_search_occur */
drop table if exists e_text_search_occur;


/* h_staff */
drop table if exists h_staff;


/* h_group */
drop table if exists h_group;


/* h_group_member */
drop table if exists h_group_member;


/* h_holidays */
drop table if exists h_holidays;


/* h_work_register */
drop table if exists h_work_register;


/* h_work_register_times */
drop table if exists h_work_register_times;


/* h_benefit_period */
drop table if exists h_benefit_period;


/* h_benefit_type */
drop table if exists h_benefit_type;


/* h_benefit_type_sched */
drop table if exists h_benefit_type_sched;


/* h_benefits */
drop table if exists h_benefits;


/* r_group_sched */
drop table if exists r_group_sched;


/* r_group_sched_param */
drop table if exists r_group_sched_param;


/* r_group_sched_report */
drop table if exists r_group_sched_report;


/* r_group */
drop table if exists r_group;


/* r_group_report */
drop table if exists r_group_report;


/* r_group_param */
drop table if exists r_group_param;


/* r_group_report_param */
drop table if exists r_group_report_param;


/* r_saved_paramset */
drop table if exists r_saved_paramset;


/* r_saved_param */
drop table if exists r_saved_param;


/* a_config */
drop table if exists a_config;


/* a_analysis_attr */
drop table if exists a_analysis_attr;


/* a_analysis_attr_value */
drop table if exists a_analysis_attr_value;


/* a_fund_analysis_attr */
drop table if exists a_fund_analysis_attr;


/* a_acct_analysis_attr */
drop table if exists a_acct_analysis_attr;


/* a_fund */
drop table if exists a_fund;


/* a_account */
drop table if exists a_account;


/* a_account_usage */
drop table if exists a_account_usage;


/* a_account_usage_type */
drop table if exists a_account_usage_type;


/* a_account_category */
drop table if exists a_account_category;


/* a_fund_acct */
drop table if exists a_fund_acct;


/* a_period */
drop table if exists a_period;


/* a_period_usage */
drop table if exists a_period_usage;


/* a_period_usage_type */
drop table if exists a_period_usage_type;


/* a_ledger */
drop table if exists a_ledger;


/* a_batch */
drop table if exists a_batch;


/* a_transaction */
drop table if exists a_transaction;


/* a_transaction_tmp */
drop table if exists a_transaction_tmp;


/* a_account_class */
drop table if exists a_account_class;


/* a_fund_class */
drop table if exists a_fund_class;


/* a_reporting_level */
drop table if exists a_reporting_level;


/* a_fund_prefix */
drop table if exists a_fund_prefix;


/* a_fund_staff */
drop table if exists a_fund_staff;


/* a_ledger_office */
drop table if exists a_ledger_office;


/* a_currency */
drop table if exists a_currency;


/* a_currency_exch_rate */
drop table if exists a_currency_exch_rate;


/* a_bank_recon */
drop table if exists a_bank_recon;


/* a_bank_recon_item */
drop table if exists a_bank_recon_item;


/* a_bank_recon_accts */
drop table if exists a_bank_recon_accts;


/* a_dimension */
drop table if exists a_dimension;


/* a_dimension_item */
drop table if exists a_dimension_item;


/* a_payroll */
drop table if exists a_payroll;


/* a_payroll_period */
drop table if exists a_payroll_period;


/* a_payroll_period_payee */
drop table if exists a_payroll_period_payee;


/* a_payroll_group */
drop table if exists a_payroll_group;


/* a_payroll_import */
drop table if exists a_payroll_import;


/* a_payroll_item */
drop table if exists a_payroll_item;


/* a_payroll_item_import */
drop table if exists a_payroll_item_import;


/* a_payroll_item_type */
drop table if exists a_payroll_item_type;


/* a_payroll_item_class */
drop table if exists a_payroll_item_class;


/* a_payroll_item_subclass */
drop table if exists a_payroll_item_subclass;


/* a_payroll_form_group */
drop table if exists a_payroll_form_group;


/* a_tax_filingstatus */
drop table if exists a_tax_filingstatus;


/* a_tax_table */
drop table if exists a_tax_table;


/* a_tax_allowance_table */
drop table if exists a_tax_allowance_table;


/* a_salary_review */
drop table if exists a_salary_review;


/* a_fund_admin_fee */
drop table if exists a_fund_admin_fee;


/* a_admin_fee_type */
drop table if exists a_admin_fee_type;


/* a_admin_fee_type_tmp */
drop table if exists a_admin_fee_type_tmp;


/* a_admin_fee_type_item */
drop table if exists a_admin_fee_type_item;


/* a_admin_fee_type_item_tmp */
drop table if exists a_admin_fee_type_item_tmp;


/* a_fund_receipting */
drop table if exists a_fund_receipting;


/* a_fund_receipting_accts */
drop table if exists a_fund_receipting_accts;


/* a_receipt_type */
drop table if exists a_receipt_type;


/* a_gift_payment_type */
drop table if exists a_gift_payment_type;


/* a_receipt_mailing */
drop table if exists a_receipt_mailing;


/* a_subtrx_gift */
drop table if exists a_subtrx_gift;


/* a_subtrx_gift_group */
drop table if exists a_subtrx_gift_group;


/* a_subtrx_gift_item */
drop table if exists a_subtrx_gift_item;


/* a_subtrx_gift_intent */
drop table if exists a_subtrx_gift_intent;


/* a_subtrx_gift_rcptcnt */
drop table if exists a_subtrx_gift_rcptcnt;


/* a_fund_auto_subscribe */
drop table if exists a_fund_auto_subscribe;


/* a_motivational_code */
drop table if exists a_motivational_code;


/* a_giving_pattern */
drop table if exists a_giving_pattern;


/* a_giving_pattern_allocation */
drop table if exists a_giving_pattern_allocation;


/* a_giving_pattern_flag */
drop table if exists a_giving_pattern_flag;


/* a_funding_target */
drop table if exists a_funding_target;


/* a_support_review */
drop table if exists a_support_review;


/* a_support_review_target */
drop table if exists a_support_review_target;


/* a_descriptives */
drop table if exists a_descriptives;


/* a_descriptives_hist */
drop table if exists a_descriptives_hist;


/* a_pledge */
drop table if exists a_pledge;


/* a_intent_type */
drop table if exists a_intent_type;


/* a_subtrx_cashdisb */
drop table if exists a_subtrx_cashdisb;


/* a_subtrx_payable */
drop table if exists a_subtrx_payable;


/* a_subtrx_payable_item */
drop table if exists a_subtrx_payable_item;


/* a_subtrx_xfer */
drop table if exists a_subtrx_xfer;


/* a_subtrx_deposit */
drop table if exists a_subtrx_deposit;


/* a_subtrx_cashxfer */
drop table if exists a_subtrx_cashxfer;


/* i_eg_gift_import */
drop table if exists i_eg_gift_import;


/* i_eg_gift_trx_fees */
drop table if exists i_eg_gift_trx_fees;


/* i_eg_giving_url */
drop table if exists i_eg_giving_url;


/* i_crm_partner_import */
drop table if exists i_crm_partner_import;


/* i_crm_partner_import_option */
drop table if exists i_crm_partner_import_option;


/* i_crm_import_type */
drop table if exists i_crm_import_type;


/* i_crm_import_type_option */
drop table if exists i_crm_import_type_option;


/* i_disb_import_classify */
drop table if exists i_disb_import_classify;


/* i_disb_import_status */
drop table if exists i_disb_import_status;


/* c_message */
drop table if exists c_message;


/* c_chat */
drop table if exists c_chat;


/* c_member */
drop table if exists c_member;


/* t_project */
drop table if exists t_project;


/* t_sprint */
drop table if exists t_sprint;


/* t_sprint_project */
drop table if exists t_sprint_project;


/* t_sprint_time */
drop table if exists t_sprint_time;


/* t_task */
drop table if exists t_task;


/* t_participant */
drop table if exists t_participant;


/* t_sprint_participant */
drop table if exists t_sprint_participant;


/* t_assignee */
drop table if exists t_assignee;


/* t_task_state */
drop table if exists t_task_state;


/* t_task_history */
drop table if exists t_task_history;


/* s_config */
drop table if exists s_config;


/* s_user_data */
drop table if exists s_user_data;


/* s_user_loginhistory */
drop table if exists s_user_loginhistory;


/* s_subsystem */
drop table if exists s_subsystem;


/* s_process */
drop table if exists s_process;


/* s_process_status */
drop table if exists s_process_status;


/* s_motd */
drop table if exists s_motd;


/* s_motd_viewed */
drop table if exists s_motd_viewed;


/* s_sec_endorsement */
drop table if exists s_sec_endorsement;


/* s_sec_endorsement_type */
drop table if exists s_sec_endorsement_type;


/* s_sec_endorsement_context */
drop table if exists s_sec_endorsement_context;


/* s_mykardia */
drop table if exists s_mykardia;


/* s_request */
drop table if exists s_request;


/* s_request_type */
drop table if exists s_request_type;


/* s_audit */
drop table if exists s_audit;


/* s_role */
drop table if exists s_role;


/* s_role_exclusivity */
drop table if exists s_role_exclusivity;


/* s_user_role */
drop table if exists s_user_role;


/* s_global_search */
drop table if exists s_global_search;


/* s_stats_cache */
drop table if exists s_stats_cache;


/* s_document_scanner */
drop table if exists s_document_scanner;
