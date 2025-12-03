$Version=2$
m_list_membership "application/filespec"
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
    m_show_contact "filespec/column" { type=bit; id=1; }
    s_modified_by "filespec/column" { type=varchar(20); id=2; }
    m_complimentary "filespec/column" { type=bit; id=3; }
    m_reason_member "filespec/column" { type=char(1); id=4; }
    m_end_date "filespec/column" { type=datetime; id=5; }
    m_reason_cancel "filespec/column" { type=char(1); id=6; }
    p_postal_mode "filespec/column" { type=char(1); id=7; }
    m_num_issues_sub "filespec/column" { type=integer; id=8; }
    m_hold_until_date "filespec/column" { type=datetime; id=9; }
    m_cancel_date "filespec/column" { type=datetime; id=10; }
    m_renewal_date "filespec/column" { type=datetime; id=11; }
    m_membership_status "filespec/column" { type=char(1); id=12; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=13; }
    m_comments "filespec/column" { type=varchar(255); id=14; }
    m_hist_id "filespec/column" { type=integer; id=15; }
    s_created_by "filespec/column" { type=varchar(20); id=16; }
    m_notice_sent_date "filespec/column" { type=datetime; id=17; }
    m_num_issues_recv "filespec/column" { type=integer; id=18; }
    p_location_id "filespec/column" { type=tinyint; id=19; }
    m_num_copies "filespec/column" { type=integer; id=20; }
    m_list_code "filespec/column" { type=varchar(20); id=21; }
    p_contact_id "filespec/column" { type=tinyint; id=22; }
    p_partner_key "filespec/column" { type=char(10); id=23; }
    s_date_modified "filespec/column" { type=datetime; id=24; }
    m_contact "filespec/column" { type=varchar(80); id=25; }
    m_start_date "filespec/column" { type=datetime; id=26; }
    m_delivery_method "filespec/column" { type=char(1); id=27; }
    m_member_type "filespec/column" { type=char(1); id=28; }
    m_sort_order "filespec/column" { type=integer; id=29; }
    s_date_created "filespec/column" { type=datetime; id=30; }
    }
