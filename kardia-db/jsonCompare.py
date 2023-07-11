#!/usr/bin/python
import json 		#Used for JSON processing (json.load and json.dump)
from json import JSONEncoder
import os.path		#Used to get relative filenames (os.path.join)
import sys			#Used to get command line inputs (sys.argv)
import datetime		#Used for now() function to name output changeLog file
import os			#Used to rollback changeSets
from Levenshtein import ratio
from math import floor

"""How to use this file:
Use liquibase to generate a full changelog of the database using liquibase
Store database changelog file at ddl-[database]/liquibaseFiles/currentChangeLog.json
Run parse_ddl.pl, which will create wikiChangeLog.json, which should be stored at ddl-[database]/
Run this file with the [database] (mysql or sybase) as a parameter
Once the json file with the differences is generated, include it in the master changeLog file and run "liquibase update"
"""

class ChangeLog:
	#Wrapper class that contains a list of ChangeSets

	'''
	Constructor
	takes a JSON string with the DatabaseChangeLog item on the outside
	Stores changeSets in a list
	'''
	def __init__(self, jsonInputDict = {}):
		self.jsonList = []
		self.changeSetList = []
		self.preconditions = ""
		self.property = ""
		self.include = ""
		if jsonInputDict != {}:
			self.jsonList = jsonInputDict["databaseChangeLog"]
			for item in self.jsonList:
				keyList = list(item.keys())
				if keyList == ["changeSet"]:
					self.changeSetList.append(ChangeSet(item["changeSet"]))
				elif keyList == ["preConditions"]:
					self.preconditions = item["preConditions"]
				elif keyList == ["property"]:
					self.property = item["property"]
				elif keyList == ["include"]:
					self.include = item["include"]
				else:
					raise KeyError("No match found! Keys are: {}".format(item.keys()))

	#Used to create a JSON format that works with Liquibase
	def updateJSON(self):
		self.jsonList = []
		if (self.changeSetList != []):
			for item in self.changeSetList:
				self.jsonList.append({"changeSet" : item})
		if (self.preconditions != ""):
			self.jsonList.append({"preConditions" : self.preconditions})
		if (self.property != ""):
			self.jsonList.append({"property" : self.property})
		if (self.include != ""):
			self.jsonList.append({"include" : self.include})



	def __str__(self):
		return str(self.jsonList)

	def __eq__(self, other):
		self.updateJSON()
		other.updateJSON()
		if not isinstance(other, ChangeLog):
			return False
		if (self.jsonList == other.jsonList):
			return True
		else:
			try:
				assert(self.changeSetList == other.changeSetList)
				assert(set(self.preconditions) == set(other.preconditions))
				assert(set(self.property) == set(other.property))
				assert(set(self.include) == set(other.include))
			except AssertionError:
				return False
		return True

	def getChangeSetList(self):
		return self.changeSetList

	def getPreconditions(self):
		return self.preconditions

	def getProperties(self):
		return self.property

	def getIncludes(self):
		return self.include

	#Have to invoke updateJSON() since a property has been updated, so the JSON needs to be updated as well 
	def setChangeSetList(self, newChangeSetList):
		self.changeSetList = newChangeSetList
		self.updateJSON()

	def setPreconditions(self, newPreconditions):
		self.preconditions = newPreconditions
		self.updateJSON()

	def setProperties(self, newProperties):
		self.property = newProperties
		self.updateJSON()

	def setIncludes(self, newIncludes):
		self.include = newIncludes
		self.updateJSON()
	
	# endable addition of changesets
	def appendChanges(self, other):
		if not isinstance(other, ChangeLog):
			print ("ERROR: attempted to append non-chnagelog object to changelog")
			return
		if other.jsonList != {}:
			for item in other.jsonList:
				keyList = list(item.keys())
				if keyList == ["changeSet"]:
					self.changeSetList.append(ChangeSet(item["changeSet"]))
				elif keyList == ["preConditions"]:
					self.preconditions = item["preConditions"]
				elif keyList == ["property"]:
					self.property = item["property"]
				elif keyList == ["include"]:
					self.include = item["include"]
				else:
					raise KeyError("No match found! Keys are: {}".format(item.keys()))
		self.jsonList.append(other.jsonList)


class ChangeSet:

	def __init__(self, inputDict):
		self.inputDict = inputDict
		self.id = inputDict["id"].lower()
		self.author = inputDict["author"].lower()
		#Sets optional variables even if ChangeSet does not have them
		#If __ is in the inputDict, sets the class varable to that thing, otherwise sets the class variable equal to ""
		self.changes = (inputDict["changes"] if "changes" in inputDict else [])
		self.tag = (inputDict["tagDatabase"]["tag"].lower() if "tagDatabase" in inputDict else "")
		self.dbms = (inputDict["dbms"] if "dbms" in inputDict else "")
		self.runAlways = (inputDict["runAlways"] if "runAlways" in inputDict else "")
		self.runOnChange = (inputDict["runOnChange"] if "runOnChange" in inputDict else "")
		self.context = (inputDict["context"] if "context" in inputDict else "")
		self.runInTransaction = (inputDict["runInTransaction"] if "runInTransaction" in inputDict else "")
		self.failOnError= (inputDict["failOnError"] if "failOnError" in inputDict else "")
		self.rollback = (inputDict["rollback"] if "rollback" in inputDict else "")
		self.normalizeData()

	def normalizeData(self):
		changes = self.changes[0] if len(self.changes) > 0 else ""
		# set data types to lowercase, remove spaces in data types, and change integer to int
		if "createTable" in changes:
			for item in changes["createTable"]["columns"]:
				typeString = item["column"]["type"]
				if (" " in typeString):
					typeArray = typeString.split(" ")
					typeString = ""
					for split in typeArray:
						typeString += split
				# VARCHAR and DECIMAL may not have been make lowercase because of
				if ("(" in typeString):
					typeArray = typeString.split("(")
					typeString = typeArray[0].lower() + "(" + typeArray[1]
				typeString = typeString.lower()
				# Some data types in wikiChangeLog were int, some were integer
				if (typeString == "integer"):
					typeString = "int"
				item["column"]["type"] = typeString
		# Add CreateIndex item to changes so that createIndex == addUniqueConstraint
		if "addUniqueConstraint" in changes:
			columnNameList = changes["addUniqueConstraint"]["columnNames"].split(", ")
			indexName = changes["addUniqueConstraint"]["constraintName"]
			tableName = changes["addUniqueConstraint"]["tableName"]
			del changes["addUniqueConstraint"]
			columns = []
			for item in columnNameList:
				columns.append({"column":{"name":item}})
			changes["createIndex"] = {"tableName": tableName, "indexName": indexName, "columns": columns}




	def __eq__(self, other):
		if not isinstance(other, ChangeSet):
			return False
		if (self.inputDict == other.inputDict):
			return True
		else:
			try:
				#Don't need to check id and author because those will probably change from auto-generating the full ChangeLog
				#Use set(variable) to check if lists are the same, just in scrambled order
				assert(set(self.dbms) == set(other.dbms))
				assert(set(self.runAlways) == set(other.runAlways))
				assert(set(self.runOnChange) == set(other.runOnChange))
				assert(set(self.context) == set(other.context))
				assert(set(self.runInTransaction) == set(other.runInTransaction))
				assert(set(self.failOnError) == set(other.failOnError))
				assert(set(self.rollback) == set(other.rollback))
			except AssertionError:
				return False
			#Tags can be different since they will be auto-generated from parse_ddl.pl
			if (self.changes != other.changes):
				for item in self.changes[0]:
					if item not in other.changes[0]:
						return False
					if self.changes[0][item] != other.changes[0][item]:
						return False
				for item in other.changes[0]:
					if item not in self.changes[0]:
						return False
		return True

	def __str__(self):
		return str(self.inputDict)

	def __bool__(self):
		return True

	def updateJSON(self):
		self.inputDict = {}
		self.inputDict["id"] = self.id
		self.inputDict["author"] = self.author
		if (self.changes != []):
			self.inputDict["changes"] = self.changes
		if (self.tag != ""):
			self.inputDict["tagDatabase"] = {"tag": self.tag}
		if (self.dbms != ""):
			self.inputDict["dbms"] = self.dbms
		if (self.runAlways != ""):
			self.inputDict["runAlways"] = self.runAlways
		if (self.runOnChange != ""):
			self.inputDict["runOnChange"] = self.runOnChange
		if (self.context != ""):
			self.inputDict["context"] = self.context
		if (self.runInTransaction != ""):
			self.inputDict["runInTransaction"] = self.runInTransaction
		if (self.failOnError != ""):
			self.inputDict["failOnError"] = self.failOnError
		if (self.rollback != ""):
			self.inputDict["rollback"] = self.rollback



