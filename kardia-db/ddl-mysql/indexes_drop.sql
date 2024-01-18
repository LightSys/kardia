use Kardia_DB;



/* p_partner */
alter table p_partner drop index p_fund_idx;
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
alter table p_contact_info drop index p_contact_idx;
/* drop index p_contact_info.p_contact_info_pk */ 
/* go */


/* p_contact_usage */
/* drop index p_contact_usage.p_contact_usg_pk */ 
/* go */


/* p_contact_usage_type */
/* drop index p_contact_usage_type.p_contact_ut_pk */ 
/* go */


/* p_partner_relationship */
/* drop index p_partner_relationship.p_partner_relationship_pk */ 
/* go */
alter table p_partner_relationship drop index p_relate_reverse_idx;


/* p_partner_relationship_type */
/* drop index p_partner_relationship_type.p_relat_type_pk */ 
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


/* p_pol_division */
/* drop index p_pol_division.p_poldiv_pk */ 
/* go */


/* p_banking_details */
alter table p_banking_details drop index p_bankd_acct_idx;
alter table p_banking_details drop index p_bankd_bpartner_idx;
alter table p_banking_details drop index p_bankd_partner_idx;
/* drop index p_banking_details.p_banking_details_pk */ 
/* go */


/* p_banking_type */
/* drop index p_banking_type.p_banking_type_pk */ 
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


/* p_acquisition_code */
/* drop index p_acquisition_code.p_acqcode_pk */ 
/* go */


/* p_partner_search */
/* drop index p_partner_search.p_search_pk */ 
/* go */


/* p_partner_search_stage */
/* drop index p_partner_search_stage.p_searchstage_pk */ 
/* go */


/* p_partner_search_results */
alter table p_partner_search_results drop index p_search_stage_idx;
/* drop index p_partner_search_results.p_searchres_pk */ 
/* go */


/* p_search_stage_criteria */
/* drop index p_search_stage_criteria.p_stage_criteria_pk */ 
/* go */


/* p_nondup */
/* drop index p_nondup.p_nondup_pk */ 
/* go */
alter table p_nondup drop index p_nondup_rev_idx;


/* p_dup */
/* drop index p_dup.p_dup_pk */ 
/* go */
alter table p_dup drop index p_dup_rev_idx;


/* p_merge */
/* drop index p_merge.p_merge_pk */ 
/* go */
alter table p_merge drop index p_merge_rev_idx;


/* m_list */
/* drop index m_list.m_list_pk */ 
/* go */


/* m_list_membership */
/* drop index m_list_membership.m_list_membership_clustered_pk */ 
/* go */
alter table m_list_membership drop index m_lists_by_partner;


/* m_list_document */
/* drop index m_list_document.m_doc_pk */ 
/* go */


/* e_contact_autorecord */
alter table e_contact_autorecord drop index e_autorec_collab_idx;
alter table e_contact_autorecord drop index e_autorec_collabhist_idx;
alter table e_contact_autorecord drop index e_autorec_histtype_idx;
/* drop index e_contact_autorecord.e_autorec_pk */ 
/* go */


/* e_contact_history_type */
/* drop index e_contact_history_type.e_cnt_hist_type_pk */ 
/* go */


/* e_contact_history */
alter table e_contact_history drop index e_cnt_hist_locpar_idx;
alter table e_contact_history drop index e_cnt_hist_par_idx;
/* drop index e_contact_history.e_cnt_hist_pk */ 
/* go */
alter table e_contact_history drop index e_cnt_hist_type_idx;
alter table e_contact_history drop index e_cnt_hist_whom_idx;


/* e_activity */
alter table e_activity drop index e_act_par_idx;
/* drop index e_activity.e_act_pk */ 
/* go */
alter table e_activity drop index e_act_sort_idx;
alter table e_activity drop index e_act_type_idx;


/* e_engagement_track */
alter table e_engagement_track drop index e_trk_name_idx;
/* drop index e_engagement_track.e_trk_pk */ 
/* go */


