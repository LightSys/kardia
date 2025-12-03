$Version=2$
p_staff "application/filespec"
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
    p_preferred_location_id "filespec/column" { type=integer; id=1; }
    p_partner_key "filespec/column" { type=char(10); id=2; }
    p_preferred_email_id "filespec/column" { type=integer; id=3; }
    s_date_created "filespec/column" { type=datetime; id=4; }
    p_is_staff "filespec/column" { type=bit; id=5; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=6; }
    s_date_modified "filespec/column" { type=datetime; id=7; }
    s_modified_by "filespec/column" { type=varchar(20); id=8; }
    p_kardia_login "filespec/column" { type=varchar(128); id=9; }
    s_created_by "filespec/column" { type=varchar(20); id=10; }
    p_kardiaweb_login "filespec/column" { type=varchar(128); id=11; }
    }
