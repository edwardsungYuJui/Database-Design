--********************** SQL Extras *************************--
-- This file describes how to design and test advanced
-- data retrieval statements using Table ExpressiOns and Psudo tables.
--**************************************************************--

'*** Derived Tables AKA, subquery ***'
-----------------------------------------------------------------------------------------------------------------------   
-- Derived tables allow you to use a fraction of data From a table and then join it to another. 
Use Northwind
Select C.CustomerID, C.CompanyName,
COUNT(Orders1996.OrderID) AS TotalOrders
From Customers AS C LEFT OUTER JOIN
-- Capture a fractiOn of data From the orders table
	(Select OrderId, CustomerId  From Orders 
    Where YEAR(Orders.OrderDate) = 1996) AS Orders1996	-- This is the Derived table
On C.CustomerID = Orders1996.CustomerID
Group By C.CustomerID, C.CompanyName
Order By TotalOrders;
Go

-- This statement LOOKS LIKE IT WILL WORK the same
-- , BUT notice that you loose any Company that did not order in 1996
-- even With a Full Outer Join! So, they are not the same!
Select C.CustomerID, C.CompanyName, COUNT(O.OrderID) AS TotalOrders
From Customers AS C 
Full OUTER JOIN Orders AS O
 On C.CustomerID = O.CustomerID
Where YEAR(O.OrderDate) = 1996 
Group By C.CustomerID, C.CompanyName 
Order By TotalOrders;


'******************** LAB ***********************'
-- Do the following:
-- 1) Use the Northwind database to produce a 
--   Report that shows a list of Products sold in
--   the year 1996, USING A SUBQUERY
'*************************************************' 

'*** Temporary Tables ***'
-----------------------------------------------------------------------------------------------------------------------   
-- SQL has two Basic types of temporary tables Local and Global:
  -- Local --
Create Table #TempCustomers (Id int , CustomerName varchar(50))
	-- Add data
	Insert Into #TempCustomers Values(1, 'Bob')
	Select * From #TempCustomers
	-- Modify data
	Update #TempCustomers SET CustomerName = 'Robert' Where Id = 1
	Select * From #TempCustomers
	-- Delete data
	Delete From #TempCustomers Where Id = 1
	Select * From #TempCustomers

-- Global --
Create Table #GlobalTempCustomers (Id int , CustomerName varchar(50))
	-- Add data
	Insert Into#GlobalTempCustomers Values(1, 'Bob')
	Select * From #GlobalTempCustomers
	-- Modify data
	Update #GlobalTempCustomers SET CustomerName = 'Robert' Where Id = 1
	Select * From #GlobalTempCustomers
	-- Delete data
	Delete From #GlobalTempCustomers Where Id = 1
	Select * From #GlobalTempCustomers

'******************** LAB ***********************'
-- Do the following:
-- 1) Use the Northwind database to produce a 
--   Report that shows a list of Products sold in
--   the year 1996, USING A TEMPORARY TABLE
'*************************************************' 

'*** CommOn Table ExpressiOns ***'
-----------------------------------------------------------------------------------------------------------------------  
 Use Northwind
 With CateGoryProductAndPrice (ProductName, CateGoryName, UnitPrice) AS
(
   Select
      c.CateGoryName,
      p.ProductName,
	  p.UnitPrice
   From Products p
      INNER JOIN CateGories c On
         c.CateGoryID = p.CateGoryID ) -- The CTE expressiOn 
Select *
From CateGoryProductAndPrice
Order By CateGoryName ASC, UnitPrice ASC, ProductName ASC


'******************** LAB ***********************'
-- Do the following:
-- 1) Use the Northwind database to produce a 
--   Report that shows a list of Products sold in
--   the year 1996, USING A CTE
'*************************************************' 

'*** Table Variables (Psuedo Tables) ***'
-----------------------------------------------------------------------------------------------------------------------   
Begin -- Must run all the code From Begin to End points
	Declare @PsuedoTableCustomers TABLE (Id int , CustomerName varchar(50))
	-- Add data
	Insert Into@PsuedoTableCustomers Values(1, 'Bob')
	Select * From @PsuedoTableCustomers
	-- Modify data
	Update @PsuedoTableCustomers SET CustomerName = 'Robert' Where Id = 1
	Select * From @PsuedoTableCustomers
	-- Delete data
	Delete From @PsuedoTableCustomers Where Id = 1
	Select * From @PsuedoTableCustomers
