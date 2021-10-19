--*************************************************************************--
-- Title: Module03-Lab01
-- Author: YourNameHere
-- Desc: This file demonstrates how to select data from a database
-- Change Log: When,Who,What
-- 2017-01-01,YourNameHere,Created File
--**************************************************************************--
/*
Lab 1: Using Joins and Unions - 30

In this lab, you create some advanced select statements using Northwind database. 
You will work on your own for the first 20 minutes, then we will review the answers together in the last 10 minutes. 

Note: This lab should be done individually. 
*/

--Step 1: Review Database Tables
--Run the following code in a SQL query editor and review the names of the tables you have to work with.

Select * From Northwind.Sys.Tables Where type = 'u' Order By Name;

-- Step 2: Create Queries
-- Answer the following questions by writing and executing SQL code.

-- Question 1: How can you show a list of category names? Order the result by the category!
Select * From Northwind.dbo.Categories;
go
Select CategoryName From Northwind.dbo.Categories
go
Select CategoryName From Northwind.dbo.Categories Order By CategoryName;
go

-- Question 2: How can you show a list of product names and the price of each product? Order the result by the product!
Select * From Northwind.dbo.Products;
go
Select ProductName, UnitPrice From Northwind.dbo.Products;
go
Select ProductName, UnitPrice From Northwind.dbo.Products Order By ProductName;
go

-- Question 3: How can you show a list of category and product names, and the price of each product? 
-- Order the result by the category and product!
Select ProductName, UnitPrice From Northwind.dbo.Products Order By ProductName;
go
Select CategoryID, ProductName, UnitPrice From Northwind.dbo.Products Order By ProductName;
go
Select CategoryName, ProductName, UnitPrice 
From Northwind.dbo.Products as p Join Northwind.dbo.Categories as c
    On p.CategoryID = c.CategoryID 
Order By CategoryName, ProductName;
go

-- Question 4: How can you show a list of order Ids, category names, product names, and order quantities. 
-- Sort the results by the Order Ids, category, product, and quantity!
Select CategoryName, ProductName, UnitPrice 
From Northwind.dbo.Products as p Join Northwind.dbo.Categories as c
    On p.CategoryID = c.CategoryID 
Order By CategoryName, ProductName;
go
Select * From Northwind.dbo.Orders;
go
Select * From Northwind.dbo.[Order Details];
go
Select OrderID, Quantity From Northwind.dbo.[Order Details];
go
Select OrderID, CategoryName, ProductName, Quantity
From Northwind.dbo.Products as p Join Northwind.dbo.Categories as c
    On p.CategoryID = c.CategoryID 
Join Northwind.dbo.[Order Details] as od
    On p.ProductID = od.ProductID
Order By OrderID, CategoryName, ProductName, Quantity;
go
Select OrderID, CategoryName, ProductName, Quantity
From Northwind.dbo.Categories as c
Join Northwind.dbo.Products as p 
    On p.CategoryID = c.CategoryID 
Join Northwind.dbo.[Order Details] as od
    On p.ProductID = od.ProductID
Order By OrderID, CategoryName, ProductName, Quantity; -- Order By 1,2,3,4
go

-- Question 5: How can you show a list of order ids, order date, category names, product names, 
-- and order quantities. Sort the results by the order id, order date, category, product, and quantity!
Select * From Northwind..Orders;
go
Select o.OrderID, OrderDate, CategoryName, ProductName, Quantity
From Northwind.dbo.Categories as c
Inner Join Northwind.dbo.Products as p  -- Inner可有可無
    On p.CategoryID = c.CategoryID 
Inner Join Northwind.dbo.[Order Details] as od -- Left Outer Join 
    On p.ProductID = od.ProductID
Inner Join Northwind.dbo.Orders as o  -- Right Outer Join
    On od.OrderID = o.OrderID
Order By o.OrderID, OrderDate, CategoryName, ProductName, Quantity; -- Order By 1,2,3,4
go

-- Step 3: Review Your Work
-- Now, you will review your work with your instructor.
-- NOTE: Unlike assignments, labs do not need to be turned in to Canvas!

