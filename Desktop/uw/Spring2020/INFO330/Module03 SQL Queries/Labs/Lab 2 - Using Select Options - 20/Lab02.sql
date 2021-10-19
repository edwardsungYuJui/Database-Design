--*************************************************************************--
-- Title: Module03-Lab02
-- Author: YourNameHere
-- Desc: This file demonstrates how to select data from a database
-- Change Log: When,Who,What
-- 2017-01-01,YourNameHere,Created File
--**************************************************************************--
Use Northwind;
go

Select * From Northwind.Sys.Tables Where type = 'u' Order by Name;

--Question 2-1:  Select the Product Id, Product Name, and Product Price 
--of all Products with the Seafood's Category Id. Ordered by the highest to the lowest products price. 
Select * From Products;
go 
Select ProductID, ProductName, UnitPrice From Products;
go 
Select * From Categories Where CategoryName = 'Seafood';
go 
Select ProductID, ProductName, UnitPrice From Products Where CategoryId = 8;
go 
Select ProductID, ProductName, UnitPrice From Products Where CategoryId = 8
Order by UnitPrice Desc;
go 

--Question 2-2:  Select the product Id, product name, and product price ordered 
--by the products price highest to the lowest. Show only the products that have a price Less than $20. 
Select ProductID, ProductName, UnitPrice From Products Where UnitPrice < 20
Order by UnitPrice Desc;
go 

--Question 2-3: Select the category name, product name, and product price from 
--both categories and products. Order the results by category name and then product 
--name, in alphabetical order. (Hint: Join Products to Category)
Select CategoryName, ProductName, UnitPrice
From Products As P Join Categories As C
On P.CategoryID = C.CategoryID;
go
Select CategoryName, ProductName, UnitPrice
From Products As P Join Categories As C
On P.CategoryID = C.CategoryID
Order By CategoryName, ProductName;
go
--Question 2-4: Select the Category Name, Product Name, and Product Price 
--from both Categories and Products. Order the results by price highest to 
--lowest. Show only the products that have a price from $10 to $20. 
Select CategoryName, ProductName, UnitPrice
From Products As P Join Categories As C
On P.CategoryID = C.CategoryID
Order By UnitPrice Desc;
go
Select CategoryName, ProductName, UnitPrice
From Products As P Join Categories As C
On P.CategoryID = C.CategoryID
Where UnitPrice Between 10 and 20
Order By UnitPrice Desc;
go