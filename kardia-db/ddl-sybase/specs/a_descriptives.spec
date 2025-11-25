$Version=2$
a_descriptives "application/filespec"
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
    a_hist_3_count "filespec/column" { type=integer; id=1; }
    a_hist_1_amount "filespec/column" { type=decimal(14,4); id=2; }
    a_hist_2_amount "filespec/column" { type=decimal(14,4); id=3; }
    a_hist_1_last "filespec/column" { type=datetime; id=4; }
    a_last_gift_amount "filespec/column" { type=decimal(14,4); id=5; }
    a_first_gift_amount "filespec/column" { type=decimal(14,4); id=6; }
    s_date_modified "filespec/column" { type=datetime; id=7; }
    a_is_current "filespec/column" { type=integer; id=8; }
    p_donor_partner_key "filespec/column" { type=char(10); id=9; }
    a_decrease_pct "filespec/column" { type=float; id=10; }
    s_created_by "filespec/column" { type=varchar(20); id=11; }
    a_ntl_gift "filespec/column" { type=datetime; id=12; }
    a_act_lookback_date "filespec/column" { type=datetime; id=13; }
    a_fund "filespec/column" { type=char(20); id=14; }
    a_is_extra "filespec/column" { type=integer; id=15; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=16; }
    s_modified_by "filespec/column" { type=varchar(20); id=17; }
    a_act_count "filespec/column" { type=integer; id=18; }
    a_act_average_months "filespec/column" { type=integer; id=19; }
    a_first_gift "filespec/column" { type=datetime; id=20; }
    a_hist_3_amount "filespec/column" { type=decimal(14,4); id=21; }
    a_ledger_number "filespec/column" { type=char(10); id=22; }
    a_act_average_interval "filespec/column" { type=float; id=23; }
    a_hist_3_first "filespec/column" { type=datetime; id=24; }
    a_increase_pct "filespec/column" { type=float; id=25; }
    s_date_created "filespec/column" { type=datetime; id=26; }
    a_act_total "filespec/column" { type=decimal(14,4); id=27; }
    a_increase_date "filespec/column" { type=datetime; id=28; }
    a_lapsed_days "filespec/column" { type=integer; id=29; }
    a_is_approximate "filespec/column" { type=integer; id=30; }
    a_act_average_amount "filespec/column" { type=decimal(14,4); id=31; }
    a_decrease_date "filespec/column" { type=datetime; id=32; }
    a_act_lookahead_date "filespec/column" { type=datetime; id=33; }
    a_last_gift "filespec/column" { type=datetime; id=34; }
    a_ntl_gift_amount "filespec/column" { type=decimal(14,4); id=35; }
    a_hist_1_count "filespec/column" { type=integer; id=36; }
    a_hist_2_first "filespec/column" { type=datetime; id=37; }
    a_hist_1_first "filespec/column" { type=datetime; id=38; }
    a_hist_3_last "filespec/column" { type=datetime; id=39; }
    a_hist_2_count "filespec/column" { type=integer; id=40; }
    a_hist_2_last "filespec/column" { type=datetime; id=41; }
    }
