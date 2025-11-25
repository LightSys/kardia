$Version=2$
s_stats_cache "application/filespec"
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
    s_stat_type "filespec/column" { type=varchar(16); id=1; }
    s_stat "filespec/column" { type=varchar(64); id=2; }
    s_string_value "filespec/column" { type=varchar(255); id=3; }
    s_stat_group "filespec/column" { type=varchar(64); id=4; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=5; }
    s_double_value "filespec/column" { type=float; id=6; }
    s_date_modified "filespec/column" { type=datetime; id=7; }
    s_date_created "filespec/column" { type=datetime; id=8; }
    s_modified_by "filespec/column" { type=varchar(20); id=9; }
    s_datetime_value "filespec/column" { type=datetime; id=10; }
    s_integer_value "filespec/column" { type=integer; id=11; }
    s_money_value "filespec/column" { type=decimal(14,4); id=12; }
    s_created_by "filespec/column" { type=varchar(20); id=13; }
    }
