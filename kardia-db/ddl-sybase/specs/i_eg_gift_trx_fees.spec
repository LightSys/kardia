$Version=2$
i_eg_gift_trx_fees "application/filespec"
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
    i_eg_service "filespec/column" { type=varchar(16); id=1; }
    a_ledger_number "filespec/column" { type=char(10); id=2; }
    s_date_created "filespec/column" { type=datetime; id=3; }
    i_eg_processor "filespec/column" { type=varchar(80); id=4; }
    s_date_modified "filespec/column" { type=datetime; id=5; }
    i_eg_fees_id "filespec/column" { type=integer; id=6; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=7; }
    s_modified_by "filespec/column" { type=varchar(20); id=8; }
    i_eg_fee_flat_amt "filespec/column" { type=decimal(14,4); id=9; }
    i_eg_gift_pmt_type "filespec/column" { type=varchar(16); id=10; }
    s_created_by "filespec/column" { type=varchar(20); id=11; }
    i_eg_fee_pct_amt "filespec/column" { type=float; id=12; }
    i_eg_gift_currency "filespec/column" { type=varchar(16); id=13; }
    }
