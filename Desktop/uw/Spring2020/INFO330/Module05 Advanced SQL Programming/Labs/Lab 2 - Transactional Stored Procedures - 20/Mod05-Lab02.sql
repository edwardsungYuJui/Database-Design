--*************************************************************************--
-- Title: Module05-Lab02
-- Author: Edward Sung
-- Desc: This file demonstrates how to select data from a database with Sprocs
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


-- Use the provided stored procedure template to create code answering the following questions.

-- Question 1: How would you add data to the Categories table using a store procedure?
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
 Exec @Status = pInsCategories @CategoryName = '1';
 Print @Status;
 Select * From Categories;
*/

-- Question 2: How would you update data in the Categories table using a store procedure?
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

-- Question 3: How would you delete data from the Categories table using a store procedure?
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
 Exec @Status = pDelCategories @CategoryID = 1, @CategoryName = 'Cat1A';
 Print @Status;
 Select * From Categories;
*/

Set NOCOUNT On 


Declare @Status int;
Exec @Status = pInsCategories @CategoryName = 'CatB';
Select Case @Status
  When +1 Then 'Insert was successful!'
  When -1 Then 'Insert failed! Common Issues: Duplicate Data'
  End as [Status]
Select [The New ID Was:] = @@IDENTITY
Select * From Categories;
go 

Declare @Status int;
Declare @NewID int = IDENT_CURRENT('Categories')
Exec @Status = pUpdCategories @CategoryID = @NewID, @CategoryName = 'CatB1';
Select Case @Status
  When +1 Then 'Update was successful!'
  When -1 Then 'Update failed! Common Issues: Check Values'
  End as [Status]
Select * From Categories;
go 

Declare @Status int;
Declare @NewID int = IDENT_CURRENT('Categories')
Exec @Status = pDelCategories @CategoryID = @NewID, @CategoryName = 'CatB1';
Select Case @Status
  When +1 Then 'Delete was successful!'
  When -1 Then 'Delete failed! Common Issues: Foreign Key Values must be deleted first'
  End as [Status]
Select * From Categories;
go 




