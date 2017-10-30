#!/bin/bash
#

# Loop through columns in tables_create.sql
cat tables_create.sql | sed -n 's/^create table \([a-z_]*\) (/\1/p' | while read TABLE; do
    # Get object id
    TABLEID=$(run_sql.sh "select id from sysobjects where name = '$TABLE'" | tail -n +3 | sed -n 's/[^0-9]*\([0-9]*\).*/\1/p' | head -1)
    if [ "$TABLEID" = "" ]; then
	echo ""
	echo "Table $TABLE does not exist in the Sybase database"
    else
	SYBCOLS=$(run_sql.sh "select name from syscolumns where id = $TABLEID order by colid" | tail -n +3 | sed -n 's/^ \([a-z0-9_]*\).*/\1/p' | paste -s -d' ')
	DDLCOLS=$(grep -m1 -A100 "^create table $TABLE ($" tables_create.sql | grep -B100 -m1 '^go' | sed -n 's/^        *\([a-z0-9_]\+\).*/\1/p' | paste -s -d' ')
	if [ "$SYBCOLS" != "$DDLCOLS" ]; then
	    echo ""
	    echo "Table $TABLE has different columns:"
	    echo "    Sybase: $SYBCOLS"
	    echo "    DDL:    $DDLCOLS"
	fi
    fi
done
