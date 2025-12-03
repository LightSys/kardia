$Version=2$
a_subtrx_gift_group "application/filespec"
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
    s_created_by "filespec/column" { type=varchar(20); id=1; }
    p_donor_partner_id "filespec/column" { type=char(10); id=2; }
    a_foreign_amount "filespec/column" { type=decimal(14,4); id=3; }
    a_receipt_desired "filespec/column" { type=char(1); id=4; }
    a_amount "filespec/column" { type=decimal(14,4); id=5; }
    s_date_modified "filespec/column" { type=datetime; id=6; }
    a_gift_number "filespec/column" { type=integer; id=7; }
    a_first_gift "filespec/column" { type=bit; id=8; }
    a_comment "filespec/column" { type=varchar(900); id=9; }
    a_goods_provided "filespec/column" { type=decimal(14,4); id=10; }
    a_ack_receipt_sent "filespec/column" { type=bit; id=11; }
    s_modified_by "filespec/column" { type=varchar(20); id=12; }
    a_foreign_currency "filespec/column" { type=char(3); id=13; }
    a_ack_receipt_desired "filespec/column" { type=char(1); id=14; }
    a_gift_received_date "filespec/column" { type=datetime; id=15; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=16; }
    p_ack_partner_id "filespec/column" { type=char(10); id=17; }
    a_ack_receipt_sent_date "filespec/column" { type=datetime; id=18; }
    a_gift_postmark_date "filespec/column" { type=datetime; id=19; }
    p_pass_partner_id "filespec/column" { type=char(10); id=20; }
    s_date_created "filespec/column" { type=datetime; id=21; }
    a_foreign_currency_exch_rate "filespec/column" { type=float; id=22; }
    a_ledger_number "filespec/column" { type=char(10); id=23; }
    a_foreign_currency_date "filespec/column" { type=float; id=24; }
    a_posted_to_gl "filespec/column" { type=bit; id=25; }
    a_receipt_number "filespec/column" { type=varchar(64); id=26; }
    a_batch_number "filespec/column" { type=integer; id=27; }
    a_receipt_sent_date "filespec/column" { type=datetime; id=28; }
    a_period "filespec/column" { type=char(8); id=29; }
    a_receipt_sent "filespec/column" { type=bit; id=30; }
    a_posted "filespec/column" { type=bit; id=31; }
    a_gift_type "filespec/column" { type=char(1); id=32; }
    }
