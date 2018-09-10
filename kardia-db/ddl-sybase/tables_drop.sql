use Kardia_DB
go

drop table ra
go


/* p_partner */
drop table p_partner
go


/* p_partner_key_cnt */
drop table p_partner_key_cnt
go


/* p_person */
drop table p_person
go


/* p_location */
drop table p_location
go


/* p_address_format */
drop table p_address_format
go


/* p_address_format_set */
drop table p_address_format_set
go


/* p_contact_info */
drop table p_contact_info
go


/* p_contact_usage */
drop table p_contact_usage
go


/* p_contact_usage_type */
drop table p_contact_usage_type
go


/* p_partner_relationship */
drop table p_partner_relationship
go


/* p_partner_relationship_type */
drop table p_partner_relationship_type
go


/* p_church */
drop table p_church
go


/* p_donor */
drop table p_donor
go


/* p_payee */
drop table p_payee
go


/* p_staff */
drop table p_staff
go


/* p_bulk_postal_code */
drop table p_bulk_postal_code
go


/* p_zipranges */
drop table p_zipranges
go


/* p_country */
drop table p_country
go


/* p_banking_details */
drop table p_banking_details
go


/* p_banking_type */
drop table p_banking_type
go


/* p_title */
drop table p_title
go


/* p_gazetteer */
drop table p_gazetteer
go


/* p_dup_check_tmp */
drop table p_dup_check_tmp
go


/* p_partner_sort_tmp */
drop table p_partner_sort_tmp
go


/* p_acquisition_code */
drop table p_acquisition_code
go


/* p_partner_search */
drop table p_partner_search
go


/* p_partner_search_stage */
drop table p_partner_search_stage
go


/* p_partner_search_results */
drop table p_partner_search_results
go


/* p_search_stage_criteria */
drop table p_search_stage_criteria
go


/* m_list */
drop table m_list
go


/* m_list_membership */
drop table m_list_membership
go


/* e_contact_autorecord */
drop table e_contact_autorecord
go


/* e_contact_history_type */
drop table e_contact_history_type
go


/* e_contact_history */
drop table e_contact_history
go


/* e_activity */
drop table e_activity
go


/* e_engagement_track */
drop table e_engagement_track
go


/* e_engagement_track_collab */
drop table e_engagement_track_collab
go


/* e_engagement_step */
drop table e_engagement_step
go


/* e_engagement_step_collab */
drop table e_engagement_step_collab
go


/* e_engagement_step_req */
drop table e_engagement_step_req
go


/* e_partner_engagement */
drop table e_partner_engagement
go


/* e_partner_engagement_req */
drop table e_partner_engagement_req
go


/* e_tag_type */
drop table e_tag_type
go


/* e_tag_type_relationship */
drop table e_tag_type_relationship
go


/* e_tag */
drop table e_tag
go


/* e_tag_activity */
drop table e_tag_activity
go


/* e_document_type */
drop table e_document_type
go


/* e_document */
drop table e_document
go


/* e_document_comment */
drop table e_document_comment
go


/* e_partner_document */
drop table e_partner_document
go


/* e_workflow_type */
drop table e_workflow_type
go


/* e_workflow_type_step */
drop table e_workflow_type_step
go


/* e_workflow */
drop table e_workflow
go


/* e_collaborator_type */
drop table e_collaborator_type
go


/* e_collaborator */
drop table e_collaborator
go


/* e_todo_type */
drop table e_todo_type
go


/* e_todo */
drop table e_todo
go


/* e_data_item_type */
drop table e_data_item_type
go


/* e_data_item_group */
drop table e_data_item_group
go


/* e_data_item */
drop table e_data_item
go


/* e_highlights */
drop table e_highlights
go


/* e_data_highlight */
drop table e_data_highlight
go


/* e_ack */
drop table e_ack
go


/* e_ack_type */
drop table e_ack_type
go


/* e_trackactivity */
drop table e_trackactivity
go


/* e_text_expansion */
drop table e_text_expansion
go


/* e_text_search_word */
drop table e_text_search_word
go


/* e_text_search_rel */
drop table e_text_search_rel
go


/* e_text_search_occur */
drop table e_text_search_occur
go


/* h_staff */
drop table h_staff
go


/* h_group */
drop table h_group
go


/* h_group_member */
drop table h_group_member
go


/* h_holidays */
drop table h_holidays
go


/* h_work_register */
drop table h_work_register
go


/* h_work_register_times */
drop table h_work_register_times
go


/* h_benefit_period */
drop table h_benefit_period
go


/* h_benefit_type */
drop table h_benefit_type
go


/* h_benefit_type_sched */
drop table h_benefit_type_sched
go


/* h_benefits */
drop table h_benefits
go


/* r_group */
drop table r_group
go


/* r_group_report */
drop table r_group_report
go


/* r_group_param */
drop table r_group_param
go


/* r_group_report_param */
drop table r_group_report_param
go


/* r_saved_paramset */
drop table r_saved_paramset
go


/* r_saved_param */
drop table r_saved_param
go


/* a_config */
drop table a_config
go


/* a_analysis_attr */
drop table a_analysis_attr
go


/* a_analysis_attr_value */
drop table a_analysis_attr_value
go


/* a_cc_analysis_attr */
drop table a_cc_analysis_attr
go


/* a_acct_analysis_attr */
drop table a_acct_analysis_attr
go


/* a_cost_center */
drop table a_cost_center
go


/* a_account */
drop table a_account
go


/* a_account_usage */
drop table a_account_usage
go