#Used to encode a ChangeLog or ChangeSet object as a JSON object with proper formatting
class MyEncoder(JSONEncoder):
	def default(self, o):
		if isinstance(o, ChangeLog):
			return {"databaseChangeLog" : o.jsonList}
		elif isinstance(o, ChangeSet):
			return o.inputDict


# remove column PK and set the position for adding a column
def setupAddColumnDiff(column):
	#before adding, take off primary key; have to update primary key separately 
	if "constraints" in column["column"]:
		if "primaryKey" in column["column"]["constraints"]:
			if column["column"]["constraints"]["primaryKey"]:
				#need to not add a primary key while still leaving original marked as such
				temp = column.copy()
				temp["column"] = column["column"].copy()
				temp["column"]["constraints"] = column["column"]["constraints"].copy()
				temp["column"]["constraints"]["primaryKey"] = False
				column = temp
	return column
# given a column, returns the attributes that should be appended to the type
def genAttrString(column):
	# NOTE: this is NOT the same as the lists used in table name change comparisons. It need only contain
	# attributes likley to be erased by various commands
	attrStr = ""
	attributeList = ['autoIncrement', 'defaultValue', 'defaultValueBoolean', 'defaultValueComputed',
			 'defaultValueDate', 'defaultValueNumeric']
	for attr in attributeList:
		if(attr in column["column"]):
			if("defaultValue" in attr): 
				if("char" in column["column"]["type"]): attrStr += " default '"+column["column"][attr]+"'"
				else: attrStr += " default "+str(column["column"][attr])
			elif(attr == "autoIncrement"): 
				attrStr += " AUTO_INCREMENT"
				if("incrementBy" in column["column"]): 
					print("ERROR: cannot add property incrementBy to a mysql table.")
					exit()
				if("startWith" in column["column"]): attrStr += "="+str(column["column"]["incrementBy"])
	return attrStr

# given a collumn, return the constraints that should be appended to the types
def genConstraintString(column):
	attrStr = ""
	if("constraints" in column["column"]):
		cons = column["column"]["constraints"]
		if("nullable" in cons and not cons["nullable"]): attrStr += " NOT NULL"
		# unique constraint is less volatile and thus is not needed. 
	return attrStr

# given a collumn, return a string of all of the constraints and attributes to append to the types
def genAttrConString(column):
	return genAttrString(column)+genConstraintString(column)

