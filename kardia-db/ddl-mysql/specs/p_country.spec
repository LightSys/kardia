$Version=2$
p_country "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for p_country";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    p_country_code "filespec/column" { type=string; id=1; }
    p_iso3166_2_code "filespec/column" { type=string; id=2; }
    p_iso3166_3_code "filespec/column" { type=string; id=3; }
    p_fips_code "filespec/column" { type=string; id=4; }
    p_country_name "filespec/column" { type=string; id=5; }
    p_local_name "filespec/column" { type=string; id=6; }
    p_phone_code "filespec/column" { type=integer; id=7; }
    p_security_level "filespec/column" { type=integer; id=8; }
    p_nationality "filespec/column" { type=string; id=9; }
    p_early_timezone "filespec/column" { type=string; id=10; }
    p_late_timezone "filespec/column" { type=string; id=11; }
    p_record_status_code "filespec/column" { type=string; id=12; }
    s_date_created "filespec/column" { type=datetime; id=13; }
    s_created_by "filespec/column" { type=string; id=14; }
    s_date_modified "filespec/column" { type=datetime; id=15; }
    s_modified_by "filespec/column" { type=string; id=16; }
    __cx_osml_control "filespec/column" { type=string; id=17; }
    }
