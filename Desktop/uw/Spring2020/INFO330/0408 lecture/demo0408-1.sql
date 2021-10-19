Create Database DemoESung;
GO
use DemoESung;
GO
Create Table Customers(CustomerID int Primary Key, CustomerName nvarchar(100));
GO
Insert Into Customers(CustomerID, CustomerName) Values (1, 'CustA');
GO
Select * From Customers;
GO
Insert Into Customers(CustomerID, CustomerName) Values (2, 'CustB');
GO
Select * From Customers;
GO


Create Table CustomersVer2(CustomerID int Primary Key Identity(1,3), CustomerName nvarchar(100));
GO
Insert Into CustomersVer2(CustomerName) Values ('CustA');
GO
Select * From CustomersVer2;


Sp_help CustomersVer2;

Select * From Northwind.dbo.Categories; /*parent*/
Select * From Northwind.dbo.Products; /*child*/

Select CategoryName, ProductName
From Northwind.dbo.Categories Join Northwind.dbo.Products
    On Northwind.dbo.Categories.CategoryID = Northwind.dbo.Products.CategoryID


-- Option 1
Create Table Projects 
(ProjectID int Constraint pkProjects Primary Key Not Null
,ProjectName nvarchar(100) Not NULL
ProjectDescription varchar(5000) Not Null -- Swtch to varchar to get 5k characters
);
go 

-- Option 2 
Create Table Projects 
(ProjectID int Not Null
,ProjectName nvarchar(100) Not NULL
ProjectDescription varchar(5000) Not Null -- Swtch to varchar to get 5k characters
Constraint pkProjects Primary Key (ProjectID)
);
go 

-- Option 3
Create Table Projects 
(ProjectID int Not Null
,ProjectName nvarchar(100) Not NULL
ProjectDescription varchar(5000) Not Null -- Swtch to varchar to get 5k characters
);
go 

Alter Table Projects
Add Constraint pkProjects Primary Key (ProjectID)