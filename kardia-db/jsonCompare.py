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
					self.include = item[include]
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
		# print("changeSetList:\n", self.changeSetList)



	def __str__(self):
		return str(self.jsonList)

	def __eq__(self, other):
		self.updateJSON()
		other.updateJSON()
		if not isinstance(other, ChangeLog):
			print("Wrong type")
			return False
		if (self.jsonList == other.jsonList):
			print("exactly equal")
			print(self.jsonList)
			print("---------------------")
			print(other.jsonList)
			return True
		else:
			try:
				# print("Checking changeSet list")
				assert(self.changeSetList == other.changeSetList)
				print("ChangeSet lists are equal")
				assert(set(self.preconditions) == set(other.preconditions))
				assert(set(self.property) == set(other.property))
				assert(set(self.include) == set(other.include))
			except AssertionError:
				print("some property unequal")
				return False
		print("all properties equal")
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


class ChangeSet:

	def __init__(self, inputDict):
		self.inputDict = inputDict
		self.id = inputDict["id"].lower()
		self.author = inputDict["author"].lower()
		#Sets optional variables even if ChangeSet does not have them
		#If __ is in the inputDict, sets the class varable to that thing, otherwise sets the class variable equal to ""
		self.changes = (inputDict["changes"] if "changes" in inputDict else "")
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
				# print(item["column"]["type"])
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
			# columnNames = changes["addUniqueConstraint"]["columnNames"]
			columnNameList = changes["addUniqueConstraint"]["columnNames"].split(", ")
			indexName = changes["addUniqueConstraint"]["constraintName"]
			tableName = changes["addUniqueConstraint"]["tableName"]
			del changes["addUniqueConstraint"]
			columns = []
			for item in columnNameList:
				columns.append({"column":{"name":item}})
			changes["createIndex"] = {"tableName": tableName, "indexName": indexName, "columns": columns}
			print("createIndex: ", changes["createIndex"])




	def __eq__(self, other):
		if not isinstance(other, ChangeSet):
			print("---------- Other is not a ChangeSet, but a", type(other), "! ----------")
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
				if self.id == other.id:
					print("---------- Various details are a mismatch ----------")
				return False
			#Tags can be different since they will be auto-generated from parse_ddl.pl
			if (self.changes != other.changes):
				# print("changes different")
				# print(self.changes[0])
				for item in self.changes[0]:
					if item not in other.changes[0]:
						if self.id == other.id:
							print("---------- Item: ", item, " not in other ----------")
						return False
					if self.changes[0][item] != other.changes[0][item]:
						if self.id == other.id:
							print("---------- changes[Item]:", self.changes[0][item], " not in other changes ----------")
						return False
				for item in other.changes[0]:
					if item not in self.changes[0]:
						if self.id == other.id:
							print("---------- Other item:", item, " not in self ----------")
						return False
		return True

	def __str__(self):
		return str(self.inputDict)

#Used to encode a ChangeLog or ChangeSet object as a JSON object with proper formatting
class MyEncoder(JSONEncoder):
	def default(self, o):
		if isinstance(o, ChangeLog):
			return {"databaseChangeLog" : o.jsonList}
		elif isinstance(o, ChangeSet):
			return o.inputDict

		


if __name__ == "__main__":

	currentPath = os.path.join(__file__, "..", "ddl-{}".format(sys.argv[1]), "liquibaseFiles", "currentChangeLog.json")
	wikiPath = os.path.join(__file__, "..", "ddl-{}".format(sys.argv[1]), "wikiChangeLog.json")
	with open(currentPath, "r") as file:
		currentChangeLogFile = json.load(file) #Data is a dict of a list of changeSet dictionaries
	with open(wikiPath, "r") as file:
		wikiChangeLogFile = json.load(file)

	currentChangeLog = ChangeLog(currentChangeLogFile)
	wikiChangeLog = ChangeLog(wikiChangeLogFile)

	print("current changeSet list:", currentChangeLog.changeSetList)
	print("wiki changeSet list:", wikiChangeLog.changeSetList)

	diffChangeLog = ChangeLog()
	diffChangeSetList = []
	if (currentChangeLog == wikiChangeLog):
		print("Current changeLog:\n", currentChangeLog.jsonList)
		print("Wiki changeLog:\n", wikiChangeLog.jsonList)
		# pass
	elif (currentChangeLog.getChangeSetList() == wikiChangeLog.getChangeSetList()):
		#Some property of the ChangeLogs are different (but not ChangeSets)
		if (currentChangeLog.getPreconditions() != wikiChangeLog.getPreconditions()):
			diffChangeLog.setPreconditions(wikiChangeLog.getPreconditions())
		if (currentChangeLog.getProperties() != wikiChangeLog.getProperties()):
			diffChangeLog.setProperties(wikiChangeLog.getProperties())
		if (currentChangeLog.getIncludes() != wikiChangeLog.getIncludes()):
			diffChangeLog.setIncludes(wikiChangeLog.getIncludes())
	else:
		#ChangeSet lists are different
		currentChangeSets = currentChangeLog.getChangeSetList()
		wikiChangeSets = wikiChangeLog.getChangeSetList()

		for changeSet in wikiChangeSets:
			if changeSet not in currentChangeSets:
				diffChangeSetList.append(changeSet)
		for changeSet in currentChangeSets:
			if changeSet not in wikiChangeSets:
				# Shouln't happen unless there's been (offline) mods to the current database without using the wiki
				#	or something has been deleted from the wiki
				# TODO: Handling of automating rollback of specific changesets.
				#	Can probably be implemented with generating a sql file for rollbacks of all changesets,
				#	parsing file, writing relevant sql commands to a new file and executing the new file on the database
				print("Note that a changeSet is in the current file, but not in the wiki file:\n{}".format(changeSet))
				print("Please remove this changeSet from the database manually or rollback to a certain date or changeset using Liquibase")
				print('You can rollback to a certain date in the database by using "liquibase rollbackDate [date]"')
				print('You can rollback to a certain changeSet by using "liquibase rollback [changeSet tag]"')

		diffChangeLog.setChangeSetList(diffChangeSetList)


	if not (diffChangeLog == ChangeLog()):
		print("Creating file with differences...")
		diffChangeLog.updateJSON()
		diffJSON = json.dumps(diffChangeLog, cls=MyEncoder, indent=4)
		currentDateTime = datetime.datetime.now()
		outputFileName = str(currentDateTime)[0:10] + "." + str(currentDateTime.hour) + "." + str(currentDateTime.minute) + "." + str(currentDateTime.second) + "ChangeLog.json"	
		writePath = os.path.join(__file__, "..", "ddl-{}".format(sys.argv[1]), "liquibaseFiles", outputFileName)
		f = open(writePath, "w")
		f.write(diffJSON)
		f.close()
		print("See %s for differences" % writePath[18:])
		print("checking to make sure formatting is correct...")
		with open(writePath, "r") as file:
			testChangeLogFile = json.load(file)
		testChangeLog = ChangeLog(testChangeLogFile)
	else:
		print("ChangeLogs are equal")
	print("finished with no errors")