# determine which columns were added and which need renamed. Replaces the old add columns functionality 
def addRenameColumnDiff(wiki, current, currToWikiCol):
	resCSList = []
	addColCS = ChangeSet({"id": wiki.id, "author": "jsonCompare.py"})
	addColList = []
	addColFirst = ChangeSet({"id": wiki.id+"-1", "author": "jsonCompare.py"})
	wikiColumns = wiki.changes[0]["createTable"]["columns"]
	currentColumns = current.changes[0]["createTable"]["columns"]
	wikiColumnList = []
	currentColumnList = []
	countCS = 0	# counter to keep changeset id's unique
	MATCH = 1	# state: step past matching columns
	FIND = 2	# state: collect unkown columns 

	for column in wikiColumns:
		wikiColumnList.append(column["column"]["name"])
	for column in currentColumns:
		currentColumnList.append(column["column"]["name"])

	# make sure was not a delete 
	if(len(wikiColumnList) < len(currentColumnList)):
		return []

	i = 0		# Track pos in current
	j = 0		# track pos in wiki
	colBuf = []	# Track unkown columns until can see if added or renamed
	state = MATCH	# keep track of current state

	# find adds and renames, assuming an add and a rename are never adjacent
	while(i < len(currentColumnList) and j < len(wikiColumnList)):
		curCol = currentColumnList[i]
		wikiCol = wikiColumnList[j]
		if(state == MATCH):
			# move past matching pairs
			if(wikiCol == curCol):
				i += 1
				j += 1
				# update the old to new column maping to reflect the match
				currToWikiCol[curCol] = wikiColumns[j-1]
			else:
				# allow the other state to identify next action
				state = FIND
		elif(state == FIND):
			# if the current set matches, all previous were added
			if(wikiCol == curCol):
				if(colBuf): tempInd = wikiColumnList.index(colBuf[0])
				if(tempInd > 0): prev = wikiColumnList[tempInd-1]
				else: prev = ""
				while(colBuf):
					colBuf.pop(0)
					# add to set of columns to add; can do in one changeset at end
					newCol = wikiColumns[tempInd]
					newCol = setupAddColumnDiff(newCol)
					if(prev != ""): newCol["column"]["afterColumn"] = prev
					else: # mariaDB does not allow adding to a position, and liquibase does not support adding to first, so have to move
						addColFirst.changes = [{"sql": {"dbms": "mysql, mariadb", "sql":"ALTER TABLE "
							+wiki.changes[0]["createTable"]["tableName"]+" MODIFY "+newCol["column"]["name"]
							+" "+newCol["column"]["type"]+" first"}}]
						addColFirst.rollback = "empty" # rolling back is just deleteing, so no need for action
						addColFirst.updateJSON()
					tempInd += 1 # all in a row, so are in consecuative positions 
					addColList.append(newCol)
					prev = newCol["column"]["name"]
				state = MATCH
			# if the current macthes a value found later, must have been renames
			elif(wikiCol in currentColumnList):
				# make sure is valid
				if(len(colBuf) > currentColumnList.index(wikiCol) - i):
					print("ERROR: not enough columns in current to rename in table "+wiki.changes[0]["createTable"]["tableName"])
					exit()
				elif(len(colBuf) == 0):
					print("ERROR: Cannot add or rename columns in table "+wiki.changes[0]["createTable"]["tableName"]+"; a reordering or delete must have occured")
					exit()

				while(colBuf):
					renameCol = colBuf.pop(0)
					renameInd = wikiColumnList.index(renameCol)
					dataType = wikiColumns[renameInd]["column"]["type"] # TODO: may need to leave this as the curr so can be updated manually later
					# add in attributes if needed
					dataType += genAttrConString(currentColumns[i])
					tempRenameCS = ChangeSet({"id": wiki.id + "-{}".format(countCS), "author": "jsonCompare.py"})
					tempRenameCS.changes = [{"renameColumn": {"tableName": wiki.changes[0]["createTable"]["tableName"], "oldColumnName": currentColumnList[i],
					      "newColumnName": renameCol, "columnDataType": dataType}}]
					currToWikiCol[currentColumnList[i]] = wikiColumns[wikiColumnList.index(renameCol)] # keep trakc of rename
					tempRenameCS.updateJSON()
					resCSList.append(tempRenameCS)
					countCS += 1
					# if both old and new have a unqiue constraint, need to update it
					currentColumn = currentColumns[i]["column"]
					wikiColumn = wikiColumns[wikiColumnList.index(renameCol)]["column"]
					if("constraints" in currentColumn and "unique" in currentColumn["constraints"] and currentColumn["constraints"]["unique"]
						and "constraints" in wikiColumn and "unique" in wikiColumn["constraints"] and wikiColumn["constraints"]["unique"]):
						tempSet = ChangeSet({"id": wiki.id + "-{}".format(countCS), "author": "jsonCompare.py"})
						tempSet.changes  = [{"dropUniqueConstraint":{"constraintName":currentColumnList[i], "tableName":wiki.changes[0]["createTable"]["tableName"]}}, 
			  				{"addUniqueConstraint":{"columnNames":renameCol, "tableName":wiki.changes[0]["createTable"]["tableName"], "constraintName":renameCol}}]
						tempSet.rollback = [{"dropUniqueConstraint":{"constraintName":renameCol, "tableName":wiki.changes[0]["createTable"]["tableName"]}}, 
			  				{"addUniqueConstraint":{"columnNames":renameCol, "tableName":wiki.changes[0]["createTable"]["tableName"], "constraintName":currentColumnList[i]}}]
						tempSet.updateJSON()
						resCSList.append(tempSet)
						countCS += 1
					i += 1 # step past the newly renamed column
				state = MATCH
			# neither matched nor found in curCols, so add it to the unknown buffer
			else:
				colBuf.append(wikiCol)
				j += 1

	# handle any leftover columns at the end
	# check if any columns still need renamed
	if(i < len(currentColumnList)): 
		if(colBuf):
			if(len(colBuf) > len(currentColumnList) - i):
				print("ERROR: Too few columns to rename at end")
				exit()
			while(colBuf):
				renameCol = colBuf.pop(0)
				curInd = wikiColumnList.index(renameCol)
				dataType = wikiColumns[curInd]["column"]["type"]
				tempRenameCS = ChangeSet({"id": wiki.id + "-{}".format(countCS), "author": "jsonCompare.py"})
				tempRenameCS.changes = [{"renameColumn": {"tableName": wiki.changes[0]["createTable"]["tableName"], "oldColumnName": currentColumnList[i],
				      "newColumnName": renameCol, "columnDataType": dataType}}]
				currToWikiCol[currentColumnList[i]] = wikiColumns[wikiColumnList.index(renameCol)] # keep track of rename
				tempRenameCS.updateJSON()
				resCSList.append(tempRenameCS)
				countCS += 1

				# if both old and new have a unqiue constraint, need to update it
				currentColumn = currentColumns[i]["column"]
				wikiColumn = wikiColumns[wikiColumnList.index(renameCol)]["column"]
				if("constraints" in currentColumn and "unique" in currentColumn["constraints"] and currentColumn["constraints"]["unique"]
					and "constraints" in wikiColumn and "unique" in wikiColumn["constraints"] and wikiColumn["constraints"]["unique"]):
					tempSet = ChangeSet({"id": wiki.id + "-{}".format(countCS), "author": "jsonCompare.py"})
					tempSet.changes  = [{"dropUniqueConstraint":{"constraintName":currentColumnList[i], "tableName":wiki.changes[0]["createTable"]["tableName"]}}, 
			  			{"addUniqueConstraint":{"columnNames":renameCol, "tableName":wiki.changes[0]["createTable"]["tableName"], "constraintName":renameCol}}]
					tempSet.rollback = [{"dropUniqueConstraint":{"constraintName":renameCol, "tableName":wiki.changes[0]["createTable"]["tableName"]}}, 
			  			{"addUniqueConstraint":{"columnNames":renameCol, "tableName":wiki.changes[0]["createTable"]["tableName"], "constraintName":currentColumnList[i]}}]
					tempSet.updateJSON()
					resCSList.append(tempSet)
					countCS += 1
				i += 1 # step past the newly renamed column
		else:
			print("ERROR: wiki seems to have deleted columns=(s)")
			exit()
	# check for any columns that still need added
	elif(j < len(wikiColumnList)):
		if(j > 0): prev = wikiColumnList[j-1]
		else: prev = ""
		# add in the remainder of the values from the wiki
		while(j < len(wikiColumnList)):
			# add to set of columns to add; can do in one changeset at end
			curCol = wikiColumns[j]
			curCol = setupAddColumnDiff(curCol)
			if(prev != ""): curCol["column"]["afterColumn"] = prev
			else: # mariaDB does not allow adding to a position, and liquibase does not support adding to first, so have to move
				addColFirst.changes = [{"sql": {"dbms": "mysql, mariadb", "sql":"ALTER TABLE "
				+wiki.changes[0]["createTable"]["tableName"]+" MODIFY "+curCol["column"]["name"]+" "
					+curCol["column"]["type"]+" first"}}]
				addColFirst.rollback = "empty" # rolling back is just deleteing, so no need for action
				addColFirst.updateJSON()
			addColList.append(curCol)
			prev = curCol["column"]["name"]
			j += 1

	if(colBuf): 
		print("ERROR: Buff is not empty at end of addRenameColumn for table "+wiki.changes[0]["createTable"]["tableName"])
		exit()

	if(len(addColList) > 0):
		addColCS.changes = [{"addColumn": {"tableName": wiki.changes[0]["createTable"]["tableName"], "columns": addColList}}]
		addColCS.updateJSON()
		resCSList.append(addColCS)
		# new columns are not needed in currToWikiCol; ignore
	if(addColFirst.changes != []): resCSList.append(addColFirst)
	return resCSList


