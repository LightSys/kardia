DBUSER=root
#MYSQLOPTS=-u $(DBUSER) -p -f -h localhost
MYSQLOPTS=-u $(DBUSER) -f -h localhost

.PHONY: tables
.PHONY: notables
.PHONY: keys
.PHONY: nokeys
.PHONY: indexes
.PHONY: noindexes
.PHONY: db
.PHONY: nodb
.PHONY: dropdowns
.PHONY: nodropdowns

db: tables keys indexes dropdowns

nodb: noindexes nokeys notables nodropdowns

tables:
	mysql $(MYSQLOPTS) < tables_create.sql

notables:
	mysql $(MYSQLOPTS) < tables_drop.sql

keys:
	mysql $(MYSQLOPTS) < keys_create.sql

nokeys:
	mysql $(MYSQLOPTS) < keys_drop.sql

indexes:
	mysql $(MYSQLOPTS) < indexes_create.sql
	#mysql $(MYSQLOPTS) < sec_keys_create.sql

noindexes:
	mysql $(MYSQLOPTS) < indexes_drop.sql

dropdowns:
	mysql $(MYSQLOPTS) < dropdowns_create.sql

nodropdowns:
	mysql $(MYSQLOPTS) < dropdowns_drop.sql
