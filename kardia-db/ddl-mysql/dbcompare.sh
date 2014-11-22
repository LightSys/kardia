#!/bin/bash
#
# dbcompare.sh - compare the schema files in this directory with the actual
# MySQL database schema.
#
# Set DBHOST to the hostname of the database server, otherwise 'localhost'
# is assumed.
#
# Set DBUSER to the username on the database server, otherwise 'root' is
# assumed.
#
# Password is assumed to be either blank or provided in an Option File (see
# the MySQL client documentation for how to use option files).  An option file
# is typically either "/etc/my.cnf" or "~/.my.cnf".
#

if [ "$DBHOST" = "" ]; then
    DBHOST=localhost
fi

if [ "$DBUSER" = "" ]; then
    DBUSER=root
fi

MYSQLOPTS="-u $DBUSER -f -s -h $DBHOST Kardia_DB"

function run_sql
    {
    local SQL="$1"

    mysql $MYSQLOPTS -e "${SQL};" 2>/dev/null
    }

# Loop through columns in tables_create.sql
cat tables_create.sql | sed -n 's/^create table \([a-z_]*\) (/\1/p' | while read TABLE; do
    DDLCOLS=$(grep -m1 -A100 "^create table $TABLE ($" tables_create.sql | grep -B100 -m1 '^\/' | sed -n 's/^        *\([a-z0-9_]\+\).*/\1/p' | paste -s -d' ')
    DBCOLS=$(run_sql "describe ${TABLE}" | tail -n +1 | sed -n 's/^\([a-zA-Z0-9_]*\).*$/\1/p' | paste -s -d' ')
    if [ "$DBCOLS" = "" ]; then
	echo ""
        echo "Table $TABLE does not exist in the MySQL database"
    else
        if [ "$DBCOLS" != "$DDLCOLS" ]; then
            echo ""
            echo "Table $TABLE has different columns:"
            echo "    MySQL: $DBCOLS"
            echo "    DDL:   $DDLCOLS"
        fi
    fi
    PREVTABLE=$TABLE
done

