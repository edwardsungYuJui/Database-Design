--*************************************************************************--
-- Title: Mod06 Labs Database 
-- Author: ESung
-- Desc: This file demonstrates how to process data in a database
-- Change Log: When,Who,What
-- 2017-01-01,ESung,Created File
--**************************************************************************--
-- Step 1: Create the database
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

-- Step 2: Create the table
Create Table Categories
([CategoryID] [int] IDENTITY(1,1) NOT NULL 
,[CategoryName] [nvarchar](100) NOT NULL
);
go

-- Step 3: Create a base view for the table
Create View vCategories
As 
Select [CategoryID], [CategoryName]
From Categories;
go 


-- Step 4: Create an insert stored procedure
go
Create Procedure pInsCategories
(@CategoryName [nvarchar] (100))
/* Author: <ESung>
** Desc: Processes Inserts into Categories
** Change Log: When,Who,What
** 2020-05-06, ESung, Created Sproc.
*/
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
    -- Transaction Code --
    Insert Into Categories (CategoryName) Values (@CategoryName);
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go

-- Step 5: Test the View and Stored Procedure
/* Testing Code:
 Declare @Status int;
 Exec @Status = pInsCategories @CategoryName = 'Cat2';
 Print @Status;
 Select * From vCategories;
*/


-- Step 6: Set permissions
Deny Select, Insert, Update, Delete On Categories To Public;
Grant Select On vCategories To Public;
Grant Exec On pInsCategories To Public;

Create User webuser For Login webuser WITH DEFAULT_SCHEMA = dbo 