$Version=2$
a_descriptives_hist "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for a_descriptives_hist";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    a_ledger_number "filespec/column" { type=string; id=1; }
    p_donor_partner_key "filespec/column" { type=string; id=2; }
    a_fund "filespec/column" { type=string; id=3; }
    a_hist_id "filespec/column" { type=integer; id=4; }
    a_amount "filespec/column" { type=money; id=5; }
    a_first_gift "filespec/column" { type=datetime; id=6; }
    a_last_gift "filespec/column" { type=datetime; id=7; }
    a_ntl_gift "filespec/column" { type=datetime; id=8; }
    a_count "filespec/column" { type=integer; id=9; }
    a_total "filespec/column" { type=money; id=10; }
    a_act_average_amount "filespec/column" { type=money; id=11; }
    a_act_average_months "filespec/column" { type=integer; id=12; }
    a_act_average_interval "filespec/column" { type=double; id=13; }
    a_merged_id "filespec/column" { type=integer; id=14; }
    a_lapsed_days "filespec/column" { type=integer; id=15; }
    a_is_current "filespec/column" { type=integer; id=16; }
    a_increase_pct "filespec/column" { type=double; id=17; }
    a_decrease_pct "filespec/column" { type=double; id=18; }
    a_is_extra "filespec/column" { type=integer; id=19; }
    a_is_approximate "filespec/column" { type=integer; id=20; }
    a_prev_end "filespec/column" { type=datetime; id=21; }
    a_next_start "filespec/column" { type=datetime; id=22; }
    s_date_created "filespec/column" { type=datetime; id=23; }
    s_created_by "filespec/column" { type=string; id=24; }
    s_date_modified "filespec/column" { type=datetime; id=25; }
    s_modified_by "filespec/column" { type=string; id=26; }
    __cx_osml_control "filespec/column" { type=string; id=27; }
    }
