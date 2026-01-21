$Version=2$
a_support_review_target "application/filespec"
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
    a_comment "filespec/column" { type=varchar(255); id=2; }
    a_target_id "filespec/column" { type=integer; id=3; }
    s_modified_by "filespec/column" { type=varchar(20); id=4; }
    s_date_created "filespec/column" { type=datetime; id=5; }
    a_amount "filespec/column" { type=decimal(14,4); id=6; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=7; }
    s_date_modified "filespec/column" { type=datetime; id=8; }
    a_fund "filespec/column" { type=char(20); id=9; }
    a_review "filespec/column" { type=varchar(16); id=10; }
    a_target_amount "filespec/column" { type=decimal(14,4); id=11; }
    a_ledger_number "filespec/column" { type=char(10); id=12; }
    }
