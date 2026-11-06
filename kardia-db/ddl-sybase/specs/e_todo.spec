$Version=2$
e_todo "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for e_todo";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    e_todo_id "filespec/column" { type=integer; id=1; }
    e_todo_type_id "filespec/column" { type=integer; id=2; }
    e_todo_desc "filespec/column" { type=string; id=3; }
    e_todo_comments "filespec/column" { type=string; id=4; }
    e_todo_status "filespec/column" { type=string; id=5; }
    e_todo_completion_date "filespec/column" { type=datetime; id=6; }
    e_todo_canceled_date "filespec/column" { type=datetime; id=7; }
    e_todo_due_date "filespec/column" { type=datetime; id=8; }
    e_todo_collaborator "filespec/column" { type=string; id=9; }
    e_todo_partner "filespec/column" { type=string; id=10; }
    e_todo_engagement_id "filespec/column" { type=integer; id=11; }
    e_todo_document_id "filespec/column" { type=integer; id=12; }
    e_todo_req_item_id "filespec/column" { type=integer; id=13; }
    s_date_created "filespec/column" { type=datetime; id=14; }
    s_created_by "filespec/column" { type=string; id=15; }
    s_date_modified "filespec/column" { type=datetime; id=16; }
    s_modified_by "filespec/column" { type=string; id=17; }
    __cx_osml_control "filespec/column" { type=string; id=18; }
    }
