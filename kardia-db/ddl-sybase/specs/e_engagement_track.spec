$Version=2$
e_engagement_track "application/filespec"
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
    e_track_name "filespec/column" { type=varchar(24); id=1; }
    s_date_created "filespec/column" { type=datetime; id=2; }
    e_track_color "filespec/column" { type=varchar(32); id=3; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=4; }
    s_date_modified "filespec/column" { type=datetime; id=5; }
    s_modified_by "filespec/column" { type=varchar(20); id=6; }
    e_track_id "filespec/column" { type=integer; id=7; }
    e_track_description "filespec/column" { type=varchar(255); id=8; }
    s_created_by "filespec/column" { type=varchar(20); id=9; }
    e_track_status "filespec/column" { type=char(1); id=10; }
    }
