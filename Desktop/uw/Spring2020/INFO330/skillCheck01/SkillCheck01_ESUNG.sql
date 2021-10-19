Use Master
go
If Exists(Select Name from SysDatabases Where Name = 'SC1ESung')
 Begin 
  Alter Database SC1ESung set Single_user With Rollback Immediate;
  Drop Database SC1ESung;
 End
go
Create Database SC1ESung;
go
use SC1ESung;
go

--Skill Check - 1
--Create a table with the following data about people:
--(First, Last, Date of birth, Address, City, State, Zip)
--Bob, Smith, 1/1/2000, 123 Main Street, Seattle, WA, 98001
--Sue, Jones, 6/6/2000, 543 1st Ave, Seattle, WA, 98001
Create Table Peoples
(PeopleID int Constraint pkPersons Primary Key 
,PeopleFirstName nvarchar(100) Not Null
,PeopleLastName nvarchar(100) Not Null
,PeopleDateOfBirth Date Not Null
,PeopleAddress nvarchar(100) Not Null
,PeopleCity nvarchar(100) Not Null
,PeopleState nchar(2) Not Null
,PeopleZip nchar(5) Not Null
);
go
Insert Into Peoples 
(PeopleID 
,PeopleFirstName 
,PeopleLastName 
,PeopleDateOfBirth 
,PeopleAddress
,PeopleCity 
,PeopleState 
,PeopleZip
) Values
 (1, 'Bob', 'Smith', '1/1/2000', '123 Main Street', 'Seattle', 'WA', '98001')
,(2, 'Sue', 'Jones', '6/6/2000', '543 1st Ave', 'Seattle', 'WA', '98001')
go
Select * From Peoples;

--Create a table with the following data about Employees:
--(PersonID, Title, HireDate, Extension, Email, Current Status)
--1, Tech Support, 5/30/2019, 2222, BSmith@MyCo.com, Employed
Create Table Employees
(EmployeeID int Constraint pkEmployees Primary Key
,PeopleID int Not Null Constraint fkEmployeesToPeoples 
                       References Peoples(PeopleID)
,EmployeeTitle nvarchar(100) Not Null 
,EmployeeHireDate date Not Null
,EmployeeExtension nchar(4) Null
,EmployeeEmail nvarchar(100) Null
,EmployeeCurStatus nvarchar(100) Not Null
); 
go

Insert Into Employees
(EmployeeID
,PeopleID
,EmployeeTitle
,EmployeeHireDate
,EmployeeExtension
,EmployeeEmail
,EmployeeCurStatus
)Values
(1, 1, 'Tech Support', '5/30/2019', '2222', 'BSmith@MyCo.com', 'Employed')
go

--Create a table with the following data about Customer:
--(PersonID, Email, Phone, Contact Preference)
--2, SueJones@HeyYou.com, 206.555.5556, Email
 
Create 
Table Customers
(CustomerID int Constraint pkCustomers Primary Key
,PeopleID int Not Null Constraint fkCustomersToPeoples 
                       References Peoples(PeopleID)
,CustomerEmail nvarchar(200) Not Null
,CustomerPhone nvarchar(100) Not Null
,CustomerContactPref nvarchar(200) Not Null
); 
go
Insert Into Customers
(CustomerID
,PeopleID
,CustomerEmail
,CustomerPhone
,CustomerContactPref
)Values
(1, 2, 'SueJones@HeyYou.com', '206.555.5556', 'Email')
go


--Create a view for each table
go
Create View vPeoples
As
 Select 
  PeopleID 
 ,PeopleFirstName 
 ,PeopleLastName 
 ,PeopleDateOfBirth 
 ,PeopleAddress
 ,PeopleCity 
 ,PeopleState
 ,PeopleZip
 From Peoples

go
Create View  vEmployees
As Select EmployeeID
 ,PeopleID
 ,EmployeeTitle
 ,EmployeeHireDate
 ,EmployeeExtension
 ,EmployeeEmail
 ,EmployeeCurStatus
 From Employees;
go

Create or Alter View vCustomers
As Select 
  CustomerID
 ,PeopleID
 ,CustomerEmail
 ,CustomerPhone
 ,CustomerContactPref
 From Customers;
go

--Create a view that combines all tables
Create View vAllTable
As Select 
  PeopleID 
 ,PeopleFirstName 
 ,PeopleLastName 
 ,PeopleDateOfBirth 
 ,PeopleAddress
 ,PeopleCity 
 ,PeopleState
 ,PeopleZip
 ,EmployeeID
 ,EmployeeTitle
 ,EmployeeHireDate
 ,EmployeeExtension
 ,EmployeeEmail
 ,EmployeeCurStatus
 ,CustomerID
 ,CustomerEmail
 ,CustomerPhone
 ,CustomerContactPref 
go

