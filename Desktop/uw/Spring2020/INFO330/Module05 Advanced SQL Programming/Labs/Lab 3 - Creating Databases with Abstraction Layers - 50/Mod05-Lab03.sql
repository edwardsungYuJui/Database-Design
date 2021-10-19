--*************************************************************************--
-- Title: Module05-Lab03
-- Author: ESung
-- Desc: This file demonstrates how to create transaction stored procedures
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
,[UnitPrice] [mOney] NOT NULL
);
go

-- Add Constraints (Module 02) -- 
Begin  -- Categories
	Alter Table Categories 
	 Add Constraint pkCategories 
	  Primary Key (CategoryId);

	Alter Table Categories 
	 Add Constraint ukCategories 
	  Unique (CategoryName);
End
go 

Begin -- Products
	Alter Table Products 
	 Add Constraint pkProducts 
	  Primary Key (ProductId);

	Alter Table Products 
	 Add Constraint ukProducts 
	  Unique (ProductName);

	Alter Table Products 
	 Add Constraint fkProductsToCategories 
	  Foreign Key (CategoryId) References Categories(CategoryId);

	Alter Table Products 
	 Add Constraint ckProductUnitPriceZeroOrHigher 
	  Check (UnitPrice >= 0);
End
go

--Step 1: Review the Lab Database
--Show the current data in the Categories, Products and Inventories Tables
Select * From Categories;
go
Select * From Products;
go


--Step 2: Create SQL Transaction Stored Procedures
--Use the provided stored procedure template to create one insert, 
--one update, and one delete stored procedure for the Products table 
--(as you did with the Categories table in Lab 2).
-- Category Sprocs

Create Procedure pInsCategories
(@CategoryName nvarchar(100))
/* Author: ESung
** Desc: Processes Inserts for Categories Table
** Change Log: When,Who,What
** <2020-05-02>,ESung,Created Sproc.
*/
AS
 Begin -- Body
  Declare @RC int = 0;
  Begin Try
   Begin Transaction; 
    -- Transaction Code --
    Insert Into Categories (CategoryName) Values (@CategoryName);
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
/*
 Declare @Status int;
 Exec @Status = pInsCategories @CategoryName = 'Cat1';
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
    Update Categories Set CategoryName = @CategoryName Where CategoryID = @CategoryID
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
    Delete From Categories Where CategoryID = @CategoryID
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

/*
 Declare @Status int;
 Exec @Status = pDelCategories @CategoryID = 1
 Print @Status;
 Select * From Categories;
*/

Exec sp_help Categories;
go
Exec sp_help Products;
go 

-- Product Spocs 
Create Procedure pInsProducts
(@ProductName nvarchar(100), @CategoryID int, @UnitPrice Money)
/* Author: ESung
** Desc: Processes Inserts for Products Table
** Change Log: When,Who,What
** <2020-05-02>,ESung,Created Sproc.
*/
AS
 Begin -- Body
  Declare @RC int = 0;
  Begin Try
   Begin Transaction; 
    -- Transaction Code --
    Insert Into Products(ProductName, CategoryID, UnitPrice) 
	Values (@ProductName, @CategoryID, @UnitPrice);
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
** <2020-05-02>,ESung,Created Sproc.
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
** <2020-05-02>,ESung,Created Sproc.
*/
AS
 Begin -- Body
  Declare @RC int = 0;
  Begin Try
   Begin Transaction; 
    -- Transaction Code --
    Delete From Products Where ProductID = @ProductID;
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
/*
 Declare @Status int;
 Exec @Status = pDelProducts @ProductID = 2;
 Print @Status;
 Select * From Products;
*/


--Step 3: Test the Transaction Stored Procedures 
--Modify and use formal testing code to test your stored procedures.
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
Declare @NewCategoryID int = IDENT_CURRENT('Categories');
Exec @Status = pUpdCategories @CategoryID = @NewCategoryID, @CategoryName = 'CatAB';
Select Case @Status
  When +1 Then 'Insert was successful!'
  When -1 Then 'Insert failed! Common Issues: Duplicate Data'
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
Exec @Status = pDelProducts @ProductID = @NewProductID;
Select Case @Status
  When +1 Then 'Update was successful!'
  When -1 Then 'Update failed! Common Issues: Check Values'
  End as [Status]
Select * From Products;
go

Declare @Status int;
Declare @NewID int = IDENT_CURRENT('Categories');
Exec @Status = pDelCategories @CategoryID = @NewID;
Select Case @Status
  When +1 Then 'Delete was successful!'
  When -1 Then 'Delete failed! Common Issues: Foreign Key Values must be deleted first'
  End as [Status]
Select * From Categories;
go