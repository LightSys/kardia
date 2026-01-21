$Version=2$
e_trackactivity "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for e_trackactivity";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    p_partner_key "filespec/column" { type=string; id=1; }
    e_username "filespec/column" { type=string; id=2; }
    e_sort_key "filespec/column" { type=string; id=3; }
    e_track_id "filespec/column" { type=integer; id=4; }
    e_step_id "filespec/column" { type=integer; id=5; }
    e_object_type "filespec/column" { type=string; id=6; }
    e_completion_status "filespec/column" { type=string; id=7; }
    e_object_name "filespec/column" { type=string; id=8; }
    e_object_label "filespec/column" { type=string; id=9; }
    e_object_desc "filespec/column" { type=string; id=10; }
    e_object_comm "filespec/column" { type=string; id=11; }
    s_date_created "filespec/column" { type=datetime; id=12; }
    s_created_by "filespec/column" { type=string; id=13; }
    s_date_modified "filespec/column" { type=datetime; id=14; }
    s_modified_by "filespec/column" { type=string; id=15; }
    __cx_osml_control "filespec/column" { type=string; id=16; }
    }