# Used to create a changeSet to drop columns from table
# Each column needs to be its own changeSet, so this function returns a list of changeSets
# NOTE: this function only allows columns to be dropped if no other changes have been made to the table
def dropColumnDiff(wiki, current, currToWikiCol):
	resCSList = []
	wikiColumns = wiki.changes[0]["createTable"]["columns"]
	currentColumns = current.changes[0]["createTable"]["columns"]
	resColumns = []
	wikiColumnList = []
	currentColumnList = []
	for column in wikiColumns:
		wikiColumnList.append(column["column"]["name"])
	for column in currentColumns:
		currentColumnList.append(column["column"]["name"])
		if column not in wikiColumns and column["column"]["name"] not in wikiColumnList:
			resColumns.insert(0, column) # load in reverse order to make rollbacks easier
			currToWikiCol[column["column"]["name"]] = None
		else: currToWikiCol[column["column"]["name"]] = wikiColumns[wikiColumnList.index(column["column"]["name"])]

	if(len(currentColumnList) <= len(wikiColumnList)):
		print("ERROR: no columns found to delete")
		exit()
	
	# Must have no new column names, and order must be the same
	wikiTemp = wikiColumnList.copy()
	for columnName in currentColumnList:
		if wikiTemp and columnName == wikiTemp[0]:
			wikiTemp.pop(0)
	if len(wikiTemp) != 0:
		print("Error: Table "+wiki.changes[0]["createTable"]["tableName"]+" dropped and changed columns: cannot determine changeset")
		exit()

	count = 0
	for column in resColumns:
		resChangeSet = ChangeSet({"id": wiki.id + "-{}".format(count), "author": "jsonCompare.py"})
		resChangeSet.changes = [{"dropColumn": {"tableName": wiki.changes[0]["createTable"]["tableName"], "columnName": column["column"]["name"]}}]
		# make rollbacks possible. 
		# Since columns dropped in reverse order, the rollback will go in order; indexes are the same
		rollbackCol = setupAddColumnDiff(column) # don't add as PK. TODO: make sure the PK status is handled elswhere
		curPos = currentColumnList.index(column["column"]["name"])
		if(curPos > 0): rollbackCol["column"]["afterColumn"] = currentColumnList[curPos-1]
		resChangeSet.rollback = [{"addColumn":{"tableName":wiki.changes[0]["createTable"]["tableName"], "columns":[rollbackCol]}}]
		if(curPos == 0): # need to move to the front
			moveColFirst = {"sql": {"dbms": "mysql, mariadb", "sql":"ALTER TABLE "
				+wiki.changes[0]["createTable"]["tableName"]+" MODIFY "+column["column"]["name"]+" "+column["column"]["type"]+" first"}}
			resChangeSet.rollback.append(moveColFirst)
		resChangeSet.updateJSON()
		resCSList.append(resChangeSet)
		count += 1
	return resCSList

# check if the primary key needs to change
def pkColumnDiff(wiki, current):
	dropOldKey = ChangeSet({"id": wiki.id+"-PK0", "author": "jsonCompare.py"})
	addNewKey = ChangeSet({"id": wiki.id+"-PK1", "author": "jsonCompare.py"})
	resCSList = []
	wikiKeyList = []
	currentKeyList = []
	wikiColumns = wiki.changes[0]["createTable"]["columns"]
	currentColumns = current.changes[0]["createTable"]["columns"]

	# get list of current and wiki primary keys

	for column in wikiColumns:
		if "constraints" in column["column"]:
			if "primaryKey" in column["column"]["constraints"]:
				if column["column"]["constraints"]["primaryKey"]:
					wikiKeyList.append(column["column"]["name"])

	for column in currentColumns:
		if "constraints" in column["column"]:
			if "primaryKey" in column["column"]["constraints"]:
				if column["column"]["constraints"]["primaryKey"]:
					currentKeyList.append(column["column"]["name"])

	# see if the primary key needs to change
	isSameKey = True
	if len(wikiKeyList) == len(currentKeyList):
		for i in range(len(wikiKeyList)):
			if wikiKeyList[i] != currentKeyList[i]:
				isSameKey = False
				break
	else:
		isSameKey = False
	if isSameKey:
		return []

	# drop the old PK
	dropOldKey.changes = [{"dropPrimaryKey": {"constraintName": "PRIMARY", "dropIndex":True, "tableName": wiki.changes[0]["createTable"]["tableName"]}}]
	dropOldKey.rollback = [{"addPrimaryKey": {"columnNames":', '.join(currentKeyList), "tableName": wiki.changes[0]["createTable"]["tableName"]}}]
	dropOldKey.updateJSON()
	resCSList.append(dropOldKey)
	# make sure there is a new PK to add
	if(len(wikiKeyList) > 0):
		addNewKey.changes = [{"addPrimaryKey": {"columnNames":', '.join(wikiKeyList), "tableName": wiki.changes[0]["createTable"]["tableName"]}}]
		addNewKey.updateJSON()
		resCSList.append(addNewKey)
	return resCSList

# create a changeset to reorder columns 
# NOTE: columns can be rearranged as much as desired, but reordering must be the only change to the table
def reorderColumnDif(wiki, current, currToWikiCol):
	resCSList = [] 
	wikiColumns = wiki.changes[0]["createTable"]["columns"]
	currentColumns = current.changes[0]["createTable"]["columns"]
	wikiColumnList = []
	currentColumnList = []

	# should have all of the same columns, just out of order
	# should only run if there is work to do; error if requirements not met
	if(len(wikiColumns) != len(currentColumns)):
		print("ERROR: cannot reorder table "+wiki.changes[0]["createTable"]["tableName"]+" if there are any added or removed columns")
		exit()
	for column in wikiColumns:
		wikiColumnList.append(column["column"]["name"])
	isMixed = False
	for ind, column in enumerate(currentColumns):
		currentColumnList.append(column["column"]["name"])
		if(ind >= len(wikiColumnList)): break # stop if sizes are not even
		if(currentColumnList[ind] != wikiColumnList[ind]): isMixed = True
		if(not column["column"]["name"] in wikiColumnList):
			print("ERROR: cannot reorder table "+wiki.changes[0]["createTable"]["tableName"]+" if there are any new or renamed columns")
			exit()
	if (not isMixed): 
		print("ERROR: Nothing to reorder in table "+wiki.changes[0]["createTable"]["tableName"])
		exit()
	
	# make it faster to map column to index
	wikiColInd = {} # the indexes for all of the wiki columns
	for index, column in enumerate(wikiColumnList):
		wikiColInd[column] = index

	# find the optimal number of moves to sort the table 
	# this is based on finding the largest set of rows that can be left alone, and then
	# moving all of the rest.
	
	prevColInd = [-1]*len(currentColumnList)	# keeps track of the previous column for each column in one of the best index lists
	bestInds = [-1]*(len(currentColumnList)+1)	# stores indexes for the last columns in a subset. The length of the subset = index into bestInds
	longest = 0 					# longest nonconsecutive subset have currently found

	for i in range(len(currentColumnList)):
		# find the smallest (first in order) column which the current column is smaller than
		# uses a binary search
		lowest = 1		# lowest index could replace/add
		highest = longest+1	# highest index could replace/add
		while(lowest < highest):
			midpoint = lowest + floor((highest - lowest)/2) # midpoint will be <= lowest
			# compare where midpoint column and current column rank in target (wiki) columns
			curCol = currentColumnList[i]
			midCol = currentColumnList[bestInds[midpoint]]
			if(wikiColInd[midCol] >= wikiColInd[curCol]):
				highest = midpoint
			else: 
				lowest = midpoint+1
		
		newLowest = lowest
		prevColInd[i] = bestInds[newLowest-1]
		bestInds[newLowest] = i # this will either replace a higher end on a exitsting subset, or will create a new, longer subset

		if(newLowest > longest):
			longest = newLowest
	
	# generate the resulting longest sequence
	longestSubset = [""]*longest
	prevInd = bestInds[longest]
	j = longest-1
	while(j >= 0):
		longestSubset[j] = currentColumnNames[prevInd]
		prevInd = prevColInd[prevInd]
		j -= 1

	count=0 	# keep the liquibase command indexes unique
	# generate the changelog
	for ind, wikiCol in enumerate(wikiColumnList): # needs to be done in the same order as we want it to end in
		currToWikiCol[wikiCol] = wikiColumns[ind] # make sure changed order does not disrupt matching old to new. Names are same though
		if(wikiCol not in longestSubset):
			# find which column to place after
			prev = ""
			if(ind == 0):
				# move to first position
				prev = "FIRST"
			else:
				# move after the column that should be before it
				prev = "AFTER "+wikiColumnList[ind-1]
			
			# leave the data type same as the old one
			currentColumn = -1
			for column in currentColumns: 
				if(column["column"]["name"] == wikiCol): currentColumn = column; break
			dataType = currentColumn["column"]["type"] + genAttrConString(currentColumn)

			# perform the move on the out of place column
			tempSet = ChangeSet({"id": wiki.id+"-"+str(count), "author": "jsonCompare.py"})
			tempSet.changes = [{"sql": {"dbms": "mysql, mariadb", "sql":"ALTER TABLE "
				+wiki.changes[0]["createTable"]["tableName"]+" MODIFY "+wikiCol+" "+dataType+" "+prev}}]
			
			# Set up rollback
			currentIndex = currentColumnList.index(wikiCol)
			if(currentIndex == 0): prev = "FIRST"
			else: prev = "AFTER "+currentColumnList[currentIndex -1]
			
			tempSet.rollback = [{"sql": {"dbms": "mysql, mariadb", "sql":"ALTER TABLE "
				+wiki.changes[0]["createTable"]["tableName"]+" MODIFY "+wikiCol+" "+dataType+" "+prev}}]
			
			# now have to take step with currentColumnList so the next rollback can properly undo the step
			currentColumnList.remove(wikiCol)
			if(ind == 0): currentColumnList.insert(0, wikiCol)
			else: currentColumnList.insert(currentColumnList.index(wikiColumnList[ind-1])+1, wikiCol)

			tempSet.updateJSON()
			resCSList.append(tempSet)
			count += 1 
	return resCSList

	
