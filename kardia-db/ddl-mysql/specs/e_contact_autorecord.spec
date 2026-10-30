$Version=2$
e_contact_autorecord "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for e_contact_autorecord";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    p_partner_key "filespec/column" { type=string; id=1; }
    e_collaborator_id "filespec/column" { type=string; id=2; }
    e_contact_history_type "filespec/column" { type=integer; id=3; }
    e_contact_id "filespec/column" { type=integer; id=4; }
    e_engagement_id "filespec/column" { type=integer; id=5; }
    e_auto_record "filespec/column" { type=integer; id=6; }
    e_auto_record_apply_all "filespec/column" { type=integer; id=7; }
    e_comments "filespec/column" { type=string; id=8; }
    s_date_created "filespec/column" { type=datetime; id=9; }
    s_created_by "filespec/column" { type=string; id=10; }
    s_date_modified "filespec/column" { type=datetime; id=11; }
    s_modified_by "filespec/column" { type=string; id=12; }
    __cx_osml_control "filespec/column" { type=string; id=13; }
    }
