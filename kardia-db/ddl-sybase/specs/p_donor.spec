$Version=2$
p_donor "application/filespec"
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
    p_receipt_desired "filespec/column" { type=char(1); id=1; }
    a_gl_account_code "filespec/column" { type=char(16); id=2; }
    s_modified_by "filespec/column" { type=varchar(20); id=3; }
    p_is_daf "filespec/column" { type=bit; id=4; }
    p_location_id "filespec/column" { type=integer; id=5; }
    p_org_name_first "filespec/column" { type=bit; id=6; }
    s_created_by "filespec/column" { type=varchar(20); id=7; }
    p_contact_id "filespec/column" { type=integer; id=8; }
    a_gl_ledger_number "filespec/column" { type=char(10); id=9; }
    p_partner_key "filespec/column" { type=char(10); id=10; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=11; }
    p_allow_contributions "filespec/column" { type=bit; id=12; }
    s_date_modified "filespec/column" { type=datetime; id=13; }
    s_date_created "filespec/column" { type=datetime; id=14; }
    p_account_with_donor "filespec/column" { type=varchar(20); id=15; }
    }
