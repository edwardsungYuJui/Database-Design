--**********************************************************************************************--
-- Title: Assigment06 
-- Author: ESung
-- Desc: This file demonstrates how to design and create; 
--       tables, constraints, views, stored procedures, and permissions
-- Change Log: When,Who,What
-- 2020-05-11,ESung,Created File
--***********************************************************************************************--
Begin Try
	Use Master;
	If Exists(Select Name From SysDatabases Where Name = 'Assignment06DB_ESung')
	 Begin 
	  Alter Database [Assignment06DB_ESung] set Single_user With Rollback Immediate;
	  Drop Database Assignment06DB_ESung;
	 End
	Create Database Assignment06DB_ESung;
End Try
Begin Catch
	Print Error_Number();
End Catch
go
Use Assignment06DB_ESung;

-- Create Tables -- 
Create Table Students
(
StudentID int Identity(1,1) Not Null
,StudentNumber nvarchar (100) Not Null
,StudentFirstName nvarchar (100) Not Null
,StudentLastName nvarchar (100) Not Null
,StudentEmail nvarchar (100) Not Null
,StudentPhone nvarchar (100) 
,StudentAddress1 nvarchar (100) Not Null
,StudentAddress2 nvarchar (100) 
,StudentCity nvarchar (100) Not Null
,StudentStateCode nvarchar (100) Not Null
,StudentZipCode nvarchar (100) Not Null
,Constraint pkStudentID Primary Key (StudentID)
);
go

Create Table Enrollments
(
EnrollmentID int Identity(1,1) Not Null
,StudentID int NOT NULL
,CourseID int NOT NULL
,EnrollmentDateTime Datetime NOT NULL
,EnrollmentPrice Money NOT NULL
,Constraint pkEnrollmentID Primary Key (EnrollmentID)
);
go 

Create Table Courses 
(
CourseID int Identity(1,1) Not Null
,CourseName nvarchar(100) Not Null
,CourseStartDate Date 
,CourseEndDate Date 
,CourseStartTime Time 
,CourseEndTime Time 
,CourseWeekDays nvarchar(100) 
,CourseCurrentPrice money 
,Constraint pkCourseID Primary Key (CourseID)
);
go 

-- add constraints 
Alter Table Students
	Add Constraint uqStudentNumber Unique (StudentNumber)
go 
Alter Table Students
	Add Constraint uqStudentEmail Unique (StudentEmail)
go 
Alter Table Students
    Add Constraint ckStudentPhone Check(StudentPhone like '([0-9][0-9][0-9])-[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]')
go 
Alter Table Students
    Add Constraint ckStudentZipCode Check(StudentZipCode Like '[0-9][0-9][0-9][0-9][0-9]' OR  
										  StudentZipCode Like  '[0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9][0-9]');
go 

-- add constraints
Alter Table Enrollments 
 Add Constraint fkEnrollmentsToStudents Foreign Key (StudentID) 
 References Students(StudentID);
go

Alter Table Enrollments 
 Add Constraint fkEnrollmentsToCourses Foreign Key (CourseID) 
 References Courses(CourseID);
go 

Alter Table Enrollments
ADD CONSTRAINT dfEnrollmentDateTime
DEFAULT GETDATE() FOR EnrollmentDateTime
go 

Create Function dbo.fGetCourseStartDate
(@CourseID int)
Returns Date
as
Begin
Return(Select CourseStartDate
From Courses
where CourseID = @CourseID)
End 
go

Alter Table Enrollments 
  Add Constraint ckEnrollmentDateTime
 	check (EnrollmentDateTime < dbo.fGetCourseStartDate(CourseID));
go


-- add constraints 

Alter Table Courses 
	Add Constraint ckCourseEndDate Check (CourseEndDate > CourseStartDate)
go
Alter Table Courses 
	Add Constraint ckCourseEndTime Check (CourseEndTime > CourseStartTime)
go 
Alter Table Courses 
	Add Constraint uqCourseName Unique (CourseName)
