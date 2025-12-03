$Version=2$
p_country "application/filespec"
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
    p_late_timezone "filespec/column" { type=char(5); id=1; }
    p_local_name "filespec/column" { type=varchar(255); id=2; }
    p_nationality "filespec/column" { type=varchar(30); id=3; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=4; }
    p_country_code "filespec/column" { type=char(2); id=5; }
    p_iso3166_3_code "filespec/column" { type=char(3); id=6; }
    s_modified_by "filespec/column" { type=varchar(20); id=7; }
    p_record_status_code "filespec/column" { type=char(1); id=8; }
    p_early_timezone "filespec/column" { type=char(5); id=9; }
    p_fips_code "filespec/column" { type=char(2); id=10; }
    s_date_modified "filespec/column" { type=datetime; id=11; }
    p_iso3166_2_code "filespec/column" { type=char(2); id=12; }
    s_date_created "filespec/column" { type=datetime; id=13; }
    p_security_level "filespec/column" { type=integer; id=14; }
    p_country_name "filespec/column" { type=varchar(255); id=15; }
    p_phone_code "filespec/column" { type=integer; id=16; }
    s_created_by "filespec/column" { type=varchar(20); id=17; }
    }
