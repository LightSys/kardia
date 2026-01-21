$Version=2$
a_intent_type "application/filespec"
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
    a_recv_account_code "filespec/column" { type=char(16); id=1; }
    a_ledger_number "filespec/column" { type=char(10); id=2; }
    a_allow_daf "filespec/column" { type=bit; id=3; }
    a_create_receivable "filespec/column" { type=bit; id=4; }
    a_is_active "filespec/column" { type=bit; id=5; }
    s_date_created "filespec/column" { type=datetime; id=6; }
    s_date_modified "filespec/column" { type=datetime; id=7; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=8; }
    s_modified_by "filespec/column" { type=varchar(20); id=9; }
    a_intent_desc "filespec/column" { type=varchar(80); id=10; }
    s_created_by "filespec/column" { type=varchar(20); id=11; }
    a_comment "filespec/column" { type=varchar(255); id=12; }
    a_intent_type "filespec/column" { type=varchar(1); id=13; }
    }
