$Version=2$
r_saved_paramset "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for r_saved_paramset";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    r_paramset_id "filespec/column" { type=integer; id=1; }
    r_paramset_desc "filespec/column" { type=string; id=2; }
    r_module "filespec/column" { type=string; id=3; }
    r_file "filespec/column" { type=string; id=4; }
    r_is_personal "filespec/column" { type=integer; id=5; }
    s_date_created "filespec/column" { type=datetime; id=6; }
    s_created_by "filespec/column" { type=string; id=7; }
    s_date_modified "filespec/column" { type=datetime; id=8; }
    s_modified_by "filespec/column" { type=string; id=9; }
    __cx_osml_control "filespec/column" { type=string; id=10; }
    }
