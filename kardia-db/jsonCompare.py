#!/usr/bin/python
import json 		#Used for JSON processing (json.load and json.dump)
from json import JSONEncoder
import os.path		#Used to get relative filenames (os.path.join)
import sys			#Used to get command line inputs (sys.argv)
import datetime		#Used for now() function to name output changeLog file
import os			#Used to rollback changeSets

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


# Used to create a changeSet to add columns to table
def addColumnDiff(wiki, current):
	resChangeSet = ChangeSet({"id": wiki.id, "author": "jsonCompare.py"})
	wikiColumns = wiki.changes[0]["createTable"]["columns"]
	currentColumns = current.changes[0]["createTable"]["columns"]
	resColumns = []
	currentColumnList = []
	for column in currentColumns:
		currentColumnList.append(column["column"]["name"])

	for ind, column in enumerate(wikiColumns):
		if column not in currentColumns and column["column"]["name"] not in currentColumnList:
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
			# find out what position to add column in
			column["column"]["position"] = ind
			
			resColumns.append(column)
	if len(resColumns) == 0:
		return False
	resChangeSet.changes = [{"addColumn": {"tableName": wiki.changes[0]["createTable"]["tableName"], "columns": resColumns}}]
	resChangeSet.updateJSON()
	return resChangeSet



# Used to create a changeSet to drop columns from table
# Each column needs to be its own changeSet, so this function returns a list of changeSets
# NOTE: this function only allows columns to be dropped if no other changes have been made to the table
def dropColumnDiff(wiki, current):
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
			resColumns.append(column)

	if(len(currentColumnList) <= len(wikiColumnList)):
		return [] # any possible changes must be renames, adds, or reorders
	
	# Must have no new column names, and order must be the same
	wikiTemp = wikiColumnList.copy()
	for columnName in currentColumnList:
		if columnName == wikiTemp[0]:
			wikiTemp.pop(0)
	if len(wikiTemp) != 0:
		print("Error: Table "+wiki.changes[0]["CreateTable"]["TableName"]+" dropped and changed columns: cannot determine changeset")
		print("PS: [] == None: "+([] == None))
		return None

	count = 0
	for column in resColumns:
		resChangeSet = ChangeSet({"id": wiki.id + "-{}".format(count), "author": "jsonCompare.py"})
		resChangeSet.changes = [{"dropColumn": {"tableName": wiki.changes[0]["createTable"]["tableName"], "columnName": column["column"]["name"]}}]
		# resChangeSet.changes.append({"dropColumn": {"tableName": wiki.changes[0]["createTable"]["tableName"], "columnName": column}})
		resChangeSet.updateJSON()
		resCSList.append(resChangeSet)
		count += 1
	return resCSList

def modifyColumnDiff(wiki, current):
	resCSList = []
	wikiColumns = wiki.changes[0]["createTable"]["columns"]
	currentColumns = current.changes[0]["createTable"]["columns"]
	resColumns = []
	resColumnList = []
	# Gather names of all columns in wiki and current
	wikiColumnList = []
	currentColumnList = []
	for column in wikiColumns:
		wikiColumnList.append(column["column"]["name"])
	for column in currentColumns:
		currentColumnList.append(column["column"]["name"])

	for column in wikiColumns:
		if column not in currentColumns and column["column"]["name"] in currentColumnList:
			resColumns.append(column)
			resColumnList.append(column["column"]["name"])
	for column in currentColumns:
		if column not in wikiColumns and column["column"]["name"] in wikiColumnList and column["column"]["name"] not in resColumnList:
			print("Column in current, but not in wiki. Cannot change data type of column:", column)

	if len(resCSList) == 0:
		return []

	count = 0
	for column in resColumns:
		resChangeSet = ChangeSet({"id": wiki.id + "-{}".format(count), "author": "jsonCompare.py"})
		resChangeSet.changes = [{"modifyDataType": {"columnName": column["column"]["name"], "newDataType": column["column"]["type"], "tableName": wiki.changes[0]["createTable"]["tableName"]}}]
		resChangeSet.updateJSON()
		resCSList.append(resChangeSet)
		count += 1

	return resCSList

# check if the primary key needs to change
def pkColumnDiff(wiki, current):
	resCSList = [ChangeSet({"id": wiki.id+"-PK0", "author": "jsonCompare.py"}), ChangeSet({"id": wiki.id+"-PK1", "author": "jsonCompare.py"})] 
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

	resCSList[0].changes = [{"dropPrimaryKey": {"constraintName": "PRIMARY", "dropIndex":True, "tableName": current.changes[0]["createTable"]["tableName"]}}]
	resCSList[0].updateJSON()
	resCSList[1].changes = [{"addPrimaryKey": {"columnNames":', '.join(wikiKeyList), "tableName": current.changes[0]["createTable"]["tableName"]}}]
	resCSList[1].updateJSON()
	return resCSList

