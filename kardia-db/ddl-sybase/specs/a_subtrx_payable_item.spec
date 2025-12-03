$Version=2$
a_subtrx_payable_item "application/filespec"
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
    a_fund "filespec/column" { type=char(20); id=1; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=2; }
    s_modified_by "filespec/column" { type=varchar(20); id=3; }
    a_line_item "filespec/column" { type=integer; id=4; }
    a_comment "filespec/column" { type=varchar(255); id=5; }
    a_accrued_date "filespec/column" { type=datetime; id=6; }
    a_ledger_number "filespec/column" { type=char(10); id=7; }
    a_requested_terms "filespec/column" { type=varchar(16); id=8; }
    s_date_created "filespec/column" { type=datetime; id=9; }
    s_date_modified "filespec/column" { type=datetime; id=10; }
    a_amount "filespec/column" { type=decimal(14,4); id=11; }
    a_liab_account_code "filespec/column" { type=char(10); id=12; }
    a_occurrence_date "filespec/column" { type=datetime; id=13; }
    a_account_code "filespec/column" { type=char(10); id=14; }
    s_created_by "filespec/column" { type=varchar(20); id=15; }
    a_liab_fund "filespec/column" { type=char(20); id=16; }
    a_payable_id "filespec/column" { type=integer; id=17; }
    a_document_id "filespec/column" { type=integer; id=18; }
    }
