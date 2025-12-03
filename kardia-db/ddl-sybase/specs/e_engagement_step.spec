$Version=2$
e_engagement_step "application/filespec"
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
    e_step_name "filespec/column" { type=varchar(32); id=2; }
    s_modified_by "filespec/column" { type=varchar(20); id=3; }
    e_step_description "filespec/column" { type=varchar(255); id=4; }
    e_step_id "filespec/column" { type=integer; id=5; }
    e_step_sequence "filespec/column" { type=integer; id=6; }
    e_track_id "filespec/column" { type=integer; id=7; }
    s_date_created "filespec/column" { type=datetime; id=8; }
    s_date_modified "filespec/column" { type=datetime; id=9; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=10; }
    }
