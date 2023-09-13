## Download Instructions:
1. Download the lastest version of Liquibase at: https://download.liquibase.org/download/?frm=n
2. Follow Liquibase install instructions
3. Test that you can use Liquibase by using the command ```liquibase --version``` in the command line

	a. If this does not work, check that your PATH variable is properly set and check that you have the latest version of java
4. Download Perl and Python  
<br>

## How to use Liquibase:
1. Look at Liquibase.properties (located at ```kardia/kardia-db/ddl-[database]```) and make sure the information is correct.  
  a. The driver and classpath should not need to be changed.  
  b. The url should look something like this: ```jdbc:jtds:sybase//localhost:3306/Kardia_DB``` for sybase (```jdbc:mariadb://...``` for mysql)  
  &nbsp;&nbsp;&nbsp;&nbsp;**NOTE:** localhost should be changed to the machine running Kardia if not localhost

	c. Add lines for username and password for machine if desired (username: myUsername and password: myPassword)  
2. Use the command line to navigate to ```kardia/kardia-db/ddl-[database]```
3. Get the full changeLog of the current database with the following command: 
	```
	liquibase generateChangeLog --changeLogFile liquibaseFiles/currentChangeLog.json
	``` 
	a. Use  the ```--username``` and ```--password``` tags if they are not in the .properties file
	
	b. If the currentChangeLog.json file already exists, include the ```--overwrite-output-file``` tag
4. Navigate up a folder to ```kardia/kardia-db```
5. Get the database schema from the wiki by running:  
	```
	perl parse_ddl.pl -b [database] -n
	```
	**NOTE:** to include the dropdown tables and data, also run: 
	```
	perl make_dropdowns.pl [database]
	```
6. enerate the differences between the schema in the current database and the wiki by running the following:
	```
	python jsonCompare.py [database]
	```
	**NOTE:** If tables need to be dropped, the resulting changeset will be placed in a seperate file to avoid the accidental loss of data, and to make double checking which tables are being dropped far more convenient. 
7. Edit masterChangeLog.json (located at ```kardia/kardia-db/ddl-[database]/liquibaseFiles```) to include the newly created json file
8. Navigate to ```kardia/kardia-db/ddl-[database]``` in the command line
9. Update the current database with the following command:
	```
	liquibase update --changeLogFile liquibaseFiles/masterChangeLog.json
	```
<br>

### Rollbacks using Liquibase:
There are 3 main options to rollback a database schema using Liquibase.  
Option 1:  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Use "liquibase rollback [tag]" to rollback to the changeSet with the given tag  
Option 2:  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Use "liquibase rollback-to-date [date]" to rollback to the given datetime  
Option 3:  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Use "liquibase rollback-count --count=[num]" to rollback num changeSets  
<br>
## Rules for automated changes with jsonCompare.py:
1. Do NOT mix reordering columns with column adds, renames, or drops
2. Do NOT mix dropping columns with column adds, renames, or reordering
3. Do NOT add a column adjacent to a renamed column
4. Do NOT reame a column to or add a column with the old name of a column that has been renamed in this same set of changes
5. Do NOT have the primary key order and the column order in a table differ. 
6. Do NOT create indexes which are the same as the primary key for that table
**Note:** Rules 1 through 4 apply to changes on a single table, while rule 5 applies to the ordering of columnss within a table.

 These rules are designed to keep changest to tables conisting of renames, adds, drops, and reorderings from reaching ambiguous states
- Operations like changing data types or changing primary keys will not conflict and are thus not considered
- Rules 1 and 2 remove a significant amount of ambiguity, and should be unobtrusive given they are rarer operations
- Rule 3 is meant to prevent ambiguous cases such as:
	```
	ABC -> ABDE (A>A, B>B, C>D, +E | A>A, B>B, +D, C>E
	```
- Rule 4 is mainly meant to prevent 2 types of ambiguous cases:

	a) changing to an old column name as in:
	```
	ABC -> XACY ( A>X, B>A, C>C, +Y | +X, A>A, B>C, C>Y) 
	```
	b) adding a new column with the name of an old column:
	```
	ABC -> XYCABZ (+X, +Y, +C, A>A, B>B, C>Z | A>X, B>Y, C>C, +A, +B, +Z)
	```
	Or any mixture of the two, or any case that could be confused with simply reordering columns
- Rule 5 is the result of a limitation with the way Liquibase handles primary keys. The order of composite keys can only differ from the table's column order if the PK is added after the table is created. This creates problems with the current workflow. Furthermore, the changelog generation for the current schema does not indicate what order the columns in a composite PK are, meaning in order to support it additional work would need to be done. 
- Rule 6 is the result of the fact that liquibase ignores index that are redundant to the PK for the table when generating the current changelog, while the wiki changelog generated by the perl scripts will show it. Because of this, jsonCompare.py would interpret this as the index being missing, and will attempt to add it again. When run b liquibase, this command would fail (since the index exists), making the changelog unable to finish running. 

If a change needs to be made that breaks one or more of the above rules, the change can still be made by creating a changelog manually. Once the changelog is created, follow steps 7 and onward ("How to use Liquibase", above) to apply the changes. 
Alternatively, breaking up the desired illegal change into multiple legal changes may be possible. For example, while the change AB --> BX (A>B, B>X) is illegal (rule 4), creating one changeset with AB --> AX and then creating one with AX --> BX is fine. 

## Limitations: 

Currently, the liquibase set up has the following limitations:

- The scripts can only generate changelogs for mariadb databases
- The current setup assumes an existing database with proper grants already performed. This is part of the reason why sql scripts are still generated by parse_ddl.pl