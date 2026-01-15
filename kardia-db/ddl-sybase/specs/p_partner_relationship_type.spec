$Version=2$
p_partner_relationship_type "application/filespec"
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
    s_modified_by "filespec/column" { type=varchar(20); id=2; }
    p_relation_type_rev_desc "filespec/column" { type=varchar(900); id=3; }
    s_date_created "filespec/column" { type=datetime; id=4; }
    p_relation_type_desc "filespec/column" { type=varchar(900); id=5; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=6; }
    s_date_modified "filespec/column" { type=datetime; id=7; }
    p_relation_type_label "filespec/column" { type=varchar(40); id=8; }
    p_relation_type_rev_label "filespec/column" { type=varchar(40); id=9; }
    p_relation_type "filespec/column" { type=integer; id=10; }
    }
