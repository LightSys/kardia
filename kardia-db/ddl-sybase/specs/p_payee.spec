$Version=2$
p_payee "application/filespec"
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
    a_gl_account_code "filespec/column" { type=char(16); id=1; }
    s_modified_by "filespec/column" { type=varchar(20); id=2; }
    s_created_by "filespec/column" { type=varchar(20); id=3; }
    p_location_id "filespec/column" { type=integer; id=4; }
    p_partner_key "filespec/column" { type=char(10); id=5; }
    a_gl_ledger_number "filespec/column" { type=char(10); id=6; }
    p_contact_id "filespec/column" { type=integer; id=7; }
    s_date_modified "filespec/column" { type=datetime; id=8; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=9; }
    p_allow_payments "filespec/column" { type=bit; id=10; }
    s_date_created "filespec/column" { type=datetime; id=11; }
    p_account_with_payee "filespec/column" { type=varchar(20); id=12; }
    }
