$Version=2$
e_ack "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for e_ack";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    e_ack_id "filespec/column" { type=integer; id=1; }
    e_object_type "filespec/column" { type=string; id=2; }
    e_object_id "filespec/column" { type=string; id=3; }
    e_ack_type "filespec/column" { type=integer; id=4; }
    e_ack_comments "filespec/column" { type=string; id=5; }
    e_whom "filespec/column" { type=string; id=6; }
    p_dn_partner_key "filespec/column" { type=string; id=7; }
    s_date_created "filespec/column" { type=datetime; id=8; }
    s_created_by "filespec/column" { type=string; id=9; }
    s_date_modified "filespec/column" { type=datetime; id=10; }
    s_modified_by "filespec/column" { type=string; id=11; }
    __cx_osml_control "filespec/column" { type=string; id=12; }
    }
