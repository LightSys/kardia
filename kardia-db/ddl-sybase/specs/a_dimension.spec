$Version=2$
a_dimension "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for a_dimension";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    a_dimension "filespec/column" { type=string; id=1; }
    a_ledger_number "filespec/column" { type=string; id=2; }
    a_is_posting "filespec/column" { type=integer; id=3; }
    a_dim_desc "filespec/column" { type=string; id=4; }
    a_dim_comments "filespec/column" { type=string; id=5; }
    a_legacy_code "filespec/column" { type=string; id=6; }
    a_default_item "filespec/column" { type=string; id=7; }
    a_start_date "filespec/column" { type=datetime; id=8; }
    a_end_date "filespec/column" { type=datetime; id=9; }
    a_lock_position "filespec/column" { type=integer; id=10; }
    a_lock_always_show "filespec/column" { type=integer; id=11; }
    a_required "filespec/column" { type=integer; id=12; }
    a_dim_usage "filespec/column" { type=string; id=13; }
    a_dim_fund "filespec/column" { type=string; id=14; }
    a_dim_fund_class "filespec/column" { type=string; id=15; }
    s_date_created "filespec/column" { type=datetime; id=16; }
    s_created_by "filespec/column" { type=string; id=17; }
    s_date_modified "filespec/column" { type=datetime; id=18; }
    s_modified_by "filespec/column" { type=string; id=19; }
    __cx_osml_control "filespec/column" { type=string; id=20; }
    }
