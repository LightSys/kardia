$Version=2$
a_subtrx_gift_item "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for a_subtrx_gift_item";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    a_ledger_number "filespec/column" { type=string; id=1; }
    a_batch_number "filespec/column" { type=integer; id=2; }
    a_gift_number "filespec/column" { type=integer; id=3; }
    a_split_number "filespec/column" { type=integer; id=4; }
    a_period "filespec/column" { type=string; id=5; }
    a_fund "filespec/column" { type=string; id=6; }
    a_account_code "filespec/column" { type=string; id=7; }
    a_amount "filespec/column" { type=money; id=8; }
    a_foreign_amount "filespec/column" { type=money; id=9; }
    a_foreign_currency "filespec/column" { type=string; id=10; }
    a_foreign_currency_exch_rate "filespec/column" { type=double; id=11; }
    a_foreign_currency_date "filespec/column" { type=double; id=12; }
    a_recv_document_id "filespec/column" { type=string; id=13; }
    a_account_hash "filespec/column" { type=string; id=14; }
    a_check_front_image "filespec/column" { type=string; id=15; }
    a_check_back_image "filespec/column" { type=string; id=16; }
    a_posted "filespec/column" { type=integer; id=17; }
    a_posted_to_gl "filespec/column" { type=integer; id=18; }
    a_gift_admin_fee "filespec/column" { type=double; id=19; }
    a_gift_admin_subtype "filespec/column" { type=string; id=20; }
    a_calc_admin_fee "filespec/column" { type=double; id=21; }
    a_calc_admin_fee_type "filespec/column" { type=string; id=22; }
    a_calc_admin_fee_subtype "filespec/column" { type=string; id=23; }
    p_recip_partner_id "filespec/column" { type=string; id=24; }
    a_confidential "filespec/column" { type=integer; id=25; }
    a_non_tax_deductible "filespec/column" { type=integer; id=26; }
    a_motivational_code "filespec/column" { type=string; id=27; }
    a_item_intent_code "filespec/column" { type=string; id=28; }
    a_comment "filespec/column" { type=string; id=29; }
    i_eg_source_key "filespec/column" { type=string; id=30; }
    p_dn_donor_partner_id "filespec/column" { type=string; id=31; }
    p_dn_ack_partner_id "filespec/column" { type=string; id=32; }
    p_dn_pass_partner_id "filespec/column" { type=string; id=33; }
    a_dn_receipt_number "filespec/column" { type=string; id=34; }
    a_dn_gift_received_date "filespec/column" { type=datetime; id=35; }
    a_dn_gift_postmark_date "filespec/column" { type=datetime; id=36; }
    a_dn_gift_type "filespec/column" { type=string; id=37; }
    s_date_created "filespec/column" { type=datetime; id=38; }
    s_created_by "filespec/column" { type=string; id=39; }
    s_date_modified "filespec/column" { type=datetime; id=40; }
    s_modified_by "filespec/column" { type=string; id=41; }
    __cx_osml_control "filespec/column" { type=string; id=42; }
    }
