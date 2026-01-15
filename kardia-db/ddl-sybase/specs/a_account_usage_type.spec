$Version=2$
a_account_usage_type "application/filespec"
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
    s_modified_by "filespec/column" { type=varchar(20); id=1; }
    a_acct_type "filespec/column" { type=char(1); id=2; }
    a_acct_usage_desc "filespec/column" { type=varchar(32); id=3; }
    a_acct_usage_comment "filespec/column" { type=varchar(255); id=4; }
    s_created_by "filespec/column" { type=varchar(20); id=5; }
    s_date_created "filespec/column" { type=datetime; id=6; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=7; }
    s_date_modified "filespec/column" { type=datetime; id=8; }
    a_acct_usage_code "filespec/column" { type=char(4); id=9; }
    }