# make changes for any of the various attributes a column might have
def attributeColumnDif(wiki, current, currToWikiCol):
	resCSList = [] 
	currentColumns = current.changes[0]["createTable"]["columns"]
	count = 0
	tableName = wiki.changes[0]["createTable"]["tableName"]
	toDropUnique = []
	toAddUnique = []

	# make a list of all of the attributes that need to be managed
	# NOTE: this is NOT the same as the lists used in table name change comparisons
	attributeList = ['type', 'autoIncrement', 'startWith', 'incrementBy', 'defaultValue', 'defaultValueBoolean', 'defaultValueComputed',
			 'defaultValueDate', 'defaultValueNumeric']
	# NOTE: primary keys are currently handled elsewhere, check constraints are a pro feature (could manual sql if needed), and foreign keys are ignored for now. 
	constraintList = ['nullable'] # just one for now, but others may be needed later
	constraintListKey = {'nullable':False, 'unique':True} # the value needed to indicate the attribute should be added/removed depends on the constraint

	# for each column, check each possible attribute
	count = 0
	for currColumn in currentColumns:
		currName = currColumn["column"]["name"]
		if(currToWikiCol[currName] == None): continue # if not in cur and wiki, skip
		wikiColumn = currToWikiCol[currName]
		columnName = wikiColumn["column"]["name"]

		# see if anything needs updated.
		needsUpdate = False
		for attr in attributeList:
			if(attr in currColumn["column"] and attr in wikiColumn["column"]):
				if(currColumn["column"][attr] != wikiColumn["column"][attr]): 
					needsUpdate = True
					break
			elif(attr in currColumn["column"] or attr in wikiColumn["column"]):
				# ignore if the problem is that a primary key has a non-null default value in current but is null on wiki; MariaDB forces keys to not allow null values
				# 	This will look like the current needs to drop it's default value, when that actually isn't possible. 
				if("defaultValue" in attr and attr in currColumn["column"] and "constraints" in wikiColumn["column"] and 
					"primaryKey" in wikiColumn["column"]["constraints"] and wikiColumn["column"]["constraints"]["primaryKey"]): continue
				needsUpdate = True
				break
		# If an update is needed, must apply update with all attributes (otherwise, they get overwritten)
		if(needsUpdate):
			tempSet = ChangeSet({"id": wiki.id+"-at-"+str(count), "author": "jsonCompare.py"})
			# leave the constraints as are in current. Next step handles update for cosntraints 
			tempSet.changes  = [{"sql":{"dbms":"mysql, mariadb", "sql":"ALTER TABLE "+tableName+" CHANGE COLUMN "+columnName+" "+columnName+" "+wikiColumn["column"]["type"] + genAttrString(wikiColumn) + genConstraintString(currColumn)}}]
			tempSet.rollback = [{"sql":{"dbms":"mysql, mariadb", "sql":"ALTER TABLE "+tableName+" CHANGE COLUMN "+columnName+" "+columnName+" "+currColumn["column"]["type"] + genAttrString(currColumn) + genConstraintString(currColumn)}}]
			tempSet.updateJSON()
			resCSList.append(tempSet)
			count += 1


		# now check for constraint updates. Handle seperately just to keep 
		needsUpdate = False
		if("constraints" in currColumn["column"] and "constraints" in wikiColumn["column"]):
			currCons = currColumn["column"]["constraints"]
			wikiCons = wikiColumn["column"]["constraints"]
			for con in constraintList:
				# exception: don't try to remove the not null constraint if it is a PK; mysql forces PK's to have the NOT NULL attr.
				if(con in currCons and con in wikiCons):
					if(currCons[con] != wikiCons[con] and not(con == "nullable" and not wikiCons[con] and "primaryKey" in wikiCons and wikiCons["primaryKey"])): 
						needsUpdate = True; break
				elif(con in currCons and currCons[con] == constraintListKey[con] and not(con == "nullable" and "primaryKey" in wikiCons and wikiCons["primaryKey"])): 
					needsUpdate = True; break
				elif(con in wikiCons and wikiCons[con] == constraintListKey[con]): 
					needsUpdate = True; break
		elif("constraints" in currColumn["column"]):
			for con in constraintList:
				if(con in currColumn["column"]["constraints"]): needsUpdate = True; break
		elif("constraints" in wikiColumn):
			for con in constraintList:
				if(con in wikiColumn["column"]["constraints"]): needsUpdate = True; break

		if(needsUpdate):
			tempSet = ChangeSet({"id": wiki.id+"-at-"+str(count), "author": "jsonCompare.py"})
			# Make sure to keep the attributes matching the wiki. Constraints rollback to current
			tempSet.changes  = [{"sql":{"dbms":"mysql, mariadb", "sql":"ALTER TABLE "+tableName+" CHANGE COLUMN "+columnName+" "+columnName+" "+wikiColumn["column"]["type"] + genAttrConString(wikiColumn)}}]
			tempSet.rollback = [{"sql":{"dbms":"mysql, mariadb", "sql":"ALTER TABLE "+tableName+" CHANGE COLUMN "+columnName+" "+columnName+" "+currColumn["column"]["type"] + genAttrString(wikiColumn) + genConstraintString(currColumn)}}]
			tempSet.updateJSON()
			resCSList.append(tempSet)
			count += 1
		
		# unique works differently and must be handled by itself
		if("constraints" in currColumn["column"] and "constraints" in wikiColumn["column"]):
			currCons = currColumn["column"]["constraints"]
			wikiCons = wikiColumn["column"]["constraints"]
			if("unique" in currCons and "unique" in wikiCons):
				if(currCons["unique"] and not wikiCons["unique"]): 
					toDropUnique.append(currColumn["column"]["name"])
				elif(not currCons["unique"] and wikiCons["unique"]):
					toAddUnique.append(wikiColumn["column"]["name"])
			elif("unique" in currCons and currCons["unique"]): 
				toDropUnique.append(currColumn["column"]["name"])
			elif("unique" in wikiCons and wikiCons["unique"]): 
				toAddUnique.append(wikiColumn["column"]["name"])
		elif("constraints" in currColumn["column"]):
			if("unique" in currColumn["column"]["constraints"] and currColumn["column"]["constraints"]["unique"]):
				toDropUnique.append(currColumn["column"]["name"])
		elif("constraints" in wikiColumn["column"]):
			if("unique" in wikiColumn["column"]["constraints"] and wikiColumn["column"]["constraints"]["unique"]): 
				toAddUnique.append(wikiColumn["column"]["name"])
	
	# now add and drop unique constraints based on lists
	for colName in toAddUnique:
		tempSet = ChangeSet({"id": wiki.id+"-at-"+str(count), "author": "jsonCompare.py"})
		tempSet.changes = [{"addUniqueConstraint":{"columnNames":colName, "tableName":tableName, "constraintName":colName}}]
		tempSet.updateJSON()
		resCSList.append(tempSet)
		count += 1
	# NOTE: MariaDB default name for unqique constraints appears to just be the column name
	for colName in toDropUnique:
		tempSet = ChangeSet({"id": wiki.id+"-at-"+str(count), "author": "jsonCompare.py"})
		tempSet.changes  = [{"dropUniqueConstraint":{"constraintName":colName, "tableName":tableName}}]
		# note that the column may have been renamed, so the new column name must be the wiki name. Index name is still cur name
		tempSet.rollback =[{"addUniqueConstraint":{"columnNames":currToWikiCol[colName]["column"]["name"], "tableName":tableName, "constraintName":colName}}]
		tempSet.updateJSON()
		resCSList.append(tempSet)
		count += 1

	return resCSList


