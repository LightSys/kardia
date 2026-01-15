$Version=2$
p_contact_info "application/filespec"
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
    s_date_created "filespec/column" { type=datetime; id=1; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=2; }
    s_date_modified "filespec/column" { type=datetime; id=3; }
    p_contact_comments "filespec/column" { type=varchar(1536); id=4; }
    p_partner_key "filespec/column" { type=char(10); id=5; }
    p_contact_id "filespec/column" { type=tinyint; id=6; }
    p_contact_type "filespec/column" { type=char(1); id=7; }
    p_location_id "filespec/column" { type=char(3); id=8; }
    s_created_by "filespec/column" { type=varchar(20); id=9; }
    s_modified_by "filespec/column" { type=varchar(20); id=10; }
    p_record_status_code "filespec/column" { type=char(1); id=11; }
    p_contact_data "filespec/column" { type=varchar(80); id=12; }
    p_phone_country "filespec/column" { type=varchar(3); id=13; }
    p_phone_area_city "filespec/column" { type=varchar(4); id=14; }
    }