/* e_engagement_track_collab */
/* drop index e_engagement_track_collab.e_trkcoll_pk */ 
/* go */
alter table e_engagement_track_collab drop index e_trkcoll_ptnr_idx;


/* e_engagement_step */
alter table e_engagement_step drop index e_step_name_idx;
/* drop index e_engagement_step.e_step_pk */ 
/* go */


/* e_engagement_step_collab */
/* drop index e_engagement_step_collab.e_stepcoll_pk */ 
/* go */
alter table e_engagement_step_collab drop index e_stepcoll_ptnr_idx;


/* e_engagement_step_req */
/* drop index e_engagement_step_req.e_req_pk */ 
/* go */


/* e_partner_engagement */
/* drop index e_partner_engagement.e_pareng_pk */ 
/* go */
alter table e_partner_engagement drop index e_pareng_start_idx;
alter table e_partner_engagement drop index e_pareng_trackstep_idx;


/* e_partner_engagement_req */
/* drop index e_partner_engagement_req.e_parreq_pk */ 
/* go */


/* e_tag_type */
/* drop index e_tag_type.e_tagtype_pk */ 
/* go */


/* e_tag_type_relationship */
/* drop index e_tag_type_relationship.e_tagtyperel_pk */ 
/* go */


/* e_tag */
/* drop index e_tag.e_tag_pk */ 
/* go */
alter table e_tag drop index e_tag_rev_idx;
alter table e_tag drop index e_tag_strength_idx;


/* e_tag_activity */
alter table e_tag_activity drop index e_tagact_gptnr_idx;
alter table e_tag_activity drop index e_tagact_gtag_idx;
/* drop index e_tag_activity.e_tagact_pk */ 
/* go */
alter table e_tag_activity drop index e_tagact_ptnr_idx;
alter table e_tag_activity drop index e_tagact_tagid_idx;


/* e_tag_source */
/* drop index e_tag_source.e_tagsrc_pk */ 
/* go */
alter table e_tag_source drop index e_tagsrc_src_idx;


/* e_document_type */
alter table e_document_type drop index e_doctype_label_idx;
alter table e_document_type drop index e_doctype_parent_idx;
/* drop index e_document_type.e_doctype_pk */ 
/* go */


/* e_document */
alter table e_document drop index e_doc_curpath_idx;
/* drop index e_document.e_doc_pk */ 
/* go */
alter table e_document drop index e_doc_type_idx;
alter table e_document drop index e_doc_work_idx;


/* e_document_comment */
alter table e_document_comment drop index e_doccom_collab_idx;
/* drop index e_document_comment.e_doccom_pk */ 
/* go */
alter table e_document_comment drop index e_doccom_tgtcollab_idx;
alter table e_document_comment drop index e_doccom_work_idx;


/* e_partner_document */
alter table e_partner_document drop index e_pardoc_egagement_idx;
/* drop index e_partner_document.e_pardoc_pk */ 
/* go */
alter table e_partner_document drop index e_pardoc_rev_idx;
alter table e_partner_document drop index e_pardoc_work_idx;


/* e_workflow_type */
/* drop index e_workflow_type.e_work_pk */ 
/* go */


/* e_workflow_type_step */
/* drop index e_workflow_type_step.e_workstep_pk */ 
/* go */
alter table e_workflow_type_step drop index e_workstep_trig_idx;
alter table e_workflow_type_step drop index e_workstep_type_idx;


/* e_workflow */
/* drop index e_workflow.e_workinst_pk */ 
/* go */
alter table e_workflow drop index e_workinst_steptrig_idx;
alter table e_workflow drop index e_workinst_trig_idx;
alter table e_workflow drop index e_workinst_type_idx;


/* e_collaborator_type */
/* drop index e_collaborator_type.e_collabtype_pk */ 
/* go */


/* e_collaborator */
/* drop index e_collaborator.e_collab_pk */ 
/* go */
alter table e_collaborator drop index e_collab_rev_idx;
alter table e_collaborator drop index e_collab_type_idx;


/* e_todo_type */
/* drop index e_todo_type.e_todotype_pk */ 
/* go */


