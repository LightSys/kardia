$Version=2$
a_funding_target "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for a_funding_target";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    a_ledger_number "filespec/column" { type=string; id=1; }
    a_fund "filespec/column" { type=string; id=2; }
    a_target_id "filespec/column" { type=integer; id=3; }
    a_target_desc "filespec/column" { type=string; id=4; }
    a_review "filespec/column" { type=string; id=5; }
    a_amount "filespec/column" { type=money; id=6; }
    a_interval "filespec/column" { type=integer; id=7; }
    a_start_date "filespec/column" { type=datetime; id=8; }
    a_end_date "filespec/column" { type=datetime; id=9; }
    s_date_created "filespec/column" { type=datetime; id=10; }
    s_created_by "filespec/column" { type=string; id=11; }
    s_date_modified "filespec/column" { type=datetime; id=12; }
    s_modified_by "filespec/column" { type=string; id=13; }
    __cx_osml_control "filespec/column" { type=string; id=14; }
    }
