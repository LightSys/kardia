$Version=2$
a_reporting_level "application/filespec"
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
    s_date_modified "filespec/column" { type=datetime; id=1; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=2; }
    s_date_created "filespec/column" { type=datetime; id=3; }
    a_ledger_number "filespec/column" { type=char(10); id=4; }
    a_level_desc "filespec/column" { type=varchar(32); id=5; }
    a_level_rpt_desc "filespec/column" { type=varchar(32); id=6; }
    a_level_comment "filespec/column" { type=varchar(255); id=7; }
    a_reporting_level "filespec/column" { type=integer; id=8; }
    s_created_by "filespec/column" { type=varchar(20); id=9; }
    s_modified_by "filespec/column" { type=varchar(20); id=10; }
    }