/* e_todo */
alter table e_todo drop index e_todo_collab_idx;
alter table e_todo drop index e_todo_doc_idx;
alter table e_todo drop index e_todo_eng_idx;
alter table e_todo drop index e_todo_par_idx;
/* drop index e_todo.e_todo_pk */ 
/* go */
alter table e_todo drop index e_todo_reqitem_idx;
alter table e_todo drop index e_todo_type_idx;


/* e_data_item_type */
alter table e_data_item_type drop index e_ditype_parent_idx;
/* drop index e_data_item_type.e_ditype_pk */ 
/* go */


/* e_data_item_type_value */
/* drop index e_data_item_type_value.e_dataitemval_pk */ 
/* go */


/* e_data_item_group */
/* drop index e_data_item_group.e_digrp_pk */ 
/* go */
alter table e_data_item_group drop index e_digrp_type_idx;


/* e_data_item */
alter table e_data_item drop index e_dataitem_group_idx;
/* drop index e_data_item.e_dataitem_pk */ 
/* go */
alter table e_data_item drop index e_dataitem_type_idx;


/* e_highlights */
alter table e_highlights drop index e_h_nt_idx;
/* drop index e_highlights.e_h_pk */ 
/* go */
alter table e_highlights drop index e_h_prec_idx;


/* e_data_highlight */
alter table e_data_highlight drop index e_dh_obj_idx;
/* drop index e_data_highlight.e_dh_pk */ 
/* go */


/* e_ack */
alter table e_ack drop index e_ack_obj_idx;
alter table e_ack drop index e_ack_par2_idx;
alter table e_ack drop index e_ack_par3_idx;
alter table e_ack drop index e_ack_par_idx;
/* drop index e_ack.e_ack_pk */ 
/* go */


/* e_ack_type */
/* drop index e_ack_type.e_ackt_pk */ 
/* go */


/* e_trackactivity */
/* drop index e_trackactivity.e_trkact_pk */ 
/* go */


/* e_text_expansion */
/* drop index e_text_expansion.e_exp_pk */ 
/* go */


/* e_text_search_word */
/* drop index e_text_search_word.e_tsw_pk */ 
/* go */
alter table e_text_search_word drop index e_tsw_word_idx;


/* e_text_search_rel */
/* drop index e_text_search_rel.e_tsr_pk */ 
/* go */
alter table e_text_search_rel drop index e_tsr_rev_idx;


/* e_text_search_occur */
/* drop index e_text_search_occur.e_tso_pk */ 
/* go */
alter table e_text_search_occur drop index e_tso_seq_idx;


/* h_staff */
/* drop index h_staff.h_staff_pk */ 
/* go */


/* h_group */
/* drop index h_group.h_group_pk */ 
/* go */


/* h_group_member */
alter table h_group_member drop index h_group_ptnr_idx;
/* drop index h_group_member.h_groupm_pk */ 
/* go */


/* h_holidays */
/* drop index h_holidays.h_holiday_pk */ 
/* go */


/* h_work_register */
alter table h_work_register drop index h_workreg_ben_idx;
/* drop index h_work_register.h_workreg_pk */ 
/* go */


/* h_work_register_times */
/* drop index h_work_register_times.h_workregt_pk */ 
/* go */


/* h_benefit_period */
/* drop index h_benefit_period.h_benper_pk */ 
/* go */


/* h_benefit_type */
/* drop index h_benefit_type.h_bentype_pk */ 
/* go */


/* h_benefit_type_sched */
/* drop index h_benefit_type_sched.h_bentypesch_pk */ 
/* go */
alter table h_benefit_type_sched drop index h_bts_group_idx;
alter table h_benefit_type_sched drop index h_bts_partner_idx;


/* h_benefits */
alter table h_benefits drop index h_ben_partner_idx;
alter table h_benefits drop index h_ben_period_idx;
/* drop index h_benefits.h_ben_pk */ 
/* go */


/* r_group_sched */
/* drop index r_group_sched.r_grp_sch_pk */ 
/* go */


