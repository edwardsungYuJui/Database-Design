--*************************************************************************--
-- Title: Mod08 Labs Database 
-- Author: ESung
-- Desc: This file creates reporting structures
-- Change Log: When,Who,What
-- 2017-01-01,ESung,Created File
--**************************************************************************--
Use Master;
go
If Exists(Select Name from SysDatabases Where Name = 'MyLabsDB_ESung')
 Begin 
  Alter Database [MyLabsDB_ESung] set Single_user With Rollback Immediate;
  Drop Database MyLabsDB_ESung;
 End
go
Create Database MyLabsDB_ESung;
go
Use MyLabsDB_ESung;
go

Create View vSalesByCategories
as
Select 
 [CategoryName]
,[OrderYear] = Year(o.OrderDate) 
,[TotalQuantity] = Sum(od.Quantity) 
,[TotalDollars] = Sum(od.UnitPrice)  
From Northwind.dbo.Categories as c
 Join Northwind.dbo.Products as p
  On c.CategoryID = p.CategoryID
 Join Northwind.dbo.[Order Details] as od
  On p.ProductID = od.ProductID
 Join Northwind.dbo.Orders as o
  On od.OrderID = o.OrderID
Group By c.CategoryName, Year(o.OrderDate) 
