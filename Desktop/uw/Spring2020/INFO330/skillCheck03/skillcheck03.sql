--*************************************************************************
-- Title: SkillCheck03
-- Author: ESung
-- Desc: This file demonstrates how to create a database
-- Change Log: When,Who,What
-- 2020-05-06,ESung,Created File
--**************************************************************************
-- Create a database based on this design: (Developers) 1 ---- N (Projects)
-- All table need at least an ID and Name columns, but may have others too.
Use Master;
go 
If Exists(Select [Name] From [Sysdatabases] Where Name = 'SkillCheck03ESung')
    Drop Database SkillCheck03ESung;
go 
Create Database SkillCheck03ESung;
go 
Use SkillCheck03ESung;
go 

-- Tables (5 mins) --
Create Table Developers
([DeveloperID] int Not Null IDENTITY(1,1)
,[DeveloperFirstName] nvarchar(100) Not Null
,[DeveloperLastName] nvarchar (100) Not Null
);

Create Table Projects
([ProjectID] int Not Null IDENTITY(1,1) 
,[ProjectName] nvarchar(100) Not Null
,ProjectDate Date Not Null
,DeveloperID int Not Null-- foreign key 
);


-- Constraints (5 mins) --
Alter Table Developers
Add Constraint pkDevelopers Primary Key (DeveloperID);
-- sp_helpConstraint Developers 
go
Alter Table Projects
Add Constraint pkProjects Primary Key (ProjectID);
Alter Table Projects
Add Constraint uqProjects Unique (ProjectName);
Alter Table Projects 
Add Constraint ckProjectDate Check (ProjectDate < Cast(DateAdd(dd, 1, GetDate()) as date));
-- sp_helpConstraint Projects
go

-- Views (5 mins) --
Create View vDevelopers 
As 
    Select DeveloperID, DeveloperFirstName, DeveloperLastName From Developers;
go 
Create View vProjects 
As 
    Select ProjectID, ProjectName, ProjectDate, DeveloperID From Projects;
go

-- Reporting View 
Create View vDevelopersProjects 
As 
    Select d.DeveloperID, DeveloperFirstName, DeveloperLastName, ProjectID, ProjectName, ProjectDate
    From Developers as d 
    Join Projects as p
    On d.DeveloperID = p.DeveloperID 


-- Stored Procedures (10 mins)--
go
Create Procedure pInsDevelopers
(@DeveloperFirstName nvarchar(100) 
,@DeveloperLastName nvarchar (100) 
)
/* Author: <ESung>
** Desc: Processes Inserts into Developers
** Change Log: When,Who,What
** 2020-05-06, ESung, Created Sproc.
*/
AS
 Begin
    Insert Into Developers (DeveloperFirstName, DeveloperLastName) 
    Values (@DeveloperFirstName, @DeveloperLastName);
 End
-- Exec pInsDevelopers 'Bob', 'Smith'
-- Select * From Developers 
go


-- Permissions (5 mins) --
Deny Select, Insert, Update, Delete On Developers To Public;
Grant Select On vDevelopers To Public;
Grant Exec On pInsDevelopers To Public;