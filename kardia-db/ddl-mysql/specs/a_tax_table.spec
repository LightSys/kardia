$Version=2$
a_tax_table "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for a_tax_table";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    a_tax_entry_id "filespec/column" { type=integer; id=1; }
    a_payroll_item_type "filespec/column" { type=string; id=2; }
    a_ledger_number "filespec/column" { type=string; id=3; }
    a_start_date "filespec/column" { type=datetime; id=4; }
    a_end_date "filespec/column" { type=datetime; id=5; }
    a_payroll_interval "filespec/column" { type=string; id=6; }
    a_filing_status "filespec/column" { type=string; id=7; }
    a_minimum_salary "filespec/column" { type=money; id=8; }
    a_maximum_salary "filespec/column" { type=money; id=9; }
    a_subtract_salary "filespec/column" { type=money; id=10; }
    a_percent "filespec/column" { type=double; id=11; }
    a_add_to_tax "filespec/column" { type=money; id=12; }
    s_date_created "filespec/column" { type=datetime; id=13; }
    s_created_by "filespec/column" { type=string; id=14; }
    s_date_modified "filespec/column" { type=datetime; id=15; }
    s_modified_by "filespec/column" { type=string; id=16; }
    __cx_osml_control "filespec/column" { type=string; id=17; }
    }
