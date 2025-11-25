$Version=2$
r_group "application/filespec"
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
    r_group_template_file "filespec/column" { type=varchar(255); id=1; }
    s_date_created "filespec/column" { type=datetime; id=2; }
    r_group_description "filespec/column" { type=varchar(255); id=3; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=4; }
    s_date_modified "filespec/column" { type=datetime; id=5; }
    r_send_empty "filespec/column" { type=bit; id=6; }
    r_group_file "filespec/column" { type=varchar(255); id=7; }
    s_created_by "filespec/column" { type=varchar(20); id=8; }
    r_group_module "filespec/column" { type=varchar(20); id=9; }
    r_group_name "filespec/column" { type=char(8); id=10; }
    s_modified_by "filespec/column" { type=varchar(20); id=11; }
    r_is_active "filespec/column" { type=bit; id=12; }
    }
