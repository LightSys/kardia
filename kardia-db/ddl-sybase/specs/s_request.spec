$Version=2$
s_request "application/filespec"
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
    s_completed_by "filespec/column" { type=varchar(20); id=1; }
    s_date_assigned "filespec/column" { type=datetime; id=2; }
    s_created_by "filespec/column" { type=varchar(20); id=3; }
    s_approved_comment "filespec/column" { type=varchar(255); id=4; }
    s_approved_by "filespec/column" { type=varchar(20); id=5; }
    s_request_sec_context "filespec/column" { type=varchar(255); id=6; }
    s_date_modified "filespec/column" { type=datetime; id=7; }
    s_assigned_by "filespec/column" { type=varchar(20); id=8; }
    s_completed_comment "filespec/column" { type=varchar(255); id=9; }
    s_date_created "filespec/column" { type=datetime; id=10; }
    s_date_completed "filespec/column" { type=datetime; id=11; }
    s_object_key_2 "filespec/column" { type=varchar(255); id=12; }
    s_request_type "filespec/column" { type=char(10); id=13; }
    s_date_approved "filespec/column" { type=datetime; id=14; }
    s_request_comment "filespec/column" { type=varchar(255); id=15; }
    s_assigned_to "filespec/column" { type=varchar(20); id=16; }
    s_deleted_by "filespec/column" { type=varchar(20); id=17; }
    s_request_id "filespec/column" { type=integer; id=18; }
    s_deleted_comment "filespec/column" { type=varchar(255); id=19; }
    s_object_key_1 "filespec/column" { type=varchar(255); id=20; }
    s_date_deleted "filespec/column" { type=datetime; id=21; }
    s_modified_by "filespec/column" { type=varchar(20); id=22; }
    s_requested_by "filespec/column" { type=varchar(20); id=23; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=24; }
    s_date_requested "filespec/column" { type=datetime; id=25; }
    s_assigned_comment "filespec/column" { type=varchar(255); id=26; }
    }
