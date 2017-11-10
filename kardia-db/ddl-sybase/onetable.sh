#!/bin/bash
#
# (drop and) create one specific table from the downloaded data model
# DDL, and load its keys and indexes.
#
# GRB 7/22/2008

export LANG=C

TABLE="$1"
[ "$DBSERVER" = "" ] && DBSERVER="SYBASE"
[ "$DBUSER" = "" ] && DBUSER="sa"
[ "$DBPASS" = "" ] && DBPASS=""
SYBOPTS="-U$DBUSER -S$DBSERVER -P '$DBPASS'"

echo "/* Rebuild table ${TABLE}.  Auto-generated by onetable.sh */" > onetable.sql
echo "use Kardia_DB" >> onetable.sql
echo "go" >> onetable.sql

grep -m1 -A1 "^drop table ${TABLE}$" tables_drop.sql >> onetable.sql
grep -m1 -A100 "^create table ${TABLE} ($" tables_create.sql | grep -B100 -m1 '^go' >> onetable.sql
grep -A1 "^insert into ${TABLE} select" tables_create.sql >> onetable.sql

grep -m2 -A10 "^alter table ${TABLE}$" keys_create.sql | grep -B10 -m1 '^go' >> onetable.sql
grep -A1 "^create.*on ${TABLE} " indexes_create.sql >> onetable.sql
grep -A1 "^grant.*on ${TABLE} " users_create.sql >> onetable.sql

bcp "Kardia_DB.dbo.${TABLE}" out "onetable.bcp" -c -t'|' $SYBOPTS

isql $SYBOPTS -i onetable.sql

bcp "Kardia_DB.dbo.${TABLE}" in "onetable.bcp" -c -t'|' -Y $SYBOPTS