go 


-- Add Views  --
Create or Alter View vStudents 
As 
	Select 
		StudentID 
		,StudentNumber 
		,StudentFirstName 
		,StudentLastName 
		,StudentEmail 
		,StudentPhone 
		,StudentAddress1 
		,StudentAddress2 
		,StudentCity 
		,StudentStateCode 
		,StudentZipCode
	From Students;
go 

Create or Alter View vEnrollments 
As 
	Select 
		EnrollmentID 
		,StudentID 
		,CourseID
		,EnrollmentDateTime 
		,EnrollmentPrice  
	From Enrollments;
go 

Create or Alter View vCourses 
As 
	Select 
		CourseID 
		,CourseName 
		,CourseStartDate 
		,CourseEndDate 
		,CourseStartTime
		,CourseEndTime 
		,CourseWeekDays
		,CourseCurrentPrice
	From Courses;
go 


-- Reporting Views --
Create View vStudentsEnrollmentsCourses
As
Select s.StudentID
	   ,StudentNumber
	   ,StudentFirstName
 	   ,StudentLastName
 	   ,StudentEmail
  	 ,StudentPhone
 	   ,StudentAddress1
	   ,StudentAddress2
 	   ,StudentCity
 	   ,StudentStateCode
 	   ,StudentZipCode
		 ,EnrollmentDateTime
 	   ,EnrollmentPrice
		 ,c.CourseID
 	   ,CourseName
 	   ,CourseStartDate
 	   ,CourseEndDate
 	   ,CourseStartTime
 	   ,CourseEndTime
 	   ,CourseWeekDays
 	   ,CourseCurrentPrice
From Students as s
Join Enrollments as e
	On s.studentID = e.studentID
Join Courses as c
	On e.CourseID = c.CourseID
go 

-- Add Stored Procedures (Module 04 and 05) --
Create Procedure pInsStudents                               
(@StudentNumber nvarchar(100)
,@StudentFirstName nvarchar(100)
,@StudentLastName nvarchar(100)
,@StudentEmail nvarchar(100) 
,@StudentPhone nvarchar(100)
,@StudentAddress1 nvarchar(100) 
,@StudentAddress2 nvarchar(100) 
,@StudentCity nvarchar(100) 
,@StudentStateCode nvarchar(100) 
,@StudentZipCode nvarchar(100))
/* Author: ESung
** Desc: Processes Insert For Students Table
** Change Log: When,Who,What
** 2020-05-11,ESung ,Created stored procedure.
*/
As
Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction;
    -- Transaction Code --
    Insert Into Students
  	(StudentNumber
	  ,StudentFirstName
	  ,StudentLastName
	  ,StudentEmail
	  ,StudentPhone
  	,StudentAddress1
	  ,StudentAddress2
	  ,StudentCity
	  ,StudentStateCode
	  ,StudentZipCode) 
 	values(@StudentNumber
	 	    ,@StudentFirstName
		    ,@StudentLastName
		    ,@StudentEmail
		    ,@StudentPhone
 		    ,@StudentAddress1
		    ,@StudentAddress2
		    ,@StudentCity
		    ,@StudentStateCode
		    ,@StudentZipCode);
   Commit Transaction;
   Set @RC = +1;
  End Try
  Begin Catch
If(@@Trancount > 0)  Rollback Transaction;
   Print Error_Message();
   Set @RC = -1
  End Catch
  Return @RC;
 End
go

