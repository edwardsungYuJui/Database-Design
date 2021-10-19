-- Step 1: Create Tables 
-- Use the following SQL code to create a reporting table in your Mod05Labs_YouNameHere database.
-- Create Database MyLabsDB_RRoot; -- As Needed
go
Use MyLabsDB_ESung; 
go
Create -- Drop
TABLE [dbo].[DimProducts](
	[ProductKey] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[ProductID] [int] NOT NULL,
	[ProductName] [nvarchar](100) NOT NULL,
	[ProductCategoryName] [nvarchar](100) NOT NULL,
	[ProductStdPriceUSD] [nvarchar](100) NOT NULL,
	[ProductIsDiscontinued] [nchar](1) NOT NULL -- ('y or n')
)

-- Step 2: Create and Test Transformation Code
-- Test the following SQL transformation code and note what is does.
Declare @BitTest bit = 1, @DecimalTest money = $1.99;
Select iif(@BitTest = 0, 'y', 'n'); -- Convert Bit to Character
Select Format(@DecimalTest, 'C', 'en-us'); -- Convert Character with $

-- Step 3: Create an ETL Stored Procedure
--Create and test an ETL stored procedure that will delete all the data in the DimProducts Reporting table 
-- and fill it with the transformed data from the Northwind.dbo.Products table.
go 
Delete From DimProducts; -- Clear table of current data
go
Insert Into DimProducts
(ProductID, ProductName, ProductCategoryName, ProductStdPriceUSD, ProductIsDiscontinued)
Select 
 ProductID = ProductId
,ProductName = Cast(ProductName as nvarchar(100))-- Convert to nVarchar(100)
,ProductCategoryName = cast(CategoryName as nvarchar(100))-- Convert to nVarchar(100)
,ProductStdPrice = Format(UnitPrice, 'C', 'en-us')-- Convert to nVarchar(100) with $
,ProductIsDiscontinued = iif(Discontinued = 0, 'n', 'y')-- Convert to character ('y' or 'n')
From Northwind.dbo.Products as p Join Northwind.dbo.Categories as c
 On p.CategoryID = c.CategoryID



go 

Create -- Drop
Procedure pETLDimProducts
/* Author: ESung
** Desc: Processes Flush and Fill ETL on DimProducts
** Change Log: When,Who,What
** 2020-05-10,ESung,Created Sproc.
*/
AS
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
    -- Transaction Code --

     -- Step 1: Clear the Old Data
      Delete From DimProducts; -- Clear table of current data

     -- Step 2: Load Current Data
    Insert Into DimProducts
    (ProductID, ProductName, ProductCategoryName, ProductStdPriceUSD, ProductIsDiscontinued)
    Select 
        ProductID = ProductId
        ,ProductName = Cast(ProductName as nvarchar(100))-- Convert to nVarchar(100)
        ,ProductCategoryName = cast(CategoryName as nvarchar(100))-- Convert to nVarchar(100)
        ,ProductStdPrice = Format(UnitPrice, 'C', 'en-us')-- Convert to nVarchar(100) with $
        ,ProductIsDiscontinued = iif(Discontinued = 0, 'n', 'y')-- Convert to character ('y' or 'n')
    From Northwind.dbo.Products as p Join Northwind.dbo.Categories as c
    On p.CategoryID = c.CategoryID


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
Exec pETLDimProducts;
go
Select * From DimProducts; 
