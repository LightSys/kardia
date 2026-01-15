$Version=2$
a_tax_table "application/filespec"
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
    a_filing_status "filespec/column" { type=char(1); id=1; }
    a_ledger_number "filespec/column" { type=char(10); id=2; }
    s_date_created "filespec/column" { type=datetime; id=3; }
    a_add_to_tax "filespec/column" { type=decimal(14,4); id=4; }
    a_start_date "filespec/column" { type=datetime; id=5; }
    s_date_modified "filespec/column" { type=datetime; id=6; }
    a_payroll_item_type "filespec/column" { type=char(4); id=7; }
    a_subtract_salary "filespec/column" { type=decimal(14,4); id=8; }
    a_tax_entry_id "filespec/column" { type=integer; id=9; }
    s_created_by "filespec/column" { type=varchar(20); id=10; }
    a_percent "filespec/column" { type=float; id=11; }
    a_minimum_salary "filespec/column" { type=decimal(14,4); id=12; }
    a_payroll_interval "filespec/column" { type=char(2); id=13; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=14; }
    a_end_date "filespec/column" { type=datetime; id=15; }
    s_modified_by "filespec/column" { type=varchar(20); id=16; }
    a_maximum_salary "filespec/column" { type=decimal(14,4); id=17; }
    }
