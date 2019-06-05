Starting Liquibase at Fri, 31 May 2019 15:42:52 MDT (version 3.6.3 built at 2019-01-29 11:34:48)
Rolling Back Changeset:liquibaseFiles/changeLog1.1.json::1::Nate Gamble
--  *********************************************************************
--  SQL to roll back currently unexecuted changes
--  *********************************************************************
--  Change Log: liquibaseFiles/masterChangeLog.json
--  Ran at: 5/31/19 3:42 PM
--  Against: devel@jdbc:mariadb://10.5.11.230:3306/Kardia_DB
--  Liquibase version: 3.6.3
--  *********************************************************************

--  Lock Database
UPDATE Kardia_DB.DATABASECHANGELOGLOCK SET `LOCKED` = 1, LOCKEDBY = 'DESKTOP-O1OAVI5 (10.5.12.79)', LOCKGRANTED = '2019-05-31 15:42:53.918' WHERE ID = 1 AND `LOCKED` = 0;

--  Rolling Back ChangeSet: liquibaseFiles/changeLog1.1.json::1::Nate Gamble
DROP TABLE Kardia_DB.NatesTable;

DELETE FROM Kardia_DB.DATABASECHANGELOG WHERE ID = '1' AND AUTHOR = 'Nate Gamble' AND FILENAME = 'liquibaseFiles/changeLog1.1.json';

--  Release Database Lock
UPDATE Kardia_DB.DATABASECHANGELOGLOCK SET `LOCKED` = 0, LOCKEDBY = NULL, LOCKGRANTED = NULL WHERE ID = 1;

