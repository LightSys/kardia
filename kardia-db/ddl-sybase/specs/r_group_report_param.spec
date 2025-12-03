$Version=2$
r_group_report_param "application/filespec"
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
    r_group_name "filespec/column" { type=char(8); id=2; }
    r_param_value "filespec/column" { type=varchar(900); id=3; }
    r_delivery_method "filespec/column" { type=char(1); id=4; }
    p_recipient_partner_key "filespec/column" { type=char(10); id=5; }
    r_param_name "filespec/column" { type=varchar(64); id=6; }
    r_report_id "filespec/column" { type=integer; id=7; }
    s_created_by "filespec/column" { type=varchar(20); id=8; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=9; }
    s_date_modified "filespec/column" { type=datetime; id=10; }
    s_date_created "filespec/column" { type=datetime; id=11; }
    }
