$Version=2$
p_partner_relationship "application/filespec"
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
    p_relation_comments "filespec/column" { type=varchar(900); id=1; }
    p_relation_type "filespec/column" { type=integer; id=2; }
    p_partner_key "filespec/column" { type=char(10); id=3; }
    p_relation_end_date "filespec/column" { type=datetime; id=4; }
    s_date_modified "filespec/column" { type=datetime; id=5; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=6; }
    p_relation_start_date "filespec/column" { type=datetime; id=7; }
    s_date_created "filespec/column" { type=datetime; id=8; }
    p_relation_key "filespec/column" { type=char(10); id=9; }
    s_modified_by "filespec/column" { type=varchar(20); id=10; }
    s_created_by "filespec/column" { type=varchar(20); id=11; }
    }
