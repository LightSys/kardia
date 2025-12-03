$Version=2$
e_contact_autorecord "application/filespec"
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
    e_auto_record "filespec/column" { type=bit; id=1; }
    s_modified_by "filespec/column" { type=varchar(20); id=2; }
    e_contact_id "filespec/column" { type=integer; id=3; }
    e_engagement_id "filespec/column" { type=integer; id=4; }
    e_contact_history_type "filespec/column" { type=integer; id=5; }
    s_created_by "filespec/column" { type=varchar(20); id=6; }
    e_collaborator_id "filespec/column" { type=char(10); id=7; }
    p_partner_key "filespec/column" { type=char(10); id=8; }
    s_date_created "filespec/column" { type=datetime; id=9; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=10; }
    e_auto_record_apply_all "filespec/column" { type=bit; id=11; }
    e_comments "filespec/column" { type=varchar(255); id=12; }
    s_date_modified "filespec/column" { type=datetime; id=13; }
    }
