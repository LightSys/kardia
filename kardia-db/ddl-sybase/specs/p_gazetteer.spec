$Version=2$
p_gazetteer "application/filespec"
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
    p_validity_date "filespec/column" { type=datetime; id=1; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=2; }
    p_country_code "filespec/column" { type=char(2); id=3; }
    s_modified_by "filespec/column" { type=varchar(20); id=4; }
    p_area_water "filespec/column" { type=float; id=5; }
    p_feature_type "filespec/column" { type=char(2); id=6; }
    p_feature_id "filespec/column" { type=integer; id=7; }
    p_longitude "filespec/column" { type=float; id=8; }
    p_feature_desc "filespec/column" { type=varchar(255); id=9; }
    p_alt_feature_id "filespec/column" { type=integer; id=10; }
    p_source "filespec/column" { type=varchar(40); id=11; }
    s_date_modified "filespec/column" { type=datetime; id=12; }
    p_feature_name "filespec/column" { type=varchar(80); id=13; }
    s_date_created "filespec/column" { type=datetime; id=14; }
    p_area_land "filespec/column" { type=float; id=15; }
    p_latitude "filespec/column" { type=float; id=16; }
    s_created_by "filespec/column" { type=varchar(20); id=17; }
    p_state_province "filespec/column" { type=varchar(64); id=18; }
    }
