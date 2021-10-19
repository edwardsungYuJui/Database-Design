--*************************************************************************--
-- Title: Module03-Lab05
-- Author: YourNameHere
-- Desc: This file demonstrates how to select data from a database
-- Change Log: When,Who,What
-- 2017-01-01,YourNameHere,Created File
--**************************************************************************--
Use Northwind;
go

--Question 1:  Show a list of Product names, and the price of each product, with the price 
--formatted as US dollars? Order the result by the Product!
Select * from Products;
go 
Select ProductName, UnitPrice From Products;
go 
Select ProductName, '$' + str(UnitPrice,100,2) From Products;
go 
Select ProductName, '$' + ltrim(str(UnitPrice,100,2)) From Products;
go  -- option 1
Select ProductName, '$' + cast(UnitPrice as nvarchar(100)) From Products;
go -- option 2
Select ProductName, [UnitPrice] = format(UnitPrice, 'C', 'en-us') From Products
Order By ProductName;
go -- option 3


--Question 2: Show a list of the top five Order Ids and Order Dates based on the ordered date. 
--Format the results as a US date with back-slashes.
Select Top 5 OrderID, OrderDate From Orders;
go 
Select Top 5 OrderID, format(OrderDate, 'd', 'en-us') From Orders;
go -- option1
Select Top 5 OrderID, convert(nvarchar(100), OrderDate, 101) From Orders;
go --option2
Select Top 5 OrderID, [Order Date] = format(OrderDate, 'd', 'en-us') From Orders;
go --option1
Select Top 5 OrderID, convert(nvarchar(100), OrderDate, 101) as [Order Date] From Orders;
go --option2