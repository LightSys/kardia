$Version=2$
a_period_usage_type "application/filespec"
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
    a_period_usage_desc "filespec/column" { type=varchar(32); id=1; }
    s_created_by "filespec/column" { type=varchar(20); id=2; }
    s_modified_by "filespec/column" { type=varchar(20); id=3; }
    a_period_usage_code "filespec/column" { type=char(4); id=4; }
    s_date_modified "filespec/column" { type=datetime; id=5; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=6; }
    s_date_created "filespec/column" { type=datetime; id=7; }
    a_period_usage_comment "filespec/column" { type=varchar(255); id=8; }
    }
