$Version=2$
a_account_usage_type "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for a_account_usage_type";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    a_acct_usage_code "filespec/column" { type=string; id=1; }
    a_acct_type "filespec/column" { type=string; id=2; }
    a_acct_usage_desc "filespec/column" { type=string; id=3; }
    a_acct_usage_comment "filespec/column" { type=string; id=4; }
    s_date_created "filespec/column" { type=datetime; id=5; }
    s_created_by "filespec/column" { type=string; id=6; }
    s_date_modified "filespec/column" { type=datetime; id=7; }
    s_modified_by "filespec/column" { type=string; id=8; }
    __cx_osml_control "filespec/column" { type=string; id=9; }
    }
