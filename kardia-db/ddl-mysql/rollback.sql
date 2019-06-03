Starting Liquibase at Mon, 03 Jun 2019 15:25:57 MDT (version 3.6.3 built at 2019-01-29 11:34:48)
Rolling Back Changeset:liquibaseFiles/currentFullChangeLog.json::1559592998398-3::Nate Gamble (generated)
Rolling Back Changeset:liquibaseFiles/currentFullChangeLog.json::1559592998398-2::Nate Gamble (generated)
Rolling Back Changeset:liquibaseFiles/currentFullChangeLog.json::1559592998398-1::Nate Gamble (generated)
--  *********************************************************************
--  Rollback 5 Change(s) Script
--  *********************************************************************
--  Change Log: liquibaseFiles/currentFullChangeLog.json
--  Ran at: 6/3/19 3:25 PM
--  Against: devel@jdbc:mariadb://10.5.11.230:3306/test
--  Liquibase version: 3.6.3
--  *********************************************************************

--  Lock Database
UPDATE test.DATABASECHANGELOGLOCK SET `LOCKED` = 1, LOCKEDBY = 'DESKTOP-O1OAVI5 (10.5.12.79)', LOCKGRANTED = '2019-06-03 15:25:58.663' WHERE ID = 1 AND `LOCKED` = 0;

--  Rolling Back ChangeSet: liquibaseFiles/currentFullChangeLog.json::1559592998398-3::Nate Gamble (generated)
DROP TABLE test.NatesTable3;

DELETE FROM test.DATABASECHANGELOG WHERE ID = '1559592998398-3' AND AUTHOR = 'Nate Gamble (generated)' AND FILENAME = 'liquibaseFiles/currentFullChangeLog.json';

--  Rolling Back ChangeSet: liquibaseFiles/currentFullChangeLog.json::1559592998398-2::Nate Gamble (generated)
DROP TABLE test.NatesTable2;

DELETE FROM test.DATABASECHANGELOG WHERE ID = '1559592998398-2' AND AUTHOR = 'Nate Gamble (generated)' AND FILENAME = 'liquibaseFiles/currentFullChangeLog.json';

--  Rolling Back ChangeSet: liquibaseFiles/currentFullChangeLog.json::1559592998398-1::Nate Gamble (generated)
DROP TABLE test.NatesTable;

DELETE FROM test.DATABASECHANGELOG WHERE ID = '1559592998398-1' AND AUTHOR = 'Nate Gamble (generated)' AND FILENAME = 'liquibaseFiles/currentFullChangeLog.json';

--  Release Database Lock
UPDATE test.DATABASECHANGELOGLOCK SET `LOCKED` = 0, LOCKEDBY = NULL, LOCKGRANTED = NULL WHERE ID = 1;

