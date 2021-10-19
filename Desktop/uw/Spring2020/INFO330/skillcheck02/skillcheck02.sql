
--*************************************************************************--
-- Title: SkillCheck02
-- Author: Edward Sung
-- Desc: This file demonstrates how to create a database
-- Change Log: When,Who,What
-- 2020-04-24,Edward Sung,Created File
--**************************************************************************--

-- Task 01 (10 Min): Use the following data to design and create a database 
-- (Include Primary Key, Foriegn Key and Not Null constraints).
/*
first_name,last_name,department
Nicky,Kuschek,Legal
Rubie,Hargrave,Sales
Onfroi,Rushworth,Legal
Atlante,Samper,Legal
Brigida,Bufton,Engineering
*/

Use Master;
go
If Exists(Select Name from SysDatabases Where Name = 'SkillCheck2_ESung')
Begin 
Alter Database [SkillCheck2_ESung] set Single_user With Rollback Immediate;
Drop Database SkillCheck2_ESung;
End
go
Create Database SkillCheck2_ESung;
go
Use SkillCheck2_ESung;
go
Create Table Departments 
(
    DepartmentID int Not Null Constraint pkDepartments Primary Key 
    ,DepartmentName nvarchar(100)
);
go
Create Table Employees 
(
    EmployeeID int Not Null Constraint pkEmployees Primary Key 
    ,EmployeeFirstName nvarchar(100) Not Null
    ,EmployeeLastName nvarchar(100) Not Null
    ,DepartmentID int Not Null Constraint fkEmployeesToDepartments 
    References Departments(DepartmentID)
);
go 

-- Task 02 (5 Min): Create a Base View for each table.
Create View vEmployees
As 
Select EmployeeID, EmployeeFirstName, EmployeeLastName From Employees;
go 
Create View vDepartments
As 
Select DepartmentID, DepartmentName From Departments; 
go 

-- Task 03 (5 Min): Insert the sample data into the tables.
Insert Into Departments(DepartmentID, DepartmentName)
Values (1, 'Dept1');

Insert Into Employees(EmployeeID, EmployeeFirstName, EmployeeLastName, DepartmentID)
Values (100, 'Bob', 'Smith', 1);

-- Task 04 (5 Min): Place the Insert code into Stored Procedures and test that they work. 
-- (Use the following starter code as a guide)
go 
Create Procedure pInsDepartments
(@DepartmentID int, @DepartmentName nvarchar(100))
As
Begin
Insert Into Departments(DepartmentID, DepartmentName)
Values (@DepartmentID, @DepartmentName);
End 
go
Exec pInsDepartments @DepartmentID = 2, @DepartmentName = 'Dept2';
Select * From vDepartments 

go 
Create Procedure pInsEmployees
(@EmployeeID int,
 @EmployeeFirstName nvarchar(100), 
 @EmployeeLastName nvarchar(100),
 @DepartmentID int )
As
Begin
Insert Into Employees(EmployeeID, EmployeeFirstName, EmployeeLastName, DepartmentID)
Values (@EmployeeID, @EmployeeFirstName, @EmployeeLastName, @DepartmentID);
End 
go
Exec pInsEmployees @EmployeeID = 200, 
@EmployeeFirstName = 'Sue', 
@EmployeeLastName = 'Jones', 
@DepartmentID = 1 
Select * From vEmployees 
-- Create Procedure <pInsMyTableName>
-- (<Col1> <type>, <Col2> <type>)
-- As
-- Begin
-- Insert Code Goes Here
-- End 