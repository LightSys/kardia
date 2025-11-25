$Version=2$
p_staff "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for p_staff";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    p_partner_key "filespec/column" { type=string; id=1; }
    p_is_staff "filespec/column" { type=integer; id=2; }
    p_kardia_login "filespec/column" { type=string; id=3; }
    p_kardiaweb_login "filespec/column" { type=string; id=4; }
    p_preferred_email_id "filespec/column" { type=integer; id=5; }
    p_preferred_location_id "filespec/column" { type=integer; id=6; }
    s_date_created "filespec/column" { type=datetime; id=7; }
    s_created_by "filespec/column" { type=string; id=8; }
    s_date_modified "filespec/column" { type=datetime; id=9; }
    s_modified_by "filespec/column" { type=string; id=10; }
    __cx_osml_control "filespec/column" { type=string; id=11; }
    }
