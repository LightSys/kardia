$Version=2$
p_contact_usage "application/filespec"
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
    __cx_osml_control "filespec/column" { type=varchar(255); id=1; }
    s_date_modified "filespec/column" { type=datetime; id=2; }
    p_daterange_no_year "filespec/column" { type=bit; id=3; }
    p_start_date "filespec/column" { type=datetime; id=4; }
    s_date_created "filespec/column" { type=datetime; id=5; }
    p_contact_location_id "filespec/column" { type=integer; id=6; }
    p_partner_key "filespec/column" { type=char(10); id=7; }
    p_contact_usage_type_code "filespec/column" { type=varchar(4); id=8; }
    p_end_date "filespec/column" { type=datetime; id=9; }
    s_created_by "filespec/column" { type=varchar(20); id=10; }
    p_contact_or_location "filespec/column" { type=char(1); id=11; }
    s_modified_by "filespec/column" { type=varchar(20); id=12; }
    }
