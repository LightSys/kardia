$Version=2$
a_descriptives_hist "application/filespec"
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
    s_created_by "filespec/column" { type=varchar(20); id=1; }
    a_next_start "filespec/column" { type=datetime; id=2; }
    a_last_gift "filespec/column" { type=datetime; id=3; }
    a_ntl_gift "filespec/column" { type=datetime; id=4; }
    a_merged_id "filespec/column" { type=integer; id=5; }
    a_is_approximate "filespec/column" { type=integer; id=6; }
    a_prev_end "filespec/column" { type=datetime; id=7; }
    a_lapsed_days "filespec/column" { type=integer; id=8; }
    a_act_average_amount "filespec/column" { type=decimal(14,4); id=9; }
    p_donor_partner_key "filespec/column" { type=char(10); id=10; }
    a_decrease_pct "filespec/column" { type=float; id=11; }
    a_increase_pct "filespec/column" { type=float; id=12; }
    s_date_created "filespec/column" { type=datetime; id=13; }
    s_date_modified "filespec/column" { type=datetime; id=14; }
    a_count "filespec/column" { type=integer; id=15; }
    a_is_current "filespec/column" { type=integer; id=16; }
    a_amount "filespec/column" { type=decimal(14,4); id=17; }
    a_ledger_number "filespec/column" { type=char(10); id=18; }
    a_act_average_interval "filespec/column" { type=float; id=19; }
    a_act_average_months "filespec/column" { type=integer; id=20; }
    a_first_gift "filespec/column" { type=datetime; id=21; }
    a_hist_id "filespec/column" { type=integer; id=22; }
    s_modified_by "filespec/column" { type=varchar(20); id=23; }
    a_is_extra "filespec/column" { type=integer; id=24; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=25; }
    a_total "filespec/column" { type=decimal(14,4); id=26; }
    a_fund "filespec/column" { type=char(20); id=27; }
    }
