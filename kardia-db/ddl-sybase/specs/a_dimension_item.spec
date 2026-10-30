$Version=2$
a_dimension_item "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for a_dimension_item";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    a_dimension "filespec/column" { type=string; id=1; }
    a_ledger_number "filespec/column" { type=string; id=2; }
    a_dimension_item "filespec/column" { type=string; id=3; }
    a_is_posting "filespec/column" { type=integer; id=4; }
    a_dim_item_desc "filespec/column" { type=string; id=5; }
    a_dim_item_comments "filespec/column" { type=string; id=6; }
    a_legacy_code "filespec/column" { type=string; id=7; }
    a_start_date "filespec/column" { type=datetime; id=8; }
    a_end_date "filespec/column" { type=datetime; id=9; }
    a_dim_item_usage "filespec/column" { type=string; id=10; }
    a_dim_item_fund "filespec/column" { type=string; id=11; }
    a_dim_item_fund_class "filespec/column" { type=string; id=12; }
    s_date_created "filespec/column" { type=datetime; id=13; }
    s_created_by "filespec/column" { type=string; id=14; }
    s_date_modified "filespec/column" { type=datetime; id=15; }
    s_modified_by "filespec/column" { type=string; id=16; }
    __cx_osml_control "filespec/column" { type=string; id=17; }
    }
