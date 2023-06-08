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
4. Get the database schema from the wiki by running:  
	```
	perl parse_ddl.pl -b [database] -n
	```
	**NOTE:** to include the dropdown tables and data, also run: 
	```
	perl make_dropdowns.pl [database]
	```
5. Navigate up a folder to ```kardia/kardia-db```
6. enerate the differences between the schema in the current database and the wiki by running the following:
	```
	python jsonCompare.py [database]
	```
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
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Use "liquibase rollback [date]" to rollback to the given datetime  
Option 3:  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Use "liquibase rollbackCount [num]" to rollback num changeSets  
<br>
## Rules for automated changes with jsonCompare.py:
1. Do NOT mix reordering columns with adds, renames, or drops
2. Do NOT mix dropping columns with adds, renames, or reordering
3. Do NOT add a column adjacent to a renamed column
4. Do NOT reame a column to or add a column with the old name of a column that has been renamed in this same set of changes
5. Do NOT mix dropping tables with renaming tables or adding tables

**Note:** Rules 1 through 4 apply to changes on a single table, while rule 5 refers to changes to table names.

 These rules are designed to keep changest to tables conisting of renames, adds, drops, adds, and reorderings from reaching ambiguous states
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
- Rule 5 is similar to rule 2; an add and drop will likely be mistaken for a rename