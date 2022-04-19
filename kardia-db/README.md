## Note on Liquibase
There are some files in this directory from experiments with using Liquibase for data model upgrades. This is NOT currently part of the standard Kardia workflow for handling schema changes. Please don't use the instructions in the Liquibase related files or otherwise mess with them unless you know what you're doing.

## Development Schema Changes

To edit the Kardia database schema in your local development deployment:

1. Edit the Kardia wiki page for the table you'd like to change. There's a full list here: https://www.codn.net/projects/kardia/wiki/index.php/Kardia:NewTableList If you don't already have an account, you'll need to ask Greg for one.

2. In a terminal, navigate to the `kardia-db` folder. Then run the command `./parse_ddl.pl -b mysql -n` to pull schema information from the Kardia wiki and generate SQL files for building a database with that schema.

3. Still in a terminal, run `kardia.sh` and navigate to Developer Tools, then select Rebuild the Kardia Database. You may see some errors as it processes the new SQL; this is normal and not a cause for concern.

4. When the rebuilding process is done, you should be brought back to the Developer Tools window. Select Restart Centrallix.

5. Once Centrallix has restarted, navigate to your Kardia installation in a browser and then go to System > Kardia Tables to check the table you changed and make sure it now has your new schema.

6. Once you've finalized your schema, make sure to commit any changes that were made by `parse_ddl.pl` to files in `kardia-db/ddl-mysql`.

## Production Deployment
On production systems, Greg prefers to upgrade tables one at a time using:

```
[user@host ddl-mysql]$ ./onetable.sh {tablename}
```

That works great on mysql/mariadb, but on Sybase due to the way their toolchain works, you have to do:

```
sql> sp_rename {tablename}, {tablename}_0
sql> go

[user@host ddl-sybase]$ ./onetable.sh {tablename}

sql> insert into {tablename} select {list all of the columns here, with defaults for new ones sigh...} from {tablename}_0
```

Then verify it worked, and

```
sql> drop table {tablename}_0 
```
