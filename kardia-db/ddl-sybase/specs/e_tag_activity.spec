$Version=2$
e_tag_activity "application/filespec"
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
    e_tag_activity_group "filespec/column" { type=integer; id=1; }
    s_created_by "filespec/column" { type=varchar(20); id=2; }
    e_tag_strength "filespec/column" { type=float; id=3; }
    e_tag_volatility "filespec/column" { type=char(1); id=4; }
    e_tag_certainty "filespec/column" { type=float; id=5; }
    s_modified_by "filespec/column" { type=varchar(20); id=6; }
    s_date_modified "filespec/column" { type=datetime; id=7; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=8; }
    s_date_created "filespec/column" { type=datetime; id=9; }
    e_tag_activity_id "filespec/column" { type=integer; id=10; }
    e_tag_id "filespec/column" { type=integer; id=11; }
    p_partner_key "filespec/column" { type=char(10); id=12; }
    e_tag_origin "filespec/column" { type=varchar(8); id=13; }
    }
