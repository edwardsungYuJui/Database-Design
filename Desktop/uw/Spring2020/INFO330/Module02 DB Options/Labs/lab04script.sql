---------------------------------------
-- Title: Mod03-Lab04
-- Desc: Answer for lab04
-- ChangeLog(When,Who,What)
-- 4/5, ESung, Created Script
---------------------------------------
Use Master;
go
-- drop database as needed
If Exists(Select Name From SysDatabases Where Name = 'Mod02Lab04ESung')
    Drop Database Mod02Lab04ESung;
go 
-- create database for lab
Create Database Mod02Lab04ESung;
go 
Use Mod02Lab04ESung;
go
-- create tables
Create Table Employees
(EmployeeID int Constraint pkEmployees Primary Key Not Null Identity(1,1)
,EmployeeName nvarchar (100) Not Null
);

Create Table Projects
(ProjectsID int Constraint pkProjects Primary Key Not Null Identity(1,1)
,ProjectsName nvarchar (100) Not Null
,ProjectsDescription varchar(5000) Not Null -- switch to varchar to get 5k characters
);
go

Create Table EmployeeProjectHours
(EmployeeID int Not Null
,ProjectID int Not Null
,[Date] date Not NULL
,[Hours] decimal(18,2)
,Constraint pkEmployeeProjectHours Primary Key (EmployeeID, ProjectID)
);
go
Alter Table EmployeeProjectHours
    Add Constraint fkEmployeeID Foreign Key (EmployeeID)
      References Employees(EmployeeID);
go 
Alter Table EmployeeProjectHours
    Add Constraint fkProjectID Foreign Key (ProjectID)
      References Projects(ProjectID);
go 
Alter Table EmployeeProjectHours
    Add Constraint ckEmployeeProjectDate check ([Date] < cast(GetDate()) as date);
go 
Alter Table EmployeeProjectHours
    Add Constraint ckEmployeeProjectHours check ([Hours] between .5 and 10);
go 

---- create views
Create View vEmployees
As Select EmployeeID, EmployeeName  From Employees;
go
Create View vProjects
As Select ProjectID,ProjectName,ProjectDescription From Projects;
go
Create View vEmployeeProjectHours
As Select EmployeeID,ProjectID,[Date],[Hours] From EmployeeProjectHours;
go

-- check views
Select * From vEmployees
Select * From vProjects
Select * From vEmployeeProjectHours