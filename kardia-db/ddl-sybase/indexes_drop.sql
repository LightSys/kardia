use Kardia_DB
go



/* p_partner */
drop index p_partner.p_cost_ctr_idx
go
drop index p_partner.p_given_name_idx
go
drop index p_partner.p_legacy_key_1_idx
go
drop index p_partner.p_legacy_key_2_idx
go
drop index p_partner.p_merged_with_idx
go
drop index p_partner.p_org_name_idx
go
drop index p_partner.p_parent_key_idx
go
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
drop index p_location.p_location_city_idx
go
/* drop index p_location.p_location_pk */ 
/* go */
drop index p_location.p_location_rev_idx
go
drop index p_location.p_location_state_idx
go
drop index p_location.p_location_zip_idx
go
/* drop index p_location.p_postal_sort_clustered_idx */ 
/* go */


/* p_address_format */
drop index p_address_format.p_af_country_idx
go
/* drop index p_address_format.p_af_pk */ 
/* go */


/* p_address_format_set */
/* drop index p_address_format_set.p_afs_pk */ 
/* go */


/* p_contact_info */
drop index p_contact_info.p_contact_idx
go
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
drop index p_partner_relationship.p_relate_reverse_idx
go


/* p_partner_relationship_type */
/* drop index p_partner_relationship_type.p_relat_type_pk */ 
/* go */


/* p_church */
/* drop index p_church.p_church_pk */ 
/* go */


/* p_donor */
drop index p_donor.p_dnr_gl_acct_idx
go
/* drop index p_donor.p_donor_pk */ 
/* go */


/* p_payee */
drop index p_payee.p_gl_acct_idx
go
/* drop index p_payee.p_payee_pk */ 
/* go */


/* p_staff */
drop index p_staff.p_staff_login_idx
go
/* drop index p_staff.p_staff_pk */ 
/* go */
drop index p_staff.p_staff_weblogin_idx
go


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
drop index p_banking_details.p_bankd_acct_idx
go
drop index p_banking_details.p_bankd_bpartner_idx
go
drop index p_banking_details.p_bankd_partner_idx
go
/* drop index p_banking_details.p_banking_details_pk */ 
/* go */


/* p_banking_type */
/* drop index p_banking_type.p_banking_type_pk */ 
/* go */


/* p_title */
/* drop index p_title.p_title_pk */ 
/* go */


/* p_gazetteer */
drop index p_gazetteer.p_gaz_altid_idx
go
drop index p_gazetteer.p_gaz_id_idx
go
/* drop index p_gazetteer.p_gaz_name_clustered_idx */ 
/* go */
drop index p_gazetteer.p_gaz_state_idx
go
drop index p_gazetteer.p_gaz_type_idx
go
/* drop index p_gazetteer.p_gazetteer_pk */ 
/* go */


/* p_dup_check_tmp */
drop index p_dup_check_tmp.p_dc_username_idx
go
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
drop index p_partner_search_results.p_search_stage_idx
go
/* drop index p_partner_search_results.p_searchres_pk */ 
/* go */


/* p_search_stage_criteria */
/* drop index p_search_stage_criteria.p_stage_criteria_pk */ 
/* go */


/* m_list */
/* drop index m_list.m_list_pk */ 
/* go */


/* m_list_membership */
/* drop index m_list_membership.m_list_membership_clustered_pk */ 
/* go */
drop index m_list_membership.m_lists_by_partner
go


/* e_contact_autorecord */
drop index e_contact_autorecord.e_autorec_collab_idx
go
drop index e_contact_autorecord.e_autorec_collabhist_idx
go
drop index e_contact_autorecord.e_autorec_histtype_idx
go
/* drop index e_contact_autorecord.e_autorec_pk */ 
/* go */


/* e_contact_history_type */
/* drop index e_contact_history_type.e_cnt_hist_type_pk */ 
/* go */


/* e_contact_history */
drop index e_contact_history.e_cnt_hist_locpar_idx
go
drop index e_contact_history.e_cnt_hist_par_idx
go
/* drop index e_contact_history.e_cnt_hist_pk */ 
/* go */
drop index e_contact_history.e_cnt_hist_type_idx
go
drop index e_contact_history.e_cnt_hist_whom_idx
go


