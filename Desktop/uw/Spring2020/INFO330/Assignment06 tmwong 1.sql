--**********************************************************************************************--
-- Title: Assigment06 
-- Author: Tsz Ming Wong
-- Desc: This file demonstrates how to design and create; 
--       tables, constraints, views, stored procedures, and permissions
-- Change Log: When,Who,What
-- 2020-05-10,Tsz Ming Wong,Created File
--***********************************************************************************************--

--Create database
Begin Try
	Use Master;
	If Exists(Select Name From SysDatabases Where Name = 'Assignment06DB_TMWong')
	 Begin 
	  Alter Database [Assignment06DB_TMWong] set Single_user With Rollback Immediate;
	  Drop Database Assignment06DB_TMWong;
	 End
	Create Database Assignment06DB_TMWong;
End Try
Begin Catch
	Print Error_Number();
End Catch
go
Use Assignment06DB_TMWong;

-- Create Tables (Module 01)
Create Table Students (
StudentID int IDENTITY(1,1) NOT NULL 
,StudentNumber nvarchar(100) NOT NULL
,StudentFirstName nvarchar(100) NOT NULL
,StudentLastName nvarchar(100) NOT NULL
,StudentEmail nvarchar(100) NOT NULL
,StudentPhone nvarchar(100)
,StudentAddress1 nvarchar(100) NOT NULL
,StudentAddress2 nvarchar(100) 
,StudentCity nvarchar(100) NOT NULL
,StudentStateCode nvarchar(100) NOT NULL
,StudentZipCode nvarchar(100) NOT NULL
,Constraint pkStudents Primary Key (StudentID)
);
go

Create Table Enrollments (
EnrollmentID int IDENTITY(1,1) NOT NULL
,StudentID int NOT NULL
,CourseID int NOT NULL
,EnrollmentDateTime Datetime NOT NULL
,EnrollmentPrice money NOT NULL
,Constraint pkEnrollments Primary Key (EnrollmentID)
);
go


Create Table Courses(
CourseID int IDENTITY(1,1) NOT NULL
,CourseName nvarchar(100) NOT NULL
,CourseStartDate date
,CourseEndDate date
,CourseStartTime time
,CourseEndTime time
,CourseWeekDay nvarchar(100)
,CourseCurrentPrice money
,Constraint pkCourses Primary Key(CourseID)
);
go
-- Add Constraints (Module 02) -- 

--Add Constraints to Stutent Table
Alter Table Students 
 Add Constraint ukStudentsNumber
  Unique (StudentNumber);
go

Alter Table Students 
 Add Constraint ukStudentsEmail
  Unique (StudentEmail);
go

Alter Table Students 
 Add Constraint ckStudentPhone
  Check(StudentPhone like '([0-9][0-9][0-9])[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]');
go

Alter Table Students 
 Add Constraint ckStudentZipCode
  Check(StudentZipCode LIKE '[0-9][0-9][0-9][0-9][0-9]' OR
 StudentZipCode LIKE '[0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]');
go

--Add Constraints to Enrollments Table
Alter Table Enrollments 
 Add Constraint fkEnrollmentsToStudents Foreign Key (StudentID) 
 References Students(StudentID);
go

Alter Table Enrollments 
 Add Constraint fkEnrollmentsToCourses Foreign Key (CourseID) 
 References Courses(CourseID);
 go

ALTER Table Enrollments
ADD CONSTRAINT DfEnrollmentDateTime
DEFAULT GETDATE() FOR EnrollmentDateTime
GO

--create udf
Create Function dbo.fGetCourseStartDate
(@CourseID int)
Returns Date
as
Begin
Return(Select CourseStartDate
From Courses
where CourseID=@CourseID)
End 
go

 Alter Table Enrollments 
 Add Constraint ckEnrollmentDateTime
 	check (EnrollmentDateTime < dbo.fGetCourseStartDate(CourseID));
go


--Add Constraints to Courses Table

Alter Table Courses 
 Add Constraint ckCourseEndDate
 	check (CourseEndDate > CourseStartDate);
go

Alter Table Courses 
 Add Constraint ckCourseEndTime
 	check (CourseEndTime > CourseStartTime);
go

Alter Table Courses 
 Add Constraint ukCourseName
  Unique (CourseName);
go

