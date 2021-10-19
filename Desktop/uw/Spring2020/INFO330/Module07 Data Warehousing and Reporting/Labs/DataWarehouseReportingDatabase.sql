Use [master];
go
If Exists(Select Name from SysDatabases Where Name = 'DWPubsSales')
 Begin 
  Alter Database DWPubsSales Set Single_user With Rollback Immediate;
  Drop Database DWPubsSales;
 End
go
Create Database DWPubsSales;
go
Use DWPubsSales;
go
/****** Create the Dimension Tables ******/
Create Table [dbo].[DimStores](
	[StoreId] [nchar](4) NOT NULL Primary Key,
	[StoreName] [nvarchar](100) NOT NULL,
	[StoreState] [nChar](2) NOT NULL);
go
Create Table [dbo].[DimTitles](
	[TitleId] [nvarchar](6) Primary Key NOT NULL,
	[TitleName] [nvarchar](100) NOT NULL,
	[TitleType] [nvarchar](100) NOT NULL,
	[TitlePrice] Money NOT NULL,
       [PublisherID] int NOT NULL,
       [PublisherName] [nvarchar](100) NOT NULL,
       [PublishedDate] [date] NOT NULL);
go
/****** Create the Fact Tables ******/
Create Table [dbo].[FactSales](
	[OrderNumber] [nvarchar](100) NOT NULL,
	[OrderDate] [date] NOT NULL,
	[TitleID] [nvarchar](6) NOT NULL,
	[StoreID] [nchar](4) NOT NULL,
	[SalesQuantity] [int] NOT NULL, -- Measure
       Constraint [PK_FactSales] Primary Key 
	([OrderNumber] ASC, [OrderDate] ASC, [TitleID] ASC, [StoreID] ASC));
go
/****** Add Foreign Keys ******/
Alter Table [dbo].[FactSales] With Check Add Constraint [FK_FactSales_DimStores] 
  Foreign Key ([StoreID]) References [dbo].[DimStores] ([StoreID]);
go
Alter Table [dbo].[FactSales] With Check Add Constraint [FK_FactSales_DimTitles] 
  Foreign Key ([TitleID]) References [dbo].[DimTitles] ([TitleID]);
go