# create a changeset to reorder columns 
# NOTE: columns can be rearranged as much as desired, but reordering must be the only change to the table
def reorderColumnDif(wiki, current):
	resCSList = [] 
	wikiColumns = wiki.changes[0]["createTable"]["columns"]
	currentColumns = current.changes[0]["createTable"]["columns"]
	wikiColumnList = []
	currentColumnList = []

	# should have all of the same columns, just out of order
	for column in wikiColumns:
		wikiColumnList.append(column["column"]["name"])
	isMixed = False
	for ind, column in enumerate(currentColumns):
		currentColumnList.append(column["column"]["name"])
		if(currentColumnList[ind] != wikiColumnList[ind]): isMixed = True
		if(not column["column"]["name"] in wikiColumnList):
			return [] # cannot reorder if there are any new or renamed columns
	if (not isMixed): 
		return [] # no need to reorder; already in order
	if(len(currentColumnList) != len(wikiColumnList)):
		return [] # cannot reorder if clumns missing or added
	
	# make it faster to map column to index
	wikiColInd = {} # the indexes for all of the wiki columns
	for index, column in enumerate(wikiColumnList):
		wikiColInd[column] = index

	# find the optimal number of moves to sort the table 
	# this is based on finding the largest set of rows that can be left alone, and then
	# moving all of the rest.
	maxSize = -1	# keep track of the largest consecutive run 
	maxInd = -1 	# the index of the column used to find the run
	maxRun = []	# all of the columns in the run
	for i in range(len(currentColumnList)):
		curRun = []
		curSize = 0
		iColumn = currentColumnList[i]
		compCol = currentColumnList[i] # use this to keep track of run.
		startIndex = i
		# find first char before it that could be in the run (uses self if none)
		for j in range(i):
			if(wikiColInd[currentColumnList[i]] > wikiColInd[currentColumnList[j]]):
				compCol = currentColumnList[j]
				startIndex = j
		j = startIndex
		# loop through from startIndex until the end, looking for columns that fit run
		while (j < len(currentColumnList)):
			jColumn = currentColumnList[j]
			# make sure fits in run
			if(wikiColInd[compCol] <= wikiColInd[jColumn]):
				# make sure works with the current row as well 
				if((i < j and wikiColInd[iColumn] < wikiColInd[jColumn])
				or (i > j and wikiColInd[iColumn] > wikiColInd[jColumn])
				or (i == j)):
					curSize += 1
					compCol = jColumn
					curRun.append(jColumn)
			j += 1
		# update best
		if(curSize > maxSize):
			maxSize = curSize
			maxRun = curRun

	print(curRun)	# DELETEME
	total = 0 	# DELETEME
	count=0 	# keep the indexes unique
	# generate the changelog
	# NOTE: currently also sorting the columns to be sure the instructions work
	for ind, curCol in enumerate(wikiColumnList): # needs to be done in the same order as we want it to end in
		curCol = wikiColumnList[ind]
		if(curCol not in maxRun):
			toMove = currentColumnList.pop(currentColumnList.index(curCol))
			# find which column to place after
			prev = ""
			if(ind == 0):
				# move to first position
				prev = "FIRST"
				currentColumnList.insert(0, toMove) #delete?
			else:
				# move after the column that should be before it
				prev = "AFTER "+wikiColumnList[ind-1]
				currentColumnList.insert(currentColumnList.index(wikiColumnList[ind - 1])+1, toMove)
			total += 1
			# find data type
			dataType = wikiColumns[ind]["column"]["type"]

			# perform the move on the out of place column
			tempSet = ChangeSet({"id": wiki.id+"-"+str(count), "author": "jsonCompare.py"})
			tempSet.changes = [{"sql": {"dbms": "mysql, mariadb", "sql":"ALTER TABLE "
				+wiki.changes[0]["createTable"]["tableName"]+" MODIFY "+curCol+" "+dataType+" "+prev}}]
			tempSet.updateJSON()
			resCSList.append(tempSet)
			count += 1 
	prev = ""
	for col in currentColumnList:
		if(prev != ""): assert(wikiColInd[prev] < wikiColInd[col])
		prev = col
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
		


