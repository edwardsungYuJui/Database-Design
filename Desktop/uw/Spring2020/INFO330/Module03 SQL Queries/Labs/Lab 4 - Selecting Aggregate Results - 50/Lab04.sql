--*************************************************************************--
-- Title: Module03_Lab04
-- Author: ESung
-- Desc: This file demonstrates how to select data from a database
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

Insert Into Categories 
(CategoryName)
Select CategoryName 
 From Northwind.dbo.Categories
 Order By CategoryID;
go

Insert Into Products
(ProductName, CategoryID, UnitPrice)
Select ProductName,CategoryID, UnitPrice 
 From Northwind.dbo.Products
  Order By ProductID;
go

Insert Into Inventories
(InventoryDate, ProductID, [Count])
Select '20170101' as InventoryDate, ProductID, ABS(CHECKSUM(NewId())) % 100 as RandomValue
From Northwind.dbo.Products
UNION
Select '20170201' as InventoryDate, ProductID, ABS(CHECKSUM(NewId())) % 100 as RandomValue
From Northwind.dbo.Products
UNION
Select '20170302' as InventoryDate, ProductID, ABS(CHECKSUM(NewId())) % 100 as RandomValue
From Northwind.dbo.Products
Order By 1, 2
go

-- Show all of the data in the Categories, Products, and Inventories Tables
Select * from Categories;
go
Select * from Products;
go
Select * from Inventories;
go

--Step 2: Create Some Queries
--Answer the following questions by writing and executing SQL code. We start with some review questions to get you warmed up, and then move on to new ones!
--Notes: 
--The following image is what your results should look like.
--Quantities may vary, since I use a random function to create the data!
--Make sure your code is well formatted, consistent, and produces the same result!

--Question 1: Select the Category Id and Category Name of the Category 'Seafood'.
Use Northwind;
go
Select * From Categories;
go 
Select c.CategoryID, c.CategoryName 
From Categories as c 
Where CategoryName = 'Seafood'; 

--Question 2:  Select the Product Id, Product Name, and Product Price of all Products with the Seafood's 
--Category Id. Ordered By the Products Price highest to the lowest 
Select p.ProductID, p.ProductName, p.UnitPrice 
From Products as p
Where p.CategoryID = (Select CategoryID From Categories Where CategoryName = 'Seafood') -- or p.CategoryID = 8
Order by p.UnitPrice Desc;
go 

--Question 3:  Select the Product Id, Product Name, and Product Price Ordered By the Products 
--Price highest to the lowest. Show only the products that have a price Less than $20. 
Select p.ProductID, p.ProductName, p.UnitPrice 
From Products as p
Order by p.UnitPrice Desc;
go 
Select p.ProductID, p.ProductName, p.UnitPrice 
From Products as p
Where p.UnitPrice < 20
Order by p.UnitPrice Desc;
go 

--Question 4: Select the CATEGORY NAME, product name, and Product Price from both 
--Categories and Products. Order the results by Category Name and then Product Name, 
--in alphabetical order. (Hint: Join Products to Category)
Select c.CategoryName, p.ProductName, p.UnitPrice 
From Products as p
Join Categories as c
  On p.CategoryID = c.CategoryID
Order by c.CategoryName, p.ProductName ;
go 

--Question 5: Select the Product Id and Number of Products in Inventory for the Month of JANUARY. 
--Order the results by the ProductIDs. 
--(Note: Quantities may vary, since I use a random function to create the data!)
Use MyLabsDB_ESung;
go
Select * From Inventories;
go 
Select ProductID, [Count] From Inventories;
go 
Select ProductID, [Count] -- i.InventoryDate -- for testing
From Inventories as i 
Where Month(i.InventoryDate) = 1;
go 

--Question 6: Select the Category Name, Product Name, and Product Price from 
--both Categories and Products. Order the results by price highest to lowest. 
--Show only the products that have a PRICE FROM $10 TO $20. 
Select c.CategoryName, p.ProductName, p.UnitPrice 
From Products as p
Join Categories as c
  On p.CategoryID = c.CategoryID
Order by c.CategoryName, p.ProductName ;
go 
Select c.CategoryName, p.ProductName, p.UnitPrice 
From Products as p
Join Categories as c
  On p.CategoryID = c.CategoryID
Order by p.UnitPrice Desc;
go 
Select c.CategoryName, p.ProductName, p.UnitPrice 
From Products as p
Join Categories as c
  On p.CategoryID = c.CategoryID
Where p.UnitPrice Between 10 and 20
Order by p.UnitPrice Desc;
go 

--Question 7: Select the Product Id and Number of Products in Inventory for the Month of JANUARY. 
--Order the results by the ProductIDs and where the ProductID are only the ones in the seafood category 
--(Hint: Use a subquery to get the list of productIds with a category ID of 8)
--(Note: Quantities may vary, since I use a random function to create the data!)
Select ProductID, [Count] -- i.InventoryDate -- for testing
From Inventories as i 
Where Month(i.InventoryDate) = 1;
go 
Select ProductID, [Count] -- i.InventoryDate -- for testing
From Inventories as i 
Where Month(i.InventoryDate) = 1
Order By i.ProductID;
go 
Select ProductID, [Count] -- i.InventoryDate -- for testing
From Inventories as i 
  Where Month(i.InventoryDate) = 1
  And i.ProductID in (Select ProductID From Products Where CategoryID = 8)
