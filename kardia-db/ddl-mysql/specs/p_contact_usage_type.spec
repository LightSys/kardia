$Version=2$
p_contact_usage_type "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for p_contact_usage_type";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    p_contact_usage_type_code "filespec/column" { type=string; id=1; }
    p_system_provided "filespec/column" { type=integer; id=2; }
    p_use_for_locations "filespec/column" { type=integer; id=3; }
    p_use_for_contacts "filespec/column" { type=integer; id=4; }
    p_contact_types "filespec/column" { type=string; id=5; }
    p_contact_usage_label "filespec/column" { type=string; id=6; }
    s_date_created "filespec/column" { type=datetime; id=7; }
    s_created_by "filespec/column" { type=string; id=8; }
    s_date_modified "filespec/column" { type=datetime; id=9; }
    s_modified_by "filespec/column" { type=string; id=10; }
    __cx_osml_control "filespec/column" { type=string; id=11; }
    }
