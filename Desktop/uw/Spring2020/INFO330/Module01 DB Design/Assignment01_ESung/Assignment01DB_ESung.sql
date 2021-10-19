----------------------------------
-- Title: INFO 330 - Module 1: Assignment1
-- Description: This file shows the scripts to assignment 1
-- Developer: Edward Sung
-- ChangeLog: When, Who, What
--   04/06/2020, Edward Sung, Created Script
----------------------------------
Use Master;
go
if Exists(Select Name From SysDatabases Where Name = 'Assignment01DB_ESung')
Drop Database Assignment01DB_ESung;
go

Create Database Assignment01DB_ESung;
go
Use Assignment01DB_ESung;
go 
CREATE TABLE Projects
(ProjectID int Primary Key
,ProjectName varchar(100)
,ProjectDescription varchar(5000)
);
go
CREATE TABLE Employees
(EmployeeID int Primary Key
,EmployeeFirstName varchar(50)
,EmployeeLastName varchar(50)
);
go
CREATE TABLE ProjectDetails
(EmployeeID int
,ProjectID int
,ProjectDate datetime
,ProjectHours decimal(18,2)
Primary Key(EmployeeID, ProjectID,ProjectDate) -- missing ProjectDate in the hw
);
go
