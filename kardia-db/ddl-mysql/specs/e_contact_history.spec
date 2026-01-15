$Version=2$
e_contact_history "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for e_contact_history";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    e_contact_history_id "filespec/column" { type=integer; id=1; }
    p_partner_key "filespec/column" { type=string; id=2; }
    e_contact_history_type "filespec/column" { type=integer; id=3; }
    p_contact_id "filespec/column" { type=integer; id=4; }
    p_location_partner_key "filespec/column" { type=string; id=5; }
    p_location_id "filespec/column" { type=integer; id=6; }
    p_location_revision_id "filespec/column" { type=integer; id=7; }
    e_whom "filespec/column" { type=string; id=8; }
    e_initiation "filespec/column" { type=string; id=9; }
    e_subject "filespec/column" { type=string; id=10; }
    e_contact_date "filespec/column" { type=datetime; id=11; }
    e_notes "filespec/column" { type=string; id=12; }
    e_message_id "filespec/column" { type=string; id=13; }
    s_date_created "filespec/column" { type=datetime; id=14; }
    s_created_by "filespec/column" { type=string; id=15; }
    s_date_modified "filespec/column" { type=datetime; id=16; }
    s_modified_by "filespec/column" { type=string; id=17; }
    __cx_osml_control "filespec/column" { type=string; id=18; }
    }
