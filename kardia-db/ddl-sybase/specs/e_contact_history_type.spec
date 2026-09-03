$Version=2$
e_contact_history_type "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for e_contact_history_type";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    e_contact_history_type "filespec/column" { type=integer; id=1; }
    e_short_name "filespec/column" { type=string; id=2; }
    e_description "filespec/column" { type=string; id=3; }
    e_user_selectable "filespec/column" { type=integer; id=4; }
    e_is_notes "filespec/column" { type=integer; id=5; }
    e_is_inperson "filespec/column" { type=integer; id=6; }
    s_date_created "filespec/column" { type=datetime; id=7; }
    s_created_by "filespec/column" { type=string; id=8; }
    s_date_modified "filespec/column" { type=datetime; id=9; }
    s_modified_by "filespec/column" { type=string; id=10; }
    __cx_osml_control "filespec/column" { type=string; id=11; }
    }