Create Procedure pUpdStudents
(@StudentNumber nvarchar(100)
,@StudentID int
,@StudentFirstName nvarchar(100)
,@StudentLastName nvarchar(100)
,@StudentEmail nvarchar(100) 
,@StudentPhone nvarchar(100)
,@StudentAddress1 nvarchar(100) 
,@StudentAddress2 nvarchar(100) 
,@StudentCity nvarchar(100) 
,@StudentStateCode nvarchar(100) 
,@StudentZipCode nvarchar(100)) 
/* Author: ESung
** Desc: Processes Update For Students Table
** Change Log: When,Who,What
** 2020-05-11,ESung,Created stored procedure.
*/
As
Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction;
    -- Transaction Code --
    Update Students
    Set StudentNumber = @StudentNumber,
		StudentFirstName = @StudentFirstName,
    StudentLastName = @StudentLastName,
		StudentEmail = @StudentEmail,
		StudentPhone = @StudentPhone,
		StudentAddress1 = @StudentAddress1,
		StudentAddress2 = @StudentAddress2,
		StudentCity = @StudentCity,
		StudentStateCode = @StudentStateCode,
		StudentZipCode = @StudentZipCode
    Where StudentID = @StudentID;
   Commit Transaction;
   Set @RC = +1;
  End Try
  Begin Catch
If(@@Trancount > 0)  Rollback Transaction;
   Print Error_Message();
   Set @RC = -1
  End Catch
  Return @RC;
 End
go

Create Procedure pDelStudents
(@StudentID int)
/* Author: ESung
** Desc: Processes delete for the Students table
** Change Log: When,Who,What
** 2020-05-11,ESung,delete stored procedure.
*/
As 
 Begin
  Declare @RC Int = 0;
  Begin Try
   Begin Transaction 
   -- Transaction Code --
   Delete From Students Where StudentID = @StudentID
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
If(@@Trancount > 0)  Rollback Transaction;
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go

-----

Create Procedure pInsEnrollments
(@EnrollmentID int
,@StudentID int
,@CourseID int
,@EnrollmentDateTime Datetime
,@EnrollmentPrice Money)
/* Author: ESung
** Desc: Processes Insert for the Enrollments Table
** Change Log: When,Who,What
** 2020-05-11,ESung,Created stored procedure.
*/
As 
 Begin
  Declare @RC int = 0;
  Begin Try
    Begin Transaction 
     Insert Into Enrollments(
	  	EnrollmentID
     	,StudentID
     	,CourseID
     	,EnrollmentDateTime
     	,EnrollmentPrice)
     Values (@EnrollmentID
    		,@StudentID
    		,@CourseID
    		,@EnrollmentDateTime
    		,@EnrollmentPrice);
    Commit Transaction
    Set @RC = +1
  End Try
  Begin Catch
If(@@Trancount > 0)  Rollback Transaction;
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go

Create Procedure pUpdEnrollments
(@EnrollmentID int
,@StudentID int
,@CourseID int
,@EnrollmentDateTime Datetime
,@EnrollmentPrice Money)
/* Author: ESung
** Desc: Processes update for the Enrollments table
** Change Log: When,Who,What
** 2020-05-11,ESung,update stored procedure.
*/
As 
 Begin
  Declare @RC Int = 0;
  Begin Try
   Begin Transaction 
   -- Transaction Code --
   Update Enrollments Set 
    StudentID = @StudentID
    ,CourseID = @CourseID
    ,EnrollmentDateTime = @EnrollmentDateTime
    ,EnrollmentPrice = @EnrollmentPrice
   Where EnrollmentID = @EnrollmentID
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
If(@@Trancount > 0)  Rollback Transaction;
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go

Create Procedure pDelEnrollments
(@EnrollmentID int)
/* Author: ESung
** Desc: Processes delete for the Students table
** Change Log: When,Who,What
** 2020-05-11,ESung,delete stored procedure.
*/
As 
 Begin
  Declare @RC Int = 0;
  Begin Try
   Begin Transaction 
   -- Transaction Code --
   Delete From Enrollments Where EnrollmentID = @EnrollmentID
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
If(@@Trancount > 0)  Rollback Transaction;
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go