/* e_activity */
drop index e_activity.e_act_par_idx
go
/* drop index e_activity.e_act_pk */ 
/* go */
drop index e_activity.e_act_sort_idx
go
drop index e_activity.e_act_type_idx
go


/* e_engagement_track */
drop index e_engagement_track.e_trk_name_idx
go
/* drop index e_engagement_track.e_trk_pk */ 
/* go */


/* e_engagement_track_collab */
/* drop index e_engagement_track_collab.e_trkcoll_pk */ 
/* go */
drop index e_engagement_track_collab.e_trkcoll_ptnr_idx
go


/* e_engagement_step */
drop index e_engagement_step.e_step_name_idx
go
/* drop index e_engagement_step.e_step_pk */ 
/* go */


/* e_engagement_step_collab */
/* drop index e_engagement_step_collab.e_stepcoll_pk */ 
/* go */
drop index e_engagement_step_collab.e_stepcoll_ptnr_idx
go


/* e_engagement_step_req */
/* drop index e_engagement_step_req.e_req_pk */ 
/* go */


/* e_partner_engagement */
/* drop index e_partner_engagement.e_pareng_pk */ 
/* go */
drop index e_partner_engagement.e_pareng_start_idx
go
drop index e_partner_engagement.e_pareng_trackstep_idx
go


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
drop index e_tag.e_tag_rev_idx
go
drop index e_tag.e_tag_strength_idx
go


/* e_tag_activity */
drop index e_tag_activity.e_tagact_gptnr_idx
go
drop index e_tag_activity.e_tagact_gtag_idx
go
/* drop index e_tag_activity.e_tagact_pk */ 
/* go */
drop index e_tag_activity.e_tagact_ptnr_idx
go
drop index e_tag_activity.e_tagact_tagid_idx
go


/* e_tag_source */
/* drop index e_tag_source.e_tagsrc_pk */ 
/* go */
drop index e_tag_source.e_tagsrc_src_idx
go


/* e_document_type */
drop index e_document_type.e_doctype_label_idx
go
drop index e_document_type.e_doctype_parent_idx
go
/* drop index e_document_type.e_doctype_pk */ 
/* go */


/* e_document */
drop index e_document.e_doc_curpath_idx
go
/* drop index e_document.e_doc_pk */ 
/* go */
drop index e_document.e_doc_type_idx
go
drop index e_document.e_doc_work_idx
go


/* e_document_comment */
drop index e_document_comment.e_doccom_collab_idx
go
/* drop index e_document_comment.e_doccom_pk */ 
/* go */
drop index e_document_comment.e_doccom_tgtcollab_idx
go
drop index e_document_comment.e_doccom_work_idx
go


/* e_partner_document */
drop index e_partner_document.e_pardoc_egagement_idx
go
/* drop index e_partner_document.e_pardoc_pk */ 
/* go */
drop index e_partner_document.e_pardoc_rev_idx
go
drop index e_partner_document.e_pardoc_work_idx
go


/* e_workflow_type */
/* drop index e_workflow_type.e_work_pk */ 
/* go */


/* e_workflow_type_step */
/* drop index e_workflow_type_step.e_workstep_pk */ 
/* go */
drop index e_workflow_type_step.e_workstep_trig_idx
go
drop index e_workflow_type_step.e_workstep_type_idx
go


/* e_workflow */
/* drop index e_workflow.e_workinst_pk */ 
/* go */
drop index e_workflow.e_workinst_steptrig_idx
go
drop index e_workflow.e_workinst_trig_idx
go
drop index e_workflow.e_workinst_type_idx
go


/* e_collaborator_type */
/* drop index e_collaborator_type.e_collabtype_pk */ 
/* go */


/* e_collaborator */
/* drop index e_collaborator.e_collab_pk */ 
/* go */
drop index e_collaborator.e_collab_rev_idx
go
drop index e_collaborator.e_collab_type_idx
go


/* e_todo_type */
/* drop index e_todo_type.e_todotype_pk */ 
/* go */


