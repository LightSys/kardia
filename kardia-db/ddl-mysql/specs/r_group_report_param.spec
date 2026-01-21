$Version=2$
r_group_report_param "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for r_group_report_param";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    r_group_name "filespec/column" { type=string; id=1; }
    r_delivery_method "filespec/column" { type=string; id=2; }
    p_recipient_partner_key "filespec/column" { type=string; id=3; }
    r_report_id "filespec/column" { type=integer; id=4; }
    r_param_name "filespec/column" { type=string; id=5; }
    r_param_value "filespec/column" { type=string; id=6; }
    s_date_created "filespec/column" { type=datetime; id=7; }
    s_created_by "filespec/column" { type=string; id=8; }
    s_date_modified "filespec/column" { type=datetime; id=9; }
    s_modified_by "filespec/column" { type=string; id=10; }
    __cx_osml_control "filespec/column" { type=string; id=11; }
    }
