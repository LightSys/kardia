$Version=2$
e_data_item_type_value "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for e_data_item_type_value";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    e_data_item_type_id "filespec/column" { type=integer; id=1; }
    e_data_item_value_id "filespec/column" { type=integer; id=2; }
    e_data_item_string_value "filespec/column" { type=string; id=3; }
    e_data_item_integer_value "filespec/column" { type=integer; id=4; }
    e_data_item_datetime_value "filespec/column" { type=datetime; id=5; }
    e_data_item_double_value "filespec/column" { type=double; id=6; }
    e_data_item_money_value "filespec/column" { type=money; id=7; }
    e_is_default "filespec/column" { type=integer; id=8; }
    s_date_created "filespec/column" { type=datetime; id=9; }
    s_created_by "filespec/column" { type=string; id=10; }
    s_date_modified "filespec/column" { type=datetime; id=11; }
    s_modified_by "filespec/column" { type=string; id=12; }
    __cx_osml_control "filespec/column" { type=string; id=13; }
    }
