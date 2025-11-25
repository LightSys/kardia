$Version=2$
e_contact_history "application/filespec"
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
    p_location_partner_key "filespec/column" { type=char(10); id=1; }
    e_subject "filespec/column" { type=varchar(255); id=2; }
    e_contact_history_id "filespec/column" { type=integer; id=3; }
    e_contact_history_type "filespec/column" { type=integer; id=4; }
    p_location_id "filespec/column" { type=integer; id=5; }
    s_created_by "filespec/column" { type=varchar(20); id=6; }
    p_partner_key "filespec/column" { type=char(10); id=7; }
    p_contact_id "filespec/column" { type=integer; id=8; }
    e_notes "filespec/column" { type=varchar(900); id=9; }
    s_date_modified "filespec/column" { type=datetime; id=10; }
    s_date_created "filespec/column" { type=datetime; id=11; }
    s_modified_by "filespec/column" { type=varchar(20); id=12; }
    e_initiation "filespec/column" { type=char(1); id=13; }
    e_message_id "filespec/column" { type=varchar(255); id=14; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=15; }
    e_whom "filespec/column" { type=char(10); id=16; }
    p_location_revision_id "filespec/column" { type=integer; id=17; }
    e_contact_date "filespec/column" { type=datetime; id=18; }
    }
