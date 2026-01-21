$Version=2$
p_contact_usage_type "application/filespec"
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
    p_contact_usage_label "filespec/column" { type=varchar(80); id=2; }
    p_system_provided "filespec/column" { type=bit; id=3; }
    p_contact_types "filespec/column" { type=varchar(32); id=4; }
    p_contact_usage_type_code "filespec/column" { type=varchar(4); id=5; }
    s_modified_by "filespec/column" { type=varchar(20); id=6; }
    p_use_for_locations "filespec/column" { type=bit; id=7; }
    p_use_for_contacts "filespec/column" { type=bit; id=8; }
    s_date_created "filespec/column" { type=datetime; id=9; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=10; }
    s_date_modified "filespec/column" { type=datetime; id=11; }
    }