---- 
Create Procedure pInsCourses                             
(@CourseID int
,@CourseName nvarchar(100)
,@CourseStartDate Date
,@CourseEndDate Date
,@CourseStartTime Time
,@CourseEndTime Time
,@CourseWeekDay nvarchar(100)
,@CourseCurrentPrice Money)
/* Author: ESung
** Desc: Processes Insert For Courses Table
** Change Log: When,Who,What
** 2020-05-11,ESung ,Created stored procedure.
*/
As
Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction;
    -- Transaction Code --
    Insert Into Courses(
		CourseID,
		CourseName,
		CourseStartDate,
		CourseEndDate,
		CourseStartTime,
		CourseEndTime,
		CourseWeekDays,
		CourseCurrentPrice) 
	Values(@CourseID,
		     @CourseName,
		     @CourseStartDate,
		     @CourseEndDate,
		     @CourseStartTime ,
		     @CourseEndTime,
		     @CourseWeekDay,
		     @CourseCurrentPrice);
   Commit Transaction;
   Set @RC = +1;
  End Try
  Begin Catch
If(@@Trancount > 0)  Rollback Transaction;
   Print Error_Message();
   Set @RC = -1
  End Catch
  Return @RC;
 End
go

Create Procedure pUpdCourses  
(@CourseID int
,@CourseName nvarchar(100)
,@CourseStartDate Date
,@CourseEndDate Date
,@CourseStartTime Time
,@CourseEndTime Time
,@CourseWeekDays nvarchar(100)
,@CourseCurrentPrice Money) 
/* Author: ESung
** Desc: Processes Update For Courses Table
** Change Log: When,Who,What
** 2020-05-11,ESung,Created stored procedure.
*/
As
Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction;
    -- Transaction Code --
    Update Courses
    Set CourseName = @CourseName,
		CourseStartDate = @CourseStartDate,
    	CourseEndDate = @CourseEndDate,
		CourseStartTime = @CourseStartTime,
		CourseEndTime = @CourseEndTime,
		CourseWeekDays = @CourseWeekDays,
		CourseCurrentPrice = @CourseCurrentPrice
    Where CourseID = @CourseID ;
   Commit Transaction;
   Set @RC = +1;
  End Try
  Begin Catch
If(@@Trancount > 0)  Rollback Transaction;
   Print Error_Message();
   Set @RC = -1
  End Catch
  Return @RC;
 End
go

Create Procedure pDelCourses  
(@CourseID int)
/* Author: ESung
** Desc: Processes delete for the Courses table
** Change Log: When,Who,What
** 2020-05-11,ESung,delete stored procedure.
*/
As 
 Begin
  Declare @RC Int = 0;
  Begin Try
   Begin Transaction 
   -- Transaction Code --
   Delete From Courses  Where CourseID = @CourseID 
   Commit Transaction
   Set @RC = +1
  End Try
  Begin Catch
If(@@Trancount > 0) Rollback Transaction;
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go

-- Set Permissions 
Deny Select, Insert, Update, Delete On Students To Public; 
Grant Select On vStudents To Public;
Grant Execute On pInsStudents To Public;
Grant Execute On pUpdStudents To Public;
Grant Execute On pDelStudents To Public;

Deny Select, Insert, Update, Delete On Enrollments To Public; 
Grant Select On vEnrollments To Public;
Grant Execute On pInsEnrollments To Public;
Grant Execute On pUpdEnrollments To Public;
Grant Execute On pDelEnrollments To Public;

Deny Select, Insert, Update, Delete On Courses To Public; 
Grant Select On vCourses To Public;
Grant Execute On pInsCourses To Public;
Grant Execute On pUpdCourses To Public;
Grant Execute On pDelCourses To Public;


--Test coding and insert data
-------------------------Insert-------------------------
Declare @Status Int;
Exec @Status =pInsStudents @StudentNumber = 'A-Kevin-003'
 ,@StudentFirstName = 'Adam'
 ,@StudentLastName = 'Kevin'
 ,@StudentEmail = 'Aka@uwuw.com'
 ,@StudentPhone = '(206)-221-8942'
 ,@StudentAddress1 = '4567 Main St'
 ,@StudentAddress2 = 'Apt 37'
 ,@StudentCity = 'Bellevue'
 ,@StudentStateCode = 'WA'
 ,@StudentZipCode = '98004'