/* r_group_sched_param */
/* drop index r_group_sched_param.r_sparam_pk */ 
/* go */


/* r_group_sched_report */
/* drop index r_group_sched_report.r_grp_sch_r_pk */ 
/* go */
alter table r_group_sched_report drop index r_schrpt_partner_idx;


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


/* a_fund_analysis_attr */
/* drop index a_fund_analysis_attr.a_fund_an_attr_pk */ 
/* go */


/* a_acct_analysis_attr */
/* drop index a_acct_analysis_attr.a_acct_an_attr_pk */ 
/* go */


/* a_fund */
alter table a_fund drop index a_fund_bal_idx;
alter table a_fund drop index a_fund_ledger_number_idx;
alter table a_fund drop index a_fund_legacy_idx;
alter table a_fund drop index a_fund_parent_idx;
/* drop index a_fund.a_fund_pk */ 
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


/* a_fund_acct */
/* drop index a_fund_acct.a_fund_acct_pk */ 
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
alter table a_transaction drop index a_trx_donor_id_idx;
/* drop index a_transaction.a_trx_fund_clustered_idx */ 
/* go */
alter table a_transaction drop index a_trx_fund_quicksum_idx;
alter table a_transaction drop index a_trx_fundperiod_idx;
alter table a_transaction drop index a_trx_journal_idx;
alter table a_transaction drop index a_trx_period_idx;
alter table a_transaction drop index a_trx_recip_id_idx;
alter table a_transaction drop index a_trx_transaction_idx;


/* a_transaction_tmp */
/* drop index a_transaction_tmp.a_transaction_tmp_pk */ 
/* go */
alter table a_transaction_tmp drop index a_trxt_batch_idx;
alter table a_transaction_tmp drop index a_trxt_donor_id_idx;
/* drop index a_transaction_tmp.a_trxt_fund_clustered_idx */ 
/* go */
alter table a_transaction_tmp drop index a_trxt_fund_quicksum_idx;
alter table a_transaction_tmp drop index a_trxt_journal_idx;
alter table a_transaction_tmp drop index a_trxt_recip_id_idx;
alter table a_transaction_tmp drop index a_trxt_transaction_idx;


/* a_account_class */
/* drop index a_account_class.a_account_class_pk */ 
/* go */


/* a_fund_class */
/* drop index a_fund_class.a_fund_class_pk */ 
/* go */


/* a_reporting_level */
/* drop index a_reporting_level.a_level_pk */ 
/* go */


/* a_fund_prefix */
alter table a_fund_prefix drop index a_fund_pfx_ledger_number_idx;
/* drop index a_fund_prefix.a_fund_prefix_pk */ 
/* go */


/* a_fund_staff */
alter table a_fund_staff drop index a_fund_staff_partner_idx;
/* drop index a_fund_staff.a_fund_staff_pk */ 
/* go */


/* a_ledger_office */
/* drop index a_ledger_office.a_lo_pk */ 
/* go */


/* a_currency */
/* drop index a_currency.a_curr_pk */ 
/* go */


/* a_currency_exch_rate */
/* drop index a_currency_exch_rate.a_curr_pk */ 
/* go */


/* a_payroll */
alter table a_payroll drop index a_payroll_fund_idx;
alter table a_payroll drop index a_payroll_payee_idx;
/* drop index a_payroll.a_payroll_pk */ 
/* go */


/* a_payroll_period */
alter table a_payroll_period drop index a_payperiod_idx;
/* drop index a_payroll_period.a_payperiod_pk */ 
/* go */


/* a_payroll_period_payee */
/* drop index a_payroll_period_payee.a_payperiodpayee_pk */ 
/* go */


/* a_payroll_group */
alter table a_payroll_group drop index a_payroll_fund_idx;
/* drop index a_payroll_group.a_payroll_grp_pk */ 
/* go */


/* a_payroll_import */
alter table a_payroll_import drop index a_payrolli_fund_idx;
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


/* a_payroll_item_subclass */
/* drop index a_payroll_item_subclass.a_payroll_isc_pk */ 
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