# Drop and re-add indexes if columns are different between wiki and current
def addIndexDiff(wiki, current):
	resCSList = []
	wikiColumns = wiki.changes[0]["createIndex"]["columns"]
	currentColumns = current.changes[0]["createIndex"]["columns"]
	for column in wikiColumns:
		if column not in currentColumns:
			# drop and re-add all columns if there is at least one different column
			dropChangeSet = ChangeSet({"id": wiki.id + "-1", "author": "jsonCompare.py"})
			dropChangeSet.changes = [{"dropIndex": {"indexName": wiki.changes[0]["createIndex"]["indexName"], "tableName": wiki.changes[0]["createIndex"]["tableName"]}}]
			dropChangeSet.rollback = [{"createIndex": {"indexName": wiki.changes[0]["createIndex"]["indexName"], "tableName": wiki.changes[0]["createIndex"]["tableName"], "columns": currentColumns}}]
			dropChangeSet.updateJSON()
			resCSList.append(dropChangeSet)
			addChangeSet = ChangeSet({"id": wiki.id + "-2", "author": "jsonCompare.py"})
			addChangeSet.changes = [{"createIndex": {"indexName": wiki.changes[0]["createIndex"]["indexName"], "tableName": wiki.changes[0]["createIndex"]["tableName"], "columns": wikiColumns}}]
			addChangeSet.updateJSON()
			resCSList.append(addChangeSet)
			break
	if len(resCSList) == 0:
		return []
	return resCSList


# make a table into a consistent string suitable for levenshtein and similar alrgorithms
def tableToString(table):
	# order of the attributes must be enforced for lev to work properly
	attributeList = ['name', 'type', 'value', 'autoIncrement', 'defaultValue', 'computed', 'defaultValueBoolean', 'defaultValueComputed',
			'defaultValueConstraintName', 'defaultValueDate', 'defaultValueNumeric', 'descending', 'incrementBy', 'position', 
			'remarks', 'startWith', 'valueBlobFile', 'valueBoolean', 'valueClobFile', 'valueComputed', 
			'valueDate', 'valueNumeric']
	constraintList = ['checkConstraint', 'deleteCascade', 'deferrable', 'foreignKeyName', 'initiallyDeferred', 
			'notNullConstraintName', 'nullable', 'primaryKey', 'primaryKeyName', 'primaryKeyTablespace', 
			'unique', 'uniqueConstraintName', 'references', 'referencedColumnNames', 
			'referencedTableCatalogName', 'referencedTableName', 'referencedTableSchemaName', 
			'validateForeignKey', 'validateNullable', 'validatePrimaryKey', 'validateUnique']
	tableStr = table[0]["createTable"]["tableName"]

	# concatinate all of the attributes
	for column in table[0]["createTable"]["columns"]:
		column = column["column"]					
		for attribute in attributeList:
			if attribute in column: 
				tableStr += " "+attribute+":"+str(column[attribute])
		if "constraints" in column:
			for constraint in constraintList:
				if constraint in column["constraints"]:
					tableStr += " "+constraint+":"+str(column["constraints"][constraint])
		tableStr+="|"

	return tableStr


# Find which tables have most likley been renamed, added, or deleted. 
# NOTE: Tables cannot be dropped at the same time as an add or rename
def renameTableDiff(wikiCS, currentCS, oldToNewTableName):
	resCSList = []
	wikiTableList = []
	wikiTableNames = []
	currentTableList = []
	currentTableNames = []

	for changeSet in wikiCS:
		if("createTable" in changeSet.changes[0]):
			wikiTableList.append(changeSet.changes)
			wikiTableNames.append(changeSet.changes[0]["createTable"]["tableName"])

	for changeSet in currentCS:
		if("createTable" in changeSet.changes[0]):
			currentTableList.append(changeSet.changes)
			currentTableNames.append(changeSet.changes[0]["createTable"]["tableName"])
			
	# look for dropped tables
	if(len(currentTableNames) > len(wikiTableNames)):
		# make sure was only a delete
		for table in wikiTableNames:
			if not table in currentTableNames:
				print("ERROR: Table "+table+" was added at the same time as some deletes. Cannot mix table drops and renames/adds")
				exit()
		# make the drop table changeset
		count = 0 # keep ids unique
		for table in currentTableNames:
			if not table in wikiTableNames:
				resChangeSet = ChangeSet({"id": wikiCS[0].id + "-{}".format(count), "author": "jsonCompare.py"})
				resChangeSet.changes = [{"dropTable": {"tableName":table}}]
				resChangeSet.rollback = currentTableList[currentTableNames.index(table)]
				resChangeSet.updateJSON()
				resCSList.append(resChangeSet)
				count += 1

	# look for added and renamed tables
	else:
		# remove all of the tables that are the same
		i = 0
		while(i < len(currentTableNames)):
			j = 0
			while(j < len(wikiTableNames)):
				if(currentTableNames[i] == wikiTableNames[j]):
					# remove from all lists
					currentTableNames.pop(i)
					currentTableList.pop(i)
					wikiTableNames.pop(j)
					wikiTableList.pop(j)
					i -= 1
					j -= 1
					break
				j += 1
			i += 1
		
		# now compare what's left and find the most likely pairs 
		# keep track of all of the best matches for each still in current
		bestMatch = []
		levResults = []
		count = 0  # keep ids unique

		for i, curTable in enumerate(currentTableNames):
			best = -1
			bestInd = -1
			fullCur = tableToString(currentTableList[i])
			tempResults = []
			tempResults.append(curTable)
			for j, wikiTable in enumerate(wikiTableNames):
				fullWiki = tableToString(wikiTableList[j])
				rat = ratio(fullWiki, fullCur)
				tempResults.append(rat)
				if(best < rat):
					best = rat
					bestInd = j
			levResults.append(tempResults)
			if(bestInd not in bestMatch):
				bestMatch.append(bestInd)
			else: 
				print("Error: cannot rename tables; comparisons are too ambiguous")
				print("	Problem was caused by "+curTable+" and "+(currentTableNames[bestMatch.index(bestInd)])+" over "+wikiTableNames[bestInd])
				exit()

		for i, j in enumerate(bestMatch):
			resChangeSet = ChangeSet({"id": wikiCS[0].id + "-{}".format(count), "author": "jsonCompare.py"})
			resChangeSet.changes = [{"renameTable": {"oldTableName":currentTableNames[i], "newTableName": wikiTableNames[j]}}]
			resChangeSet.updateJSON()
			resCSList.append(resChangeSet)
			count += 1
			oldToNewTableName[currentTableNames[i]] = wikiTableNames[j]

	
		for j in range(len(wikiTableNames)):
			if( j not in bestMatch): 
				resChangeSet = ChangeSet({"id": wikiCS[0].id + "-{}".format(count), "author": "jsonCompare.py"})
				resChangeSet.changes = wikiTableList[j]
				resChangeSet.updateJSON()
				resCSList.append(resChangeSet)
				count += 1
	return resCSList

