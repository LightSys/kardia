$Version=2$
e_engagement_track "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for e_engagement_track";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    e_track_id "filespec/column" { type=integer; id=1; }
    e_track_name "filespec/column" { type=string; id=2; }
    e_track_description "filespec/column" { type=string; id=3; }
    e_track_color "filespec/column" { type=string; id=4; }
    e_track_status "filespec/column" { type=string; id=5; }
    s_date_created "filespec/column" { type=datetime; id=6; }
    s_created_by "filespec/column" { type=string; id=7; }
    s_date_modified "filespec/column" { type=datetime; id=8; }
    s_modified_by "filespec/column" { type=string; id=9; }
    __cx_osml_control "filespec/column" { type=string; id=10; }
    }