Select Case @Status
  When +1 Then 'Insert was successful!'
  When -1 Then 'Insert failed! Common Issues: Duplicate Data'
  End as [Status]; 
Select [The New ID Was: ] = @@IDENTITY
Select * From Students;
Go



-- Insert stored procedure for Courses
Declare @Status int;
Exec @Status = pInsCourses @CourseID = 1 
    ,@CourseName = 'SQL3 - Winter 2020' 
    ,@CourseStartDate = '2020-03-01'
    ,@CourseEndDate = '2020-03-24'
    ,@CourseStartTime = '02:00:00'
    ,@CourseEndTime = '04:00:00'
    ,@CourseWeekDay = 'F'
    ,@CourseCurrentPrice = 20.00
Select Case @Status
  When +1 Then 'Insert was successful!'
  When -1 Then 'Insert failed! Common Issue: Duplicate Data'
  End as [Status]
Select [The New ID Was:] = @@IDENTITY
Select * From Courses;
go

-- Insert stored procedure for Enrollments
Declare @Status Int;
Declare @NewStudentID int = IDENT_CURRENT('Students')
Declare @NewCourseID int = IDENT_CURRENT('Courses')
Exec @Status = pInsEnrollments @EnrollmentID = 1
    ,@StudentID = @NewStudentID
    ,@CourseID = @NewCourseID
    ,@EnrollmentDateTime = '2020-01-01'
    ,@EnrollmentPrice = 39
Select Case @Status
  When +1 Then 'Insert was successful!'
  When -1 Then 'Insert failed! Common Issues: Duplicate Data'
  End as [Status]; 
Select [The New ID Was: ] = @@IDENTITY
Select * From Enrollments;
go 

-------------------------Update-------------------------
-- Update of student
Declare @Status int;
Declare @NewStudentNumber int = IDENT_CURRENT('StudentNumber')
Declare @NewStudentID int = IDENT_CURRENT('StudentID')
Exec @Status = pUpdstudents @StudentNumber = @NewStudentNumber
							,@StudentID = @NewStudentID
                            ,@StudentFirstName = 'Susan'
							 ,@StudentLastName = 'Joe'
 							,@StudentEmail = 'SuJoe@YaYou.com'
 							,@StudentPhone = '(206)-345-2321'
							,@StudentAddress1 = '2456 2nd Ave.'
 							,@StudentAddress2 = 'Apt 2'
							,@StudentCity = 'Seattle'
							,@StudentStateCode = 'WA'
							,@StudentZipCode = '98117';
Select Case @Status
When +1 Then 'Update was successful!'
When -1 Then 'Update failed! Common Issue: Check Value'
End as [Status]
Select * From Students;
go 


-- Update of Enrollments
Declare @Status int;
Declare @NewStudentID int = IDENT_CURRENT('Students')
Declare @NewCourseID int = IDENT_CURRENT('Courses')
Declare @NewEnrollmentID int = IDENT_CURRENT('EnrollmentID')
Exec @Status = pUpdEnrollments @StudentID = @NewStudentID
								,@EnrollmentID = @NewEnrollmentID
								,@CourseID = @NewCourseID
								,@EnrollmentDateTime = '12/14/19'
								,@EnrollmentPrice = '349';
Select Case @Status
When +1 Then 'Update was successful!'
When -1 Then 'Update failed! Common Issue: Check Value'
End as [Status]
Select * From Students;
go 

-- Update of Courses
Declare @Status int;
Declare @NewCourseID int = IDENT_CURRENT('Courses')
Declare @NewCourseName int = IDENT_CURRENT('CourseName')
Exec @Status = pUpdCourses @CourseID = @NewCourseID
							,@CourseName = @NewCourseName
							,@CourseStartDate = '01/10/2020'
							,@CourseEndDate = '01/24/2020'
							,@CourseStartTime = '06:00:00'
							,@CourseEndTime = '08:50:00'
							,@CourseWeekDays = 'T'
							,@CourseCurrentPrice = '349';
