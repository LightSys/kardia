$Version=2$
a_fund_admin_fee "application/filespec"
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
    s_date_created "filespec/column" { type=datetime; id=1; }
    s_date_modified "filespec/column" { type=datetime; id=2; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=3; }
    a_default_subtype "filespec/column" { type=char(1); id=4; }
    a_ledger_number "filespec/column" { type=char(10); id=5; }
    a_percentage "filespec/column" { type=float; id=6; }
    a_fund "filespec/column" { type=char(20); id=7; }
    s_created_by "filespec/column" { type=varchar(20); id=8; }
    a_admin_fee_type "filespec/column" { type=char(3); id=9; }
    s_modified_by "filespec/column" { type=varchar(20); id=10; }
    }
