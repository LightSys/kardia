$Version=2$
e_data_item_type "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for e_data_item_type";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    e_data_item_type_id "filespec/column" { type=integer; id=1; }
    e_parent_data_item_type_id "filespec/column" { type=integer; id=2; }
    e_data_item_type_label "filespec/column" { type=string; id=3; }
    e_data_item_type_desc "filespec/column" { type=string; id=4; }
    e_data_item_type_type "filespec/column" { type=string; id=5; }
    e_data_item_type_highlight "filespec/column" { type=integer; id=6; }
    e_data_item_type_highlight_if "filespec/column" { type=string; id=7; }
    s_date_created "filespec/column" { type=datetime; id=8; }
    s_created_by "filespec/column" { type=string; id=9; }
    s_date_modified "filespec/column" { type=datetime; id=10; }
    s_modified_by "filespec/column" { type=string; id=11; }
    __cx_osml_control "filespec/column" { type=string; id=12; }
    }
