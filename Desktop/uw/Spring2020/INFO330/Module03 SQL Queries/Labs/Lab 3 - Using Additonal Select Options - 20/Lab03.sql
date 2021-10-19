--*************************************************************************--
-- Title: Module03-Lab03
-- Author: YourNameHere
-- Desc: This file demonstrates how to select data from a database
-- Change Log: When,Who,What
-- 2017-01-01,YourNameHere,Created File
--**************************************************************************--
Select * From Northwind.Sys.Tables Where type = 'u' Order By Name;

Use Northwind;
go

-- Question 3-1:  Select the product name and the order quantity all products in the Northwind database,
-- ordered by the prodcut name. 
Select * From Products;
go

Select ProductName From Products;
go

Select * From [Order Details];
go

Select Quantity From [Order Details];
go

Select ProductName, Quantity 
From Products as p
Join [Order Details] as od
 On p.ProductID = od.ProductID
 Order by p.ProductName;
go