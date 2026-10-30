$Version=2$
a_gift_payment_type "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for a_gift_payment_type";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    a_ledger_number "filespec/column" { type=string; id=1; }
    a_gift_payment_type "filespec/column" { type=string; id=2; }
    a_gift_payment_type_desc "filespec/column" { type=string; id=3; }
    a_is_default "filespec/column" { type=integer; id=4; }
    a_is_enabled "filespec/column" { type=integer; id=5; }
    a_is_cash "filespec/column" { type=integer; id=6; }
    a_payment_fund "filespec/column" { type=string; id=7; }
    a_payment_account_code "filespec/column" { type=string; id=8; }
    a_desig_account_code "filespec/column" { type=string; id=9; }
    a_min_gift "filespec/column" { type=money; id=10; }
    a_max_gift "filespec/column" { type=money; id=11; }
    s_date_created "filespec/column" { type=datetime; id=12; }
    s_created_by "filespec/column" { type=string; id=13; }
    s_date_modified "filespec/column" { type=datetime; id=14; }
    s_modified_by "filespec/column" { type=string; id=15; }
    __cx_osml_control "filespec/column" { type=string; id=16; }
    }
