$Version=2$
i_crm_partner_import "application/filespec"
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
    s_date_modified "filespec/column" { type=datetime; id=1; }
    i_crm_import_session_id "filespec/column" { type=integer; id=2; }
    s_date_created "filespec/column" { type=datetime; id=3; }
    i_crm_country_code "filespec/column" { type=char(2); id=4; }
    i_crm_city "filespec/column" { type=varchar(80); id=5; }
    i_crm_postal_code "filespec/column" { type=char(12); id=6; }
    i_crm_email "filespec/column" { type=varchar(80); id=7; }
    i_crm_addr_comment "filespec/column" { type=varchar(255); id=8; }
    i_crm_import_status "filespec/column" { type=char(1); id=9; }
    i_crm_surname "filespec/column" { type=varchar(64); id=10; }
    i_crm_org_name "filespec/column" { type=varchar(64); id=11; }
    i_crm_state_province "filespec/column" { type=varchar(64); id=12; }
    i_crm_external_key "filespec/column" { type=varchar(64); id=13; }
    s_created_by "filespec/column" { type=varchar(20); id=14; }
    i_crm_partner_key "filespec/column" { type=char(10); id=15; }
    i_crm_create_partner "filespec/column" { type=bit; id=16; }
    i_crm_given_name "filespec/column" { type=varchar(64); id=17; }
    i_crm_create_phone "filespec/column" { type=bit; id=18; }
    i_crm_comment "filespec/column" { type=varchar(255); id=19; }
    i_crm_address3 "filespec/column" { type=varchar(80); id=20; }
    i_crm_address1 "filespec/column" { type=varchar(80); id=21; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=22; }
    i_crm_import_id "filespec/column" { type=integer; id=23; }
    i_crm_address2 "filespec/column" { type=varchar(80); id=24; }
    i_crm_phone "filespec/column" { type=varchar(80); id=25; }
    i_crm_import_type_id "filespec/column" { type=integer; id=26; }
    i_crm_date "filespec/column" { type=datetime; id=27; }
    i_crm_in_care_of "filespec/column" { type=varchar(80); id=28; }
    i_crm_create_email "filespec/column" { type=bit; id=29; }
    s_modified_by "filespec/column" { type=varchar(20); id=30; }
    }
