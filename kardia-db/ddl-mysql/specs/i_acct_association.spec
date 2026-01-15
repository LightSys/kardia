$Version=2$
i_acct_association "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for i_acct_association";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    a_ledger_number "filespec/column" { type=string; id=1; }
    i_assoc_service "filespec/column" { type=string; id=2; }
    i_assoc_type "filespec/column" { type=string; id=3; }
    i_assoc_external_id "filespec/column" { type=string; id=4; }
    i_assoc_hist_id "filespec/column" { type=integer; id=5; }
    i_assoc_start_date "filespec/column" { type=datetime; id=6; }
    i_assoc_end_date "filespec/column" { type=datetime; id=7; }
    i_assoc_id "filespec/column" { type=string; id=8; }
    i_assoc_future "filespec/column" { type=integer; id=9; }
    s_date_created "filespec/column" { type=datetime; id=10; }
    s_created_by "filespec/column" { type=string; id=11; }
    s_date_modified "filespec/column" { type=datetime; id=12; }
    s_modified_by "filespec/column" { type=string; id=13; }
    __cx_osml_control "filespec/column" { type=string; id=14; }
    }
