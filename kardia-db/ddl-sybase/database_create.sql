
/* Create the Kardia_DB database */

--set nocount on
if not exists (select * from master.dbo.sysdevices where name = "kardia_data")
    /* If the physical device does not exist, make it */
           begin
                  print 'Creating the Kardia DB device.'
                   disk init name="kardia_data", physname="/usr/local/kardia/Kardia_DB.db",vdevno=4,size=262288
                   disk init name="kardia_log", physname="/usr/local/kardia/Kardia_DB.log",vdevno=5,size=262288
           end
go

if exists (select * from master.dbo.sysdatabases where name = "Kardia_DB")
           begin
        /* drop the existing database */
                   print 'Recreating the "Kardia_DB" database.'
                   drop database Kardia_DB
           end
else
           begin
                   print 'Creating the "Kardia_DB" database.'
           end
go
    
/* create a new database */
create database Kardia_DB on kardia_data=1020 log on kardia_log=1020
go
