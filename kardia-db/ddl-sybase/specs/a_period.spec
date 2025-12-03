$Version=2$
a_period "application/filespec"
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
    a_summary_only "filespec/column" { type=bit; id=1; }
    a_period_desc "filespec/column" { type=varchar(32); id=2; }
    a_period_comment "filespec/column" { type=varchar(255); id=3; }
    s_created_by "filespec/column" { type=varchar(20); id=4; }
    a_ledger_number "filespec/column" { type=char(10); id=5; }
    a_archived "filespec/column" { type=datetime; id=6; }
    a_start_date "filespec/column" { type=datetime; id=7; }
    a_first_opened "filespec/column" { type=datetime; id=8; }
    s_date_modified "filespec/column" { type=datetime; id=9; }
    s_date_created "filespec/column" { type=datetime; id=10; }
    s_modified_by "filespec/column" { type=varchar(20); id=11; }
    a_parent_period "filespec/column" { type=char(8); id=12; }
    a_last_closed "filespec/column" { type=datetime; id=13; }
    a_period "filespec/column" { type=char(8); id=14; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=15; }
    a_end_date "filespec/column" { type=datetime; id=16; }
    a_status "filespec/column" { type=char(1); id=17; }
    }