Order By i.ProductID;
go 

--Question 8: Select the PRODUCT NAME and Number of Products in Inventory for the Month of January. 
--Order the results by the Product Names and where the ProductID as only the ones in the seafood category (Hint: Use a Join between Inventories and Products to get the Name)
--(Note: Quantities may vary, since I use a random function to create the data!)
Select ProductName, [Count] -- i.InventoryDate -- for testing
From Inventories as i 
Join Products as p
  On i.ProductID = p.ProductID
Where Month(i.InventoryDate) = 1
And i.ProductID in (Select ProductID From Products Where CategoryID = 8)
go 
Select ProductName, [Count] -- i.InventoryDate -- for testing
From Inventories as i 
Join Products as p
  On i.ProductID = p.ProductID
Where Month(i.InventoryDate) = 1
And i.ProductID in (Select ProductID From Products Where CategoryID = 8)
Order By p.ProductName;
go 

--Question 9: Select the Product Name and Number of Products in Inventory for both JANUARY and FEBURARY. 
--Show what the MAXIMUM AMOUNT IN INVENTORY was and where the productID as only the ones in the seafood 
--category and Order the results by the Product Names. (Hint: If Jan count was 5, but Feb count was 15, 
--show 15) (Note: Quantities may vary, since I use a random function to create the data!)
Select ProductName, [Count] -- i.InventoryDate -- for testing
From Inventories as i 
Join Products as p
  On i.ProductID = p.ProductID
Where Month(i.InventoryDate) = 1
go
Select ProductName, [Count] -- i.InventoryDate -- for testing
From Inventories as i 
Join Products as p
  On i.ProductID = p.ProductID
Where Month(i.InventoryDate) = 1 Or Month(i.InventoryDate) = 2 -- Month(i.InventoryDate) in (1,2)
go
Select ProductName, Max([Count]) -- i.InventoryDate -- for testing
From Inventories as i 
Join Products as p
  On i.ProductID = p.ProductID
Where Month(i.InventoryDate) = 1 Or Month(i.InventoryDate) = 2 -- Month(i.InventoryDate) in (1,2)
Group By ProductName
go
Select ProductName, Max([Count]) as [Highest Count] -- add column name
From Inventories as i 
Join Products as p
  On i.ProductID = p.ProductID
Where Month(i.InventoryDate) = 1 Or Month(i.InventoryDate) = 2 -- Month(i.InventoryDate) in (1,2)
Group By ProductName -- aggregated otherwise max() wont work
go

--Question 10: Select the Product Name and Number of Products in Inventory for both JANUARY and FEBURARY. 
--Show what the MAX AMOUNT IN INVENTORY was and where the ProductID as only the ones in the seafood 
--category and Order the results by the Product Names. Restrict the results to rows with a MAXIMUM COUNT 
--OF 10 OR HIGHER. (Note: Quantities may vary, since I use a random function to create the data!)
Select ProductName, Max([Count]) as [Highest Count] -- add column name
From Inventories as i 
Join Products as p
  On i.ProductID = p.ProductID
Where Month(i.InventoryDate) in (1,2) -- Month(i.InventoryDate) in (1,2)
And i.ProductID in (Select ProductID From Products Where CategoryID = 8)
Group By p.ProductName -- aggregated otherwise max() wont work
Order By p.ProductName
go
Select ProductName, Max(i.[Count]) as [Highest Count] -- add column name
From Inventories as i 
Join Products as p
  On i.ProductID = p.ProductID
Where Month(i.InventoryDate) in (1,2) -- Month(i.InventoryDate) in (1,2)
  And i.ProductID in (Select ProductID From Products Where CategoryID = 8)
Group By p.ProductName -- aggregated otherwise max() wont work
  Having Max(i.[Count]) >= 10
Order By p.ProductName
go

--Question 11: Select the CATEGORY NAME, Product Name and Number of Products in Inventory for both JANUARY and FEBURARY. Show what the MAX AMOUNT IN INVENTORY was and where the ProductID as only the ones in the seafood category and Order the results by the Product Names. Restrict the results to rows with a maximum count of 10 or higher (Note: Quantities may vary, since I use a random function to create the data!)
Select ProductName, Max(i.[Count]) as [Highest Count] -- add column name
From Inventories as i 
Join Products as p
  On i.ProductID = p.ProductID
Where Month(i.InventoryDate) in (1,2) -- Month(i.InventoryDate) in (1,2)
  And i.ProductID in (Select ProductID From Products Where CategoryID = 8)
Group By p.ProductName -- aggregated otherwise max() wont work
  Having Max(i.[Count]) >= 10
Order By p.ProductName
go

Select c.CategoryName, p.ProductName, Max(i.[Count]) as [Highest Count] -- add column name
From Inventories as i 
Join Products as p
  On i.ProductID = p.ProductID
Join Categories as c
  On p.CategoryID = c.CategoryID
Where Month(i.InventoryDate) in (1,2) -- Month(i.InventoryDate) in (1,2)
  And i.ProductID in (Select ProductID From Products Where CategoryID = 8)
Group By c.CategoryName, p.ProductName -- aggregated otherwise max() wont work
  Having Max(i.[Count]) >= 10
Order By p.ProductName
go

--Step 3: Review Your Work
--Now, you will review your work with your instructor.