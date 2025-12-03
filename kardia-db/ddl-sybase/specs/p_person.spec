$Version=2$
p_person "application/filespec"
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
    p_marital_status "filespec/column" { type=char(1); id=1; }
    s_created_by "filespec/column" { type=varchar(20); id=2; }
    p_academic_title "filespec/column" { type=varchar(48); id=3; }
    s_modified_by "filespec/column" { type=varchar(20); id=4; }
    s_date_modified "filespec/column" { type=datetime; id=5; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=6; }
    s_date_created "filespec/column" { type=datetime; id=7; }
    p_previous_surname "filespec/column" { type=varchar(64); id=8; }
    p_partner_key "filespec/column" { type=char(10); id=9; }
    p_date_of_birth "filespec/column" { type=datetime; id=10; }
    }
