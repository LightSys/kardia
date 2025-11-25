$Version=2$
i_crm_import_type "application/filespec"
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
    i_crm_field_org_name "filespec/column" { type=varchar(255); id=1; }
    i_crm_field_careof "filespec/column" { type=varchar(255); id=2; }
    i_crm_field_country "filespec/column" { type=varchar(255); id=3; }
    i_crm_field_postal_code "filespec/column" { type=varchar(255); id=4; }
    i_crm_import_type_path "filespec/column" { type=varchar(255); id=5; }
    i_crm_field_addr_comment "filespec/column" { type=varchar(255); id=6; }
    i_crm_field_addr2 "filespec/column" { type=varchar(255); id=7; }
    s_created_by "filespec/column" { type=varchar(20); id=8; }
    i_crm_field_email "filespec/column" { type=varchar(255); id=9; }
    i_crm_field_pk "filespec/column" { type=varchar(255); id=10; }
    i_crm_import_type_subsys "filespec/column" { type=char(4); id=11; }
    i_crm_field_addr1 "filespec/column" { type=varchar(255); id=12; }
    i_crm_field_middle_name "filespec/column" { type=varchar(255); id=13; }
    s_date_modified "filespec/column" { type=datetime; id=14; }
    i_crm_country_type "filespec/column" { type=varchar(16); id=15; }
    s_date_created "filespec/column" { type=datetime; id=16; }
    i_crm_field_city "filespec/column" { type=varchar(255); id=17; }
    i_crm_field_given_name "filespec/column" { type=varchar(255); id=18; }
    i_crm_field_surname "filespec/column" { type=varchar(255); id=19; }
    s_modified_by "filespec/column" { type=varchar(20); id=20; }
    i_crm_field_stateprov "filespec/column" { type=varchar(255); id=21; }
    i_crm_field_addr3 "filespec/column" { type=varchar(255); id=22; }
    i_crm_import_type_desc "filespec/column" { type=varchar(255); id=23; }
    i_crm_import_type_id "filespec/column" { type=integer; id=24; }
    i_crm_field_date "filespec/column" { type=varchar(255); id=25; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=26; }
    i_crm_field_phone "filespec/column" { type=varchar(255); id=27; }
    i_crm_field_comment "filespec/column" { type=varchar(255); id=28; }
    }
