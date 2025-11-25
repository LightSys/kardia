$Version=2$
p_partner_sort_tmp "application/filespec"
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
    p_sort_session_id "filespec/column" { type=integer; id=1; }
    s_modified_by "filespec/column" { type=varchar(20); id=2; }
    s_created_by "filespec/column" { type=varchar(20); id=3; }
    p_location_id "filespec/column" { type=integer; id=4; }
    p_contact_id "filespec/column" { type=integer; id=5; }
    p_partner_key "filespec/column" { type=char(10); id=6; }
    s_date_created "filespec/column" { type=datetime; id=7; }
    s_date_modified "filespec/column" { type=datetime; id=8; }
    s_username "filespec/column" { type=varchar(20); id=9; }
    p_sortkey "filespec/column" { type=varchar(255); id=10; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=11; }
    }