/* a_salary_review */
/* drop index a_salary_review.a_salreview_pk */ 
/* go */
alter table a_salary_review drop index a_salreview_review_idx;


/* a_fund_admin_fee */
/* drop index a_fund_admin_fee.a_fund_admin_fee_pk */ 
/* go */
alter table a_fund_admin_fee drop index a_fundaf_ledger_number_idx;


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


/* a_fund_receipting */
/* drop index a_fund_receipting.a_fund_receipting_pk */ 
/* go */
alter table a_fund_receipting drop index a_fundr_ledger_number_idx;


/* a_fund_receipting_accts */
/* drop index a_fund_receipting_accts.a_fund_rcptacct_pk */ 
/* go */
alter table a_fund_receipting_accts drop index a_fundra_acct_number_idx;
alter table a_fund_receipting_accts drop index a_fundra_ledger_number_idx;


/* a_receipt_type */
/* drop index a_receipt_type.a_rcpttype_pk */ 
/* go */


/* a_gift_payment_type */
/* drop index a_gift_payment_type.a_gpmttype_pk */ 
/* go */


/* a_receipt_mailing */
/* drop index a_receipt_mailing.a_giftlist_pk */ 
/* go */


/* a_subtrx_gift */
alter table a_subtrx_gift drop index a_gifttrx_batch_idx;
alter table a_subtrx_gift drop index a_gifttrx_donor_id_idx;
/* drop index a_subtrx_gift.a_gifttrx_fund_clustered_idx */ 
/* go */
alter table a_subtrx_gift drop index a_gifttrx_gift_idx;
/* drop index a_subtrx_gift.a_gifttrx_pk */ 
/* go */
alter table a_subtrx_gift drop index a_gifttrx_recip_id_idx;


/* a_subtrx_gift_group */
alter table a_subtrx_gift_group drop index a_gifttrxgrp_ack_id_idx;
alter table a_subtrx_gift_group drop index a_gifttrxgrp_batch_idx;
alter table a_subtrx_gift_group drop index a_gifttrxgrp_donor_id_idx;
alter table a_subtrx_gift_group drop index a_gifttrxgrp_gift_idx;
alter table a_subtrx_gift_group drop index a_gifttrxgrp_pass_id_idx;
/* drop index a_subtrx_gift_group.a_gifttrxgrp_pk */ 
/* go */


/* a_subtrx_gift_item */
/* drop index a_subtrx_gift_item.a_gifttrx_pk */ 
/* go */
alter table a_subtrx_gift_item drop index a_gifttrxi_ack_idx;
alter table a_subtrx_gift_item drop index a_gifttrxi_datetype_idx;
alter table a_subtrx_gift_item drop index a_gifttrxi_donor_idx;
/* drop index a_subtrx_gift_item.a_gifttrxi_fund_clustered_idx */ 
/* go */
alter table a_subtrx_gift_item drop index a_gifttrxi_gift_idx;
alter table a_subtrx_gift_item drop index a_gifttrxi_hash_idx;
alter table a_subtrx_gift_item drop index a_gifttrxi_mcode_idx;
alter table a_subtrx_gift_item drop index a_gifttrxi_pass_idx;
alter table a_subtrx_gift_item drop index a_gifttrxi_rcpt_idx;
alter table a_subtrx_gift_item drop index a_gifttrxi_recip_id_idx;
alter table a_subtrx_gift_item drop index a_gifttrxi_src_idx;


/* a_subtrx_gift_intent */
alter table a_subtrx_gift_intent drop index a_gifttrxin_gift_idx;
/* drop index a_subtrx_gift_intent.a_gifttrxin_pk */ 
/* go */
alter table a_subtrx_gift_intent drop index a_gifttrxin_pledge_idx;


/* a_subtrx_gift_rcptcnt */
/* drop index a_subtrx_gift_rcptcnt.a_rcptno_pk */ 
/* go */


/* a_fund_auto_subscribe */
alter table a_fund_auto_subscribe drop index a_fund_as_ledger_number_idx;
alter table a_fund_auto_subscribe drop index a_fund_as_listcode_idx;
/* drop index a_fund_auto_subscribe.a_fund_auto_subscribe_pk */ 
/* go */


