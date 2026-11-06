$Version=2$
s_audit "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for s_audit";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    s_sequence "filespec/column" { type=integer; id=1; }
    s_table "filespec/column" { type=string; id=2; }
    s_key "filespec/column" { type=string; id=3; }
    s_attrname "filespec/column" { type=string; id=4; }
    s_attrtype "filespec/column" { type=string; id=5; }
    s_valuestring "filespec/column" { type=string; id=6; }
    s_valueint "filespec/column" { type=integer; id=7; }
    s_valuedouble "filespec/column" { type=double; id=8; }
    s_valuemoney "filespec/column" { type=money; id=9; }
    s_valuedatetime "filespec/column" { type=datetime; id=10; }
    s_date_created "filespec/column" { type=datetime; id=11; }
    s_created_by "filespec/column" { type=string; id=12; }
    __cx_osml_control "filespec/column" { type=string; id=13; }
    }
