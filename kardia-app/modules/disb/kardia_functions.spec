kardia_functions "application/filespec"
    {
    // General parameters.
    filetype = csv
    header_row = yes
    header_has_titles = no
    key_is_rowid = yes
    new_row_padding = 32

    // Column specifications.
    func_name "filespec/column" { type=string id=1 }
    func_type "filespec/column" { type=string id=2 }	// RPT or APP
    func_file "filespec/column" { type=string id=3 }
    func_description "filespec/column" { type=string id=4 }
    func_icon "filespec/column" { type=string id=5 }
    }