/* e_todo */
drop index e_todo.e_todo_collab_idx
go
drop index e_todo.e_todo_doc_idx
go
drop index e_todo.e_todo_eng_idx
go
drop index e_todo.e_todo_par_idx
go
/* drop index e_todo.e_todo_pk */ 
/* go */
drop index e_todo.e_todo_reqitem_idx
go
drop index e_todo.e_todo_type_idx
go


/* e_data_item_type */
drop index e_data_item_type.e_ditype_parent_idx
go
/* drop index e_data_item_type.e_ditype_pk */ 
/* go */


/* e_data_item_type_value */
/* drop index e_data_item_type_value.e_dataitemval_pk */ 
/* go */


/* e_data_item_group */
/* drop index e_data_item_group.e_digrp_pk */ 
/* go */
drop index e_data_item_group.e_digrp_type_idx
go


/* e_data_item */
drop index e_data_item.e_dataitem_group_idx
go
/* drop index e_data_item.e_dataitem_pk */ 
/* go */
drop index e_data_item.e_dataitem_type_idx
go


/* e_highlights */
drop index e_highlights.e_h_nt_idx
go
/* drop index e_highlights.e_h_pk */ 
/* go */
drop index e_highlights.e_h_prec_idx
go


/* e_data_highlight */
drop index e_data_highlight.e_dh_obj_idx
go
/* drop index e_data_highlight.e_dh_pk */ 
/* go */


/* e_ack */
drop index e_ack.e_ack_obj_idx
go
drop index e_ack.e_ack_par2_idx
go
drop index e_ack.e_ack_par3_idx
go
drop index e_ack.e_ack_par_idx
go
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
drop index e_text_search_word.e_tsw_word_idx
go


/* e_text_search_rel */
/* drop index e_text_search_rel.e_tsr_pk */ 
/* go */
drop index e_text_search_rel.e_tsr_rev_idx
go


/* e_text_search_occur */
/* drop index e_text_search_occur.e_tso_pk */ 
/* go */
drop index e_text_search_occur.e_tso_seq_idx
go


/* h_staff */
/* drop index h_staff.h_staff_pk */ 
/* go */


/* h_group */
/* drop index h_group.h_group_pk */ 
/* go */


/* h_group_member */
drop index h_group_member.h_group_ptnr_idx
go
/* drop index h_group_member.h_groupm_pk */ 
/* go */


/* h_holidays */
/* drop index h_holidays.h_holiday_pk */ 
/* go */


/* h_work_register */
drop index h_work_register.h_workreg_ben_idx
go
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
drop index h_benefit_type_sched.h_bts_group_idx
go
drop index h_benefit_type_sched.h_bts_partner_idx
go


/* h_benefits */
drop index h_benefits.h_ben_partner_idx
go
drop index h_benefits.h_ben_period_idx
go
/* drop index h_benefits.h_ben_pk */ 
/* go */


/* r_group */
drop index r_group.r_grp_modfile_idx
go
/* drop index r_group.r_grp_pk */ 
/* go */


/* r_group_report */
drop index r_group_report.r_rpt_partner_idx
go
/* drop index r_group_report.r_rpt_pk */ 
/* go */


/* r_group_param */
drop index r_group_param.r_param_cmp_idx
go
/* drop index r_group_param.r_param_pk */ 
/* go */


/* r_group_report_param */
drop index r_group_report_param.r_rparam_param_idx
go
drop index r_group_report_param.r_rparam_partner_idx
go
/* drop index r_group_report_param.r_rparam_pk */ 
/* go */
drop index r_group_report_param.r_rparam_value_idx
go


/* r_saved_paramset */
drop index r_saved_paramset.r_ps_modfile_idx
go
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
drop index a_cost_center.a_cc_bal_idx
go
drop index a_cost_center.a_cc_ledger_number_idx
go
drop index a_cost_center.a_cc_legacy_idx
go
drop index a_cost_center.a_cc_parent_idx
go
/* drop index a_cost_center.a_cost_center_pk */ 
/* go */


/* a_account */
/* drop index a_account.a_account_pk */ 
/* go */
drop index a_account.a_acct_ledger_number_idx
go
drop index a_account.a_acct_legacy_idx
go
drop index a_account.a_acct_parent_idx
go


