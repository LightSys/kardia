$Version=2$
p_location "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for p_location";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    p_partner_key "filespec/column" { type=string; id=1; }
    p_location_id "filespec/column" { type=integer; id=2; }
    p_revision_id "filespec/column" { type=integer; id=3; }
    p_location_type "filespec/column" { type=string; id=4; }
    p_date_effective "filespec/column" { type=datetime; id=5; }
    p_date_good_until "filespec/column" { type=datetime; id=6; }
    p_purge_date "filespec/column" { type=datetime; id=7; }
    p_in_care_of "filespec/column" { type=string; id=8; }
    p_address_1 "filespec/column" { type=string; id=9; }
    p_address_2 "filespec/column" { type=string; id=10; }
    p_address_3 "filespec/column" { type=string; id=11; }
    p_city "filespec/column" { type=string; id=12; }
    p_state_province "filespec/column" { type=string; id=13; }
    p_country_code "filespec/column" { type=string; id=14; }
    p_postal_code "filespec/column" { type=string; id=15; }
    p_postal_mode "filespec/column" { type=string; id=16; }
    p_bulk_postal_code "filespec/column" { type=string; id=17; }
    p_certified_date "filespec/column" { type=datetime; id=18; }
    p_postal_status "filespec/column" { type=string; id=19; }
    p_postal_barcode "filespec/column" { type=string; id=20; }
    p_record_status_code "filespec/column" { type=string; id=21; }
    p_location_comments "filespec/column" { type=string; id=22; }
    s_date_created "filespec/column" { type=datetime; id=23; }
    s_created_by "filespec/column" { type=string; id=24; }
    s_date_modified "filespec/column" { type=datetime; id=25; }
    s_modified_by "filespec/column" { type=string; id=26; }
    __cx_osml_control "filespec/column" { type=string; id=27; }
    }
