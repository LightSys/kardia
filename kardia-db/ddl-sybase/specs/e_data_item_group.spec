$Version=2$
e_data_item_group "application/filespec"
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
    s_date_created "filespec/column" { type=datetime; id=1; }
    e_data_item_group_id "filespec/column" { type=integer; id=2; }
    s_date_modified "filespec/column" { type=datetime; id=3; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=4; }
    p_partner_key "filespec/column" { type=char(10); id=5; }
    e_data_item_group_desc "filespec/column" { type=varchar(255); id=6; }
    e_data_item_group_name "filespec/column" { type=varchar(80); id=7; }
    s_created_by "filespec/column" { type=varchar(20); id=8; }
    e_data_item_type_id "filespec/column" { type=integer; id=9; }
    s_modified_by "filespec/column" { type=varchar(20); id=10; }
    }
