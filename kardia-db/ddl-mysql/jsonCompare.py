import json 		#Used for JSON processing (json.load and json.dump)
from json import JSONEncoder
import os.path		#Used to get relative filenames (os.path.join)
import sys			#Used to get command line inputs (sys.argv)
import datetime		#Used for now() function to name output changeLog file
import os			#Used to rollback changeSets

"""How to use this file:
Use liquibase to generate a full changelog of the database using liquibase 
3, 8, 11, 15, 
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
				assert(self.changeSetList == other.changeSetList)
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
		self.id = inputDict["id"]
		self.author = inputDict["author"]
		#Sets optional variables even if ChangeSet does not have them
		#If __ is in the inputDict, sets the class varable to that thing, otherwise sets the class variable equal to ""
		self.changes = (inputDict["changes"] if "changes" in inputDict else "")
		self.tag = (inputDict["changes"][0]["tagDatabase"]["tag"] if "tagDatabase" in inputDict["changes"][0] else "")
		self.dbms = (inputDict["dbms"] if "dbms" in inputDict else "")
		self.runAlways = (inputDict["runAlways"] if "runAlways" in inputDict else "")
		self.runOnChange = (inputDict["runOnChange"] if "runOnChange" in inputDict else "")
		self.context = (inputDict["context"] if "context" in inputDict else "")
		self.runInTransaction = (inputDict["runInTransaction"] if "runInTransaction" in inputDict else "")
		self.failOnError= (inputDict["failOnError"] if "failOnError" in inputDict else "")
		self.rollback = (inputDict["rollback"] if "rollback" in inputDict else "")

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
				# print("changes different")
				# print(self.changes[0])
				for item in self.changes[0]:
					if item not in other.changes[0] and item != self.changes[0]["tagDatabase"]:
						return False
					if self.changes[0][item] != other.changes[0][item]:
						return False
				for item in other.changes[0]:
					if item not in self.changes[0] and item != other.changes[0]["tagDatabase"]:
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


	path1 = os.path.join(__file__, "..", "ddl-{}".format(sys.argv[1]), "liquibaseFiles", "currentFullChangeLog.json")
	path2 = os.path.join(__file__, "..", "ddl-{}".format(sys.argv[1]), "wikiChangeLog.json")
	with open(path1, "r") as file:
		currentChangeLogFile = json.load(file) #Data is a dict of a list of changeSet dictionaries
	with open(path2, "r") as file:
		wikiChangeLogFile = json.load(file)

	currentChangeLog = ChangeLog(currentChangeLogFile)
	wikiChangeLog = ChangeLog(wikiChangeLogFile)

	diffChangeLog = ChangeLog()
	diffChangeSetList = []
	if (currentChangeLog == wikiChangeLog):
		pass
	elif (currentChangeLog.getChangeSetList() == wikiChangeLog.getChangeSetList()):
		#Some property of the ChangeLogs are different (but not ChangeSets)
		if (currentChangeLog.getPreconditions() != wikiChangeLog.getPreconditions()):
			diffChangeLog.setPreconditions(wikiChangeLog.getPreconditions())
		if (currentChangeLog.getProperties() != wikiChangeLog.getProperties()):
			diffChangeLog.setProperties(wikiChangeLog.getProperties())
		if (currentChangeLog.getIncludes() != wikiChangeLog.getIncludes()):
			diffChangeLog.setIncludes(wikiChangeLog.getIncludes())
	else:
		#ChangeSets are different
		currentChangeSets = currentChangeLog.getChangeSetList()
		wikiChangeSets = wikiChangeLog.getChangeSetList()

		for changeSet in wikiChangeSets:
			if changeSet not in currentChangeSets:
				diffChangeSetList.append(changeSet)
		for changeSet in currentChangeSets:
			if changeSet not in wikiChangeSets:
				#Shouln't happen unless there's been (offline) mods to the current database without using the wiki
				#or something has been deleted from the wiki
				# raise Exception("There is a change set in the current Kardia database that isn't in the wiki. Please rollback your database to before this changeset ({}) was implemented.".format(changeSet))
				# TODO: Nicer Handling to be implemented
				print("Note that a changeSet is in the current file, but not in the wiki file:\n{}".format(changeSet))
				print("Would you like to rollback this changeSet? (y/n)\n(Note: this will undo this changeSet. Data cannot be recovered from dropping a table)")
				choice = input()
				if (choice == "y" or "yes" or "Y" or "Yes"):
					# subprocess.run("liquibase rollback {}".format(changeSet.tag))
					# subprocess.run("exit 0")
					os.system('liquibase rollback {}'.format(changeSet.tag))
					print("changeSet rolled back")
		diffChangeLog.setChangeSetList(diffChangeSetList)


	if not (diffChangeLog == ChangeLog()):
		print("Creating file with differences...")
		diffChangeLog.updateJSON()
		diffJSON = json.dumps(diffChangeLog, cls=MyEncoder, indent=4)
		currentDateTime = datetime.datetime.now()
		outputFileName = str(currentDateTime)[0:10] + "." + str(currentDateTime.hour) + "." + str(currentDateTime.minute) + "." + str(currentDateTime.second) + "ChangeLog.json"	
		writePath = os.path.join(__file__, "..", "ddl-mysql", "liquibaseFiles", outputFileName)
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