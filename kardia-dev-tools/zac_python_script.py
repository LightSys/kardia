import csv
from datetime import datetime

counter = 0
modCount = 0
setID = set()
setAmounts = set()
setAmountErrorsId = []
setDatesErrorsPrev = []
setDatesErrorsNext = []
setErrorNTLOnce = []
setErrorNTLTwice = []
setErrorNTLMult = []
setErrorNTLMultBlank = []
setErrorNTLEqualFirst = []
setAmountZero = []
setIsExtraNull = []

with open('moreData.csv') as csvfile:
    rowReader = csv.reader(csvfile)
    prevRow = rowReader.__next__()
    for row in rowReader:
        
        firstDate = datetime.strptime(row[5], "%d %b %Y %H:%M")
        lastDate = datetime.strptime(row[6], "%d %b %Y %H:%M")
        if(row[18] == ""):
            setIsExtraNull.append(row[1])
            setIsExtraNull.append(row[2])
            setIsExtraNull.append(row[3])
        if (int(row[8]) < 2):
            if(row[7] != ""):
                setErrorNTLOnce.append(row[1])
                setErrorNTLOnce.append(row[2])
                setErrorNTLOnce.append(row[3])
        elif (int(row[8]) == 2):
            if(row[7] != row[5]):
                setErrorNTLTwice.append(row[1])
                setErrorNTLTwice.append(row[2])
                setErrorNTLTwice.append(row[3])
        else:
            if(row[7] == ""):
                setErrorNTLMultBlank.append(row[1])
                setErrorNTLMultBlank.append(row[2])
                setErrorNTLMultBlank.append(row[3])
            elif(row[7] == row[5]):
                setErrorNTLEqualFirst.append(row[1])
                setErrorNTLEqualFirst.append(row[2])
                setErrorNTLEqualFirst.append(row[3])
            else:
                ntlDate = datetime.strptime(row[7], "%d %b %Y %H:%M")
                if(firstDate >= ntlDate or lastDate < ntlDate):
                    setErrorNTLMult.append(row[1])
                    setErrorNTLMult.append(row[2])
                    setErrorNTLMult.append(row[3])
        if(row[4][0] == "-"):
            setAmountZero.append(row[1])
            setAmountZero.append(row[2])
            setAmountZero.append(row[3])
        if (row[2] == prevRow[2] and row[1] == prevRow[1]):
            if(row[6] != prevRow[20] and row[6] != "" and prevRow[20] != ""):
                setDatesErrorsPrev.append(row[1])
                setDatesErrorsPrev.append(row[2])
                setDatesErrorsPrev.append(row[3])
            if(row[21] != prevRow[5] and row[21] != "" and row[5] != ""):
                setDatesErrorsNext.append(row[1])
                setDatesErrorsNext.append(row[2])
                setDatesErrorsNext.append(row[3])
            if(row[4] == prevRow[4]):
                setAmountErrorsId.append(row[1])
                setAmountErrorsId.append(row[2])
                setAmountErrorsId.append(row[3])
            
            
        prevRow = row

print ("Amount Errors: ")
print (setAmountErrorsId)
print ("\nDate Errors Prev: ")
print (setDatesErrorsPrev)
print ("\nDate Errors Next: ")
print (setDatesErrorsNext)
print ("\n", setErrorNTLOnce)
print ("\n", setErrorNTLTwice)
print ("\n", setErrorNTLMult)
print ("\n")

f = open("thingsToEdit.txt", "w")
f.write("Amount Errors: \n")
f.write("Donor CostCenter Hist\n")
for error in setAmountErrorsId:
    if(modCount % 3 == 2):
        f.write(error)
        f.write("\n")
    else:
        f.write(error)
        f.write("\t")
    modCount += 1
f.write("\nDate Errors Prev: \n")
f.write("Donor CostCenter Hist\n")
modCount = 0
for error in setDatesErrorsPrev:
    if(modCount % 3 == 2):
        f.write(error)
        f.write("\n")
    else:
        f.write(error)
        f.write("\t")
    modCount += 1
f.write("\nDate Errors Next: \n")
f.write("Donor CostCenter Hist\n")
modCount = 0
for error in setDatesErrorsNext:
    if(modCount % 3 == 2):
        f.write(error)
        f.write("\n")
    else:
        f.write(error)
        f.write("\t")
    modCount += 1
f.write("\nNTL Errors Count 1: \n")
f.write("Donor CostCenter Hist\n")
modCount = 0
for error in setErrorNTLOnce:
    if(modCount % 3 == 2):
        f.write(error)
        f.write("\n")
    else:
        f.write(error)
        f.write("\t")
    modCount += 1
f.write("\nNTL Errors Count 2: \n")
f.write("Donor CostCenter Hist\n")
modCount = 0
for error in setErrorNTLTwice:
    if(modCount % 3 == 2):
        f.write(error)
        f.write("\n")
    else:
        f.write(error)
        f.write("\t")
    modCount += 1
f.write("\nNTL Errors Count Mult: \n")
f.write("Donor CostCenter Hist\n")
modCount = 0
for error in setErrorNTLMult:
    if(modCount % 3 == 2):
        f.write(error)
        f.write("\n")
    else:
        f.write(error)
        f.write("\t")
    modCount += 1
f.write("\nNTL Errors Count Mult Blank: \n")
f.write("Donor CostCenter Hist\n")
modCount = 0
for error in setErrorNTLMultBlank:
    if(modCount % 3 == 2):
        f.write(error)
        f.write("\n")
    else:
        f.write(error)
        f.write("\t")
    modCount += 1
f.write("\nNTL Errors Count Mult Equal First: \n")
f.write("Donor CostCenter Hist\n")
modCount = 0
for error in setErrorNTLEqualFirst:
    if(modCount % 3 == 2):
        f.write(error)
        f.write("\n")
    else:
        f.write(error)
        f.write("\t")
    modCount += 1
f.write("\nSet Amounts Zero: \n")
f.write("Donor CostCenter Hist\n")
modCount = 0
for error in setAmountZero:
    if(modCount % 3 == 2):
        f.write(error)
        f.write("\n")
    else:
        f.write(error)
        f.write("\t")
    modCount += 1
f.write("\nIs Extra is Null: \n")
f.write("Donor CostCenter Hist\n")
modCount = 0
for error in setIsExtraNull:
    if(modCount % 3 == 2):
        f.write(error)
        f.write("\n")
    else:
        f.write(error)
        f.write("\t")
    modCount += 1
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