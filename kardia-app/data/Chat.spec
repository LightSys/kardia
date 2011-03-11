Chat "application/filespec"
    {
    // General parameters.
    filetype = csv
    header_row = yes
    header_has_titles = no
    annotation = "Chat Messages"
    row_annot_exp = ":c_from + ' --> ' + :c_to + ' on ' + :c_date"
    key_is_rowid = yes
    new_row_padding = 32

    // Column specifications.
    c_from "filespec/column" { type=string id=1 }
    c_to "filespec/column" { type=string id=2 }
    c_viewed "filespec/column" { type=integer id=3 }
    c_date "filespec/column" { type=datetime id=4 }
    c_message "filespec/column" { type=string id=5 }
    }

