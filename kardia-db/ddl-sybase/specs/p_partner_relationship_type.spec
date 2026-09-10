$Version=2$
p_partner_relationship_type "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for p_partner_relationship_type";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    p_relation_type "filespec/column" { type=integer; id=1; }
    p_relation_type_label "filespec/column" { type=string; id=2; }
    p_relation_type_desc "filespec/column" { type=string; id=3; }
    p_relation_type_rev_label "filespec/column" { type=string; id=4; }
    p_relation_type_rev_desc "filespec/column" { type=string; id=5; }
    s_date_created "filespec/column" { type=datetime; id=6; }
    s_created_by "filespec/column" { type=string; id=7; }
    s_date_modified "filespec/column" { type=datetime; id=8; }
    s_modified_by "filespec/column" { type=string; id=9; }
    __cx_osml_control "filespec/column" { type=string; id=10; }
    }
