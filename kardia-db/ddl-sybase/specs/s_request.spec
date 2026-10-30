$Version=2$
s_request "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for s_request";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    s_request_id "filespec/column" { type=integer; id=1; }
    s_request_type "filespec/column" { type=string; id=2; }
    s_object_key_1 "filespec/column" { type=string; id=3; }
    s_object_key_2 "filespec/column" { type=string; id=4; }
    s_date_requested "filespec/column" { type=datetime; id=5; }
    s_requested_by "filespec/column" { type=string; id=6; }
    s_request_comment "filespec/column" { type=string; id=7; }
    s_request_sec_context "filespec/column" { type=string; id=8; }
    s_date_assigned "filespec/column" { type=datetime; id=9; }
    s_assigned_by "filespec/column" { type=string; id=10; }
    s_assigned_to "filespec/column" { type=string; id=11; }
    s_assigned_comment "filespec/column" { type=string; id=12; }
    s_date_deleted "filespec/column" { type=datetime; id=13; }
    s_deleted_by "filespec/column" { type=string; id=14; }
    s_deleted_comment "filespec/column" { type=string; id=15; }
    s_date_approved "filespec/column" { type=datetime; id=16; }
    s_approved_by "filespec/column" { type=string; id=17; }
    s_approved_comment "filespec/column" { type=string; id=18; }
    s_date_completed "filespec/column" { type=datetime; id=19; }
    s_completed_by "filespec/column" { type=string; id=20; }
    s_completed_comment "filespec/column" { type=string; id=21; }
    s_date_created "filespec/column" { type=datetime; id=22; }
    s_created_by "filespec/column" { type=string; id=23; }
    s_date_modified "filespec/column" { type=datetime; id=24; }
    s_modified_by "filespec/column" { type=string; id=25; }
    __cx_osml_control "filespec/column" { type=string; id=26; }
    }
