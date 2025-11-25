$Version=2$
e_ack "application/filespec"
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
    s_modified_by "filespec/column" { type=varchar(20); id=1; }
    e_ack_comments "filespec/column" { type=varchar(900); id=2; }
    e_ack_type "filespec/column" { type=integer; id=3; }
    s_created_by "filespec/column" { type=varchar(20); id=4; }
    e_ack_id "filespec/column" { type=integer; id=5; }
    e_object_type "filespec/column" { type=varchar(32); id=6; }
    s_date_modified "filespec/column" { type=datetime; id=7; }
    e_whom "filespec/column" { type=char(10); id=8; }
    p_dn_partner_key "filespec/column" { type=char(10); id=9; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=10; }
    e_object_id "filespec/column" { type=varchar(32); id=11; }
    s_date_created "filespec/column" { type=datetime; id=12; }
    }
