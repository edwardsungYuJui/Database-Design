--*************************************************************************--
-- Title: Module04-Lab02
-- Author: ESung
-- Desc: This file demonstrates how to select data from a database
-- Change Log: When,Who,What
-- 2017-01-01,ESung,Created File
--**************************************************************************--
/*
In this lab, you create views using Northwind database. 
You will work on your own for the first 10 minutes, then we will review the answers together in the last 10 minutes. 
Note: This lab can be done individually or with a group of up to 3 people. 
*/

--Step 1: Review Database Tables
--Run the following code in a SQL query editor and review the names of the tables you have to work with.

Select * From Northwind.Sys.Tables Where type = 'u' Order By Name;

-- Step 2: Create a Lab Database
-- Create new database for this lab called MyLabsDB_ESung (using your own name, of course!) Modify and use the follow code to accomplish this:

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
   
-- Step 3: Create a Query
-- Answer the following questions by writing and executing SQL code.

-- Question 1: How can you create a view to show a list of customers names and their locations? Call the view vCustomersByLocation.
Select * From Northwind.dbo.Customers;
go 
Select CompanyName, [Address], City, IsNull(Region, Country), PostalCode, Country 
From Northwind.dbo.Customers;
go 

Create or Alter View vCustomersByLocation
As 
Select [CustomerName] = CompanyName, City, [Region] = IsNull(Region, Country), Country 
From Northwind.dbo.Customers;
go 

Select * From vCustomersByLocation Order By CustomerName;
go 

-- Question 2: How can you create a view to show a list of customers names, their locations, and the number 
-- of orders they have placed (hint: use the count() function)? Call the view vNumberOfCustomerOrdersByLocation.
Select * From Northwind.dbo.Orders Order By CustomerID
go 
Select * From Northwind.dbo.Orders as o 
Join Northwind.dbo.Customers as c 
    On o.CustomerID = c.CustomerID
Order By c.CustomerID;
go 
Select [CustomerName] = CompanyName, City, [Region] = IsNull(Region, Country), Country 
From Northwind.dbo.Orders as o 
Join Northwind.dbo.Customers as c 
    On o.CustomerID = c.CustomerID
Order By c.CustomerID;
go 

Create or Alter View vNumberOfCustomerOrdersByLocation
As 
Select [CustomerName] = CompanyName, City, 
[Region] = IsNull(Region, Country), Country,
[NumberOfOrder] = Count(o.OrderID) 
From Northwind.dbo.Orders as o 
Join Northwind.dbo.Customers as c 
    On o.CustomerID = c.CustomerID
Group By CompanyName, City, IsNull(Region, Country), Country-- Group By always go before Order By 
go 

Select * From vNumberOfCustomerOrdersByLocation Order By CustomerName;
go 

-- Question 3: How can you create a view to show a list of customers names, their locations, and the number 
-- of orders they have placed (hint: use the count() function) on an given year (hint: use the year() function)? 
-- Call the view vNumberOfCustomerOrdersByLocationAndYears.
Create or Alter View vNumberOfCustomerOrdersByLocationAndYears
As 
Select [CustomerName] = CompanyName, City, 
[Region] = IsNull(Region, Country), Country,
[NumberOfOrder] = Count(o.OrderID)
,[OrderYear] = Year(o.OrderDate)
From Northwind.dbo.Orders as o 
Join Northwind.dbo.Customers as c 
    On o.CustomerID = c.CustomerID
Group By CompanyName, City, IsNull(Region, Country), Country, Year(o.OrderDate)-- Group By always go before Order By 
go 

Select * From vNumberOfCustomerOrdersByLocationAndYears
-- Step 4: Review Your Work
-- Now, you will review your work with your instructor.