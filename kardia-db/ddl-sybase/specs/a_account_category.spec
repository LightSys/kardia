$Version=2$
a_account_category "application/filespec"
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
    a_is_intrafund_xfer "filespec/column" { type=bit; id=2; }
    s_modified_by "filespec/column" { type=varchar(20); id=3; }
    a_acct_type "filespec/column" { type=char(1); id=4; }
    a_is_interfund_xfer "filespec/column" { type=bit; id=5; }
    a_acct_cat_desc "filespec/column" { type=varchar(32); id=6; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=7; }
    s_date_modified "filespec/column" { type=datetime; id=8; }
    a_account_category "filespec/column" { type=char(8); id=9; }
    s_date_created "filespec/column" { type=datetime; id=10; }
    a_ledger_number "filespec/column" { type=char(10); id=11; }
    a_acct_cat_comment "filespec/column" { type=varchar(255); id=12; }
    }
