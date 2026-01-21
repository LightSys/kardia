$Version=2$
a_receipt_mailing "application/filespec"
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
    s_created_by "filespec/column" { type=varchar(20); id=1; }
    a_comment "filespec/column" { type=varchar(255); id=2; }
    s_modified_by "filespec/column" { type=varchar(20); id=3; }
    a_prev_issue_max_interval "filespec/column" { type=float; id=4; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=5; }
    s_date_modified "filespec/column" { type=datetime; id=6; }
    s_date_created "filespec/column" { type=datetime; id=7; }
    m_list_code "filespec/column" { type=varchar(20); id=8; }
    a_ledger_number "filespec/column" { type=char(10); id=9; }
    a_prev_issue_lookback "filespec/column" { type=integer; id=10; }
    }