/* a_motivational_code */
alter table a_motivational_code drop index a_motiv_code_fund;
alter table a_motivational_code drop index a_motiv_code_list;
alter table a_motivational_code drop index a_motiv_code_parent;
/* drop index a_motivational_code.a_motivational_code_pk */ 
/* go */


/* a_giving_pattern */
alter table a_giving_pattern drop index a_givingp_actual_idx;
alter table a_giving_pattern drop index a_givingp_donor_idx;
alter table a_giving_pattern drop index a_givingp_fund_idx;
/* drop index a_giving_pattern.a_givingp_pk */ 
/* go */
alter table a_giving_pattern drop index a_givingp_review_idx;


/* a_giving_pattern_allocation */
alter table a_giving_pattern_allocation drop index a_givingpa_actual_idx;
alter table a_giving_pattern_allocation drop index a_givingpa_donor_idx;
alter table a_giving_pattern_allocation drop index a_givingpa_fund_idx;
/* drop index a_giving_pattern_allocation.a_givingpa_pk */ 
/* go */
alter table a_giving_pattern_allocation drop index a_givingpa_review_idx;


/* a_giving_pattern_flag */
/* drop index a_giving_pattern_flag.a_givingf_pk */ 
/* go */
alter table a_giving_pattern_flag drop index a_givingf_review_idx;


/* a_funding_target */
/* drop index a_funding_target.a_target_pk */ 
/* go */


/* a_support_review */
/* drop index a_support_review.a_supportreview_pk */ 
/* go */


/* a_support_review_target */
/* drop index a_support_review_target.a_supptgt_pk */ 
/* go */
alter table a_support_review_target drop index a_supptgt_review_idx;
alter table a_support_review_target drop index a_supptgt_target_idx;


/* a_descriptives */
alter table a_descriptives drop index a_descr_fund_idx;
alter table a_descriptives drop index a_descr_par_idx;
/* drop index a_descriptives.a_descr_pk */ 
/* go */


/* a_descriptives_hist */
alter table a_descriptives_hist drop index a_descrhist_fund_idx;
alter table a_descriptives_hist drop index a_descrhist_merge_idx;
alter table a_descriptives_hist drop index a_descrhist_par_idx;
/* drop index a_descriptives_hist.a_descrhist_pk */ 
/* go */


/* a_pledge */
alter table a_pledge drop index a_pledge_donor_idx;
alter table a_pledge drop index a_pledge_fund_idx;
/* drop index a_pledge.a_pledge_pk */ 
/* go */


/* a_intent_type */
/* drop index a_intent_type.a_intenttype_pk */ 
/* go */


/* a_subtrx_cashdisb */
alter table a_subtrx_cashdisb drop index a_subtrx_cashdisb_acct_idx;
alter table a_subtrx_cashdisb drop index a_subtrx_cashdisb_batch_idx;
/* drop index a_subtrx_cashdisb.a_subtrx_cashdisb_pk */ 
/* go */


/* a_subtrx_payable */
/* drop index a_subtrx_payable.a_subtrx_payable_pk */ 
/* go */


/* a_subtrx_payable_item */
/* drop index a_subtrx_payable_item.a_subtrx_payable_item_pk */ 
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
alter table a_subtrx_cashxfer drop index a_subtrx_cxf_batch_idx;
/* drop index a_subtrx_cashxfer.a_subtrx_cxf_fund_clustered_idx */ 
/* go */
alter table a_subtrx_cashxfer drop index a_subtrx_cxf_fund_rev1_idx;
alter table a_subtrx_cashxfer drop index a_subtrx_cxf_fund_rev2_idx;
alter table a_subtrx_cashxfer drop index a_subtrx_cxf_journal_idx;


