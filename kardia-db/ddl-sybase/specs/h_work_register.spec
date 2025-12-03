$Version=2$
h_work_register "application/filespec"
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
    s_created_by "filespec/column" { type=varchar(20); id=1; }
    s_modified_by "filespec/column" { type=varchar(20); id=2; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=3; }
    h_work_register_id "filespec/column" { type=integer; id=4; }
    s_date_modified "filespec/column" { type=datetime; id=5; }
    s_date_created "filespec/column" { type=datetime; id=6; }
    h_work_date "filespec/column" { type=datetime; id=7; }
    h_work_type "filespec/column" { type=char(1); id=8; }
    h_work_hours "filespec/column" { type=float; id=9; }
    p_partner_key "filespec/column" { type=char(10); id=10; }
    h_benefit_type_id "filespec/column" { type=integer; id=11; }
    }
