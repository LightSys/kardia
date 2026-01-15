$Version=2$
r_group_report "application/filespec"
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
    s_date_modified "filespec/column" { type=datetime; id=1; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=2; }
    s_date_created "filespec/column" { type=datetime; id=3; }
    p_recipient_partner_key "filespec/column" { type=char(10); id=4; }
    s_created_by "filespec/column" { type=varchar(20); id=5; }
    r_report_id "filespec/column" { type=integer; id=6; }
    r_is_active "filespec/column" { type=bit; id=7; }
    r_delivery_method "filespec/column" { type=varchar(1); id=8; }
    s_modified_by "filespec/column" { type=varchar(20); id=9; }
    r_group_name "filespec/column" { type=char(8); id=10; }
    }
