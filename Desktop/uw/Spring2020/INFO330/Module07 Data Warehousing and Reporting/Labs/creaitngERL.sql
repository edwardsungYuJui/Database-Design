-- Step 1) Code used to Clear tables (Will be used with SSIS Execute SQL Tasks)
Use DWPubsSales;

--1b) Clear all tables data warehouse tables
Delete From dbo.FactSales;
Delete From dbo.DimTitles;
Delete From dbo.DimStores;
Go

-- Step 2) Code used to fill tables (Will be used with SSIS Data Flow Tasks)
Insert into DimStores
Select 
  [StoreId] = Cast(stor_id as nChar(4))
, [StoreName] = Cast(stor_name as nVarchar(100))
, [StoreState] = Cast(state as nChar(2))
From pubs.dbo.stores;
Go
Insert into DimTitles
Select 
  [TitleId] = t.title_id
, [TitleName] = Cast(t.title as nvarchar(100))
, [TitleType] = Cast(IIF([type] = 'UNDECIDED', 'undecided', [type] ) as nvarchar(100))
, [TitlePrice] = [price]
, [PublisherID] = p.pub_id
, [PublisherName] = p.pub_name
, [PublishedDate] = T.pubdate
From [Pubs].[dbo].[Titles] as T
Join [Pubs].[dbo].[Publishers] as P
	On T.[pub_id] = P.[pub_Id]
WHERE T.price is NOT NULL;
Go
Insert into FactSales
Select 
  [OrderNumber] = Cast(ord_num as nVarchar(50))
, [OrderDateKey] = Cast(ord_date as Date)
, [TitleID] = title_id
, [StoreID] = stor_id
, [SalesQuantity] = qty
From Pubs.dbo.Sales as s;
--Verify the tables are filled
Go
Select * From DimStores;
Select * From DimTitles;
Select * From FactSales;
Go

-- stored procedure
go 
Create Procedure pETLDeleteAllTables
/* Author: ESung
** Desc: Processes DEletions ETL
** Change Log: When,Who,What
** 2020-05-16,ESung,Created Sproc.
*/
As
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
    -- ETL Transaction Code --
	 -- Step 1) Clear Table 
     Delete From FactSales;
	 Delete From DimStores;
     Delete From DimTitles;
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   Rollback Transaction
   Print Error_Message();
   Set @RC = -1;
  End Catch
  Return @RC;
 End
go


go 
Create Procedure pETLFactSales
/* Author: ESung
** Desc: Processes FactSales ETL
** Change Log: When,Who,What
** 2020-05-16,ESung,Created Sproc.
*/
As
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
    -- ETL Transaction Code --
	 -- Step 1) Fill Table
    Insert into FactSales
    Select 
        [OrderNumber] = Cast(ord_num as nVarchar(50))
        , [OrderDateKey] = Cast(ord_date as Date)
        , [TitleID] = title_id
        , [StoreID] = stor_id
        , [SalesQuantity] = qty
    From Pubs.dbo.Sales as s;
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   Rollback Transaction
   Print Error_Message();
   Set @RC = -1;
  End Catch
  Return @RC;
 End
go
----Testing Code:
Declare @Status int;
Exec @Status = pETLFactSales;
Select @Status;
Select * From FactSales;
go


go 
Create Procedure pETLDimStores
/* Author: ESung
** Desc: Processes DimStores ETL
** Change Log: When,Who,What
** 2020-05-16,ESung,Created Sproc.
*/
As
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
    -- ETL Transaction Code --
	 -- Step 1) Fill Table
Insert into DimStores
Select 
  [StoreId] = Cast(stor_id as nChar(4))
, [StoreName] = Cast(stor_name as nVarchar(100))
, [StoreState] = Cast(state as nChar(2))
From pubs.dbo.stores;
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   Rollback Transaction
   Print Error_Message();
   Set @RC = -1;
  End Catch
  Return @RC;
 End
go


go
Create Procedure pETLDimTitles
/* Author: ESung
** Desc: Processes DimTitles ETL
** Change Log: When,Who,What
** 2020-05-16,ESung,Created Sproc.
*/
As
 Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction 
    -- ETL Transaction Code --
	 -- Step 1) Fill Table
Insert into DimTitles
Select 
  [TitleId] = t.title_id
, [TitleName] = Cast(t.title as nvarchar(100))
, [TitleType] = Cast(IIF([type] = 'UNDECIDED', 'undecided', [type] ) as nvarchar(100))
, [TitlePrice] = [price]
, [PublisherID] = p.pub_id
, [PublisherName] = p.pub_name
, [PublishedDate] = T.pubdate
From [Pubs].[dbo].[Titles] as T
Join [Pubs].[dbo].[Publishers] as P
	On T.[pub_id] = P.[pub_Id]
WHERE T.price is NOT NULL;
 Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
   Rollback Transaction
   Print Error_Message();
   Set @RC = -1;
  End Catch
  Return @RC;
 End
go

----Testing Code:
Declare @Status int;
Exec @Status = pETLDeleteAllTables;
Select @Status;
Select * From FactSales;
Select * From DimStores;
Select * From DimTitles;
go

Declare @Status int;
Exec @Status = pETLDimTitles;
Select @Status;
Select * From DimTitles;
go


Declare @Status int;
Exec @Status = pETLDimStores;
Select @Status;
Select * From DimStores;
go

Declare @Status int;
Exec @Status = pETLFactSales;
Select @Status;
Select * From FactSales;
go

 
