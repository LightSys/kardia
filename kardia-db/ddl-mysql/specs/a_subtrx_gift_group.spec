$Version=2$
a_subtrx_gift_group "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for a_subtrx_gift_group";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    a_ledger_number "filespec/column" { type=string; id=1; }
    a_batch_number "filespec/column" { type=integer; id=2; }
    a_gift_number "filespec/column" { type=integer; id=3; }
    a_period "filespec/column" { type=string; id=4; }
    a_amount "filespec/column" { type=money; id=5; }
    a_foreign_amount "filespec/column" { type=money; id=6; }
    a_foreign_currency "filespec/column" { type=string; id=7; }
    a_foreign_currency_exch_rate "filespec/column" { type=double; id=8; }
    a_foreign_currency_date "filespec/column" { type=double; id=9; }
    a_posted "filespec/column" { type=integer; id=10; }
    a_posted_to_gl "filespec/column" { type=integer; id=11; }
    a_gift_type "filespec/column" { type=string; id=12; }
    a_receipt_number "filespec/column" { type=string; id=13; }
    p_donor_partner_id "filespec/column" { type=string; id=14; }
    p_ack_partner_id "filespec/column" { type=string; id=15; }
    p_pass_partner_id "filespec/column" { type=string; id=16; }
    a_receipt_sent "filespec/column" { type=integer; id=17; }
    a_ack_receipt_sent "filespec/column" { type=integer; id=18; }
    a_receipt_desired "filespec/column" { type=string; id=19; }
    a_ack_receipt_desired "filespec/column" { type=string; id=20; }
    a_first_gift "filespec/column" { type=integer; id=21; }
    a_goods_provided "filespec/column" { type=money; id=22; }
    a_gift_received_date "filespec/column" { type=datetime; id=23; }
    a_gift_postmark_date "filespec/column" { type=datetime; id=24; }
    a_receipt_sent_date "filespec/column" { type=datetime; id=25; }
    a_ack_receipt_sent_date "filespec/column" { type=datetime; id=26; }
    a_comment "filespec/column" { type=string; id=27; }
    s_date_created "filespec/column" { type=datetime; id=28; }
    s_created_by "filespec/column" { type=string; id=29; }
    s_date_modified "filespec/column" { type=datetime; id=30; }
    s_modified_by "filespec/column" { type=string; id=31; }
    __cx_osml_control "filespec/column" { type=string; id=32; }
    }
