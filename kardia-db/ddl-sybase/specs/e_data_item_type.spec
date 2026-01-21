$Version=2$
e_data_item_type "application/filespec"
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
    e_data_item_type_highlight_if "filespec/column" { type=varchar(64); id=1; }
    e_data_item_type_desc "filespec/column" { type=varchar(255); id=2; }
    s_date_modified "filespec/column" { type=datetime; id=3; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=4; }
    s_date_created "filespec/column" { type=datetime; id=5; }
    e_parent_data_item_type_id "filespec/column" { type=integer; id=6; }
    s_modified_by "filespec/column" { type=varchar(20); id=7; }
    e_data_item_type_id "filespec/column" { type=integer; id=8; }
    e_data_item_type_label "filespec/column" { type=varchar(40); id=9; }
    e_data_item_type_type "filespec/column" { type=varchar(16); id=10; }
    s_created_by "filespec/column" { type=varchar(20); id=11; }
    e_data_item_type_highlight "filespec/column" { type=integer; id=12; }
    }
