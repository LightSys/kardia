$Version=2$
p_location "application/filespec"
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
    p_postal_status "filespec/column" { type=char(1); id=1; }
    p_city "filespec/column" { type=varchar(64); id=2; }
    p_state_province "filespec/column" { type=varchar(64); id=3; }
    s_created_by "filespec/column" { type=varchar(20); id=4; }
    p_postal_code "filespec/column" { type=varchar(12); id=5; }
    p_location_id "filespec/column" { type=tinyint; id=6; }
    p_in_care_of "filespec/column" { type=varchar(80); id=7; }
    p_bulk_postal_code "filespec/column" { type=varchar(12); id=8; }
    p_partner_key "filespec/column" { type=char(10); id=9; }
    p_revision_id "filespec/column" { type=integer; id=10; }
    p_location_comments "filespec/column" { type=varchar(1536); id=11; }
    s_date_created "filespec/column" { type=datetime; id=12; }
    s_date_modified "filespec/column" { type=datetime; id=13; }
    p_certified_date "filespec/column" { type=datetime; id=14; }
    p_date_effective "filespec/column" { type=datetime; id=15; }
    p_address_2 "filespec/column" { type=varchar(80); id=16; }
    s_modified_by "filespec/column" { type=varchar(20); id=17; }
    p_record_status_code "filespec/column" { type=char(1); id=18; }
    p_location_type "filespec/column" { type=char(1); id=19; }
    p_country_code "filespec/column" { type=char(2); id=20; }
    p_postal_mode "filespec/column" { type=char(1); id=21; }
    p_address_3 "filespec/column" { type=varchar(80); id=22; }
    p_postal_barcode "filespec/column" { type=varchar(128); id=23; }
    p_purge_date "filespec/column" { type=datetime; id=24; }
    p_date_good_until "filespec/column" { type=datetime; id=25; }
    p_address_1 "filespec/column" { type=varchar(80); id=26; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=27; }
    }
