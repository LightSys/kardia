$Version=2$
s_mykardia "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for s_mykardia";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    s_username "filespec/column" { type=string; id=1; }
    s_module "filespec/column" { type=string; id=2; }
    s_plugin "filespec/column" { type=string; id=3; }
    s_occurrence "filespec/column" { type=integer; id=4; }
    s_sequence "filespec/column" { type=integer; id=5; }
    s_height "filespec/column" { type=integer; id=6; }
    s_date_created "filespec/column" { type=datetime; id=7; }
    s_created_by "filespec/column" { type=string; id=8; }
    s_date_modified "filespec/column" { type=datetime; id=9; }
    s_modified_by "filespec/column" { type=string; id=10; }
    __cx_osml_control "filespec/column" { type=string; id=11; }
    }
