$Version=2$
t_sprint_participant "application/filespec"
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
    t_skill_ratio "filespec/column" { type=float; id=1; }
    t_sprint_id "filespec/column" { type=integer; id=2; }
    s_modified_by "filespec/column" { type=varchar(20); id=3; }
    s_created_by "filespec/column" { type=varchar(20); id=4; }
    t_project_id "filespec/column" { type=integer; id=5; }
    p_partner_key "filespec/column" { type=char(10); id=6; }
    s_date_modified "filespec/column" { type=datetime; id=7; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=8; }
    s_date_created "filespec/column" { type=datetime; id=9; }
    }
