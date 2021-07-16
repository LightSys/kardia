import csv

counter = 0
setID = set()
setAmounts = set()
setAmountErrorsId = []
setDatesErrorsId = []

with open('moreData.csv') as csvfile:
    rowReader = csv.reader(csvfile)
    prevRow = rowReader.next()
    for row in rowReader:
        if (row[2] == prevRow[2] and row[1] == prevRow[1]):
            if(row[6] != prevRow[20]):
                setDatesErrorsId.append(row[1])
                setDatesErrorsId.append(row[2])
                setDatesErrorsId.append(row[3])
            if(row[4] == prevRow[4]):
                setAmountErrorsId.append(row[1])
                setAmountErrorsId.append(row[2])
            
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