$Version=2$
i_eg_deposit_config "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for i_eg_deposit_config";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    a_ledger_number "filespec/column" { type=string; id=1; }
    i_eg_depfee_id "filespec/column" { type=integer; id=2; }
    i_eg_service "filespec/column" { type=string; id=3; }
    i_eg_processor "filespec/column" { type=string; id=4; }
    i_eg_gift_currency "filespec/column" { type=string; id=5; }
    i_eg_gift_pmt_type "filespec/column" { type=string; id=6; }
    i_eg_deposit_method "filespec/column" { type=string; id=7; }
    i_eg_fees_method "filespec/column" { type=string; id=8; }
    i_eg_fees_fund "filespec/column" { type=string; id=9; }
    i_eg_fees_account_code "filespec/column" { type=string; id=10; }
    i_eg_calc_method "filespec/column" { type=string; id=11; }
    i_eg_calc_rounding "filespec/column" { type=string; id=12; }
    i_eg_fee_flat_amt "filespec/column" { type=money; id=13; }
    i_eg_fee_pct_amt "filespec/column" { type=double; id=14; }
    s_date_created "filespec/column" { type=datetime; id=15; }
    s_created_by "filespec/column" { type=string; id=16; }
    s_date_modified "filespec/column" { type=datetime; id=17; }
    s_modified_by "filespec/column" { type=string; id=18; }
    __cx_osml_control "filespec/column" { type=string; id=19; }
    }
