$Version=2$
e_activity "application/filespec"
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
    e_initiation "filespec/column" { type=char(1); id=2; }
    e_activity_date "filespec/column" { type=datetime; id=3; }
    e_activity_group_id "filespec/column" { type=integer; id=4; }
    s_modified_by "filespec/column" { type=varchar(20); id=5; }
    e_activity_type "filespec/column" { type=char(4); id=6; }
    e_info "filespec/column" { type=varchar(900); id=7; }
    s_date_created "filespec/column" { type=datetime; id=8; }
    s_date_modified "filespec/column" { type=datetime; id=9; }
    e_activity_id "filespec/column" { type=integer; id=10; }
    e_whom "filespec/column" { type=char(10); id=11; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=12; }
    p_partner_key "filespec/column" { type=char(10); id=13; }
    e_reference_info "filespec/column" { type=varchar(900); id=14; }
    e_sort_key "filespec/column" { type=varchar(20); id=15; }
    }