/* a_account_usage */
/* drop index a_account_usage.a_account_usage_pk */ 
/* go */
drop index a_account_usage.a_acctusg_acct_idx
go
drop index a_account_usage.a_acctusg_ledger_number_idx
go


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
drop index a_batch.a_batch_ledger_idx
go
/* drop index a_batch.a_batch_pk */ 
/* go */
drop index a_batch.a_corr_batch_idx
go


/* a_transaction */
/* drop index a_transaction.a_transaction_pk */ 
/* go */
drop index a_transaction.a_trx_batch_idx
go
/* drop index a_transaction.a_trx_cc_clustered_idx */ 
/* go */
drop index a_transaction.a_trx_cc_quicksum_idx
go
drop index a_transaction.a_trx_ccperiod_idx
go
drop index a_transaction.a_trx_donor_id_idx
go
drop index a_transaction.a_trx_journal_idx
go
drop index a_transaction.a_trx_period_idx
go
drop index a_transaction.a_trx_recip_id_idx
go
drop index a_transaction.a_trx_transaction_idx
go


/* a_transaction_tmp */
/* drop index a_transaction_tmp.a_transaction_tmp_pk */ 
/* go */
drop index a_transaction_tmp.a_trxt_batch_idx
go
/* drop index a_transaction_tmp.a_trxt_cc_clustered_idx */ 
/* go */
drop index a_transaction_tmp.a_trxt_cc_quicksum_idx
go
drop index a_transaction_tmp.a_trxt_donor_id_idx
go
drop index a_transaction_tmp.a_trxt_journal_idx
go
drop index a_transaction_tmp.a_trxt_recip_id_idx
go
drop index a_transaction_tmp.a_trxt_transaction_idx
go


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
drop index a_cost_center_prefix.a_cc_pfx_ledger_number_idx
go
/* drop index a_cost_center_prefix.a_cost_center_prefix_pk */ 
/* go */


/* a_cc_staff */
/* drop index a_cc_staff.a_cc_staff_pk */ 
/* go */


/* a_ledger_office */
/* drop index a_ledger_office.a_lo_pk */ 
/* go */


/* a_payroll */
drop index a_payroll.a_payroll_cc_idx
go
drop index a_payroll.a_payroll_payee_idx
go
/* drop index a_payroll.a_payroll_pk */ 
/* go */


/* a_payroll_period */
drop index a_payroll_period.a_payperiod_idx
go
/* drop index a_payroll_period.a_payperiod_pk */ 
/* go */


/* a_payroll_group */
/* drop index a_payroll_group.a_payroll_grp_pk */ 
/* go */


/* a_payroll_import */
drop index a_payroll_import.a_payrolli_cc_idx
go
drop index a_payroll_import.a_payrolli_payee_idx
go
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


/* a_salary_review */
/* drop index a_salary_review.a_salreview_pk */ 
/* go */
drop index a_salary_review.a_salreview_review_idx
go


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
drop index a_admin_fee_type_item.a_afti_ledger_number_idx
go


/* a_admin_fee_type_item_tmp */
/* drop index a_admin_fee_type_item_tmp.a_admin_fee_type_item_tmp_pk */ 
/* go */
drop index a_admin_fee_type_item_tmp.a_afti_tmp_ledger_number_idx
go


/* a_cc_receipting */
/* drop index a_cc_receipting.a_cc_receipting_pk */ 
/* go */
drop index a_cc_receipting.a_ccr_ledger_number_idx
go


/* a_cc_receipting_accts */
/* drop index a_cc_receipting_accts.a_cc_rcptacct_pk */ 
/* go */
drop index a_cc_receipting_accts.a_ccra_acct_number_idx
go
drop index a_cc_receipting_accts.a_ccra_ledger_number_idx
go


/* a_receipt_type */
/* drop index a_receipt_type.a_rcpttype_pk */ 
/* go */


/* a_subtrx_gift */
drop index a_subtrx_gift.a_gifttrx_batch_idx
go
/* drop index a_subtrx_gift.a_gifttrx_cc_clustered_idx */ 
/* go */
drop index a_subtrx_gift.a_gifttrx_donor_id_idx
go
drop index a_subtrx_gift.a_gifttrx_gift_idx
go
/* drop index a_subtrx_gift.a_gifttrx_pk */ 
/* go */
drop index a_subtrx_gift.a_gifttrx_recip_id_idx
go


