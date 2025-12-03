$Version=2$
a_subtrx_gift_item "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "Obfuscated Data";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    a_amount "filespec/column" { type=decimal(14,4); id=1; }
    s_date_modified "filespec/column" { type=datetime; id=2; }
    a_account_hash "filespec/column" { type=varchar(256); id=3; }
    a_foreign_amount "filespec/column" { type=decimal(14,4); id=4; }
    a_gift_number "filespec/column" { type=integer; id=5; }
    p_dn_pass_partner_id "filespec/column" { type=char(10); id=6; }
    a_account_code "filespec/column" { type=char(16); id=7; }
    s_created_by "filespec/column" { type=varchar(20); id=8; }
    a_dn_gift_received_date "filespec/column" { type=datetime; id=9; }
    a_check_front_image "filespec/column" { type=varchar(256); id=10; }
    p_dn_ack_partner_id "filespec/column" { type=char(10); id=11; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=12; }
    a_dn_receipt_number "filespec/column" { type=varchar(64); id=13; }
    a_fund "filespec/column" { type=char(20); id=14; }
    a_item_intent_code "filespec/column" { type=char(1); id=15; }
    p_recip_partner_id "filespec/column" { type=char(10); id=16; }
    a_dn_gift_postmark_date "filespec/column" { type=datetime; id=17; }
    a_confidential "filespec/column" { type=bit; id=18; }
    a_comment "filespec/column" { type=varchar(255); id=19; }
    s_modified_by "filespec/column" { type=varchar(20); id=20; }
    a_foreign_currency "filespec/column" { type=char(3); id=21; }
    a_foreign_currency_exch_rate "filespec/column" { type=float; id=22; }
    s_date_created "filespec/column" { type=datetime; id=23; }
    a_ledger_number "filespec/column" { type=char(10); id=24; }
    a_calc_admin_fee "filespec/column" { type=float; id=25; }
    a_gift_admin_subtype "filespec/column" { type=char(1); id=26; }
    p_dn_donor_partner_id "filespec/column" { type=char(10); id=27; }
    a_calc_admin_fee_type "filespec/column" { type=char(3); id=28; }
    a_recv_document_id "filespec/column" { type=varchar(64); id=29; }
    a_posted "filespec/column" { type=bit; id=30; }
    a_period "filespec/column" { type=char(8); id=31; }
    a_calc_admin_fee_subtype "filespec/column" { type=char(1); id=32; }
    a_non_tax_deductible "filespec/column" { type=bit; id=33; }
    a_check_back_image "filespec/column" { type=varchar(256); id=34; }
    a_posted_to_gl "filespec/column" { type=bit; id=35; }
    a_motivational_code "filespec/column" { type=varchar(16); id=36; }
    a_foreign_currency_date "filespec/column" { type=float; id=37; }
    a_gift_admin_fee "filespec/column" { type=float; id=38; }
    i_eg_source_key "filespec/column" { type=varchar(255); id=39; }
    a_batch_number "filespec/column" { type=integer; id=40; }
    a_dn_gift_type "filespec/column" { type=char(1); id=41; }
    a_split_number "filespec/column" { type=integer; id=42; }
    }
