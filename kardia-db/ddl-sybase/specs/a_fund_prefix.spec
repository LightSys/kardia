$Version=2$
a_fund_prefix "application/filespec"
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
    a_fund_prefix "filespec/column" { type=char(20); id=2; }
    s_created_by "filespec/column" { type=varchar(20); id=3; }
    a_ledger_number "filespec/column" { type=char(10); id=4; }
    a_fund_prefix_comments "filespec/column" { type=varchar(255); id=5; }
    a_fund_prefix_desc "filespec/column" { type=char(32); id=6; }
    s_date_modified "filespec/column" { type=datetime; id=7; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=8; }
    s_date_created "filespec/column" { type=datetime; id=9; }
    }
