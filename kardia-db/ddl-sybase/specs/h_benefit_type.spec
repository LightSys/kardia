$Version=2$
h_benefit_type "application/filespec"
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
    h_benefit_type_color "filespec/column" { type=varchar(16); id=1; }
    h_benefit_type_id "filespec/column" { type=integer; id=2; }
    h_benefit_type_label "filespec/column" { type=varchar(64); id=3; }
    s_date_created "filespec/column" { type=datetime; id=4; }
    s_date_modified "filespec/column" { type=datetime; id=5; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=6; }
    s_modified_by "filespec/column" { type=varchar(20); id=7; }
    s_created_by "filespec/column" { type=varchar(20); id=8; }
    h_benefit_type_abbrev "filespec/column" { type=varchar(16); id=9; }
    }
