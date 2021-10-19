

-- Step 1: Examine some data
-- Review the data in the following tables looking for the least number of columns you could 
-- use to create a reporting database storing ONLY product sales data. We are looking only for the "Must Haves!" 
-- 1a) Write code to look at the data
Select * From Northwind.dbo.Orders as o;
Select * From Northwind.dbo.[Order Details] as od;
Select * From Northwind.dbo.Products as p;
Select * From Northwind.dbo.Categories as c;


-- 1b) Write code to select the minimum you want
Select o.OrderID, o.OrderDate 
 From Northwind.dbo.Orders as o;
Select od.OrderID, od.ProductID, od.Quantity, od.UnitPrice as [OrderedPrice] 
 From Northwind.dbo.[Order Details] as od;
Select p.ProductID, p.ProductName, p.CategoryID, p.UnitPrice as [StandardPrice] 
 From Northwind.dbo.Products as p;
Select c.CategoryID, c.CategoryName 
 From Northwind.dbo.Categories as c;


-- 1c) Write code to identify the data types of the minimum you want
use Northwind;
go
Select TABLE_NAME, Column_Name, Data_Type, CHARACTER_MAXIMUM_LENGTH 
FROM [INFORMATION_SCHEMA].Columns 
Where table_name in ('Orders','Order Details','Products','Categories') 
 And COLUMN_NAME in ('OrderID', 'OrderDate','Quantity','UnitPrice'
                    ,'ProductID','ProductName','UnitPrice'
                    ,'CategoryID','CategoryName');
