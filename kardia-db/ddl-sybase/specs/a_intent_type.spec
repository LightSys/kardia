$Version=2$
a_intent_type "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for a_intent_type";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    a_ledger_number "filespec/column" { type=string; id=1; }
    a_intent_type "filespec/column" { type=string; id=2; }
    a_intent_desc "filespec/column" { type=string; id=3; }
    a_is_active "filespec/column" { type=integer; id=4; }
    a_create_receivable "filespec/column" { type=integer; id=5; }
    a_recv_account_code "filespec/column" { type=string; id=6; }
    a_allow_daf "filespec/column" { type=integer; id=7; }
    a_comment "filespec/column" { type=string; id=8; }
    s_date_created "filespec/column" { type=datetime; id=9; }
    s_created_by "filespec/column" { type=string; id=10; }
    s_date_modified "filespec/column" { type=datetime; id=11; }
    s_modified_by "filespec/column" { type=string; id=12; }
    __cx_osml_control "filespec/column" { type=string; id=13; }
    }
