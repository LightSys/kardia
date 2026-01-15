$Version=2$
e_trackactivity "application/filespec"
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
    s_date_created "filespec/column" { type=datetime; id=2; }
    e_object_desc "filespec/column" { type=varchar(255); id=3; }
    e_sort_key "filespec/column" { type=varchar(32); id=4; }
    e_object_label "filespec/column" { type=varchar(64); id=5; }
    p_partner_key "filespec/column" { type=char(10); id=6; }
    e_object_name "filespec/column" { type=varchar(32); id=7; }
    s_created_by "filespec/column" { type=varchar(20); id=8; }
    e_track_id "filespec/column" { type=integer; id=9; }
    e_step_id "filespec/column" { type=integer; id=10; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=11; }
    e_completion_status "filespec/column" { type=char(1); id=12; }
    e_object_type "filespec/column" { type=char(1); id=13; }
    e_username "filespec/column" { type=varchar(20); id=14; }
    e_object_comm "filespec/column" { type=varchar(900); id=15; }
    s_modified_by "filespec/column" { type=varchar(20); id=16; }
    }
