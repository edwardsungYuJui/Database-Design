--*************************************************************************--
-- Title: Module03_Lab06
-- Author: ESung
-- Desc: This file demonstrates how to process data in a database
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

-- Create Tables (Module 01)-- 
Create Table Categories
([CategoryID] [int] IDENTITY(1,1) NOT NULL 
,[CategoryName] [nvarchar](100) NOT NULL
);
go

Create Table Products
([ProductID] [int] IDENTITY(1,1) NOT NULL 
,[ProductName] [nvarchar](100) NOT NULL 
,[CategoryID] [int] NULL  
,[UnitPrice] [money] NOT NULL
);
go

 
-- Add Constraints (Module 02) -- 
Alter Table Categories 
 Add Constraint pkCategories 
  Primary Key (CategoryId);
go

Alter Table Categories 
 Add Constraint ukCategories 
  Unique (CategoryName);
go

Alter Table Products 
 Add Constraint pkProducts 
  Primary Key (ProductId);
go

Alter Table Products 
 Add Constraint ukProducts 
  Unique (ProductName);
go

Alter Table Products 
 Add Constraint fkProductsToCategories 
  Foreign Key (CategoryId) References Categories(CategoryId);
go

Alter Table Products 
 Add Constraint ckProductUnitPriceZeroOrHigher 
  Check (UnitPrice >= 0);
go

-- Show the Current data in the Categories, Products, and Inventories Tables
Select * from Categories;
go
Select * from Products;
go

--Step 2: Create SQL Transaction Statements
--Question 1: How would you add data to the Categories table?
Insert into Categories
(CategoryName)
Values
('CatA');
go 
Select * From Categories;
go

--Question 2: How would you add data to the Products table?
Insert into Products
(ProductName, CategoryID, UnitPrice)
Values
('ProdA', 1, 9.99);
go 
Select * From Products;
go

--Question 3: How would you update data in the Products table?
Update Products
Set UnitPrice = 5.99
Where ProductID = 1;
go
Select * From Products;

--Question 4: How would you delete data from the Categories table?
Delete 
From Products
Where ProductID = 1; 
go
Delete 
From Categories
Where CategoryID = 1;
go
Select * From Categories;