--*************************************************************************--
-- Title: Assignment04
-- Author: Edward Sung
-- Desc: This file demonstrates how to process data from a database
-- Change Log: When,Who,What
-- 2020-04-27,Edward Sung,Created File
--**************************************************************************--
Use Master;
go
-- avoiding having created database
If Exists(Select Name from SysDatabases Where Name = 'Assignment04DB_ESung')
 Begin 
  Alter Database [Assignment04DB_ESung] set Single_user With Rollback Immediate;
  Drop Database Assignment04DB_ESung;
 End
go

Create Database Assignment04DB_ESung;
go

Use Assignment04DB_ESung;
go

-- Add Your Code Below ---------------------------------------------------------------------

-- Data Request: 0301
-- Request: I want a list of customer companies and their contact people
Select * From Northwind.dbo.Customers; -- check all the data 
go 
Select CompanyName, ContactName From Northwind.dbo.Customers; -- filter the two columns
go 
Create or Alter View vCustomerContacts 
As 
    Select CompanyName, ContactName From Northwind.dbo.Customers;
go 

-- Test with this statement --
Select * From vCustomerContacts;

-- Data Request: 0302
-- Request: I want a list of customer companies and their contact people, but only the ones in US and Canada
Select CompanyName, ContactName,Country From Northwind.dbo.Customers -- select specific items
Where Country = 'USA' or Country = 'Canada'
Order By Country,CompanyName;
go 
Create or Alter View vUSAandCanadaCustomerContacts
As 
    Select CompanyName, ContactName, Country from Northwind.dbo.Customers
    Where Country = 'USA' or Country = 'Canada'
    -- Group By Country, CompanyName;
go 

-- Test with this statement --
Select * from vUSAandCanadaCustomerContacts Order By Country, CompanyName;
  
-- Data Request: 0303
-- Request: I want a list of products, their standard price and their categories. 
-- Order the results by Category Name and then Product Name, in alphabetical order.
Select * From Northwind.dbo.Products;
go 
Select * From Northwind.dbo.Categories;
go 
Select CategoryName, ProductName, '$' + cast(p.UnitPrice as nvarchar(100))
From Northwind.dbo.Products as p
Join Northwind.dbo.Categories as c 
    On p.CategoryID = c.CategoryID 
Order By CategoryName, ProductName;
go 
Create or Alter View vProductPricesByCategories
As
    Select CategoryName, ProductName, [StandardPrice] = '$' + cast(p.UnitPrice as nvarchar(100))
    From Northwind.dbo.Products as p
    Join Northwind.dbo.Categories as c 
        On p.CategoryID = c.CategoryID; 
    -- Group By c.CategoryName, p.ProductName;
go 

-- Test with this statement --
Select * from vProductPricesByCategories Order By CategoryName, ProductName;

-- Data Request: 0304
-- Request: I want a list of products, their standard price and their categories. 
-- Order the results by Category Name and then Product Name, in alphabetical order but only for the seafood category
Select CategoryName, ProductName, '$' + cast(p.UnitPrice as nvarchar(100))
From Northwind.dbo.Products as p
Join Northwind.dbo.Categories as c 
    On p.CategoryID = c.CategoryID 
Where c.CategoryName = 'Seafood'
Order By CategoryName, ProductName;
go 

Create Function dbo.fProductPricesByCategories
(@CategoryName nvarchar(100))
Returns Table 
As 
	Return(
		Select Distinct Top 100000
		c.[CategoryName]
		,p.[ProductName]
		,[StandardPrice] = '$' + cast(p.[UnitPrice] as nvarchar(100))
		From Northwind.dbo.Products as p Join Northwind.dbo.Categories as c 
		On p.CategoryID = c.CategoryID 
		Where 
		   c.CategoryName = @CategoryName
		Order By c.[CategoryName], p.[ProductName]
	);
go 

-- Test with this statement --
Select * from dbo.fProductPricesByCategories('seafood') Order By CategoryName, ProductName;

-- Data Request: 0305
-- Request: I want a list of how many orders our customers have placed each year
go
Create or Alter View vCustomerOrderCounts
As 
Select [CustomerName] = CompanyName, [NumberOfOrders] = Count(c.CustomerID), [OrderYear] = Year(o.OrderDate)
From Northwind.dbo.Orders as o 
Join Northwind.dbo.Customers as c 
    On o.CustomerID = c.CustomerID
Group By c.CompanyName, Year(o.OrderDate)-- Group By always go before Order By 
go 

-- Test with this statement --
Select * from vCustomerOrderCounts Order By CustomerName;
go 

-- Data Request: 0306
-- Request: I want a list of total order dollars our customers have placed each year
Select * From Northwind..[Order Details];
go
Select * From Northwind..Orders;
go
Select * From Northwind..Customers;
go
Create or Alter View vCustomerOrderDollars
As 
Select [CustomerName] = CompanyName, [TotalDollars] = '$' + cast(Sum(od.UnitPrice * od.Quantity) as nvarchar(100)), [OrderYear] = Year(o.OrderDate)
From Northwind.dbo.Orders as o 
Join Northwind.dbo.Customers as c 
    On o.CustomerID = c.CustomerID
Join Northwind.dbo.[Order Details] as od 
    On o.OrderID = od.OrderID
Group By c.CompanyName,  Year(o.OrderDate)-- Group By always go before Order By 
go 

-- Test with this statement --
Select * from vCustomerOrderDollars Order By CustomerName;