if __name__ == "__main__":

	if (len(sys.argv) < 2):
		print("Not enough parameters!")
		print("Usage: jsonCompare.py [database] [database change log] [wiki change log] [dropdwon change log] [output]")
		print("Change logs are optional parameters. Default parameters are:")
		print("database change log: ./ddl-[database]/liquibaseFiles/currentChangeLog.json")
		print("wiki change log: ./ddl-[database]/wikiChangeLog.json")
		print("dropdown change log: ./ddl-[database]/dropdownChangeLog.json")
		print("output: ./ddl-[database]/liquibaseFiles/(datetime)ChangeLog.json")
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
	elif ( 5 <= len(sys.argv) <= 6): # handle output later
		currentPath = os.path.join(os.path.dirname(os.path.realpath(__file__)), sys.argv[2])
		dropdownPath = os.path.join(os.path.dirname(os.path.realpath(__file__)), sys.argv[3])
		wikiPath = os.path.join(os.path.dirname(os.path.realpath(__file__)), sys.argv[4])
	else:
		print("Too many parameters!")
		print("Usage: jsonCompare.py [database] [database change log] [wiki change log] [dropdwon change log] [output]")
		print("Change logs are optional parameters. Default parameters are:")
		print("database change log: ./ddl-[database]/liquibaseFiles/currentChangeLog.json")
		print("wiki change log: ./ddl-[database]/wikiChangeLog.json")
		print("dropdown change log: ./ddl-[database]/dropdownChangeLog.json")
		print("output: ./ddl-[database]/liquibaseFiles/(datetime)ChangeLog.json")
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
			dropdownFile = json.load(file)
		dropdownLog = ChangeLog(dropdownFile)
		wikiChangeLog.appendChanges(dropdownLog)

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
		# TODO: could attempt to detect table name changes with this - would have to share all columns for it to stand out though

		for wikiCS in wikiChangeSets:
			# If the changeSet is a new table, add it to the difference and go to next changeSet
			if "createTable" in wikiCS.changes[0]:
				if wikiCS.changes[0]["createTable"]["tableName"] not in currentTableList:
					diffChangeSetList.append(wikiCS)
					continue
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
					if wikiCS.changes[0]["createTable"]["tableName"] == currentCS.changes[0]["createTable"]["tableName"]:

						# add changeSet to list with appropriate drop columns
						# only allow to drop, reorder, OR add/remove
						drops = dropColumnDiff(wikiCS, currentCS)
						moves = reorderColumnDif(wikiCS, currentCS)
						adds = addColumnDiff(wikiCS, currentCS)
						if drops != []:
							#TODO: HANDLE ERRORS
							for dropChangeSet in drops:
								diffChangeSetList.append(dropChangeSet)
						elif moves != []:
							#TODO: HANDLE ERRORS
							for moveChangeSet in moves:
								diffChangeSetList.append(moveChangeSet)
						elif adds != False:
							# since not drop or modify, can have add and rename
							# add changeSet to list with appropriate add columns
							# TODO: make that rename and add function (all in one...)
							diffChangeSetList.append(temp)
							
						# Column changes do not interfere, so can alway check 
						temp = pkColumnDiff(wikiCS, currentCS)
						if temp != []:
							for keyChangeSet in temp:
								diffChangeSetList.append(keyChangeSet)
						# add changeSet to list with appropriate modify columns (only data types)
						temp = modifyColumnDiff(wikiCS, currentCS)
						if temp != []:
							for modifyChangeSet in temp:
								diffChangeSetList.append(modifyChangeSet)
						
# TODO: note that if columns are both added and dropped from the same table, it COULD be a modify and need to flag it for review...
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
			if "createTable" in changeSet.changes[0]:
				if changeSet.changes[0]["createTable"]["tableName"] not in wikiTableList:
					# Shouln't happen unless there's been (offline) mods to the current database without using the wiki
					#	or something has been deleted from the wiki
					# TODO: Handling of automating rollback of specific changesets.
					#	Can probably be implemented with generating a sql file for rollbacks of all changesets,
					#	parsing file, writing relevant sql commands to a new file and executing the new file on the database
					# TODO: look into possibility of table name changes
					print("Note that a table is in the current file, but not in the wiki file:\n{}".format(changeSet))
					print("Please remove this table from the database manually or rollback to a certain date or changeset using Liquibase")
					print('You can rollback to a certain date in the database by using "liquibase rollbackDate [date]"')
					print('You can rollback to a certain changeSet by using "liquibase rollback [changeSet tag]"')
			if "createIndex" in changeSet.changes[0]:
				if changeSet.changes[0]["createIndex"]["indexName"] not in wikiIndexList:
					# Shouln't happen unless there's been (offline) mods to the current database without using the wiki
					#	or something has been deleted from the wiki
					# TODO: Handling of automating rollback of specific changesets.
					#	Can probably be implemented with generating a sql file for rollbacks of all changesets,
					#	parsing file, writing relevant sql commands to a new file and executing the new file on the database
					print("Note that an index is in the current file, but not in the wiki file:\n{}".format(changeSet))
					print("Please remove this index from the database manually or rollback to a certain date or changeset using Liquibase")
					print('You can rollback to a certain date in the database by using "liquibase rollbackDate [date]"')
					print('You can rollback to a certain changeSet by using "liquibase rollback [changeSet tag]"')

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