/* i_eg_gift_import */
alter table i_eg_gift_import drop index i_eg_edeposit_idx;
alter table i_eg_gift_import drop index i_eg_edonor_idx;
alter table i_eg_gift_import drop index i_eg_efund_idx;
alter table i_eg_gift_import drop index i_eg_egift_idx;
/* drop index i_eg_gift_import.i_eg_gift_import_pk */ 
/* go */
alter table i_eg_gift_import drop index i_eg_kdepbatch_idx;
alter table i_eg_gift_import drop index i_eg_kdonfund_idx;
alter table i_eg_gift_import drop index i_eg_kdonor_idx;
alter table i_eg_gift_import drop index i_eg_kfeebatch_idx;
alter table i_eg_gift_import drop index i_eg_kfund_idx;
alter table i_eg_gift_import drop index i_eg_kgiftbatch_idx;
alter table i_eg_gift_import drop index i_eg_stats_idx;


/* i_eg_gift_trx_fees */
/* drop index i_eg_gift_trx_fees.i_eg_gift_trx_fees_pk */ 
/* go */


/* i_eg_giving_url */
alter table i_eg_giving_url drop index i_eg_giveurl_revidx;
/* drop index i_eg_giving_url.i_eg_giving_url_pk */ 
/* go */


/* i_crm_partner_import */
/* drop index i_crm_partner_import.i_crm_partner_import_pk */ 
/* go */


/* i_crm_partner_import_option */
/* drop index i_crm_partner_import_option.i_crm_partner_import_opt_pk */ 
/* go */


/* i_crm_import_type */
/* drop index i_crm_import_type.i_crm_import_type_pk */ 
/* go */


/* i_crm_import_type_option */
/* drop index i_crm_import_type_option.i_crm_import_type_option_pk */ 
/* go */


/* i_disb_import_classify */
/* drop index i_disb_import_classify.i_disb_import_pk */ 
/* go */


/* i_disb_import_status */
/* drop index i_disb_import_status.i_disb_legacy_pk */ 
/* go */


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


/* t_project */
alter table t_project drop index t_parent_idx;
/* drop index t_project.t_project_pk */ 
/* go */


/* t_sprint */
alter table t_sprint drop index t_sprint_idx;
/* drop index t_sprint.t_sprint_pk */ 
/* go */


/* t_sprint_project */
/* drop index t_sprint_project.t_sprintproj_pk */ 
/* go */


/* t_sprint_time */
/* drop index t_sprint_time.t_sprint_time_pk */ 
/* go */
alter table t_sprint_time drop index t_time_proj_idx;
alter table t_sprint_time drop index t_time_sprint_idx;


/* t_task */
/* drop index t_task.t_task_pk */ 
/* go */
alter table t_task drop index t_task_proj_idx;
alter table t_task drop index t_task_sprint_idx;


/* t_participant */
alter table t_participant drop index t_part_proj_idx;
/* drop index t_participant.t_participant_pk */ 
/* go */


/* t_sprint_participant */
alter table t_sprint_participant drop index t_spart_proj_idx;
alter table t_sprint_participant drop index t_spart_sprint_idx;
/* drop index t_sprint_participant.t_sprint_participant_pk */ 
/* go */


/* t_assignee */
/* drop index t_assignee.t_assignee_pk */ 
/* go */
alter table t_assignee drop index t_assignee_task_idx;


/* t_task_state */
/* drop index t_task_state.t_tstate_pk */ 
/* go */


/* t_task_history */
/* drop index t_task_history.t_history_pk */ 
/* go */
alter table t_task_history drop index t_taskhist_idx;


/* s_config */
/* drop index s_config.s_config_pk */ 
/* go */


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


/* s_role */
/* drop index s_role.s_role_pk */ 
/* go */


/* s_role_exclusivity */
/* drop index s_role_exclusivity.s_role_ex_pk */ 
/* go */


/* s_user_role */
/* drop index s_user_role.s_user_role_pk */ 
/* go */


/* s_global_search */
/* drop index s_global_search.s_global_search_pk */ 
/* go */


/* s_stats_cache */
/* drop index s_stats_cache.s_stats_cache_pk */ 
/* go */


/* s_document_scanner */
/* drop index s_document_scanner.s_scanner_pk */ 
/* go */
