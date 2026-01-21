$Version=2$
e_todo "application/filespec"
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
    e_todo_canceled_date "filespec/column" { type=datetime; id=1; }
    e_todo_document_id "filespec/column" { type=integer; id=2; }
    e_todo_partner "filespec/column" { type=char(10); id=3; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=4; }
    e_todo_comments "filespec/column" { type=varchar(900); id=5; }
    e_todo_desc "filespec/column" { type=varchar(255); id=6; }
    s_modified_by "filespec/column" { type=varchar(20); id=7; }
    e_todo_due_date "filespec/column" { type=datetime; id=8; }
    e_todo_req_item_id "filespec/column" { type=integer; id=9; }
    e_todo_status "filespec/column" { type=char(1); id=10; }
    s_date_modified "filespec/column" { type=datetime; id=11; }
    s_date_created "filespec/column" { type=datetime; id=12; }
    e_todo_engagement_id "filespec/column" { type=integer; id=13; }
    e_todo_collaborator "filespec/column" { type=char(10); id=14; }
    e_todo_completion_date "filespec/column" { type=datetime; id=15; }
    e_todo_id "filespec/column" { type=integer; id=16; }
    e_todo_type_id "filespec/column" { type=integer; id=17; }
    s_created_by "filespec/column" { type=varchar(20); id=18; }
    }