-- Add base Views for student
Create View vStudents
As 
Select StudentID
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

-- Add base Views for Enrollments Table
Create View vEnrollments
As
Select EnrollmentID
	   ,StudentID
 	   ,CourseID
 	   ,EnrollmentDateTime
 	   ,EnrollmentPrice
From Enrollments;
go

---- Add base Views for student
Create View vCourses
As
Select CourseID
 	   ,CourseName
 	   ,CourseStartDate
 	   ,CourseEndDate
 	   ,CourseStartTime
 	   ,CourseEndTime
 	   ,CourseWeekDay
 	   ,CourseCurrentPrice
From Courses;
go

--creating reporting Views
Create View vStudentsEnrollmentCourses
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
 	   ,CourseWeekDay
 	   ,CourseCurrentPrice
		From Students as s
		Join Enrollments as e
		On s.studentID = e.studentID
		Join Courses as c
		On e.CourseID = c.CourseID
Go


-- Add Stored Procedures (Module 04 and 05) 


Create Procedure pInstudents                               
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
/* Author: TMWong
** Desc: Processes Insert For student  Table
** Change Log: When,Who,What
** 2020-05-03,Tsz Ming Wong ,Created stored procedure.
*/
As
Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction;
    -- Transaction Code --
    Insert Into Students
  (StudentNumber, StudentFirstName,StudentLastName,StudentEmail ,StudentPhone,
  StudentAddress1,StudentAddress2 ,StudentCity,StudentStateCode,StudentZipCode) 
 values(@StudentNumber,@StudentFirstName,@StudentLastName,@StudentEmail ,@StudentPhone ,
 @StudentAddress1,@StudentAddress2,@StudentCity,@StudentStateCode,@StudentZipCode);
   
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

Create Procedure pUpdstudents
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
/* Author: TMWong
** Desc: Processes Update For students Table
** Change Log: When,Who,What
** 2020-05-03,Tsz Ming Wong ,Created stored procedure.
*/
As
Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction;
    -- Transaction Code --
    Update students
    Set StudentNumber=@StudentNumber,
	StudentFirstName=@StudentFirstName,
    StudentLastName=@StudentLastName,
	StudentEmail =@StudentEmail,
	StudentPhone=@StudentPhone,
	StudentAddress1=@StudentAddress1,
	StudentAddress2=@StudentAddress2,
	StudentCity=@StudentCity,
	StudentStateCode=@StudentStateCode,
	StudentZipCode=@StudentZipCode
    Where StudentID=@StudentID;
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
/* Author: <TMwong>
** Desc: Processes delete for the Categories table
** Change Log: When,Who,What
** <2020-05-11>,<TMWong>,delete stored procedure.
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

------------------------------------------------------------------------------------------------

Create Procedure pInsEnrollments
(@StudentID int
,@CourseID int
,@EnrollmentDateTime Datetime
,@EnrollmentPrice money)
/* Author: <TM WOng>
** Desc: Processes Insert for the Enrollments Table
** Change Log: When,Who,What
** <2020-05-11>,<TM Wong>,Created stored procedure.
*/
As 
 Begin
  Declare @RC int = 0;
  Begin Try
    Begin Transaction 
	    Insert Into Enrollments(StudentID
					,CourseID
					,EnrollmentDateTime
					,EnrollmentPrice)
	    Values (@StudentID
				,@CourseID
				,@EnrollmentDateTime
				,@EnrollmentPrice);
    Commit Transaction
    Set @RC = +1
  End Try
  Begin Catch
   If(@@Trancount > 0) Rollback Transaction
   Print Error_Message()
   Set @RC = -1
  End Catch
  Return @RC;
 End
go

