#-------------------------------------------------#
# Title: <Type the name of the script here>
# Dev:   <Type your name here>
# Date:  <Type the day this script was first created>
# Desc: <Type a description of the script>
# ChangeLog: (Who, When, What)
# <Example: RRoot, 01/15/2020, Added more code>
#-------------------------------------------------#

#-- Data --#
# declare variables and constants
FileName = "SalesByCategory.csv"
RowOfData = {}
TableOfData = []

#-- Processing --#
# perform tasks
objFile = open(FileName, "r")
for line in objFile:
    Data = line.split(",")  # readline() reads a line of the data into 2 elements
    RowOfData = {"CategoryName": Data[0].strip(), "TotalQty": Data[1].strip()}
    TableOfData.append(RowOfData)
objFile.close()

#-- Presentation (I/O) --#
print("******* Category Sales Quantities *******")
print('Category Name (Total Quantity)')  # adding a new line
for Row in TableOfData:
    print(Row["CategoryName"] + "(" + Row["TotalQty"] + ")")
print("*******************************************")
input("Press Enter to Exit!")
