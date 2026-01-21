$Version=2$
e_contact_history_type "application/filespec"
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
    s_date_modified "filespec/column" { type=datetime; id=1; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=2; }
    e_description "filespec/column" { type=varchar(80); id=3; }
    e_is_inperson "filespec/column" { type=bit; id=4; }
    s_date_created "filespec/column" { type=datetime; id=5; }
    e_is_notes "filespec/column" { type=bit; id=6; }
    e_short_name "filespec/column" { type=varchar(24); id=7; }
    s_created_by "filespec/column" { type=varchar(20); id=8; }
    e_contact_history_type "filespec/column" { type=integer; id=9; }
    e_user_selectable "filespec/column" { type=bit; id=10; }
    s_modified_by "filespec/column" { type=varchar(20); id=11; }
    }