/* a_subtrx_gift_group */
drop index a_subtrx_gift_group.a_gifttrxgrp_ack_id_idx
go
drop index a_subtrx_gift_group.a_gifttrxgrp_batch_idx
go
drop index a_subtrx_gift_group.a_gifttrxgrp_donor_id_idx
go
drop index a_subtrx_gift_group.a_gifttrxgrp_gift_idx
go
drop index a_subtrx_gift_group.a_gifttrxgrp_pass_id_idx
go
/* drop index a_subtrx_gift_group.a_gifttrxgrp_pk */ 
/* go */


/* a_subtrx_gift_item */
/* drop index a_subtrx_gift_item.a_gifttrx_pk */ 
/* go */
drop index a_subtrx_gift_item.a_gifttrxi_ack_idx
go
/* drop index a_subtrx_gift_item.a_gifttrxi_cc_clustered_idx */ 
/* go */
drop index a_subtrx_gift_item.a_gifttrxi_datetype_idx
go
drop index a_subtrx_gift_item.a_gifttrxi_donor_idx
go
drop index a_subtrx_gift_item.a_gifttrxi_gift_idx
go
drop index a_subtrx_gift_item.a_gifttrxi_mcode_idx
go
drop index a_subtrx_gift_item.a_gifttrxi_pass_idx
go
drop index a_subtrx_gift_item.a_gifttrxi_rcpt_idx
go
drop index a_subtrx_gift_item.a_gifttrxi_recip_id_idx
go
drop index a_subtrx_gift_item.a_gifttrxi_src_idx
go


/* a_subtrx_gift_rcptcnt */
/* drop index a_subtrx_gift_rcptcnt.a_rcptno_pk */ 
/* go */


/* a_cc_auto_subscribe */
drop index a_cc_auto_subscribe.a_cc_as_ledger_number_idx
go
drop index a_cc_auto_subscribe.a_cc_as_listcode_idx
go
/* drop index a_cc_auto_subscribe.a_cc_auto_subscribe_pk */ 
/* go */


/* a_motivational_code */
drop index a_motivational_code.a_motiv_code_cc
go
drop index a_motivational_code.a_motiv_code_list
go
drop index a_motivational_code.a_motiv_code_parent
go
/* drop index a_motivational_code.a_motivational_code_pk */ 
/* go */


/* a_giving_pattern */
drop index a_giving_pattern.a_givingp_actual_idx
go
drop index a_giving_pattern.a_givingp_donor_idx
go
drop index a_giving_pattern.a_givingp_fund_idx
go
/* drop index a_giving_pattern.a_givingp_pk */ 
/* go */
drop index a_giving_pattern.a_givingp_review_idx
go


/* a_giving_pattern_allocation */
drop index a_giving_pattern_allocation.a_givingpa_actual_idx
go
drop index a_giving_pattern_allocation.a_givingpa_donor_idx
go
drop index a_giving_pattern_allocation.a_givingpa_fund_idx
go
/* drop index a_giving_pattern_allocation.a_givingpa_pk */ 
/* go */
drop index a_giving_pattern_allocation.a_givingpa_review_idx
go


/* a_giving_pattern_flag */
/* drop index a_giving_pattern_flag.a_givingf_pk */ 
/* go */
drop index a_giving_pattern_flag.a_givingf_review_idx
go


/* a_funding_target */
/* drop index a_funding_target.a_target_pk */ 
/* go */


/* a_support_review */
/* drop index a_support_review.a_supportreview_pk */ 
/* go */


/* a_support_review_target */
/* drop index a_support_review_target.a_supptgt_pk */ 
/* go */
drop index a_support_review_target.a_supptgt_review_idx
go
drop index a_support_review_target.a_supptgt_target_idx
go


/* a_descriptives */
drop index a_descriptives.a_descr_cc_idx
go
drop index a_descriptives.a_descr_par_idx
go
/* drop index a_descriptives.a_descr_pk */ 
/* go */


