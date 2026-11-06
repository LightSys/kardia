$Version=2$
h_work_register_times "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for h_work_register_times";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    p_partner_key "filespec/column" { type=string; id=1; }
    h_work_register_time_id "filespec/column" { type=integer; id=2; }
    h_work_start_date "filespec/column" { type=datetime; id=3; }
    h_work_end_date "filespec/column" { type=datetime; id=4; }
    h_work_comments "filespec/column" { type=string; id=5; }
    s_date_created "filespec/column" { type=datetime; id=6; }
    s_created_by "filespec/column" { type=string; id=7; }
    s_date_modified "filespec/column" { type=datetime; id=8; }
    s_modified_by "filespec/column" { type=string; id=9; }
    __cx_osml_control "filespec/column" { type=string; id=10; }
    }
