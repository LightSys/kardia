$Version=2$
m_list_membership "application/filespec"
    {
    // General parameters.
    filetype = csv;
    header_row = yes;
    header_has_titles = no;
    two_quote_escape = yes;
    annotation = "CSV Data for m_list_membership";
    key_is_rowid = yes;
    new_row_padding = 8;
    
    // Column specifications.
    m_list_code "filespec/column" { type=string; id=1; }
    p_partner_key "filespec/column" { type=string; id=2; }
    m_hist_id "filespec/column" { type=integer; id=3; }
    m_num_copies "filespec/column" { type=integer; id=4; }
    p_location_id "filespec/column" { type=integer; id=5; }
    p_contact_id "filespec/column" { type=integer; id=6; }
    m_delivery_method "filespec/column" { type=string; id=7; }
    m_member_type "filespec/column" { type=string; id=8; }
    m_num_issues_sub "filespec/column" { type=integer; id=9; }
    m_num_issues_recv "filespec/column" { type=integer; id=10; }
    m_start_date "filespec/column" { type=datetime; id=11; }
    m_end_date "filespec/column" { type=datetime; id=12; }
    m_hold_until_date "filespec/column" { type=datetime; id=13; }
    m_renewal_date "filespec/column" { type=datetime; id=14; }
    m_cancel_date "filespec/column" { type=datetime; id=15; }
    m_notice_sent_date "filespec/column" { type=datetime; id=16; }
    p_postal_mode "filespec/column" { type=string; id=17; }
    m_membership_status "filespec/column" { type=string; id=18; }
    m_complimentary "filespec/column" { type=integer; id=19; }
    m_comments "filespec/column" { type=string; id=20; }
    m_show_contact "filespec/column" { type=integer; id=21; }
    m_contact "filespec/column" { type=string; id=22; }
    m_reason_member "filespec/column" { type=string; id=23; }
    m_reason_cancel "filespec/column" { type=string; id=24; }
    m_sort_order "filespec/column" { type=integer; id=25; }
    s_date_created "filespec/column" { type=datetime; id=26; }
    s_created_by "filespec/column" { type=string; id=27; }
    s_date_modified "filespec/column" { type=datetime; id=28; }
    s_modified_by "filespec/column" { type=string; id=29; }
    __cx_osml_control "filespec/column" { type=string; id=30; }
    }
