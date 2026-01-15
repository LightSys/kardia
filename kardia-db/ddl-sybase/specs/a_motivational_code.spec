$Version=2$
a_motivational_code "application/filespec"
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
    a_motivational_code_status "filespec/column" { type=char(1); id=1; }
    a_comments "filespec/column" { type=varchar(255); id=2; }
    a_gift_admin_subtype "filespec/column" { type=char(1); id=3; }
    a_account_code "filespec/column" { type=varchar(16); id=4; }
    s_created_by "filespec/column" { type=varchar(20); id=5; }
    m_list_code "filespec/column" { type=varchar(20); id=6; }
    a_parent_motivational_code "filespec/column" { type=varchar(16); id=7; }
    a_ledger_number "filespec/column" { type=char(10); id=8; }
    s_date_modified "filespec/column" { type=datetime; id=9; }
    s_date_created "filespec/column" { type=datetime; id=10; }
    s_modified_by "filespec/column" { type=varchar(20); id=11; }
    a_motivational_code "filespec/column" { type=char(16); id=12; }
    a_gift_comment "filespec/column" { type=varchar(255); id=13; }
    a_gift_admin_fee "filespec/column" { type=float; id=14; }
    a_fund "filespec/column" { type=varchar(20); id=15; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=16; }
    }
