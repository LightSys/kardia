$Version=2$
p_payee "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for p_payee";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    p_partner_key "filespec/column" { type=string; id=1; }
    a_gl_ledger_number "filespec/column" { type=string; id=2; }
    a_gl_account_code "filespec/column" { type=string; id=3; }
    p_account_with_payee "filespec/column" { type=string; id=4; }
    p_allow_payments "filespec/column" { type=integer; id=5; }
    p_location_id "filespec/column" { type=integer; id=6; }
    p_contact_id "filespec/column" { type=integer; id=7; }
    s_date_created "filespec/column" { type=datetime; id=8; }
    s_created_by "filespec/column" { type=string; id=9; }
    s_date_modified "filespec/column" { type=datetime; id=10; }
    s_modified_by "filespec/column" { type=string; id=11; }
    __cx_osml_control "filespec/column" { type=string; id=12; }
    }
