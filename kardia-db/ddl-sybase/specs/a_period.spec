$Version=2$
a_period "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for a_period";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    a_period "filespec/column" { type=string; id=1; }
    a_ledger_number "filespec/column" { type=string; id=2; }
    a_parent_period "filespec/column" { type=string; id=3; }
    a_status "filespec/column" { type=string; id=4; }
    a_summary_only "filespec/column" { type=integer; id=5; }
    a_start_date "filespec/column" { type=datetime; id=6; }
    a_end_date "filespec/column" { type=datetime; id=7; }
    a_first_opened "filespec/column" { type=datetime; id=8; }
    a_last_closed "filespec/column" { type=datetime; id=9; }
    a_archived "filespec/column" { type=datetime; id=10; }
    a_period_desc "filespec/column" { type=string; id=11; }
    a_period_comment "filespec/column" { type=string; id=12; }
    s_date_created "filespec/column" { type=datetime; id=13; }
    s_created_by "filespec/column" { type=string; id=14; }
    s_date_modified "filespec/column" { type=datetime; id=15; }
    s_modified_by "filespec/column" { type=string; id=16; }
    __cx_osml_control "filespec/column" { type=string; id=17; }
    }
