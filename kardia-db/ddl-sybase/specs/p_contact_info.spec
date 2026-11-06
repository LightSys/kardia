$Version=2$
p_contact_info "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for p_contact_info";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    p_partner_key "filespec/column" { type=string; id=1; }
    p_contact_id "filespec/column" { type=integer; id=2; }
    p_contact_type "filespec/column" { type=string; id=3; }
    p_location_id "filespec/column" { type=string; id=4; }
    p_phone_country "filespec/column" { type=string; id=5; }
    p_phone_area_city "filespec/column" { type=string; id=6; }
    p_contact_data "filespec/column" { type=string; id=7; }
    p_record_status_code "filespec/column" { type=string; id=8; }
    p_contact_comments "filespec/column" { type=string; id=9; }
    s_date_created "filespec/column" { type=datetime; id=10; }
    s_created_by "filespec/column" { type=string; id=11; }
    s_date_modified "filespec/column" { type=datetime; id=12; }
    s_modified_by "filespec/column" { type=string; id=13; }
    __cx_osml_control "filespec/column" { type=string; id=14; }
    }
