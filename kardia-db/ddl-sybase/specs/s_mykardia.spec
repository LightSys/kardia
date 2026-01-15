$Version=2$
s_mykardia "application/filespec"
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
    __cx_osml_control "filespec/column" { type=varchar(255); id=1; }
    s_date_modified "filespec/column" { type=datetime; id=2; }
    s_username "filespec/column" { type=varchar(20); id=3; }
    s_date_created "filespec/column" { type=datetime; id=4; }
    s_plugin "filespec/column" { type=varchar(255); id=5; }
    s_height "filespec/column" { type=integer; id=6; }
    s_sequence "filespec/column" { type=integer; id=7; }
    s_created_by "filespec/column" { type=varchar(20); id=8; }
    s_module "filespec/column" { type=varchar(20); id=9; }
    s_occurrence "filespec/column" { type=integer; id=10; }
    s_modified_by "filespec/column" { type=varchar(20); id=11; }
    }
