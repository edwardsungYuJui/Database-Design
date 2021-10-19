/**********************************
Title: INFO330C - Module2: SQL Code
Desc: The file shows the answers to the Module 2 assignment
Dev: ESung
Change Log: When, Who, What
    4/13/2020, ESung, Created Script
***********************************/
Use Master;
go
-- drop database
If Exists(Select Name From SysDatabases Where Name = 'Assignment02DB_ESung')
    Drop Database Assignment02DB_ESung;
go 
-- create new database
Create Database Assignment02DB_ESung;
go 
Use Assignment02DB_ESung;
go
-- create tables
Create Table Customers
(CustomerID int Constraint pkCustomerID Primary Key Not Null Identity(1,1)
,CustomerFirstName nvarchar (100) Not Null
,CustomerLastName nvarchar (100) Not Null 
);
go
Create Table Categories
(CategoryID int Constraint pkCategoryID Primary Key Not Null Identity(1,1)
,CategoryName nvarchar (100) Not Null
);
go
Create Table Orders
(OrderID int Constraint pkOrderID Primary Key Not Null Identity(1,1)
,CustomerID nvarchar (100) Not Null
,OrderDate date Constraint ckOrderDate check (OrderDate <= GetDate()) 
);
go
Create Table SubCategories
(SubCategoryID int Constraint pkSubCatID Primary Key Not Null Identity(1,1)
,CategoryID int Constraint fkCategoryID Foreign Key
                                            References Categories(CategoryID)
,SubCategoryName nvarchar(100) Not Null
)
go
Create Table Products
(ProductID int Constraint pkProductID Primary Key Not Null Identity(1,1)
,ProductName nvarchar(100) Not Null
,OrderPrice money Constraint ckOrderPriceAlter check (OrderPrice >= 0)
,SubCategoryID int Constraint fkSubCatID Foreign Key 
                                            References SubCategories(SubCategoryID)
)
go 
Create Table OrderDetails
(OrderDetailID int Primary Key
,OrderID int Constraint fkOrderID Foreign Key 
                                            References Orders(OrderID)
,ProductID int Constraint fkProductID Foreign Key 
                                            References Products(ProductID)  
,OrderQty int Constraint ckOrderQty check(OrderQty > 0)
,OrderPrice money Constraint ckOrderPrice check (OrderPrice >= 0)
)
go
--- create view 
Create View vCustomers
As Select CustomerID, CustomerFirstName, CustomerLastName  From Customers;
go
Create View vCategories
As Select CategoryID,CategoryName From Categories;
go
Create View vOrders
As Select OrderID,CustomerID,OrderDate From Orders;
go
Create View vOrderDetails
As Select OrderDetailID,OrderID,ProductID,OrderQty,OrderPrice From OrderDetails;
go
Create View vProducts
As Select ProductID,ProductName,SubCategoryID From Products;
go
Create View vSubCategories
As Select SubCategoryID,CategoryID,SubCategoryName From SubCategories;
go
-- Check view 
Select * From vCustomers
Select * From vCategories
Select * From vOrders
Select * From vOrderDetails
Select * From vProducts
Select * From vSubCategories
