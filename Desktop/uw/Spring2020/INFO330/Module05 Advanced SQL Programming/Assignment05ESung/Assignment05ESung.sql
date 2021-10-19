--*************************************************************************--
-- Title: Assignment05
-- Author: ESung
-- Desc: This file demonstrates how to process data in a database
-- Change Log: When,Who,What
-- 2020-05-03,ESung,Created File
--**************************************************************************--
-- Step 1: Create the assignment database
Use Master;
go

-- Drop database if there is one exists 
If Exists(Select Name from SysDatabases Where Name = 'Assignment05DB_ESung')
 Begin 
  Alter Database [Assignment05DB_ESung] set Single_user With Rollback Immediate;
  Drop Database Assignment05DB_ESung;
 End
go

Create Database Assignment05DB_ESung;
go

-- use the one we creates
Use Assignment05DB_ESung;
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

Create Table Inventories
([InventoryID] [int] IDENTITY(1,1) NOT NULL
,[InventoryDate] [Date] NOT NULL
,[ProductID] [int] NOT NULL
,[Count] [int] NOT NULL
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

Alter Table Inventories 
 Add Constraint pkInventories 
  Primary Key (InventoryId);
go

Alter Table Inventories
 Add Constraint dfInventoryDate
  Default GetDate() For InventoryDate;
go

Alter Table Inventories
 Add Constraint fkInventoriesToProducts
  Foreign Key (ProductId) References Products(ProductId);
go

Alter Table Inventories 
 Add Constraint ckInventoryCountZeroOrHigher 
  Check ([Count] >= 0);
go


-- Show the Current data in the Categories, Products, and Inventories Tables
Select * from Categories;
go
Select * from Products;
go
Select * from Inventories;
go

-- Step 2: Add some starter data to the database
/* Add the following data to this database using inserts:
Category	Product	Price	Date		Count
Beverages	Chai	18.00	2017-01-01	61
Beverages	Chang	19.00	2017-01-01	17

Beverages	Chai	18.00	2017-02-01	13
Beverages	Chang	19.00	2017-02-01	12

Beverages	Chai	18.00	2017-03-02	18
Beverages	Chang	19.00	2017-03-02	12
*/
-- inserts once since there are repetitions
Insert into Categories 
Values ('Beverages');
go
Insert into Products
Values ('Chai', @@IDENTITY, 18.00),
       ('Chang', @@IDENTITY, 19.00);
go
Insert into Inventories
Values ('2017-01-01', 1, 61),
       ('2017-01-01', 2, 17),
       ('2017-02-01', 1, 13),
       ('2017-02-01', 2, 12),
       ('2017-03-02', 1, 18),
       ('2017-03-02', 2, 12);
go 

-- Step 3: Create transactional stored procedures for each table using the proviced template:

/* 
Logic: Insert, Update, Delete
*/

-----------------------------Categories--------------------------------
Create Procedure pInsCategories
(@CategoryName nvarchar(100))
/* Author: ESung
** Desc: Processes Inserts for Categories Table
** Change Log: When,Who,What
** <2020-05-04>,ESung,Created stored procedure.
*/
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
    -- Transaction Code --
    Insert Into Categories (CategoryName) 
    Values (@CategoryName);
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go
--Temp Testing Code
/*
Temp Testing Code
 Declare @Status int;
 Exec @Status = pInsCategories @CategoryName = '1';
 Print @Status;
 Select * From Categories;
*/

Create Procedure pUpdCategories
(@CategoryID int, @CategoryName nvarchar(100))
/* Author: ESung
** Desc: Processes Updates for Categories Table
** Change Log: When,Who,What
** <2020-05-02>,ESung,Created Sproc.
*/
AS
 Begin -- Body
  Declare @RC int = 0;
  Begin Try
   Begin Transaction; 
    -- Transaction Code --
    Update Categories Set CategoryName = @CategoryName 
    Where CategoryID = @CategoryID
   Commit Transaction;
   Set @RC = +1;
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction;
   Print Error_Message();
   Set @RC = -1
  End Catch
  Return @RC;
 End -- Body
go
--Temp Testing Code
/*
 Declare @Status int;
 Exec @Status = pUpdCategories @CategoryID = 1, @CategoryName = 'Cat1A';
 Print @Status;
 Select * From Categories;
*/

Create Procedure pDelCategories
(@CategoryID int, @CategoryName nvarchar(100))
/* Author: ESung
** Desc: Processes Deletes for Categories Table
** Change Log: When,Who,What
** <2020-05-02>,ESung,Created Sproc.
*/
AS
 Begin -- Body
  Declare @RC int = 0;
  Begin Try
   Begin Transaction; 
    -- Transaction Code --
    Delete From Categories 
    Where CategoryID = @CategoryID
   Commit Transaction;
   Set @RC = +1;
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction;
   Print Error_Message();
   Set @RC = -1
  End Catch
  Return @RC;
 End -- Body
go
--Temp Testing Code
/*
 Declare @Status int;
 Exec @Status = pDelCategories @CategoryID = 1, @CategoryName = 'Cat1A';
 Print @Status;
 Select * From Categories;
*/


-----------------------------Products--------------------------------
Create Procedure pInsProducts
(@ProductName nvarchar(100), @CategoryID int, @UnitPrice Money)
/* Author: ESung
** Desc: Processes Inserts for Products Table
** Change Log: When,Who,What
** <2020-05-04>,ESung,Created stored procedure.
*/
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
    -- Transaction Code --
    Insert Into Products(ProductName, CategoryID, UnitPrice) 
	  Values (@ProductName, @CategoryID, @UnitPrice);
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go
--Temp Testing Code
/*
 Declare @Status int;
 Exec @Status = pInsProducts @ProductName = 'ProdA', @CategoryID = '1', @UnitPrice = 9.99;
 Print @Status;
 Select * From Products;
*/

Create Procedure pUpdProducts
(@ProductID int, @ProductName nvarchar(100), @CategoryID int, @UnitPrice Money)
/* Author: ESung
** Desc: Processes Updates for Products Table
** Change Log: When,Who,What
** <2020-05-04>,ESung,Created Sproc.
*/
AS
 Begin -- Body
  Declare @RC int = 0;
  Begin Try
   Begin Transaction; 
    -- Transaction Code --
    Update Products 
	  Set ProductName = @ProductName, 
	      CategoryID = @CategoryID,
		    UnitPrice = @UnitPrice 
	  Where ProductID = @ProductID
   Commit Transaction;
   Set @RC = +1;
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction;
   Print Error_Message();
   Set @RC = -1
  End Catch
  Return @RC;
 End -- Body
go
--Temp Testing Code
/*
 Declare @Status int;
 Exec @Status = pUpdProducts @ProductID = 1, @ProductName = 'ProdAB', @CategoryID = '1', @UnitPrice = 19.99;
 Print @Status;
 Select * From Products;
*/

Create Procedure pDelProducts
(@ProductID int)
/* Author: ESung
** Desc: Processes Deletes for Products Table
** Change Log: When,Who,What
** <2020-05-04>,ESung,Created Sproc.
*/
AS
 Begin -- Body
  Declare @RC int = 0;
  Begin Try
   Begin Transaction; 
    -- Transaction Code --
    Delete From Products 
    Where ProductID = @ProductID;
   Commit Transaction;
   Set @RC = +1;
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction;
   Print Error_Message();
   Set @RC = -1
  End Catch
  Return @RC;
 End -- Body
go
--Temp Testing Code
/*
 Declare @Status int;
 Exec @Status = pDelProducts @ProductID = 2;
 Print @Status;
 Select * From Products;
*/

-----------------------------Inventories--------------------------------
Create Procedure pInsInventories
(@InventoryDate Date, @ProductID int, @Count int)
/* Author: ESung
** Desc: Processes Inserts for Products Table
** Change Log: When,Who,What
** <2020-05-04>,ESung,Created stored procedure.
*/
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
    -- Transaction Code --
    Insert Into Inventories(InventoryDate, ProductID, [Count]) 
	  Values (@InventoryDate, @ProductID, @Count);
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go
--Temp Testing Code
/*
 Declare @Status int;
 Exec @Status = pInsInventories @InventoryDate = '2017-01-05', @ProductID = '1', @Count = 2;
 Print @Status;
 Select * From Inventories;
*/

Create Procedure pUpdInventories
(@InventoryID int, @InventoryDate Date, @ProductID int, @Count int)
/* Author: ESung
** Desc: Processes Updates for Products Table
** Change Log: When,Who,What
** <2020-05-04>,ESung,Created Sproc.
*/
AS
 Begin -- Body
  Declare @RC int = 0;
  Begin Try
   Begin Transaction; 
    -- Transaction Code --
    Update Inventories 
	  Set InventoryDate = @InventoryDate, 
	      ProductID = @ProductID,
		    [Count] = @Count
	  Where InventoryID = @InventoryID
   Commit Transaction;
   Set @RC = +1;
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction;
   Print Error_Message();
   Set @RC = -1
  End Catch
  Return @RC;
 End -- Body
go
--Temp Testing Code
/*
 Declare @Status int;
 Exec @Status = pUpdInventories @InventoryID = '1', @InventoryDate = '2018-01-08', @ProductID = '1', @Count = 20;
 Print @Status;
 Select * From Inventories;
*/

Create Procedure pDelInventories
(@InventoryID int)
/* Author: ESung
** Desc: Processes Deletes for Products Table
** Change Log: When,Who,What
** <2020-05-04>,ESung,Created Sproc.
*/
AS
 Begin -- Body
  Declare @RC int = 0;
  Begin Try
   Begin Transaction; 
    -- Transaction Code --
    Delete From Inventories 
    Where InventoryID = @InventoryID;
   Commit Transaction;
   Set @RC = +1;
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction;
   Print Error_Message();
   Set @RC = -1
  End Catch
  Return @RC;
 End -- Body
go
--Temp Testing Code
/*
 Declare @Status int;
 Exec @Status = pDelInventories @InventoryID = 2;
 Print @Status;
 Select * From Inventories;
*/

-- Step 4: Create code to test each transactional stored procedure. 

-------------------------Insert-------------------------
Declare @Status int;
Exec @Status = pInsCategories @CategoryName = 'CatA';
Select Case @Status
  When +1 Then 'Insert was successful!'
  When -1 Then 'Insert failed! Common Issues: Duplicate Data'
  End as [Status]
Select [The New ID Was:] = @@IDENTITY
Select * From Categories;
go 

Declare @Status int;
Declare @NewCategoryID int = IDENT_CURRENT('Categories');
Exec @Status = pInsProducts @ProductName = 'ProdA', @CategoryID = @NewCategoryID, @UnitPrice = 9.00;
Select Case @Status
  When +1 Then 'Insert was successful!'
  When -1 Then 'Insert failed! Common Issues: Duplicate Data'
  End as [Status]
Select [The New ID Was:] = @@IDENTITY
Select * From Products;
go

Declare @Status int;
Declare @NewProductID int = IDENT_CURRENT('Products')
Exec @Status = pInsInventories @InventoryDate = '2018-01-04', @ProductID = @NewProductID, @Count = 10;
Select Case @Status
  When +1 Then 'Insert was successful!'
  When -1 Then 'Insert failed! Common Issues: Duplicate Data'
  End as [Status]
Select [The New ID Was:] = @@IDENTITY
Select * From Inventories;
go  

-------------------------Update-------------------------
Declare @Status int;
Declare @NewCategoryID int = IDENT_CURRENT('Categories');
Exec @Status = pUpdCategories @CategoryID = @NewCategoryID, @CategoryName = 'CatAB';
Select Case @Status
  When +1 Then 'Update was successful!'
  When -1 Then 'Update failed! Common Issues: Check Values'
  End as [Status]
Select * From Categories;
go

Declare @Status int;
Declare @NewCategoryID int = IDENT_CURRENT('Categories');
Declare @NewProductID int = IDENT_CURRENT('Products');
Exec @Status = pUpdProducts @ProductID = @NewProductID, 
							@ProductName = 'ProdAB',
							@CategoryID = @NewCategoryID,
							@UnitPrice = 1.00;

Select Case @Status
  When +1 Then 'Update was successful!'
  When -1 Then 'Update failed! Common Issues: Check Values'
  End as [Status]
Select * From Products;
go

Declare @Status int;
Declare @NewProductID int = IDENT_CURRENT('Products');
Declare @NewInventoryID int = IDENT_CURRENT('Inventories');
Exec @Status = pUpdInventories @InventoryID = @NewInventoryID, 
							@InventoryDate = '2018-01-21',
							@ProductID = @NewProductID,
							@Count = 20;
Select Case @Status
  When +1 Then 'Update was successful!'
  When -1 Then 'Update failed! Common Issues: Check Values'
  End as [Status]
Select * From Inventories;
go
-------------------------Delete-------------------------
Declare @Status int;
Declare @NewInventoryID int = IDENT_CURRENT('Inventories');
Exec @Status = pDelInventories @InventoryID = @NewInventoryID;
Select Case @Status
  When +1 Then 'Delete was successful!'
  When -1 Then 'Delete failed! Common Issues: Foreign Key Values must be deleted first'
  End as [Status]
Select * From Inventories;
go

-- Delete Products should go before Categories since 
-- there are foreign key constraints
Declare @Status int;
Declare @NewProductID int = IDENT_CURRENT('Products');
Exec @Status = pDelProducts @ProductID = @NewProductID;
Select Case @Status
  When +1 Then 'Delete was successful!'
  When -1 Then 'Delete failed! Common Issues: Foreign Key Values must be deleted first'
  End as [Status]
Select * From Products;
go

Declare @Status int;
Declare @NewCategoryID int = IDENT_CURRENT('Categories');
Declare @NewCategoryName nvarchar(100) = IDENT_CURRENT('Categories');
Exec @Status = pDelCategories @CategoryID = @NewCategoryID, @CategoryName = @NewCategoryName;
Select Case @Status
  When +1 Then 'Delete was successful!'
  When -1 Then 'Delete failed! Common Issues: Foreign Key Values must be deleted first'
  End as [Status]
Select * From Categories;
go