Select Case @Status
When +1 Then 'Update was successful!'
When -1 Then 'Update failed! Common Issue: Check Value'
End as [Status]
Select * From Students;
go 

-------------------------Delete-------------------------
-- Delete stored procedure of Students
Declare @Status Int;
Declare @NewStudentID int = IDENT_CURRENT('Students')
Exec @Status = pDelStudents @StudentID = @NewStudentID;
Select Case @Status
  When +1 Then 'Delete was successful!'
  When -1 Then 'Delete failed! Common Issues: Foreign Key values must be delete first'
  End as [Status]
Select * From Students;
go 

-- Delete stored procedure for Enrollments
Declare @Status int;
Declare @NewEnrollmentID int = IDENT_CURRENT('Enrollments')
Exec @Status = pDelEnrollments @EnrollmentID = @NewEnrollmentID;
Select Case @Status
  When +1 Then 'Delete was successful!'
  When -1 Then 'Delete failed! Common Issue: Foreign Key calues must be delete first'
  End as [Status]
Select * From Enrollments;
go 

-- Delete stored procedure of Courses
Declare @Status Int;
Declare @NewCourseID int = IDENT_CURRENT('Courses')
Exec @Status = pDelCourses @CourseID = @NewCourseID
Select Case @Status
  When +1 Then 'Delete was successful!'
  When -1 Then 'Delete failed! Common Issues: Foreign Key values must be delete first'
  End as 'Status';
Select [The New ID Was: ] = @@IDENTITY
Select * From Courses;
go

--Insert data-----------------------------------------------------------------

-- Insert stored procedure for Students
Declare @Bob Int;
Exec @Bob = pInsStudents @StudentNumber = 'B-Smith-071'
	,@StudentFirstName = 'Bob'
	,@StudentLastName = 'Smith'
	,@StudentEmail = 'Bsmith@HipMail.com'
	,@StudentPhone = '(206)111-2222'
	,@StudentAddress1 = '123 Main St'
	,@StudentAddress2 = ''
	,@StudentCity = 'Seattle'
	,@StudentStateCode = 'WA'
	,@StudentZipCode = '98001'
Select Case @Bob
  When +1 Then 'Insert was successful!'
  When -1 Then 'Insert failed! Common Issues: Duplicate Data'
  End as [Status]; 
Select [The New ID Was: ] = @@IDENTITY
Select * From Students
Set @Bob = @@IDENTITY;


-- Insert stored procedure for Students
Declare @Sue Int;
Exec @Sue = pInsStudents @StudentNumber = 'S-Jones-003'
	,@StudentFirstName = 'Sue'
	,@StudentLastName = 'Jones'
	,@StudentEmail = 'SueJones@YaYou.com'
	,@StudentPhone = '(206)231-4321'
	,@StudentAddress1 = '333 1st Ave'
	,@StudentAddress2 = ''
	,@StudentCity = 'Seattle'
	,@StudentStateCode = 'WA'
	,@StudentZipCode = '98001'
Select Case @Sue
  When +1 Then 'Insert was successful!'
  When -1 Then 'Insert failed! Common Issues: Duplicate Data'
  End as [Status]; 
Select [The New ID Was: ] = @@IDENTITY
Select * From Students
Set @Sue = @@IDENTITY;
-- Go

-- Insert stored procedure for Courses
Declare @Status1 int;
-- Declare @NewCourseID int = IDENT_CURRENT('Course')
Exec @Status1 = pInsCourses @CourseID = 1
        ,@CourseName = 'SQL1 - Winter 2017' 
				,@CourseStartDate = '2017-01-10'
				,@CourseEndDate = '2017-01-24'
				,@CourseStartTime = '18:00:00'
				,@CourseEndTime = '20:50:00'
				,@CourseWeekDay = 'T'
				,@CourseCurrentPrice = 399
