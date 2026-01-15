$Version=2$
a_fund_staff "application/filespec"
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
    p_staff_partner_key "filespec/column" { type=varchar(10); id=1; }
    s_modified_by "filespec/column" { type=varchar(20); id=2; }
    p_end_date "filespec/column" { type=datetime; id=3; }
    s_created_by "filespec/column" { type=varchar(20); id=4; }
    a_ledger_number "filespec/column" { type=char(10); id=5; }
    a_fund "filespec/column" { type=char(20); id=6; }
    s_date_modified "filespec/column" { type=datetime; id=7; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=8; }
    s_date_created "filespec/column" { type=datetime; id=9; }
    p_start_date "filespec/column" { type=datetime; id=10; }
    }
