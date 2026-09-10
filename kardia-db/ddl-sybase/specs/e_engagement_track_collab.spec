$Version=2$
e_engagement_track_collab "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for e_engagement_track_collab";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    e_track_id "filespec/column" { type=integer; id=1; }
    p_collab_partner_key "filespec/column" { type=string; id=2; }
    e_collab_type_id "filespec/column" { type=integer; id=3; }
    e_comments "filespec/column" { type=string; id=4; }
    s_date_created "filespec/column" { type=datetime; id=5; }
    s_created_by "filespec/column" { type=string; id=6; }
    s_date_modified "filespec/column" { type=datetime; id=7; }
    s_modified_by "filespec/column" { type=string; id=8; }
    __cx_osml_control "filespec/column" { type=string; id=9; }
    }