End
Go

-- Using a Psuedo Tables With the Output clause --
Create Table Table1
(
 ID int identity,  -- Note the Identity Clause
 Name nvarchar (20)
) 

Begin -- Must run all the code From Begin to End points
	-- Make a new Psuedo Table
	Declare @InsDetails Table
	(ID int ,  Name nvarchar(20) , InsertedBy sysName ) --sysname is a data type for holding SQL Server system names

	-- Add some data to a Table and Capture the changed data it the Psuedo table
	Insert 
	Into Table1 (Name)
		OUTPUT Inserted.ID, Inserted.Name, suser_name()
			Into @InsDetails  -- This adds data to the table variable
	Values ( 'Bob')

	-- Display the Results From the Psuedo table and the normal table
	Select * From @InsDetails
	Select * From Table1
End

'******************** LAB ***********************'
-- Do the following:
-- 1) Use the Northwind database to produce a 
--   Report that shows a list of Products sold in
--   the year 1996, USING A TABLE VARIABLE
'*************************************************' 

'*** Table Producting Functions (Inline and Multistatment Table Functions) ***'
-----------------------------------------------------------------------------------------------------------------------   
Use Northwind
Go
-- Example of an In–line Table-valued Function
Create Function fn_CustomerNamesInRegiOn ( @RegiOnParameter nvarchar(30) )
Returns table
AS
Return (
   Select CustomerID, CompanyName
   From Northwind.dbo.Customers
   Where RegiOn = @RegiOnParameter
   )

-- Calling the Function With a Parameter
Select * From fn_CustomerNamesInRegiOn('WA')

-- Example of a Multi-statement Table-valued Function
Create Function fn_Employees (@length nvarchar(9))
Returns @fn_Employees TABLE
   (EmployeeID int PRIMARY KEY NOT NULL,
   [Employee Name] Nvarchar(61) NOT NULL)
AS
Begin
   IF @length = 'ShortName'
      Insert @fn_Employees Select EmployeeID, LastName 
      From Employees
   ELSE IF @length = 'LOngName'
      Insert @fn_Employees Select EmployeeID, 
      (FirstName + ' ' + LastName) From Employees
Return
End
-- Calling the Function
Select * From dbo.fn_Employees('LOngName')
Select * From dbo.fn_Employees('ShortName')



'******************** LAB ***********************'
-- Do the following:
-- 1) Use the Northwind database to produce a 
--   Report that shows a list of Products sold in
--   the year 1996, USING A Table Function
'*************************************************' 

---------------------------------------------------------------------
-- CommOn Table ExpressiOns
---------------------------------------------------------------------

With USACusts AS
(
  Select custid, companyname
  From Sales.Customers
  Where country = N'USA'
)
Select * From USACusts;

---------------------------------------------------------------------
-- Assigning Column Aliases
---------------------------------------------------------------------

-- Inline column aliasing
With C AS
(
  Select YEAR(orderdate) AS orderyear, custid
  From Sales.Orders
)
Select orderyear, COUNT(DISTINCT custid) AS numcusts
From C
Group By orderyear;

-- External column aliasing
With C(orderyear, custid) AS -- Note the Column Aliases here!
(
  Select YEAR(orderdate), custid
  From Sales.Orders
)
Select orderyear, COUNT(DISTINCT custid) AS numcusts
From C
Group By orderyear;
Go

---------------------------------------------------------------------
-- Using Arguments
---------------------------------------------------------------------

Declare @empid AS INT = 3;

With C AS
(
  Select YEAR(orderdate) AS orderyear, custid
  From Sales.Orders
  Where empid = @empid
)
Select orderyear, COUNT(DISTINCT custid) AS numcusts
From C
Group By orderyear;
Go

---------------------------------------------------------------------
-- Defining Multiple CTEs
---------------------------------------------------------------------

With C1 AS
(
  Select YEAR(orderdate) AS orderyear, custid
  From Sales.Orders
),
C2 AS
(
  Select orderyear, COUNT(DISTINCT custid) AS numcusts
  From C1 -- This is similar to the Nested subquery.
  Group By orderyear
)
Select orderyear, numcusts
From C2
Where numcusts > 70;