Create Procedure pUpdEnrollments
(@EnrollmentID int,
@StudentID int
,@CourseID int
,@EnrollmentDateTime Datetime
,@EnrollmentPrice money)
/* Author: <TMwong>
** Desc: Processes update for the Students table
** Change Log: When,Who,What
** <2020-05-11>,<TMwong>,update stored procedure.
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
/* Author: <TMwong>
** Desc: Processes delete for the Categories table
** Change Log: When,Who,What
** <2020-05-11>,<TMwong>,delete stored procedure.
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

---------------------------------------------------------------------------------------------------------------------------------------
Create Procedure pInsCourses                             
(@CourseName nvarchar(100)
,@CourseStartDate date
,@CourseEndDate date
,@CourseStartTime time
,@CourseEndTime time
,@CourseWeekDay nvarchar(100)
,@CourseCurrentPrice money)
/* Author: TMWong
** Desc: Processes Insert For Courses  Table
** Change Log: When,Who,What
** 2020-05-03,Tsz Ming Wong ,Created stored procedure.
*/
As
Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction;
    -- Transaction Code --
    Insert Into Courses (CourseName,CourseStartDate,CourseEndDate,
	CourseStartTime,CourseEndTime,CourseWeekDay,CourseCurrentPrice) 
	values(@CourseName,@CourseStartDate,@CourseEndDate,@CourseStartTime ,
	@CourseEndTime,@CourseWeekDay,@CourseCurrentPrice);
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
,@CourseStartDate date
,@CourseEndDate date
,@CourseStartTime time
,@CourseEndTime time
,@CourseWeekDay nvarchar(100)
,@CourseCurrentPrice money) 
/* Author: TMWong
** Desc: Processes Update For Courses Table
** Change Log: When,Who,What
** 2020-05-03,Tsz Ming Wong ,Created stored procedure.
*/
As
Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction;
    -- Transaction Code --
    Update Courses
    Set CourseName=@CourseName,
	CourseStartDate=@CourseStartDate,
    CourseEndDate=@CourseEndDate,
	CourseStartTime =@CourseStartTime,
	CourseEndTime=@CourseEndTime,
	CourseWeekDay =@CourseWeekDay ,
	CourseCurrentPrice=@CourseCurrentPrice
    Where CourseID =@CourseID ;
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
/* Author: <TMwong>
** Desc: Processes delete for the Categories table
** Change Log: When,Who,What
** <2020-05-11>,<TMWong>,delete stored procedure.
*/
As 
 Begin
  Declare @RC Int = 0;
  Begin Try
   Begin Transaction 
   -- Transaction Code --
   Delete From Courses  Where CourseID =@CourseID 
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

-- Set Permissions 
Deny Select, Insert, Update, Delete On Students To Public; 
Grant Select On vStudents To Public;
Grant Execute On pInStudents To Public;
Grant Execute On pUpdStudents To Public;
Grant Execute On pDelStudents To Public;

Deny Select, Insert, Update, Delete On Enrollments To Public; 
Grant Select On vEnrollments  To Public;
Grant Execute On pInsEnrollments To Public;
Grant Execute On pUpdEnrollments To Public;
Grant Execute On pDelEnrollments To Public;

Deny Select, Insert, Update, Delete On Courses To Public; 
Grant Select On vCourses To Public;
Grant Execute On pInsCourses To Public;
Grant Execute On pUpdCourses To Public;
Grant Execute On pDelCourses To Public;

--Test coding and insert data

Declare @Status Int;
Exec @Status =pInstudents @StudentNumber = 'B-Smith-071'
 ,@StudentFirstName = 'Bob'
 ,@StudentLastName = 'Smith'
 ,@StudentEmail = 'Bsmith@HipMail.com'
 ,@StudentPhone = '(206)111-2222'
 ,@StudentAddress1 = '123 Main St'
 ,@StudentAddress2 = 'Apt 317'
 ,@StudentCity = 'Seattle'
 ,@StudentStateCode = 'WA'
 ,@StudentZipCode = '98001'
Select Case @Status
  When +1 Then 'Insert was successful!'
  When -1 Then 'Insert failed! Common Issues: Duplicate Data'
  End as [Status]; 
Select [The New ID Was: ] = @@IDENTITY
Select * From Students;
Go



-- Test the Insert stored procedure for Courses
Declare @Status int;
Exec @Status = pInsCourses @CourseName = 'SQL1 - Winter 2017' 
    ,@CourseStartDate = '2017-01-10'
    ,@CourseEndDate = '2017-01-24'
    ,@CourseStartTime = '01:00:00'
    ,@CourseEndTime = '02:00:00'
    ,@CourseWeekDay = 'T-Th'
    ,@CourseCurrentPrice = 399.00
Select Case @Status
  When +1 Then 'Insert was successful!'
  When -1 Then 'Insectfailed! Common Issue: Duplicate Data'
  End as [Status]
