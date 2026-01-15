$Version=2$
a_fund_auto_subscribe "application/filespec"
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
    __cx_osml_control "filespec/column" { type=varchar(255); id=1; }
    s_date_modified "filespec/column" { type=datetime; id=2; }
    s_date_created "filespec/column" { type=datetime; id=3; }
    a_subscribe_months "filespec/column" { type=integer; id=4; }
    m_list_code "filespec/column" { type=varchar(20); id=5; }
    a_fund "filespec/column" { type=char(20); id=6; }
    a_ledger_number "filespec/column" { type=char(10); id=7; }
    a_comments "filespec/column" { type=varchar(255); id=8; }
    s_created_by "filespec/column" { type=varchar(20); id=9; }
    s_modified_by "filespec/column" { type=varchar(20); id=10; }
    a_minimum_gift "filespec/column" { type=decimal(14,4); id=11; }
    }
