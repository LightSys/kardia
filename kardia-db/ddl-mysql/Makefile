DBUSER?=root
DBHOST?=localhost
LOGINHOST?=localhost
LOGINUSER?=root
DEFAULTPASS=newuserpass
#MYSQLOPTS=-u $(DBUSER) -p -f -h $(DBHOST)
MYSQLOPTS=-u $(DBUSER) -f -h $(DBHOST)

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
.PHONY:	createdb
.PHONY:	createuser
.PHONY:	countries

db: tables keys indexes dropdowns countries gazetteer

nodb: noindexes nokeys notables nodropdowns

createuser:
	mysql $(MYSQLOPTS) -e "CREATE USER '$(LOGINUSER)'@'$(LOGINHOST)' IDENTIFIED BY '$(DEFAULTPASS)';"
	mysql $(MYSQLOPTS) -e "GRANT ALL ON Kardia_DB.* TO '$(LOGINUSER)'@'$(LOGINHOST)';"
	mysql $(MYSQLOPTS) -e "FLUSH PRIVILEGES;"

createdb:
	mysql $(MYSQLOPTS) -e "create database Kardia_DB;"

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

countries:
	mysql $(MYSQLOPTS) < 2011countries.sql

gazetteer:
	gzip -d < gazetteer-mysql.sql.gz | mysql $(MYSQLOPTS) Kardia_DB
