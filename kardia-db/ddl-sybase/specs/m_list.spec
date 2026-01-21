$Version=2$
m_list "application/filespec"
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
    a_charge_ledger "filespec/column" { type=char(10); id=1; }
    __cx_osml_control "filespec/column" { type=varchar(255); id=2; }
    m_list_frozen "filespec/column" { type=bit; id=3; }
    m_list_type "filespec/column" { type=char(1); id=4; }
    m_list_parent "filespec/column" { type=varchar(20); id=5; }
    p_postal_mode "filespec/column" { type=char(1); id=6; }
    s_modified_by "filespec/column" { type=varchar(20); id=7; }
    m_delivery_method "filespec/column" { type=char(1); id=8; }
    s_date_modified "filespec/column" { type=datetime; id=9; }
    m_discard_after "filespec/column" { type=datetime; id=10; }
    s_date_created "filespec/column" { type=datetime; id=11; }
    m_list_code "filespec/column" { type=varchar(20); id=12; }
    m_list_description "filespec/column" { type=varchar(255); id=13; }
    m_date_sent "filespec/column" { type=datetime; id=14; }
    s_created_by "filespec/column" { type=varchar(20); id=15; }
    a_charge_fund "filespec/column" { type=varchar(20); id=16; }
    m_list_status "filespec/column" { type=char(1); id=17; }
    }
