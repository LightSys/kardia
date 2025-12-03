$Version=2$
s_stats_cache "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for s_stats_cache";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    s_stat_type "filespec/column" { type=string; id=1; }
    s_stat_group "filespec/column" { type=string; id=2; }
    s_stat "filespec/column" { type=string; id=3; }
    s_string_value "filespec/column" { type=string; id=4; }
    s_integer_value "filespec/column" { type=integer; id=5; }
    s_money_value "filespec/column" { type=money; id=6; }
    s_double_value "filespec/column" { type=double; id=7; }
    s_datetime_value "filespec/column" { type=datetime; id=8; }
    s_date_created "filespec/column" { type=datetime; id=9; }
    s_created_by "filespec/column" { type=string; id=10; }
    s_date_modified "filespec/column" { type=datetime; id=11; }
    s_modified_by "filespec/column" { type=string; id=12; }
    __cx_osml_control "filespec/column" { type=string; id=13; }
    }
