import csv

counter = 0
setID = set()
setAmounts = set()
setAmountErrorsId = set()
setDatesErrorsId = set()

with open('moreData.csv') as csvfile:
    rowReader = csv.reader(csvfile)
    prevRow = rowReader.next()
    for row in rowReader:
        if (row[2] == prevRow[2]):
            if(row[20] != prevRow[6]):
                setDatesErrorsId.add(row[1])
            if(row[4] == prevRow[4]):
                setAmountErrorsId.add(row[1])
            
        prevRow = row

print "Amount Errors: "
print setAmountErrorsId
print "\nDate Errors: "
print setDatesErrorsId

f = open("thingsToEdit.txt", "w")
f.write("Amount Errors: \n")
for error in setAmountErrorsId:
    f.write(error)
    f.write("\n")
f.write("\nDate Errors: \n")
for error in setDatesErrorsId:
    f.write(error)
    f.write("\n")
f.close()

#    for row in rowReader:
#        setID.add(row[1])
#        setAmounts.add(row[4])


#        setID.add(row[1])
#        setAmounts.add(row[4])
#        if(row[1] == "\"100400\""):
#            counter = counter + 1
#            print row

#print counter
#print len(setID)
#print "\"100400\"" in setID
#print "$4.00" in setAmounts

    #print spamreader.next()[2]
    #print "\n"