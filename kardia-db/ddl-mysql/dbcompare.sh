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
cat tables_create.sql dropdowns_create.sql | sed -n 's/^create table \([a-z_]*\) (/\1/p' | while read TABLE; do
    DDLCOLS=$(grep -h -m1 -A100 "^create table $TABLE ($" tables_create.sql dropdowns_create.sql | tail -n +2 | grep -B100 -m1 '^[^ ]' | sed -n 's/^   *\([a-z0-9_]\+\).*/\1/p' | paste -s -d' ')
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
	else
#	    # Compare rows, if this is NOT a validation table and has data provided
#	    if [ "$TABLE" = "${TABLE#_}" ]; then
#		SUPPDATA=$(grep "^insert into ${TABLE} (" tables_create.sql)
#		if [ "$SUPPDATA" != "" ]; then
#		    run_sql "select * from ${TABLE}" | tail -n +2 | sed 's/NULL/ /g' | sed 's/[	][	]*/|/g' | sed 's/|[^|]*|[^|]*|[^|]*|[^|]*|[^|]*$//' | sort > DB-rows
#		    grep "^insert into ${TABLE} (" tables_create.sql  | sed 's/.*select //' | sed 's/ as [a-z0-9A-Z_]*[,;] */|/g' | sed 's/|[^|]*|[^|]*|[^|]*|[^|]*|[^|]*|$//' | sed "s/[\"']//g" | sort > DDL-rows
#		    DIFF=$(diff -u DB-rows DDL-rows)
#		    if [ "$DIFF" != "" ]; then
#			echo "Table $TABLE has different rows:"
#			echo -n "    MySQL: "
#			diff -u DB-rows DDL-rows | tail -n +3 | sed -n 's/^-//p'
#			echo -n "    DDL:   "
#			diff -u DB-rows DDL-rows | tail -n +3 | sed -n 's/^+//p'
#		    fi
#		    /bin/rm DB-rows
#		    /bin/rm DDL-rows
#		fi
#	    fi

	    # Compare rows, if this is a validation table
	    if [ "$TABLE" != "${TABLE#_}" ]; then
		DBROWS=$(run_sql "select * from ${TABLE}" | tail -n +1 | sed 's/NULL/ /g' | sed 's/[ 	][ 	]*/ /g' | sort | paste -s -d '|')
		DDLROWS=$(grep "^insert ${TABLE} values" dropdowns_create.sql | sed 's/.*values(//' | sed 's/);$//' | sed "s/','/ /g" | sed "s/'/ /g" | sed 's/  */ /g' | sed 's/^ *//' | sort | paste -s -d '|')
		if [ "$DBROWS" != "$DDLROWS" ]; then
		    echo "Table $TABLE has different rows:"
		    echo "    MySQL: $DBROWS"
		    echo "    DDL:   $DDLROWS"
		fi
	    fi
        fi
    fi
    PREVTABLE=$TABLE
done

