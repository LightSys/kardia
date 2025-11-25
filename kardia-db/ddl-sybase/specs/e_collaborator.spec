$Version=2$
e_collaborator "application/filespec"
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
    e_silence_interval "filespec/column" { type=integer; id=3; }
    s_date_created "filespec/column" { type=datetime; id=4; }
    e_collaborator "filespec/column" { type=char(10); id=5; }
    e_collab_type_id "filespec/column" { type=integer; id=6; }
    p_partner_key "filespec/column" { type=char(10); id=7; }
    e_is_automatic "filespec/column" { type=bit; id=8; }
    s_created_by "filespec/column" { type=varchar(20); id=9; }
    e_recontact_interval "filespec/column" { type=integer; id=10; }
    s_modified_by "filespec/column" { type=varchar(20); id=11; }
    e_collaborator_status "filespec/column" { type=char(1); id=12; }
    }