Select Case @Status1
  When +1 Then 'Insert was successful!'
  When -1 Then 'Insert failed! Common Issue: Duplicate Data'
  End as [Status]
Select [The New ID Was:] = @@IDENTITY
Select * From Courses
Set @Status1 = @@IDENTITY;
-- go 

-- Insert stored procedure for Courses
Declare @Status2 int;
-- Declare @NewCourseID int = IDENT_CURRENT('Course')
Exec @Status2 = pInsCourses @CourseID = 1
        ,@CourseName = 'SQL2 - Winter 2017' 
				,@CourseStartDate = '2017-01-31'
				,@CourseEndDate = '2017-02-14'
				,@CourseStartTime = '18:00:00'
				,@CourseEndTime = '20:50:00'
				,@CourseWeekDay = 'T'
				,@CourseCurrentPrice = 399
Select Case @Status2
  When +1 Then 'Insert was successful!'
  When -1 Then 'Insert failed! Common Issue: Duplicate Data'
  End as [Status]
Select [The New ID Was:] = @@IDENTITY
Select * From Courses
Set @Status2 = @@IDENTITY;
-- go 

-- Insert stored procedure for Enrollments
-- SET IDENTITY_INSERT Enrollments ON
Declare @Status Int;
Exec @Status = pInsEnrollments @EnrollmentID = 1
        ,@StudentID = @Bob
				,@CourseID = @Status1
				,@EnrollmentDateTime = '2017-01-03'
				,@EnrollmentPrice = 399
Select Case @Status
  When +1 Then 'Insert was successful!'
  When -1 Then 'Insert failed! Common Issues: Duplicate Data'
  End as [Status]; 
Select [The New ID Was: ] = @@IDENTITY
Select * From Enrollments;


-- Insert stored procedure for Enrollments
-- SET IDENTITY_INSERT Enrollments ON
-- Declare @Status Int;
Exec @Status = pInsEnrollments @EnrollmentID = 1
        ,@StudentID = @Bob
				,@CourseID = @Status2
				,@EnrollmentDateTime = '2017-01-12'
				,@EnrollmentPrice = 399.00
Select Case @Status
  When +1 Then 'Insert was successful!'
  When -1 Then 'Insert failed! Common Issues: Duplicate Data'
  End as [Status]; 
Select [The New ID Was: ] = @@IDENTITY
Select * From Enrollments;


Exec @Status = pInsEnrollments @EnrollmentID = 1
        ,@StudentID = @Sue
				,@CourseID = @Status1
				,@EnrollmentDateTime = '2016-12-14'
				,@EnrollmentPrice = 349.00
Select Case @Status
  When +1 Then 'Insert was successful!'
  When -1 Then 'Insert failed! Common Issues: Duplicate Data'
  End as [Status]; 
Select [The New ID Was: ] = @@IDENTITY
Select * From Enrollments;


Exec @Status = pInsEnrollments @EnrollmentID = 1
        ,@StudentID = @Sue
				,@CourseID = @Status2
				,@EnrollmentDateTime = '2016-12-14'
				,@EnrollmentPrice = 349.00
Select Case @Status
  When +1 Then 'Insert was successful!'
  When -1 Then 'Insert failed! Common Issues: Duplicate Data'
  End as [Status]; 
Select [The New ID Was: ] = @@IDENTITY
Select * From Enrollments;
go 

/*
Select 
  CourseName, 
  CourseStartDate, 
  CourseEndDate, 
  CourseStartTime, 
  CourseEndTime,
  CourseWeekDays, 
  CourseCurrentPrice, 
  StudentFirstName, 
  StudentLastName, 
  StudentEmail,
  StudentPhone, 
  StudentAddress1, 
  StudentAddress2,
  StudentCity, 
  StudentStateCode, 
  StudentZipCode, 
  EnrollmentDateTime, 
  EnrollmentPrice
From vStudentsEnrollmentsCourses;
*/
/**************************************************************************************************/