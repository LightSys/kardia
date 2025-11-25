$Version=2$
p_gazetteer "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for p_gazetteer";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    p_country_code "filespec/column" { type=string; id=1; }
    p_feature_type "filespec/column" { type=string; id=2; }
    p_feature_id "filespec/column" { type=integer; id=3; }
    p_alt_feature_id "filespec/column" { type=integer; id=4; }
    p_feature_name "filespec/column" { type=string; id=5; }
    p_feature_desc "filespec/column" { type=string; id=6; }
    p_state_province "filespec/column" { type=string; id=7; }
    p_area_land "filespec/column" { type=double; id=8; }
    p_area_water "filespec/column" { type=double; id=9; }
    p_latitude "filespec/column" { type=double; id=10; }
    p_longitude "filespec/column" { type=double; id=11; }
    p_source "filespec/column" { type=string; id=12; }
    p_validity_date "filespec/column" { type=datetime; id=13; }
    s_date_created "filespec/column" { type=datetime; id=14; }
    s_created_by "filespec/column" { type=string; id=15; }
    s_date_modified "filespec/column" { type=datetime; id=16; }
    s_modified_by "filespec/column" { type=string; id=17; }
    __cx_osml_control "filespec/column" { type=string; id=18; }
    }
