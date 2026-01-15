$Version=2$
h_work_register_times "application/filespec"
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
    s_modified_by "filespec/column" { type=varchar(20); id=1; }
    h_work_end_date "filespec/column" { type=datetime; id=2; }
    s_created_by "filespec/column" { type=varchar(20); id=3; }
    p_partner_key "filespec/column" { type=char(10); id=4; }
    h_work_comments "filespec/column" { type=varchar(900); id=5; }
    h_work_start_date "filespec/column" { type=datetime; id=6; }
    s_date_created "filespec/column" { type=datetime; id=7; }
    h_work_register_time_id "filespec/column" { type=integer; id=8; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=9; }
    s_date_modified "filespec/column" { type=datetime; id=10; }
    }
