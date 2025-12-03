$Version=2$
e_tag_type_relationship "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for e_tag_type_relationship";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    e_tag_id "filespec/column" { type=integer; id=1; }
    e_rel_tag_id "filespec/column" { type=integer; id=2; }
    e_rel_strength "filespec/column" { type=double; id=3; }
    e_rel_certainty "filespec/column" { type=double; id=4; }
    s_date_created "filespec/column" { type=datetime; id=5; }
    s_created_by "filespec/column" { type=string; id=6; }
    s_date_modified "filespec/column" { type=datetime; id=7; }
    s_modified_by "filespec/column" { type=string; id=8; }
    __cx_osml_control "filespec/column" { type=string; id=9; }
    }
