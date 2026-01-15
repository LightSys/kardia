$Version=2$
h_holidays "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for h_holidays";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    h_holiday_id "filespec/column" { type=integer; id=1; }
    h_group_id "filespec/column" { type=integer; id=2; }
    h_holiday_label "filespec/column" { type=string; id=3; }
    h_holiday_date "filespec/column" { type=datetime; id=4; }
    h_holiday_end_date "filespec/column" { type=datetime; id=5; }
    s_date_created "filespec/column" { type=datetime; id=6; }
    s_created_by "filespec/column" { type=string; id=7; }
    s_date_modified "filespec/column" { type=datetime; id=8; }
    s_modified_by "filespec/column" { type=string; id=9; }
    __cx_osml_control "filespec/column" { type=string; id=10; }
    }
