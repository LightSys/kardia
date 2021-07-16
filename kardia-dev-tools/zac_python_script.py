import csv

counter = 0
setID = set()
setAmounts = set()
setAmountErrorsId = []
setDatesErrorsPrev = []
setDatesErrorsNext = []

with open('moreData.csv') as csvfile:
    rowReader = csv.reader(csvfile)
    prevRow = rowReader.next()
    for row in rowReader:
        if (row[2] == prevRow[2] and row[1] == prevRow[1]):
            if(row[6] != prevRow[20]):
                setDatesErrorsPrev.append(row[1])
                #setDatesErrorsPrev.append(row[2])
                #setDatesErrorsPrev.append(row[3])
            if(row[21] != prevRow[5]):
                setDatesErrorsNext.append(row[1])
            if(row[4] == prevRow[4]):
                setAmountErrorsId.append(row[1])
                setAmountErrorsId.append(row[2])
            
        prevRow = row

print "Amount Errors: "
print setAmountErrorsId
print "\nDate Errors Prev: "
print setDatesErrorsPrev
print "\nDate Errors Next: "
print setDatesErrorsNext

f = open("thingsToEdit.txt", "w")
f.write("Amount Errors: \n")
for error in setAmountErrorsId:
    f.write(error)
    f.write("\n")
f.write("\nDate Errors Prev: \n")
for error in setDatesErrorsPrev:
    f.write(error)
    f.write("\n")
f.write("\nDate Errors Next: \n")
for error in setDatesErrorsNext:
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