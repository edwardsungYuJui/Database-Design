Use Master
go
If Exists(Select Name from SysDatabases Where Name = 'SC1RRoot')
 Begin 
  Alter Database SC1RRoot set Single_user With Rollback Immediate;
  Drop Database SC1RRoot;
 End
go
Create Database SC1RRoot;
go
use SC1RRoot;
go

--Skill Check - 1
--Create a table with the following data about people:
--(First, Last, Date of birth, Address, City, State, Zip)
--Bob, Smith, 1/1/2000, 123 Main Street, Seattle, WA, 98001
--Sue, Jones, 6/6/2000, 543 1st Ave, Seattle, WA, 98001
Create -- Drop
Table Persons 
(PersonID int Constraint pkPersons Primary Key 
,PersonFirstName nvarchar(100) Not Null
,PersonLastName nvarchar(100) Not Null
,PersonDOB Date Not Null
,PersonAddress nvarchar(100) Not Null
,PersonCity nvarchar(100) Not Null
,PersonStateCode nchar(2) Not Null
,PersonZipCode nchar(5) Not Null
);
go
Insert Into Persons 
(PersonID 
,PersonFirstName 
,PersonLastName 
,PersonDOB 
,PersonAddress
,PersonCity 
,PersonStateCode 
,PersonZipCode
) Values
 (1, 'Bob', 'Smith', '1/1/2000', '123 Main Street', 'Seattle', 'WA', '98001')
,(2, 'Sue', 'Jones', '6/6/2000', '543 1st Ave', 'Seattle', 'WA', '98001')
Go
Select * From Persons;

--Create a table with the following data about Employees:
--(PersonID, Title, HireDate, Extension, Email, Current Status)
--1, Tech Support, 5/30/2019, 2222, BSmith@MyCo.com, Employed
Create -- Drop
Table Employees
(EmployeeID int Constraint pkEmployees Primary Key
,PersonID int Not Null Constraint fkEmployeesToPersons 
                       References Persons(PersonID)
,EmployeeTitle nvarchar(100) Not Null 
,EmployeeHireDate date Not Null
,EmployeeExtension nchar(4) Null
,EmployeeEmail nvarchar(100) Null
,EmployeeCurrentStatus nvarchar(100) Not Null
); 
Go
Insert Into Employees
(EmployeeID
,PersonID
,EmployeeTitle
,EmployeeHireDate
,EmployeeExtension
,EmployeeEmail
,EmployeeCurrentStatus
)Values
(1, 1, 'Tech Support', '5/30/2019', '2222', 'BSmith@MyCo.com', 'Employed')
Go

--Create a table with the following data about Customer:
--(PersonID, Email, Phone, Contact Preference)
--2, SueJones@HeyYou.com, 206.555.5556, Email
 
Create -- Drop
Table Customers
(CustomerID int Constraint pkCustomers Primary Key
,PersonID int Not Null Constraint fkCustomersToPersons 
                       References Persons(PersonID)
,CustomerEmail nvarchar(100) Not Null
,CustomerPhone nvarchar(100) Not Null
,CustomerContactPreference nvarchar(100) Not Null
); 
go
Insert Into Customers
(CustomerID
,PersonID
,CustomerEmail
,CustomerPhone
,CustomerContactPreference
)Values
(1, 2, 'SueJones@HeyYou.com', '206.555.5556', 'Email')
go


--Create a view for each table
go
Create or Alter View vPersons
As
 Select 
  PersonID 
 ,PersonFirstName 
 ,PersonLastName 
 ,PersonDOB 
 ,PersonAddress
 ,PersonCity 
 ,PersonStateCode 
 ,PersonZipCode
 From Persons

go
Create or Alter View  vEmployees
As
 Select EmployeeID
 ,PersonID
 ,EmployeeTitle
 ,EmployeeHireDate
 ,EmployeeExtension
 ,EmployeeEmail
 ,EmployeeCurrentStatus
 From Employees;
go

Create or Alter View vCustomers
As
 Select 
  CustomerID
 ,PersonID
 ,CustomerEmail
 ,CustomerPhone
 ,CustomerContactPreference 
 From Customers;
go

--Create a view that combines all tables
Create or Alter View vAllTableData
As
 Select 
  p.PersonID 
 ,PersonFirstName 
 ,PersonLastName 
 ,PersonDOB 
 ,PersonAddress
 ,PersonCity 
 ,PersonStateCode 
 ,PersonZipCode
 ,EmployeeID
 ,EmployeeTitle
 ,EmployeeHireDate
 ,EmployeeExtension
 ,EmployeeEmail
 ,EmployeeCurrentStatus
 ,CustomerID
 ,CustomerEmail
 ,CustomerPhone
 ,CustomerContactPreference 
 From vPersons as p 
 Left Join vEmployees as e
  On p.PersonID = e.PersonID 
 Left Join vCustomers as c
  On p.PersonID = c.PersonID;
go

Select * From vAllTableData;
