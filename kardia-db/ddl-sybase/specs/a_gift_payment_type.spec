$Version=2$
a_gift_payment_type "application/filespec"
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
    a_is_enabled "filespec/column" { type=bit; id=1; }
    s_modified_by "filespec/column" { type=varchar(20); id=2; }
    a_max_gift "filespec/column" { type=decimal(14,4); id=3; }
    a_is_cash "filespec/column" { type=bit; id=4; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=5; }
    a_gift_payment_type "filespec/column" { type=char(1); id=6; }
    a_gift_payment_type_desc "filespec/column" { type=varchar(64); id=7; }
    a_desig_account_code "filespec/column" { type=char(16); id=8; }
    a_payment_fund "filespec/column" { type=char(20); id=9; }
    s_created_by "filespec/column" { type=varchar(20); id=10; }
    a_is_default "filespec/column" { type=bit; id=11; }
    s_date_modified "filespec/column" { type=datetime; id=12; }
    s_date_created "filespec/column" { type=datetime; id=13; }
    a_ledger_number "filespec/column" { type=char(10); id=14; }
    a_payment_account_code "filespec/column" { type=char(16); id=15; }
    a_min_gift "filespec/column" { type=decimal(14,4); id=16; }
    }
