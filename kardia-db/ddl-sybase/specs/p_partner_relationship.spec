$Version=2$
p_partner_relationship "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for p_partner_relationship";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    p_partner_key "filespec/column" { type=string; id=1; }
    p_relation_type "filespec/column" { type=integer; id=2; }
    p_relation_key "filespec/column" { type=string; id=3; }
    p_relation_comments "filespec/column" { type=string; id=4; }
    p_relation_start_date "filespec/column" { type=datetime; id=5; }
    p_relation_end_date "filespec/column" { type=datetime; id=6; }
    s_date_created "filespec/column" { type=datetime; id=7; }
    s_created_by "filespec/column" { type=string; id=8; }
    s_date_modified "filespec/column" { type=datetime; id=9; }
    s_modified_by "filespec/column" { type=string; id=10; }
    __cx_osml_control "filespec/column" { type=string; id=11; }
    }
