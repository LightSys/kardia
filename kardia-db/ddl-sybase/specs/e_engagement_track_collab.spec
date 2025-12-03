$Version=2$
e_engagement_track_collab "application/filespec"
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
    p_collab_partner_key "filespec/column" { type=char(10); id=2; }
    s_modified_by "filespec/column" { type=varchar(20); id=3; }
    e_track_id "filespec/column" { type=integer; id=4; }
    s_date_created "filespec/column" { type=datetime; id=5; }
    s_date_modified "filespec/column" { type=datetime; id=6; }
    e_comments "filespec/column" { type=varchar(255); id=7; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=8; }
    e_collab_type_id "filespec/column" { type=integer; id=9; }
    }
