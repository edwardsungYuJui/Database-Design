--*************************************************************************--
-- Title: Mod05 Labs Database 
-- Author: Edward Sung
-- Desc: This file demonstrates how to process data in a database
-- Change Log: When,Who,What
-- 2017-01-01,Edward Sung,Created File
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

-- Step 2: Create SQL Transaction Statements
-- NOTE: This is the same lab we did in Module 3, but this time make sure to add the Begin, 
-- Commit, and Rollback transaction statements with your Try-Catch block!
-- Question 1: How would you add data to the Categories table?
Begin Try 
    Begin Tran 
        Insert Into Categories (CategoryName) Values ('Cat1'); -- cant do ID cuz it is identity
    Commit Tran
End Try 
Begin Catch 
    Print 'Insert Failed'
    Print Error_Message()
    Rollback Tran 
End Catch 
go 
Select * From Categories

-- Question 2: How would you add data to the Products table?
Begin Try 
    Begin Tran 
        Insert Into Products (ProductName, UnitPrice, CategoryID) 
        Values ('Prod1', 1.99, 1); 
    Commit Tran
End Try 
Begin Catch 
    Print 'Insert Failed'
    Print Error_Message()
    Rollback Tran 
End Catch 
go 
Select * From Products

-- Question 3: How would you update data in the Products table?
Begin Try 
    Begin Tran 
        -- transaction code
        Update Products Set UnitPrice = 4.99 Where ProductID = 1;
        If(@@Rowcount > 1) RAISERROR('Do not change more than one row!', 15, 1);
    Commit Tran
End Try 
Begin Catch 
    Print 'Update Failed'
    Print Error_Message()
    Rollback Tran 
End Catch 
go 
Select * From Products

-- Question 4: How would you delete data from the Categories table?
Begin Try 
    Begin Tran 
        -- transaction code
        Delete From Products Where CategoryID = 1;
        Delete From Categories Where CategoryID = 1;
        If(@@Rowcount > 1) RAISERROR('Do not change more than one row!', 15, 1);
    Commit Tran
End Try 
Begin Catch 
    Print 'Delete Failed'
    Print Error_Message()
    Rollback Tran 
End Catch 
go 
Select * From Categories;
Select * From Products;

-- Question 1: Select the Category Id and Category Name of the Category 'Seafood'.

-- Question 2:  Select the Product Id, Product Name, and Product Price 
-- of all Products with the Seafood's Category Id. Ordered By the Products Price
-- highest to the lowest 

-- Question 3:  Select the Product Id, Product Name, and Product Price 
-- Ordered By the Products Price highest to the lowest. 
-- Show only the products that have a price greater than $100. 

-- Question 4: Select the CATEGORY NAME, product name, and Product Price 
-- from both Categories and Products. Order the results by Category Name 
-- and then Product Name, highest to the lowest
-- (Hint: Join Products to Category)

-- Question 5: Select the Category Name, Product Name, and Product Price 
-- from both Categories and Products. Order the results by price highest to lowest.
-- Show only the products that have a PRICE FROM $10 TO $20. 
