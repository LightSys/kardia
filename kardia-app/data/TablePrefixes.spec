TablePrefixes "application/filespec"
    {
    // General parameters.
    filetype = csv
    header_row = yes
    header_has_titles = no
    annotation = "Table Prefix List"
    row_annot_exp = ""
    key_is_rowid = yes
    new_row_padding = 32

    // Column specifications.
    prefix "filespec/column" { type=string id=1 }
    description "filespec/column" { type=string id=2 }
    }

