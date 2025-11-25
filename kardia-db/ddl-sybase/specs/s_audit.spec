$Version=2$
s_audit "application/filespec"
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
    s_sequence "filespec/column" { type=integer; id=1; }
    s_created_by "filespec/column" { type=varchar(20); id=2; }
    s_valueint "filespec/column" { type=integer; id=3; }
    s_attrtype "filespec/column" { type=varchar(32); id=4; }
    s_key "filespec/column" { type=varchar(255); id=5; }
    s_valuestring "filespec/column" { type=varchar(255); id=6; }
    s_attrname "filespec/column" { type=varchar(32); id=7; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=8; }
    s_valuedatetime "filespec/column" { type=datetime; id=9; }
    s_table "filespec/column" { type=varchar(32); id=10; }
    s_valuedouble "filespec/column" { type=float; id=11; }
    s_date_created "filespec/column" { type=datetime; id=12; }
    s_valuemoney "filespec/column" { type=decimal(14,4); id=13; }
    }
