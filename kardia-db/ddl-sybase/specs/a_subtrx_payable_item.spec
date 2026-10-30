$Version=2$
a_subtrx_payable_item "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for a_subtrx_payable_item";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    a_ledger_number "filespec/column" { type=string; id=1; }
    a_payable_id "filespec/column" { type=integer; id=2; }
    a_line_item "filespec/column" { type=integer; id=3; }
    a_requested_terms "filespec/column" { type=string; id=4; }
    a_document_id "filespec/column" { type=integer; id=5; }
    a_occurrence_date "filespec/column" { type=datetime; id=6; }
    a_accrued_date "filespec/column" { type=datetime; id=7; }
    a_amount "filespec/column" { type=money; id=8; }
    a_fund "filespec/column" { type=string; id=9; }
    a_account_code "filespec/column" { type=string; id=10; }
    a_liab_fund "filespec/column" { type=string; id=11; }
    a_liab_account_code "filespec/column" { type=string; id=12; }
    a_comment "filespec/column" { type=string; id=13; }
    s_date_created "filespec/column" { type=datetime; id=14; }
    s_created_by "filespec/column" { type=string; id=15; }
    s_date_modified "filespec/column" { type=datetime; id=16; }
    s_modified_by "filespec/column" { type=string; id=17; }
    __cx_osml_control "filespec/column" { type=string; id=18; }
    }
