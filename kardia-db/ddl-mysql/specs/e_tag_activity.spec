$Version=2$
e_tag_activity "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for e_tag_activity";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    e_tag_activity_group "filespec/column" { type=integer; id=1; }
    e_tag_activity_id "filespec/column" { type=integer; id=2; }
    e_tag_id "filespec/column" { type=integer; id=3; }
    p_partner_key "filespec/column" { type=string; id=4; }
    e_tag_strength "filespec/column" { type=double; id=5; }
    e_tag_certainty "filespec/column" { type=double; id=6; }
    e_tag_volatility "filespec/column" { type=string; id=7; }
    e_tag_origin "filespec/column" { type=string; id=8; }
    s_date_created "filespec/column" { type=datetime; id=9; }
    s_created_by "filespec/column" { type=string; id=10; }
    s_date_modified "filespec/column" { type=datetime; id=11; }
    s_modified_by "filespec/column" { type=string; id=12; }
    __cx_osml_control "filespec/column" { type=string; id=13; }
    }
