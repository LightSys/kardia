$Version=2$
a_subtrx_gift "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for a_subtrx_gift";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    a_ledger_number "filespec/column" { type=string; id=1; }
    a_batch_number "filespec/column" { type=integer; id=2; }
    a_gift_number "filespec/column" { type=integer; id=3; }
    a_period "filespec/column" { type=string; id=4; }
    a_fund "filespec/column" { type=string; id=5; }
    a_account_code "filespec/column" { type=string; id=6; }
    a_amount "filespec/column" { type=money; id=7; }
    a_posted "filespec/column" { type=integer; id=8; }
    a_posted_to_gl "filespec/column" { type=integer; id=9; }
    a_gift_type "filespec/column" { type=string; id=10; }
    a_gift_admin_fee "filespec/column" { type=double; id=11; }
    a_gift_admin_subtype "filespec/column" { type=string; id=12; }
    a_calc_admin_fee "filespec/column" { type=double; id=13; }
    a_calc_admin_fee_type "filespec/column" { type=string; id=14; }
    a_calc_admin_fee_subtype "filespec/column" { type=string; id=15; }
    a_recv_document_id "filespec/column" { type=string; id=16; }
    a_receipt_number "filespec/column" { type=string; id=17; }
    p_donor_partner_id "filespec/column" { type=string; id=18; }
    p_recip_partner_id "filespec/column" { type=string; id=19; }
    a_receipt_sent "filespec/column" { type=integer; id=20; }
    a_receipt_desired "filespec/column" { type=integer; id=21; }
    a_anonymous_gift "filespec/column" { type=integer; id=22; }
    a_personal_gift "filespec/column" { type=integer; id=23; }
    a_first_gift "filespec/column" { type=integer; id=24; }
    a_goods_provided "filespec/column" { type=money; id=25; }
    a_gift_received_date "filespec/column" { type=datetime; id=26; }
    a_gift_postmark_date "filespec/column" { type=datetime; id=27; }
    a_receipt_sent_date "filespec/column" { type=datetime; id=28; }
    a_comment "filespec/column" { type=string; id=29; }
    s_date_created "filespec/column" { type=datetime; id=30; }
    s_created_by "filespec/column" { type=string; id=31; }
    s_date_modified "filespec/column" { type=datetime; id=32; }
    s_modified_by "filespec/column" { type=string; id=33; }
    __cx_osml_control "filespec/column" { type=string; id=34; }
    }
