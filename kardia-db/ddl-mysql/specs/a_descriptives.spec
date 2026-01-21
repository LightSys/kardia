$Version=2$
a_descriptives "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for a_descriptives";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    a_ledger_number "filespec/column" { type=string; id=1; }
    p_donor_partner_key "filespec/column" { type=string; id=2; }
    a_fund "filespec/column" { type=string; id=3; }
    a_first_gift "filespec/column" { type=datetime; id=4; }
    a_first_gift_amount "filespec/column" { type=money; id=5; }
    a_last_gift "filespec/column" { type=datetime; id=6; }
    a_last_gift_amount "filespec/column" { type=money; id=7; }
    a_ntl_gift "filespec/column" { type=datetime; id=8; }
    a_ntl_gift_amount "filespec/column" { type=money; id=9; }
    a_act_lookahead_date "filespec/column" { type=datetime; id=10; }
    a_act_lookback_date "filespec/column" { type=datetime; id=11; }
    a_act_average_amount "filespec/column" { type=money; id=12; }
    a_act_average_months "filespec/column" { type=integer; id=13; }
    a_act_average_interval "filespec/column" { type=double; id=14; }
    a_act_count "filespec/column" { type=integer; id=15; }
    a_act_total "filespec/column" { type=money; id=16; }
    a_hist_1_amount "filespec/column" { type=money; id=17; }
    a_hist_1_count "filespec/column" { type=integer; id=18; }
    a_hist_1_first "filespec/column" { type=datetime; id=19; }
    a_hist_1_last "filespec/column" { type=datetime; id=20; }
    a_hist_2_amount "filespec/column" { type=money; id=21; }
    a_hist_2_count "filespec/column" { type=integer; id=22; }
    a_hist_2_first "filespec/column" { type=datetime; id=23; }
    a_hist_2_last "filespec/column" { type=datetime; id=24; }
    a_hist_3_amount "filespec/column" { type=money; id=25; }
    a_hist_3_count "filespec/column" { type=integer; id=26; }
    a_hist_3_first "filespec/column" { type=datetime; id=27; }
    a_hist_3_last "filespec/column" { type=datetime; id=28; }
    a_lapsed_days "filespec/column" { type=integer; id=29; }
    a_is_current "filespec/column" { type=integer; id=30; }
    a_increase_pct "filespec/column" { type=double; id=31; }
    a_increase_date "filespec/column" { type=datetime; id=32; }
    a_decrease_pct "filespec/column" { type=double; id=33; }
    a_decrease_date "filespec/column" { type=datetime; id=34; }
    a_is_extra "filespec/column" { type=integer; id=35; }
    a_is_approximate "filespec/column" { type=integer; id=36; }
    s_date_created "filespec/column" { type=datetime; id=37; }
    s_created_by "filespec/column" { type=string; id=38; }
    s_date_modified "filespec/column" { type=datetime; id=39; }
    s_modified_by "filespec/column" { type=string; id=40; }
    __cx_osml_control "filespec/column" { type=string; id=41; }
    }
