$Version=2$
a_reporting_level "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for a_reporting_level";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    a_reporting_level "filespec/column" { type=integer; id=1; }
    a_ledger_number "filespec/column" { type=string; id=2; }
    a_level_desc "filespec/column" { type=string; id=3; }
    a_level_rpt_desc "filespec/column" { type=string; id=4; }
    a_level_comment "filespec/column" { type=string; id=5; }
    s_date_created "filespec/column" { type=datetime; id=6; }
    s_created_by "filespec/column" { type=string; id=7; }
    s_date_modified "filespec/column" { type=datetime; id=8; }
    s_modified_by "filespec/column" { type=string; id=9; }
    __cx_osml_control "filespec/column" { type=string; id=10; }
    }
