$Version=2$
t_assignee "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for t_assignee";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    p_partner_key "filespec/column" { type=string; id=1; }
    t_task_id "filespec/column" { type=integer; id=2; }
    s_date_created "filespec/column" { type=datetime; id=3; }
    s_created_by "filespec/column" { type=string; id=4; }
    s_date_modified "filespec/column" { type=datetime; id=5; }
    s_modified_by "filespec/column" { type=string; id=6; }
    __cx_osml_control "filespec/column" { type=string; id=7; }
    }
