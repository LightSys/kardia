$Version=2$
e_tag "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for e_tag";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    e_tag_id "filespec/column" { type=integer; id=1; }
    p_partner_key "filespec/column" { type=string; id=2; }
    e_tag_strength "filespec/column" { type=double; id=3; }
    e_tag_certainty "filespec/column" { type=double; id=4; }
    e_tag_volatility "filespec/column" { type=string; id=5; }
    e_tag_origin "filespec/column" { type=string; id=6; }
    e_tag_comments "filespec/column" { type=string; id=7; }
    s_date_created "filespec/column" { type=datetime; id=8; }
    s_created_by "filespec/column" { type=string; id=9; }
    s_date_modified "filespec/column" { type=datetime; id=10; }
    s_modified_by "filespec/column" { type=string; id=11; }
    __cx_osml_control "filespec/column" { type=string; id=12; }
    }