/* a_account_usage_type */
drop table a_account_usage_type
go


/* a_account_category */
drop table a_account_category
go


/* a_cc_acct */
drop table a_cc_acct
go


/* a_period */
drop table a_period
go


/* a_period_usage */
drop table a_period_usage
go


/* a_period_usage_type */
drop table a_period_usage_type
go


/* a_ledger */
drop table a_ledger
go


/* a_batch */
drop table a_batch
go


/* a_transaction */
drop table a_transaction
go


/* a_transaction_tmp */
drop table a_transaction_tmp
go


/* a_account_class */
drop table a_account_class
go


/* a_cost_center_class */
drop table a_cost_center_class
go


/* a_reporting_level */
drop table a_reporting_level
go


/* a_cost_center_prefix */
drop table a_cost_center_prefix
go


/* a_cc_staff */
drop table a_cc_staff
go


/* a_ledger_office */
drop table a_ledger_office
go


/* a_payroll */
drop table a_payroll
go


/* a_payroll_period */
drop table a_payroll_period
go


/* a_payroll_group */
drop table a_payroll_group
go


/* a_payroll_import */
drop table a_payroll_import
go


/* a_payroll_item */
drop table a_payroll_item
go


/* a_payroll_item_import */
drop table a_payroll_item_import
go


/* a_payroll_item_type */
drop table a_payroll_item_type
go


/* a_payroll_item_class */
drop table a_payroll_item_class
go


/* a_payroll_form_group */
drop table a_payroll_form_group
go


/* a_tax_filingstatus */
drop table a_tax_filingstatus
go


/* a_tax_table */
drop table a_tax_table
go


/* a_tax_allowance_table */
drop table a_tax_allowance_table
go


/* a_salary_review */
drop table a_salary_review
go


/* a_cc_admin_fee */
drop table a_cc_admin_fee
go


/* a_admin_fee_type */
drop table a_admin_fee_type
go


/* a_admin_fee_type_tmp */
drop table a_admin_fee_type_tmp
go


/* a_admin_fee_type_item */
drop table a_admin_fee_type_item
go


/* a_admin_fee_type_item_tmp */
drop table a_admin_fee_type_item_tmp
go


/* a_cc_receipting */
drop table a_cc_receipting
go


/* a_cc_receipting_accts */
drop table a_cc_receipting_accts
go


/* a_receipt_type */
drop table a_receipt_type
go


/* a_subtrx_gift */
drop table a_subtrx_gift
go


/* a_subtrx_gift_group */
drop table a_subtrx_gift_group
go


/* a_subtrx_gift_item */
drop table a_subtrx_gift_item
go


/* a_subtrx_gift_rcptcnt */
drop table a_subtrx_gift_rcptcnt
go


/* a_cc_auto_subscribe */
drop table a_cc_auto_subscribe
go


/* a_motivational_code */
drop table a_motivational_code
go


/* a_giving_pattern */
drop table a_giving_pattern
go


/* a_giving_pattern_allocation */
drop table a_giving_pattern_allocation
go


/* a_giving_pattern_flag */
drop table a_giving_pattern_flag
go


/* a_funding_target */
drop table a_funding_target
go


/* a_support_review */
drop table a_support_review
go


/* a_support_review_target */
drop table a_support_review_target
go


/* a_descriptives */
drop table a_descriptives
go


/* a_descriptives_hist */
drop table a_descriptives_hist
go


/* a_subtrx_cashdisb */
drop table a_subtrx_cashdisb
go


/* a_subtrx_payable */
drop table a_subtrx_payable
go


/* a_subtrx_payable_item */
drop table a_subtrx_payable_item
go


/* a_subtrx_xfer */
drop table a_subtrx_xfer
go


/* a_subtrx_deposit */
drop table a_subtrx_deposit
go


/* a_subtrx_cashxfer */
drop table a_subtrx_cashxfer
go


/* i_eg_gift_import */
drop table i_eg_gift_import
go


/* i_eg_giving_url */
drop table i_eg_giving_url
go


/* i_crm_partner_import */
drop table i_crm_partner_import
go


/* i_crm_partner_import_option */
drop table i_crm_partner_import_option
go


/* i_crm_import_type */
drop table i_crm_import_type
go


/* i_crm_import_type_option */
drop table i_crm_import_type_option
go


/* i_disb_import_classify */
drop table i_disb_import_classify
go


/* i_disb_import_status */
drop table i_disb_import_status
go


/* c_message */
drop table c_message
go


/* c_chat */
drop table c_chat
go


/* c_member */
drop table c_member
go


/* s_config */
drop table s_config
go


/* s_user_data */
drop table s_user_data
go


/* s_user_loginhistory */
drop table s_user_loginhistory
go


/* s_subsystem */
drop table s_subsystem
go


/* s_process */
drop table s_process
go


/* s_process_status */
drop table s_process_status
go


/* s_motd */
drop table s_motd
go


/* s_motd_viewed */
drop table s_motd_viewed
go


/* s_sec_endorsement */
drop table s_sec_endorsement
go


/* s_sec_endorsement_type */
drop table s_sec_endorsement_type
go


/* s_sec_endorsement_context */
drop table s_sec_endorsement_context
go


/* s_mykardia */
drop table s_mykardia
go


/* s_request */
drop table s_request
go


/* s_request_type */
drop table s_request_type
go


/* s_audit */
drop table s_audit
go


/* s_role */
drop table s_role
go


/* s_role_exclusivity */
drop table s_role_exclusivity
go


/* s_user_role */
drop table s_user_role
go
