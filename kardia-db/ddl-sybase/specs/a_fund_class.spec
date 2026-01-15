$Version=2$
a_fund_class "application/filespec"
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
    a_fund_class "filespec/column" { type=char(3); id=1; }
    s_modified_by "filespec/column" { type=varchar(20); id=2; }
    a_fund_class_desc "filespec/column" { type=varchar(255); id=3; }
    s_created_by "filespec/column" { type=varchar(20); id=4; }
    a_ledger_number "filespec/column" { type=char(10); id=5; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=6; }
    s_date_modified "filespec/column" { type=datetime; id=7; }
    s_date_created "filespec/column" { type=datetime; id=8; }
    }
