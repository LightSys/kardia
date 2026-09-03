$Version=2$
e_data_item_group "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for e_data_item_group";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    e_data_item_group_id "filespec/column" { type=integer; id=1; }
    e_data_item_type_id "filespec/column" { type=integer; id=2; }
    e_data_item_group_name "filespec/column" { type=string; id=3; }
    e_data_item_group_desc "filespec/column" { type=string; id=4; }
    p_partner_key "filespec/column" { type=string; id=5; }
    s_date_created "filespec/column" { type=datetime; id=6; }
    s_created_by "filespec/column" { type=string; id=7; }
    s_date_modified "filespec/column" { type=datetime; id=8; }
    s_modified_by "filespec/column" { type=string; id=9; }
    __cx_osml_control "filespec/column" { type=string; id=10; }
    }
