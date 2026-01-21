$Version=2$
r_group_sched_param "application/filespec"
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
    r_param_name "filespec/column" { type=varchar(64); id=1; }
    r_group_sched_id "filespec/column" { type=integer; id=2; }
    s_created_by "filespec/column" { type=varchar(20); id=3; }
    s_modified_by "filespec/column" { type=varchar(20); id=4; }
    r_param_value "filespec/column" { type=varchar(900); id=5; }
    r_group_name "filespec/column" { type=char(8); id=6; }
    s_date_modified "filespec/column" { type=datetime; id=7; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=8; }
    s_date_created "filespec/column" { type=datetime; id=9; }
    }