if __name__ == "__main__":

	if (len(sys.argv) < 2):
		print("Not enough parameters!")
		print("Usage: jsonCompare.py [database] [database change log] [wiki change log] [dropdwon change log] [output] [table drop output]")
		print("Change logs are optional parameters. Default parameters are:")
		print("database change log: ./ddl-[database]/liquibaseFiles/currentChangeLog.json")
		print("wiki change log: ./ddl-[database]/wikiChangeLog.json")
		print("dropdown change log: ./ddl-[database]/dropdownChangeLog.json")
		print("output: ./ddl-[database]/liquibaseFiles/(datetime)ChangeLog.json")
		print("table drop output: ./ddl-[database]/liquibaseFiles/DROP_TABLE.(datetime)ChangeLog.json")
		raise SystemExit(0)
	elif (len(sys.argv) == 2):
		# os.path.dirname(os.path.realpath(__file__) gets the pathname of the current file
		currentPath = os.path.join(os.path.dirname(os.path.realpath(__file__)), "ddl-{}".format(sys.argv[1]), "liquibaseFiles", "currentChangeLog.json")
		wikiPath = os.path.join(os.path.dirname(os.path.realpath(__file__)), "ddl-{}".format(sys.argv[1]), "wikiChangeLog.json")
		dropdownPath = os.path.join(os.path.dirname(os.path.realpath(__file__)), "ddl-{}".format(sys.argv[1]), "dropdownChangeLog.json")
	elif (len(sys.argv) == 3):
		# os.path.dirname(os.path.realpath(__file__) gets the pathname of the current file
		currentPath = os.path.join(os.path.dirname(os.path.realpath(__file__)), sys.argv[2])
		wikiPath = os.path.join(os.path.dirname(os.path.realpath(__file__)), "ddl-{}".format(sys.argv[1]), "wikiChangeLog.json")
		dropdownPath = os.path.join(os.path.dirname(os.path.realpath(__file__)), "ddl-{}".format(sys.argv[1]), "dropdownChangeLog.json")
	elif (len(sys.argv) == 4):
		currentPath = os.path.join(os.path.dirname(os.path.realpath(__file__)), sys.argv[2])
		dropdownPath = os.path.join(os.path.dirname(os.path.realpath(__file__)), sys.argv[3])
		wikiPath = os.path.join(os.path.dirname(os.path.realpath(__file__)), "ddl-{}".format(sys.argv[1]), "dropdownChangeLog.json")
	elif ( 5 <= len(sys.argv) <= 7): # handle output later
		currentPath = os.path.join(os.path.dirname(os.path.realpath(__file__)), sys.argv[2])
		dropdownPath = os.path.join(os.path.dirname(os.path.realpath(__file__)), sys.argv[3])
		wikiPath = os.path.join(os.path.dirname(os.path.realpath(__file__)), sys.argv[4])
	else:
		print("Too many parameters!")
		print("Usage: jsonCompare.py [database] [database change log] [wiki change log] [dropdwon change log] [output] [table drop output]")
		print("Change logs are optional parameters. Default parameters are:")
		print("database change log: ./ddl-[database]/liquibaseFiles/currentChangeLog.json")
		print("wiki change log: ./ddl-[database]/wikiChangeLog.json")
		print("dropdown change log: ./ddl-[database]/dropdownChangeLog.json")
		print("output: ./ddl-[database]/liquibaseFiles/(datetime)ChangeLog.json")
		print("table drop output: ./ddl-[database]/liquibaseFiles/DROP_TABLE.(datetime)ChangeLog.json")
		raise SystemExit(0)
	with open(currentPath, "r") as file:
		currentChangeLogFile = json.load(file) #Data is a dict of a list of changeSet dictionaries
	with open(wikiPath, "r") as file:
		wikiChangeLogFile = json.load(file)

	currentChangeLog = ChangeLog(currentChangeLogFile)
	wikiChangeLog = ChangeLog(wikiChangeLogFile)

	# add dropdown to the existing changeset
	if(dropdownPath != ""):
		with open(dropdownPath, "r") as file:
			try:
				dropdownFile = json.load(file)
				dropdownLog = ChangeLog(dropdownFile)
				wikiChangeLog.appendChanges(dropdownLog)
			except:
				print("Drop down file did not contain any json. Skipping it")

	diffChangeLog = ChangeLog()
	diffChangeSetList = []
	if (currentChangeLog == wikiChangeLog):
		pass
	else:
		# Make sure other properties of changeLog are the same
		if (currentChangeLog.getPreconditions() != wikiChangeLog.getPreconditions()):
			diffChangeLog.setPreconditions(wikiChangeLog.getPreconditions())
		if (currentChangeLog.getProperties() != wikiChangeLog.getProperties()):
			diffChangeLog.setProperties(wikiChangeLog.getProperties())
		if (currentChangeLog.getIncludes() != wikiChangeLog.getIncludes()):
			diffChangeLog.setIncludes(wikiChangeLog.getIncludes())
		# iterate through changeSets and accumulate differences
		currentChangeSets = currentChangeLog.getChangeSetList()
		wikiChangeSets = wikiChangeLog.getChangeSetList()

		wikiTableList = []
		wikiIndexList = []
		currentTableList = []
		currentIndexList = []
		oldToNewTableName = {}

		for wikiCS in wikiChangeSets:
			if "createTable" in wikiCS.changes[0]:
				wikiTableList.append(wikiCS.changes[0]["createTable"]["tableName"])
			elif "createIndex" in wikiCS.changes[0]:
				wikiIndexList.append(wikiCS.changes[0]["createIndex"]["indexName"])
		for currentCS in currentChangeSets:
			if "createTable" in currentCS.changes[0]:
				currentTableList.append(currentCS.changes[0]["createTable"]["tableName"])
			elif "createIndex" in currentCS.changes[0]:
				currentIndexList.append(currentCS.changes[0]["createIndex"]["indexName"])

		tableEdit = renameTableDiff(wikiChangeSets, currentChangeSets, oldToNewTableName)
		if(tableEdit != []): 
			# If was a drop table, is only table drops. Put in a seperate file to avoid accidental data loss
			if("dropTable" in tableEdit[0].changes[0]):
				# set up a seperate file for deletes
				deleteChangeLog = ChangeLog()
				deleteChangeLog.setChangeSetList(tableEdit)

				print("Creating seperate file for table drops. Confirm you wish to drop these tables before adding")
				deleteChangeLog.updateJSON()
				diffJSON = json.dumps(deleteChangeLog, cls=MyEncoder, indent=4)
				if (len(sys.argv) != 7):
					currentDateTime = datetime.datetime.now()
					outputFileName = "DROP_TABLE." + str(currentDateTime)[0:10] + "." + str(currentDateTime.hour) + "." + str(currentDateTime.minute) + "." + str(currentDateTime.second) + "ChangeLog.json"	
					writePath = os.path.join(os.path.dirname(os.path.realpath(__file__)), "ddl-{}".format(sys.argv[1]), "liquibaseFiles", outputFileName)
				else:
					writePath = os.path.join(os.path.dirname(os.path.realpath(__file__)), sys.argv[6])
				f = open(writePath, "w")
				f.write(diffJSON)
				f.close()
				print("See %s for the table drop commands" % writePath)
				print("checking to make sure formatting is correct...")
				with open(writePath, "r") as file:
					testChangeLogFile = json.load(file)
				testChangeLog = ChangeLog(testChangeLogFile)
			# if no drops, safe to add renames to the general changelog
			else:
				for tEdit in tableEdit:
					diffChangeSetList.append(tEdit)
				
		for wikiCS in wikiChangeSets:
			# New/Renamed tables are handled above; just consider indexes
			# If the changeSet is a new index, add it to the difference and go to next changeSet
			if "createIndex" in wikiCS.changes[0]:
				if wikiCS.changes[0]["createIndex"]["indexName"] not in currentIndexList:
					diffChangeSetList.append(wikiCS)
					continue
			for currentCS in currentChangeSets:
				if wikiCS == currentCS:
					break
				# If the changeSet is a table
				if "createTable" in wikiCS.changes[0] and "createTable" in currentCS.changes[0]:
					# if the tables are equal
					wikiTable = wikiCS.changes[0]["createTable"]["tableName"]
					currentTable = currentCS.changes[0]["createTable"]["tableName"]
					if wikiTable == currentTable or (currentTable in oldToNewTableName and oldToNewTableName[currentTable] == wikiTable):
						# add changeSet to list with appropriate drop columns
						# only allow to drop, reorder, OR add/remove
						temp = []

						currToWikiCol = {}
						wikiColumnNames = [col["column"]["name"] for col in wikiCS.changes[0]["createTable"]["columns"]]
						currentColumnNames = [col["column"]["name"] for col in currentCS.changes[0]["createTable"]["columns"]]
						# determine if drops, adds/renames, or reordering occured. 
						if(len(wikiColumnNames) < len(currentColumnNames)):
							# must have been a dropped column
							temp = dropColumnDiff(wikiCS, currentCS, currToWikiCol)
						elif(len(set(wikiColumnNames).difference(set(currentColumnNames))) > 0 ):
							# there is a column in the wiki table not found in the current table. Must be add or rename
							temp = addRenameColumnDiff(wikiCS, currentCS, currToWikiCol)
						elif(set(wikiColumnNames) == set(currentColumnNames) and wikiColumnNames != currentColumnNames):
							# same columns, different order. 
							temp = reorderColumnDif(wikiCS, currentCS, currToWikiCol)
						else: # maping of columns stays the same. Set currToWikiCol accordingly
							for i in range(len(wikiCS.changes[0]["createTable"]["columns"])):
								currToWikiCol[currentCS.changes[0]["createTable"]["columns"][i]["column"]["name"]] = wikiCS.changes[0]["createTable"]["columns"][i]

						if temp != []:
							for changes in temp:
								diffChangeSetList.append(changes)
													
						# Column changes do not interfere, so can alway check 
						temp = pkColumnDiff(wikiCS, currentCS)
						if temp != []:
							for keyChangeSet in temp:
								diffChangeSetList.append(keyChangeSet)

						# add attribute changes
						temp = attributeColumnDif(wikiCS, currentCS, currToWikiCol)
						if temp != []:
							for attrChangeSet in temp:
								diffChangeSetList.append(attrChangeSet)

				# If the changeSet is an index
				elif "createIndex" in wikiCS.changes[0] and "createIndex" in currentCS.changes[0]:
					# if we're looking at the same index and same table
					if (wikiCS.changes[0]["createIndex"]["tableName"] == currentCS.changes[0]["createIndex"]["tableName"]) and (wikiCS.changes[0]["createIndex"]["indexName"] == currentCS.changes[0]["createIndex"]["indexName"]):
						# add changeSets to drop and re-add indexes if a column is different between wiki and current
						temp = addIndexDiff(wikiCS, currentCS)
						if temp != []:
							diffChangeSetList.append(temp[0])
							diffChangeSetList.append(temp[1])

		for changeSet in currentChangeSets:
			# NOTE: No longer concerned about tables only existant in current changeset; they would be renamed or dropped
			if "createIndex" in changeSet.changes[0]:
				if changeSet.changes[0]["createIndex"]["indexName"] not in wikiIndexList:
					# drop the changeset. May have been a name change or actually removed. Either way, no longer needed
					# make sure the table name is correct
					tableName = changeSet.changes[0]["createIndex"]["tableName"]
					if(tableName in oldToNewTableName): tableName = oldToNewTableName[tableName]

					dropChangeSet = ChangeSet({"id": changeSet.id, "author": "jsonCompare.py"})
					dropChangeSet.changes = [{"dropIndex": {"indexName": changeSet.changes[0]["createIndex"]["indexName"], "tableName": tableName}}]
					dropChangeSet.rollback = [{"createIndex": {"indexName": changeSet.changes[0]["createIndex"]["indexName"], "tableName": changeSet.changes[0]["createIndex"]["tableName"], "columns": changeSet.changes[0]["createIndex"]["columns"]}}]
					dropChangeSet.updateJSON()
					diffChangeSetList.append(dropChangeSet)
		diffChangeLog.setChangeSetList(diffChangeSetList)


	if not (diffChangeLog == ChangeLog()):
		print("Creating file with differences...")
		diffChangeLog.updateJSON()
		diffJSON = json.dumps(diffChangeLog, cls=MyEncoder, indent=4)
		if (len(sys.argv) != 6):
			currentDateTime = datetime.datetime.now()
			outputFileName = str(currentDateTime)[0:10] + "." + str(currentDateTime.hour) + "." + str(currentDateTime.minute) + "." + str(currentDateTime.second) + "ChangeLog.json"	
			writePath = os.path.join(os.path.dirname(os.path.realpath(__file__)), "ddl-{}".format(sys.argv[1]), "liquibaseFiles", outputFileName)
		else:
			writePath = os.path.join(os.path.dirname(os.path.realpath(__file__)), sys.argv[5])
		f = open(writePath, "w")
		f.write(diffJSON)
		f.close()
		print("See %s for differences" % writePath)
		print("checking to make sure formatting is correct...")
		with open(writePath, "r") as file:
			testChangeLogFile = json.load(file)
		testChangeLog = ChangeLog(testChangeLogFile)
	else:
		print("ChangeLogs are equal")
	print("finished with no errors")