/* a_descriptives_hist */
drop index a_descriptives_hist.a_descrhist_cc_idx
go
drop index a_descriptives_hist.a_descrhist_merge_idx
go
drop index a_descriptives_hist.a_descrhist_par_idx
go
/* drop index a_descriptives_hist.a_descrhist_pk */ 
/* go */


/* a_subtrx_cashdisb */
drop index a_subtrx_cashdisb.a_subtrx_cashdisb_acct_idx
go
drop index a_subtrx_cashdisb.a_subtrx_cashdisb_batch_idx
go
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
drop index a_subtrx_deposit.a_subtrx_dep_acct_idx
go
drop index a_subtrx_deposit.a_subtrx_dep_batch_idx
go
/* drop index a_subtrx_deposit.a_subtrx_deposit_pk */ 
/* go */


/* a_subtrx_cashxfer */
/* drop index a_subtrx_cashxfer.a_subtrx_cashxfer_pk */ 
/* go */


/* i_eg_gift_import */
drop index i_eg_gift_import.i_eg_edeposit_idx
go
drop index i_eg_gift_import.i_eg_edonor_idx
go
drop index i_eg_gift_import.i_eg_efund_idx
go
drop index i_eg_gift_import.i_eg_egift_idx
go
/* drop index i_eg_gift_import.i_eg_gift_import_pk */ 
/* go */
drop index i_eg_gift_import.i_eg_kdepbatch_idx
go
drop index i_eg_gift_import.i_eg_kdoncc_idx
go
drop index i_eg_gift_import.i_eg_kdonor_idx
go
drop index i_eg_gift_import.i_eg_kfeebatch_idx
go
drop index i_eg_gift_import.i_eg_kfund_idx
go
drop index i_eg_gift_import.i_eg_kgiftbatch_idx
go


/* i_eg_gift_trx_fees */
/* drop index i_eg_gift_trx_fees.i_eg_gift_trx_fees_pk */ 
/* go */


/* i_eg_giving_url */
drop index i_eg_giving_url.i_eg_giveurl_revidx
go
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
drop index c_chat.c_public_idx
go


/* c_member */
/* drop index c_member.c_member_pk */ 
/* go */
drop index c_member.s_username_idx
go


/* t_project */
/* drop index t_project.t_project_pk */ 
/* go */


/* t_sprint */
/* drop index t_sprint.t_sprint_pk */ 
/* go */
drop index t_sprint.t_sprint_proj_idx
go


/* t_sprint_time */
/* drop index t_sprint_time.t_sprint_time_pk */ 
/* go */
drop index t_sprint_time.t_time_proj_idx
go
drop index t_sprint_time.t_time_sprint_idx
go


/* t_task */
/* drop index t_task.t_task_pk */ 
/* go */
drop index t_task.t_task_proj_idx
go
drop index t_task.t_task_sprint_idx
go


/* t_participant */
drop index t_participant.t_part_proj_idx
go
/* drop index t_participant.t_participant_pk */ 
/* go */


/* t_sprint_participant */
drop index t_sprint_participant.t_spart_proj_idx
go
drop index t_sprint_participant.t_spart_sprint_idx
go
/* drop index t_sprint_participant.t_sprint_participant_pk */ 
/* go */


/* t_assignee */
/* drop index t_assignee.t_assignee_pk */ 
/* go */
drop index t_assignee.t_assignee_task_idx
go


/* t_task_state */
/* drop index t_task_state.t_tstate_pk */ 
/* go */


/* t_task_history */
/* drop index t_task_history.t_history_pk */ 
/* go */


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
drop index s_motd_viewed.s_motd_viewed_username_idx
go


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
drop index s_request.s_objkey12_idx
go
drop index s_request.s_objkey21_idx
go
/* drop index s_request.s_req_pk */ 
/* go */


/* s_request_type */
/* drop index s_request_type.s_reqtype_pk */ 
/* go */


/* s_audit */
drop index s_audit.s_audit_intval_idx
go
drop index s_audit.s_audit_name_idx
go
/* drop index s_audit.s_audit_pk */ 
/* go */
drop index s_audit.s_audit_strval_idx
go


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
