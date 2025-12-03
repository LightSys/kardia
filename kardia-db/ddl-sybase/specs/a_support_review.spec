$Version=2$
a_support_review "application/filespec"
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
    s_date_created "filespec/column" { type=datetime; id=1; }
    a_review_desc "filespec/column" { type=varchar(255); id=2; }
    s_date_modified "filespec/column" { type=datetime; id=3; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=4; }
    a_review "filespec/column" { type=varchar(16); id=5; }
    a_ledger_number "filespec/column" { type=char(10); id=6; }
    s_created_by "filespec/column" { type=varchar(20); id=7; }
    s_modified_by "filespec/column" { type=varchar(20); id=8; }
    a_review_date "filespec/column" { type=datetime; id=9; }
    }
