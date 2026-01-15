$Version=2$
a_subtrx_gift "application/filespec"
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
    a_receipt_number "filespec/column" { type=varchar(64); id=1; }
    a_batch_number "filespec/column" { type=integer; id=2; }
    a_gift_admin_fee "filespec/column" { type=float; id=3; }
    a_posted_to_gl "filespec/column" { type=bit; id=4; }
    a_gift_type "filespec/column" { type=char(1); id=5; }
    a_receipt_sent_date "filespec/column" { type=datetime; id=6; }
    a_calc_admin_fee_subtype "filespec/column" { type=char(1); id=7; }
    a_period "filespec/column" { type=char(8); id=8; }
    a_posted "filespec/column" { type=bit; id=9; }
    a_receipt_sent "filespec/column" { type=bit; id=10; }
    a_recv_document_id "filespec/column" { type=varchar(64); id=11; }
    a_gift_postmark_date "filespec/column" { type=datetime; id=12; }
    a_anonymous_gift "filespec/column" { type=bit; id=13; }
    a_calc_admin_fee_type "filespec/column" { type=char(3); id=14; }
    a_gift_admin_subtype "filespec/column" { type=char(1); id=15; }
    a_calc_admin_fee "filespec/column" { type=float; id=16; }
    a_ledger_number "filespec/column" { type=char(10); id=17; }
    s_date_created "filespec/column" { type=datetime; id=18; }
    s_modified_by "filespec/column" { type=varchar(20); id=19; }
    a_personal_gift "filespec/column" { type=bit; id=20; }
    a_first_gift "filespec/column" { type=bit; id=21; }
    a_comment "filespec/column" { type=varchar(255); id=22; }
    a_goods_provided "filespec/column" { type=decimal(14,4); id=23; }
    a_fund "filespec/column" { type=char(20); id=24; }
    p_recip_partner_id "filespec/column" { type=char(10); id=25; }
    a_gift_received_date "filespec/column" { type=datetime; id=26; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=27; }
    p_donor_partner_id "filespec/column" { type=char(10); id=28; }
    s_created_by "filespec/column" { type=varchar(20); id=29; }
    a_account_code "filespec/column" { type=char(16); id=30; }
    a_gift_number "filespec/column" { type=integer; id=31; }
    a_receipt_desired "filespec/column" { type=bit; id=32; }
    a_amount "filespec/column" { type=decimal(14,4); id=33; }
    s_date_modified "filespec/column" { type=datetime; id=34; }
    }
