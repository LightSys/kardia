$Version=2$
e_data_item_type_value "application/filespec"
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
    e_data_item_type_id "filespec/column" { type=integer; id=1; }
    s_modified_by "filespec/column" { type=varchar(20); id=2; }
    e_data_item_double_value "filespec/column" { type=float; id=3; }
    e_is_default "filespec/column" { type=bit; id=4; }
    s_created_by "filespec/column" { type=varchar(20); id=5; }
    e_data_item_value_id "filespec/column" { type=integer; id=6; }
    e_data_item_string_value "filespec/column" { type=varchar(999); id=7; }
    e_data_item_datetime_value "filespec/column" { type=datetime; id=8; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=9; }
    s_date_modified "filespec/column" { type=datetime; id=10; }
    e_data_item_integer_value "filespec/column" { type=integer; id=11; }
    e_data_item_money_value "filespec/column" { type=decimal(14,4); id=12; }
    s_date_created "filespec/column" { type=datetime; id=13; }
    }