Select [The New ID Was:] = @@IDENTITY
Select * From Courses;
go

-- Test the Insert stored procedure for Enrollments
Declare @Status Int;
Declare @NewStudentID int = IDENT_CURRENT('Students')
Declare @NewCourseID int = IDENT_CURRENT('Courses')
Exec @Status = pInsEnrollments @StudentID = @NewStudentID
    ,@CourseID = @NewCourseID
    ,@EnrollmentDateTime = '2017-01-03'
    ,@EnrollmentPrice = 399
Select Case @Status
  When +1 Then 'Insert was successful!'
  When -1 Then 'Insert failed! Common Issues: Duplicate Data'
  End as [Status]; 
Select [The New ID Was: ] = @@IDENTITY
Select * From Enrollments;
Go

--test the update of student
Declare @Status int;
Declare @NewStudentNumber int = IDENT_CURRENT('StudentNumber')
Declare @NewStudentID int = IDENT_CURRENT('StudentID')
Exec @Status = pUpdstudents @StudentNumber = @NewStudentNumber
							,@StudentID = @NewStudentID
                            ,@StudentFirstName = 'ds'
							 ,@StudentLastName = 'mic'
 							,@StudentEmail = '123@uw.com'
 							,@StudentPhone = '(111)-111-1111'
							,@StudentAddress1 = '111 Main St.'
 							,@StudentAddress2 = '232 206'
							,@StudentCity = 'Seattle'
							,@StudentStateCode = 'WA'
							,@StudentZipCode = '98335';
Select Case @Status
When +1 Then 'Update was successful!'
When -1 Then 'Update failed! Common Issue: Check Value'
End as [Status]
Select * From Students;
go 


--test the update of Enrollments
Declare @Status int;
Declare @NewStudentID int = IDENT_CURRENT('Students')
Declare @NewCourseID int = IDENT_CURRENT('Course')
Declare @NewEnrollmentID int = IDENT_CURRENT('EnrollmentID')
Exec @Status = pUpdEnrollments @StudentID = @NewStudentID
								,@EnrollmentID = @NewEnrollmentID
								,@CourseID = @NewCourseID
								,@EnrollmentDateTime = '11/1/20'
								,@EnrollmentPrice = '200.00';
Select Case @Status
When +1 Then 'Update was successful!'
When -1 Then 'Update failed! Common Issue: Check Value'
End as [Status]
Select * From Students;
go 

---Test the Update stored procedure for Courses---
Declare @Status int;
Declare @NewCourseID int = IDENT_CURRENT('Courses')
Exec @Status = pUpdCourses @CourseID = @NewCourseID
							,@CourseName = 'SQL1 - Winter 2020'
							,@CourseStartDate = '02/22/22'
							,@CourseEndDate = '02/22/22'
							,@CourseStartTime = '01:00:00'
							,@CourseEndTime = '02:00:00'
							,@CourseWeekDay = 'T'
							,@CourseCurrentPrice = '400.00';
Select Case @Status
When +1 Then 'Update was successful!'
When -1 Then 'Update failed! Common Issue: Check Value'
End as [Status]
Select * From Students;
go 




-- test the Delete stored procedure for Enrollments
Declare @Status int;
Declare @NewEnrollmentID int = IDENT_CURRENT('Enrollments')
Exec @Status = pDelEnrollments @EnrollmentID = @NewEnrollmentID;
Select Case @Status
  When +1 Then 'Delete was successful!'
  When -1 Then 'Delete failed! Common Issue: Foreign Key calues must be delete first'
  End as [Status]
Select * From Enrollments;
go 

-- test the Delete stored procedure of Students
Declare @Status Int;
Declare @NewStudentID int = IDENT_CURRENT('Students')
Exec @Status = pDelStudents @StudentID = @NewStudentID;
Select Case @Status
  When +1 Then 'Delete was successful!'
  When -1 Then 'Delete failed! Common Issues: Foreign Key values must be delete first'
  End as [Status]
Select * From Students;
go 

--test the Delete stored procedure of Courses
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

-- Test the Insert stored procedure for Students
Declare @Bob Int;
Exec @Bob = pInstudents @StudentNumber = 'B-Smith-071'
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
-- Go

