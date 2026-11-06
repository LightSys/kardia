$Version=2$
p_partner_sort_tmp "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for p_partner_sort_tmp";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    p_partner_key "filespec/column" { type=string; id=1; }
    s_username "filespec/column" { type=string; id=2; }
    p_sort_session_id "filespec/column" { type=integer; id=3; }
    p_sortkey "filespec/column" { type=string; id=4; }
    p_location_id "filespec/column" { type=integer; id=5; }
    p_contact_id "filespec/column" { type=integer; id=6; }
    s_date_created "filespec/column" { type=datetime; id=7; }
    s_created_by "filespec/column" { type=string; id=8; }
    s_date_modified "filespec/column" { type=datetime; id=9; }
    s_modified_by "filespec/column" { type=string; id=10; }
    __cx_osml_control "filespec/column" { type=string; id=11; }
    }
