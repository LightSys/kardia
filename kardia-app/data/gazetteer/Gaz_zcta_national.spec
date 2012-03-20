Gaz_zcta_national "application/filespec"
    {
    // General parameters.
    filetype = csv
    header_row = yes
    header_has_titles = no
    annotation = "Census 2010 ZCTA List"
    row_annot_exp = ""
    key_is_rowid = yes
    new_row_padding = 32

    // Column specifications.
    // GEOID,ALAND,AWATER,ALAND_SQMI,AWATER_SQMI,INTPTLONG,INTPTLAT
    zcta "filespec/column" { type=string id=1 }
    aland "filespec/column" { type=double id=2 }
    awater "filespec/column" { type=double id=3 }
    aland_sqmi "filespec/column" { type=double id=4 }
    awater_sqmi "filespec/column" { type=double id=5 }
    lat "filespec/column" { type=double id=6 }
    lon "filespec/column" { type=double id=7 }
    }

