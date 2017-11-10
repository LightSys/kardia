#/bin/bash

[ "$DBSERVER" = "" ] && DBSERVER="SYBASE"
[ "$DBUSER" = "" ] && DBUSER="sa"
[ "$DBPASS" = "" ] && DBPASS=""
SYBOPTS="-U$DBUSER -S$DBSERVER -P '$DBPASS'"

echo "Building New tables"
isql $SYBOPTS -i tables_create.sql 1> /dev/null
echo "Creating Main Keys (remember to add secondary keys later)"
isql $SYBOPTS -i keys_create.sql
echo "Creating Indexes"
isql $SYBOPTS -i indexes_create.sql
echo "Creating drop-downs"
isql $SYBOPTS -i dropdowns_create.sql  1>/dev/null
echo "Creating users"
isql $SYBOPTS -i users_create.sql  1>/dev/null
echo "Configuring database locking"
isql $SYBOPTS -i locking.sql  1>/dev/null
