$Version=2$
e_activity "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for e_activity";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    e_activity_group_id "filespec/column" { type=integer; id=1; }
    e_activity_id "filespec/column" { type=integer; id=2; }
    p_partner_key "filespec/column" { type=string; id=3; }
    e_whom "filespec/column" { type=string; id=4; }
    e_initiation "filespec/column" { type=string; id=5; }
    e_sort_key "filespec/column" { type=string; id=6; }
    e_activity_date "filespec/column" { type=datetime; id=7; }
    e_activity_type "filespec/column" { type=string; id=8; }
    e_reference_info "filespec/column" { type=string; id=9; }
    e_info "filespec/column" { type=string; id=10; }
    s_date_created "filespec/column" { type=datetime; id=11; }
    s_created_by "filespec/column" { type=string; id=12; }
    s_date_modified "filespec/column" { type=datetime; id=13; }
    s_modified_by "filespec/column" { type=string; id=14; }
    __cx_osml_control "filespec/column" { type=string; id=15; }
    }
