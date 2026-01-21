$Version=2$
h_staff "application/filespec"
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
    p_partner_key "filespec/column" { type=char(10); id=1; }
    h_staff_role "filespec/column" { type=char(1); id=2; }
    s_date_created "filespec/column" { type=datetime; id=3; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=4; }
    h_percent_fulltime "filespec/column" { type=float; id=5; }
    s_date_modified "filespec/column" { type=datetime; id=6; }
    s_modified_by "filespec/column" { type=varchar(20); id=7; }
    h_start_date "filespec/column" { type=datetime; id=8; }
    h_is_active "filespec/column" { type=bit; id=9; }
    s_created_by "filespec/column" { type=varchar(20); id=10; }
    }
