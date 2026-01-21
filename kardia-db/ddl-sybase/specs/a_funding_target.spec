$Version=2$
a_funding_target "application/filespec"
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
    s_date_modified "filespec/column" { type=datetime; id=2; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=3; }
    a_amount "filespec/column" { type=decimal(14,4); id=4; }
    a_end_date "filespec/column" { type=datetime; id=5; }
    a_start_date "filespec/column" { type=datetime; id=6; }
    a_target_desc "filespec/column" { type=varchar(255); id=7; }
    a_review "filespec/column" { type=varchar(16); id=8; }
    a_ledger_number "filespec/column" { type=char(10); id=9; }
    a_fund "filespec/column" { type=char(20); id=10; }
    s_created_by "filespec/column" { type=varchar(20); id=11; }
    a_interval "filespec/column" { type=integer; id=12; }
    s_modified_by "filespec/column" { type=varchar(20); id=13; }
    a_target_id "filespec/column" { type=integer; id=14; }
    }