-- Test the Insert stored procedure for Students
Declare @Sue Int;
Exec @Sue = pInstudents @StudentNumber = 'S-Jones-003'
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

-- Test the Insert stored procedure for Courses
Declare @SQL1 int;
-- Declare @NewCourseID int = IDENT_CURRENT('Course')
Exec @SQL1 = pInsCourses @CourseName = 'SQL1 - Winter 2017' 
				,@CourseStartDate = '2017-01-10'
				,@CourseEndDate = '2017-01-24'
				,@CourseStartTime = '18:00:00'
				,@CourseEndTime = '20:50:00'
				,@CourseWeekDay = 'T'
				,@CourseCurrentPrice = 399
Select Case @SQL1
  When +1 Then 'Insert was successful!'
  When -1 Then 'Insectfailed! Common Issue: Duplicate Data'
  End as [Status]
Select [The New ID Was:] = @@IDENTITY
Select * From Courses
Set @SQL1 = @@IDENTITY;
-- go 

-- Test the Insert stored procedure for Courses
Declare @SQL2 int;
-- Declare @NewCourseID int = IDENT_CURRENT('Course')
Exec @SQL2 = pInsCourses @CourseName = 'SQL2 - Winter 2017' 
				,@CourseStartDate = '2017-01-31'
				,@CourseEndDate = '2017-02-14'
				,@CourseStartTime = '18:00:00'
				,@CourseEndTime = '20:50:00'
				,@CourseWeekDay = 'T'
				,@CourseCurrentPrice = 399
Select Case @SQL2
  When +1 Then 'Insert was successful!'
  When -1 Then 'Insectfailed! Common Issue: Duplicate Data'
  End as [Status]
Select [The New ID Was:] = @@IDENTITY
Select * From Courses
Set @SQL2 = @@IDENTITY;
-- go 

-- Test the Insert stored procedure for Enrollments
-- SET IDENTITY_INSERT Enrollments ON
Declare @Status Int;
Exec @Status = pInsEnrollments @StudentID = @Bob
				,@CourseID = @SQL1
				,@EnrollmentDateTime = '2017-01-03'
				,@EnrollmentPrice = 399
Select Case @Status
  When +1 Then 'Insert was successful!'
  When -1 Then 'Insert failed! Common Issues: Duplicate Data'
  End as [Status]; 
Select [The New ID Was: ] = @@IDENTITY
Select * From Enrollments;
-- Go

-- Test the Insert stored procedure for Enrollments
-- SET IDENTITY_INSERT Enrollments ON
-- Declare @Status Int;
Exec @Status = pInsEnrollments @StudentID = @Bob
				,@CourseID = @SQL2
				,@EnrollmentDateTime = '2017-01-12'
				,@EnrollmentPrice = 399
Select Case @Status
  When +1 Then 'Insert was successful!'
  When -1 Then 'Insert failed! Common Issues: Duplicate Data'
  End as [Status]; 
Select [The New ID Was: ] = @@IDENTITY
Select * From Enrollments;
-- Go

Exec @Status = pInsEnrollments @StudentID = @Sue
				,@CourseID = @SQL1
				,@EnrollmentDateTime = '2016-12-14'
				,@EnrollmentPrice = 349
Select Case @Status
  When +1 Then 'Insert was successful!'
  When -1 Then 'Insert failed! Common Issues: Duplicate Data'
  End as [Status]; 
Select [The New ID Was: ] = @@IDENTITY
Select * From Enrollments;
-- Go

Exec @Status = pInsEnrollments @StudentID = @Sue
				,@CourseID = @SQL2
				,@EnrollmentDateTime = '2016-12-14'
				,@EnrollmentPrice = 349
Select Case @Status
  When +1 Then 'Insert was successful!'
  When -1 Then 'Insert failed! Common Issues: Duplicate Data'
  End as [Status]; 
Select [The New ID Was: ] = @@IDENTITY
Select * From Enrollments;
Go

Select CourseName, CourseStartDate, CourseEndDate, CourseStartTime, CourseEndTime,
CourseWeekDay, CourseCurrentPrice, StudentFirstName, StudentLastName, StudentEmail,
StudentPhone, StudentAddress1, StudentCity, StudentStateCode, StudentZipCode, 
EnrollmentDateTime, EnrollmentPrice
From vStudentsEnrollmentCourses;