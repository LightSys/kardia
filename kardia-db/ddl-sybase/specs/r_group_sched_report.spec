$Version=2$
r_group_sched_report "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for r_group_sched_report";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    r_group_name "filespec/column" { type=string; id=1; }
    r_delivery_method "filespec/column" { type=string; id=2; }
    r_group_sched_id "filespec/column" { type=integer; id=3; }
    p_recipient_partner_key "filespec/column" { type=string; id=4; }
    r_report_id "filespec/column" { type=integer; id=5; }
    r_group_sched_address "filespec/column" { type=string; id=6; }
    r_group_sched_status "filespec/column" { type=string; id=7; }
    r_group_sched_error "filespec/column" { type=string; id=8; }
    r_group_sched_sent_date "filespec/column" { type=datetime; id=9; }
    r_group_sched_file "filespec/column" { type=string; id=10; }
    s_date_created "filespec/column" { type=datetime; id=11; }
    s_created_by "filespec/column" { type=string; id=12; }
    s_date_modified "filespec/column" { type=datetime; id=13; }
    s_modified_by "filespec/column" { type=string; id=14; }
    __cx_osml_control "filespec/column" { type=string; id=15; }
    }
