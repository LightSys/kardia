$Version=2$
i_eg_gift_trx_fees "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for i_eg_gift_trx_fees";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    a_ledger_number "filespec/column" { type=string; id=1; }
    i_eg_fees_id "filespec/column" { type=integer; id=2; }
    i_eg_service "filespec/column" { type=string; id=3; }
    i_eg_processor "filespec/column" { type=string; id=4; }
    i_eg_gift_currency "filespec/column" { type=string; id=5; }
    i_eg_gift_pmt_type "filespec/column" { type=string; id=6; }
    i_eg_fee_flat_amt "filespec/column" { type=money; id=7; }
    i_eg_fee_pct_amt "filespec/column" { type=double; id=8; }
    s_date_created "filespec/column" { type=datetime; id=9; }
    s_created_by "filespec/column" { type=string; id=10; }
    s_date_modified "filespec/column" { type=datetime; id=11; }
    s_modified_by "filespec/column" { type=string; id=12; }
    __cx_osml_control "filespec/column" { type=string; id=13; }
    }
