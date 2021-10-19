--*************************************************************************--
-- Title: Final Project Milestone 02 Database 
-- Author: Edward Sung
-- Desc: This file creates tables, views and stored procedures
-- Change Log: When,Who,What
-- 2020-05-25,ESung,Created File
--**************************************************************************--
Use Master 
go

If Exists(Select Name From SysDatabases Where Name = 'PatientAppointmentsDB_ESung')
    Begin 
        Alter Database [PatientAppointmentsDB_ESung] set Single_user with Rollback Immediate;
        Drop Database PatientAppointmentsDB_ESung;
    End 
go 

Create Database PatientAppointmentsDB_ESung;
go 

Use PatientAppointmentsDB_ESung;
go 

----------- Create Table 
Create Table Clinics
(
    ClinicID int Identity(1,1) 
    ,ClinicName nvarchar (100) Not Null
    ,ClinicPhoneNumber nvarchar (100) Not Null
    ,ClinicAddress nvarchar (100) Not Null
    ,ClinicCity nvarchar (100) Not Null
    ,ClinicState nvarchar (2) Not Null
    ,ClinicZipCode nvarchar (10) Not Null
    ,Constraint pkClinicID Primary Key (ClinicID)
)
go 

Create Table Patients
(
    PatientID int Identity(1,1)
    ,PatientFirstName nVarchar(100) Not Null
    ,PatientLastName nVarchar(100) Not Null
    ,PatientPhoneNumber nVarchar(100) Not Null
    ,PatientAddress nVarchar(100) Not Null
    ,PatientCity nVarchar(100) Not Null
    ,PatientState nVarchar(2) Not Null
    ,PatientZipCode nVarchar(10) Not Null
    ,Constraint pkPatientID Primary Key (PatientID)
)
go 

Create Table Doctors
(
    DoctorID int Identity(1,1)
    ,DoctorFirstName nVarchar(100) Not Null 
    ,DoctorLastName nVarchar(100) Not Null 
    ,DoctorPhoneNumber nVarchar(100) Not Null 
    ,DoctorAddress nVarchar(100) Not Null 
    ,DoctorCity nVarchar(100) Not Null 
    ,DoctorState nVarchar(2) Not Null 
    ,DoctorZipCode nVarchar(10) Not Null 
    ,Constraint pkDoctorID Primary Key (DoctorID)
)
go 

Create Table Appointments
(
    AppointmentID int Identity(1,1)
    ,AppointmentDateTime Datetime Not Null 
    ,AppointmentPatientID int Not Null 
    ,AppointmentDoctorID int Not Null 
    ,AppointmentClinicID int Not Null
    ,Constraint pkAppointmentID Primary Key(AppointmentID)
)
go 

---------------- Add Constraints
Alter Table Clinics
	Add Constraint uqClinicName Unique (ClinicName)
go 
Alter Table Clinics
	Add Constraint ckClinicPhoneNumber Check(ClinicPhoneNumber like '[0-9][0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]')
go 
Alter Table Clinics
    Add Constraint ckClinicZipCode Check(ClinicZipCode like '[0-9][0-9][0-9][0-9][0-9]' OR ClinicZipCode 
                                         like '[0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]')
go 
Alter Table Patients
	Add Constraint ckPatientPhoneNumber Check(PatientPhoneNumber like '[0-9][0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]')
go 
Alter Table Patients
    Add Constraint ckPatientZipCode Check(PatientZipCode like '[0-9][0-9][0-9][0-9][0-9]' OR PatientZipCode 
                                         like '[0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]')
go 
Alter Table Doctors
	Add Constraint ckDoctorPhoneNumber Check(DoctorPhoneNumber like '[0-9][0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]')
go 
Alter Table Doctors
    Add Constraint ckDoctorZipCode Check(DoctorZipCode like '[0-9][0-9][0-9][0-9][0-9]' OR DoctorZipCode 
                                         like '[0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]')
go 
Alter Table Appointments 
    Add Constraint fkAppointmentsToPatients Foreign Key (AppointmentPatientID) 
    References Patients(PatientID);
go
Alter Table Appointments 
    Add Constraint fkAppointmentsToDoctors Foreign Key (AppointmentDoctorID) 
    References Doctors(DoctorID);
go
Alter Table Appointments 
    Add Constraint fkAppointmentsToClinics Foreign Key (AppointmentClinicID) 
    References Clinics(ClinicID);
go

--------Create Views 
Create or Alter View vClinics
As 
	Select 
        ClinicID
        ,ClinicName 
        ,ClinicPhoneNumber 
        ,ClinicAddress 
        ,ClinicCity
        ,ClinicState 
        ,ClinicZipCode 
    From Clinics;
go 
Create or Alter View vPatients
As 
    Select
        PatientID 
        ,PatientFirstName 
        ,PatientLastName 
        ,PatientPhoneNumber 
        ,PatientAddress 
        ,PatientCity 
        ,PatientState
        ,PatientZipCode
    From Patients;
go 
Create or Alter View vDoctors
As 
    Select
        DoctorID 
        ,DoctorFirstName 
        ,DoctorLastName 
        ,DoctorPhoneNumber 
        ,DoctorAddress 
        ,DoctorCity 
        ,DoctorState 
        ,DoctorZipCode 
    From Doctors;
go 
Create or Alter View vAppointments
As 
    Select
        AppointmentID 
        ,AppointmentDateTime 
        ,AppointmentPatientID 
        ,AppointmentDoctorID 
        ,AppointmentClinicID
    From Appointments;
go 

-- Reporting View
Create View vAppointmentsByPatientsDoctorsAndClinics
As Select
    a.AppointmentID
    ,[AppointmentDate] = Format(AppointmentDateTime,'mm-dd-yyyy')
    ,[AppointmentTime] = Format(AppointmentDateTime,'hh:mm')
    ,p.PatientID
    ,[PatientName] = PatientFirstName + ' ' + PatientLastName
    ,PatientPhoneNumber
    ,PatientAddress
    ,PatientCity
    ,PatientState
    ,PatientZipCode
    ,d.DoctorID
    ,[DoctorName] = DoctorFirstName + ' ' + DoctorLastName
    ,DoctorPhoneNumber
    ,DoctorAddress
    ,DoctorCity
    ,DoctorState
    ,DoctorZipCode
    ,c.ClinicID
    ,ClinicName
    ,ClinicPhoneNumber
    ,ClinicAddress
    ,ClinicCity
    ,ClinicState
    ,ClinicZipCode
From Appointments as a
Join Patients as p 
    On a.AppointmentPatientID = p.PatientID
Join Doctors as d 
    On a.AppointmentDoctorID = d.DoctorID
Join Clinics as c 
    On a.AppointmentClinicID = c.ClinicID;
go

-- Stored Procedures
Create Procedure pInsClinics                               
(
@ClinicName nvarchar(100)
,@ClinicPhoneNumber nvarchar(100)
,@ClinicAddress nvarchar(100)
,@ClinicCity nvarchar(100) 
,@ClinicState nvarchar(2)
,@ClinicZipCode nvarchar(10)
,@ClinicID int Output
)
/* Author: ESung
** Desc: Processes Insert For Clinics Table
** Change Log: When,Who,What
** 2020-05-25,ESung ,Created stored procedure.
*/
As
Begin
 Declare @RC int = 0;
  Begin Try
   Begin Transaction;
    -- Transaction Code --
    Insert Into Clinics
  	  (ClinicName
	  ,ClinicPhoneNumber
	  ,ClinicAddress
	  ,ClinicCity
	  ,ClinicState
  	  ,ClinicZipCode)
 	values( @ClinicName
	 	    ,@ClinicPhoneNumber
		    ,@ClinicAddress
		    ,@ClinicCity
		    ,@ClinicState
 		    ,@ClinicZipCode);
   Select @ClinicID = SCOPE_IDENTITY()
   Commit Transaction;
   Set @RC = +1
  End Try
  Begin Catch
    If(@@Trancount > 0)  Rollback Transaction;
    Print Error_Message();
    Set @RC = -1
  End Catch
  Return @RC;
 End
go
/*
 Declare @Status int;
 Exec @Status = pInsClinics 
        @ClinicName = 'MainClinic';
        @ClinicPhoneNumber = '206-222-1111',
        @ClinicAddress = 'Not Main Ave', 
        @ClinicCity = 'Los Angeles', 
        @ClinicState = 'CA', 
        @ClinicZipCode = 45682;
 Print @Status;
 Select * From Clinics;
*/

Create Procedure pUpdClinics                               
(
@ClinicID int 
,@ClinicName nvarchar(100)
,@ClinicPhoneNumber nvarchar(100)
,@ClinicAddress nvarchar(100)
,@ClinicCity nvarchar(100) 
,@ClinicState nvarchar(2)
,@ClinicZipCode nvarchar(10)
)
/* Author: ESung
** Desc: Processes Update For Clinics Table
** Change Log: When,Who,What
** 2020-05-25,ESung ,Created stored procedure.
*/
As
Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction;
    -- Transaction Code --
    Update Clinics
    Set ClinicName = @ClinicName,
		ClinicPhoneNumber = @ClinicPhoneNumber,
        ClinicAddress = @ClinicAddress,
		ClinicCity = @ClinicCity,
		ClinicState = @ClinicState,
		ClinicZipCode = @ClinicZipCode
    Where ClinicID = @ClinicID;
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
/*
 Declare @Status int;
 Exec @Status = pUpdClinics 
        @ClinicID = 1, 
        @ClinicName = 'HelloClinic', 
        @ClinicPhoneNumber = '206-111-1111',
        @ClinicAddress = 'Main Ave', 
        @ClinicCity = 'Seattle', 
        @ClinicState = 'WA', 
        @ClinicZipCode = 98112;
 Print @Status;
 Select * From Clinics;
*/

Create Procedure pDelClinics                               
(@ClinicID int)
/* Author: ESung
** Desc: Processes Delete For Clinics Table
** Change Log: When,Who,What
** 2020-05-25,ESung ,Created stored procedure.
*/
As
Begin
  Declare @RC int = 0;
  Begin Try
   Begin Transaction;
    -- Transaction Code --
    Delete From Clinics Where ClinicID = @ClinicID
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
/*
 Declare @Status int;
 Exec @Status = pDelClinics 
        @ClinicID = 1, 
        @ClinicName = 'HelloClinic', 
        @ClinicPhoneNumber = '206-111-1111',
        @ClinicAddress = 'Main Ave', 
        @ClinicCity = 'Seattle', 
        @ClinicState = 'WA', 
        @ClinicZipCode = 98112;
 Print @Status;
 Select * From Clinics;
*/

-------------------------------------------------------
Create Procedure pInsAppointments
(@AppointmentDateTime Datetime
,@AppointmentPatientID int
,@AppointmentDoctorID int
,@AppointmentClinicID int
,@AppointmentID int Output)
/* Author: ESung
** Desc: Processes Insert for the Appointments Table
** Change Log: When,Who,What
** 2020-05-25,ESung,Created stored procedure.
*/
As 
 Begin
  Declare @RC int = 0;
  Begin Try
    Begin Transaction 
     Insert Into Appointments(
     	AppointmentDateTime 
        ,AppointmentPatientID 
        ,AppointmentDoctorID 
        ,AppointmentClinicID)
     Values (@AppointmentDateTime
    		,@AppointmentPatientID
    		,@AppointmentDoctorID
    		,@AppointmentClinicID);
    Select @AppointmentID = SCOPE_IDENTITY ()
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

Create Procedure pUpdAppointments
(@AppointmentID int
,@AppointmentDateTime Datetime
,@AppointmentPatientID int
,@AppointmentDoctorID int
,@AppointmentClinicID int)
/* Author: ESung
** Desc: Processes Update for the Appointments Table
** Change Log: When,Who,What
** 2020-05-25,ESung,Created stored procedure.
*/
As 
 Begin
  Declare @RC int = 0;
  Begin Try
    Begin Transaction 
     Update Appointments Set 
        AppointmentDateTime = @AppointmentDateTime
        ,AppointmentPatientID = @AppointmentPatientID
        ,AppointmentDoctorID = @AppointmentDoctorID
        ,AppointmentClinicID = @AppointmentClinicID
     Where AppointmentID = @AppointmentID
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

Create Procedure pDelAppointments
(@AppointmentID int)
/* Author: ESung
** Desc: Processes Update for the Appointments Table
** Change Log: When,Who,What
** 2020-05-25,ESung,Created stored procedure.
*/
As 
 Begin
  Declare @RC int = 0;
  Begin Try
    Begin Transaction 
     Delete From Appointments Where AppointmentID = @AppointmentID
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

----------------------------------------------------------
Create Procedure pInsPatients
(@PatientFirstName nVarchar(100)
,@PatientLastName nVarchar(100)
,@PatientPhoneNumber nVarchar(100)
,@PatientAddress nVarchar(100)
,@PatientCity nVarchar(100)
,@PatientState nchar(2)
,@PatientZipCode nVarchar(10)
,@PatientID int Output)
/* Author: ESung
** Desc: Processes Insert for the Patients Table
** Change Log: When,Who,What
** 2020-05-24,ESung,Created stored procedure.
*/
As 
 Begin
  Declare @RC int = 0;
  Begin Try
    Begin Transaction 
        Insert Into Patients(
            PatientFirstName
            ,PatientLastName
            ,PatientPhoneNumber
            ,PatientAddress
            ,PatientCity
            ,PatientState
            ,PatientZipCode)
        Values(
            @PatientFirstName
            ,@PatientLastName
            ,@PatientPhoneNumber
            ,@PatientAddress
            ,@PatientCity
            ,@PatientState
            ,@PatientZipCode);
    Select @PatientID = SCOPE_IDENTITY()
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

Create Procedure pUpdPatients
(@PatientID int
,@PatientFirstName nVarchar(100)
,@PatientLastName nVarchar(100)
,@PatientPhoneNumber nVarchar(100)
,@PatientAddress nVarchar(100)
,@PatientCity nVarchar(100)
,@PatientState nchar(2)
,@PatientZipCode nVarchar(10))
/* Author: ESung
** Desc: Processes update for the Patients table
** Change Log: When,Who,What
** <2020-05-24>,ESung,update stored procedure.
*/
As 
 Begin
  Declare @RC Int = 0;
  Begin Try
   Begin Transaction 
   -- Transaction Code 
    Update Patients Set 
         PatientFirstName = @PatientFirstName
        ,PatientLastName = @PatientLastName
        ,PatientPhoneNumber = @PatientPhoneNumber
        ,PatientAddress = @PatientAddress
        ,PatientCity = @PatientCity
        ,PatientState = @PatientState
        ,PatientZipCode = @PatientZipCode
    Where PatientID = @PatientID
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

Create Procedure pDelPatients
(@PatientID int)
/* Author: ESung
** Desc: Processes delete for the Patients table
** Change Log: When,Who,What
** <2020-05-24>,ESung,delete stored procedure.
*/
As 
 Begin
  Declare @RC Int = 0;
  Begin Try
   Begin Transaction 
   -- Transaction Code
    Delete From Patients Where PatientID = @PatientID
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

 -------------------------------------------------
 Create Procedure pInsDoctors
(@DoctorFirstName nVarchar(100)
,@DoctorLastName nVarchar(100)
,@DoctorPhoneNumber nVarchar(100)
,@DoctorAddress nVarchar(100)
,@DoctorCity nVarchar(100)
,@DoctorState nchar(2)
,@DoctorZipCode nVarchar(10)
,@DoctorID int Output)
/* Author: ESung
** Desc: Processes Insert for the Doctors Table
** Change Log: When,Who,What
** 2020-05-25,ESung,Created stored procedure.
*/
As 
 Begin
  Declare @RC int = 0;
  Begin Try
    Begin Transaction 
        Insert Into Doctors(
            DoctorFirstName
            ,DoctorLastName
            ,DoctorPhoneNumber
            ,DoctorAddress
            ,DoctorCity
            ,DoctorState
            ,DoctorZipCode)
        Values(
            @DoctorFirstName
            ,@DoctorLastName
            ,@DoctorPhoneNumber
            ,@DoctorAddress
            ,@DoctorCity
            ,@DoctorState
            ,@DoctorZipCode);
    Select @DoctorID = SCOPE_IDENTITY()
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

Create Procedure pUpdDoctors
(@DoctorID int
,@DoctorFirstName nVarchar(100)
,@DoctorLastName nVarchar(100)
,@DoctorPhoneNumber nVarchar(100)
,@DoctorAddress nVarchar(100)
,@DoctorCity nVarchar(100)
,@DoctorState nchar(2)
,@DoctorZipCode nVarchar(10))
/* Author: ESung
** Desc: Processes update for the Doctors table
** Change Log: When,Who,What
** 2020-05-24,ESung,update stored procedure.
*/
As 
 Begin
  Declare @RC Int = 0;
  Begin Try
   Begin Transaction 
   -- Transaction Code 
    Update Doctors Set 
        DoctorFirstName = @DoctorFirstName
        ,DoctorLastName = @DoctorLastName
        ,DoctorPhoneNumber = @DoctorPhoneNumber
        ,DoctorAddress = @DoctorAddress
        ,DoctorCity = @DoctorCity
        ,DoctorState = @DoctorState
        ,DoctorZipCode = @DoctorZipCode
    Where DoctorID = @DoctorID
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

Create Procedure pDelDoctors
(@DoctorID int)
/* Author: ESung
** Desc: Processes delete for the Patients table
** Change Log: When,Who,What
** <2020-05-25>,ESung,delete stored procedure.
*/
As 
 Begin
  Declare @RC Int = 0;
  Begin Try
   Begin Transaction 
   -- Transaction Code 
    Delete From Doctors Where DoctorID = @DoctorID
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


---------------- Set Permissions 

Deny Select, Insert, Update, Delete On Clinics To Public; 
Grant Select On vClinics To Public;
Grant Execute On pInsClinics To Public;
Grant Execute On pUpdClinics To Public;
Grant Execute On pDelClinics To Public;

Deny Select, Insert, Update, Delete On Patients To Public; 
Grant Select On vPatients To Public;
Grant Execute On pInsPatients To Public;
Grant Execute On pUpdPatients To Public;
Grant Execute On pDelPatients To Public;

Deny Select, Insert, Update, Delete On Doctors To Public; 
Grant Select On vDoctors To Public;
Grant Execute On pInsDoctors To Public;
Grant Execute On pUpdDoctors To Public;
Grant Execute On pDelDoctors To Public;

Deny Select, Insert, Update, Delete On Appointments To Public; 
Grant Select On vAppointments To Public;
Grant Execute On pInsAppointments To Public;
Grant Execute On pUpdAppointments To Public;
Grant Execute On pDelAppointments To Public;
go

---------------- Test Inserts 
DECLARE @NewClinicID INT;
Declare @Status Int;
Exec @Status = pInsClinics @ClinicID = @NewClinicID Output
    ,@ClinicName = 'MainClinics'
    ,@ClinicPhoneNumber ='206-999-1234'
    ,@ClinicAddress = 'Main Street'
    ,@ClinicCity = 'Seattle'
    ,@ClinicState = 'WA'
    ,@ClinicZipCode = '98117'
Select Case @Status
  When +1 Then 'Insert was successful!'
  When -1 Then 'Insert failed! Common Issues: Duplicate Data'
  End as [Status]; 
Select [The New ID Was: ] = @NewClinicID;
Select * From vClinics;
go 
  
Declare @NewPatientID Int;
Declare @Status Int;
Exec @Status = pInsPatients @PatientID = @NewPatientID Output
    ,@PatientFirstName = 'Bob'
    ,@PatientLastName = 'Smith'
    ,@PatientPhoneNumber = '206-666-6666'
    ,@PatientAddress = '123 Street'
    ,@PatientCity = 'Seattle'
    ,@PatientState = 'WA'
    ,@PatientZipCode = '98105'
Select Case @Status
  When +1 Then 'Insert was successful!'
  When -1 Then 'Insert failed! Common Issues: Duplicate Data'
  End as [Status]; 
Select [The New ID Was: ] = @NewPatientID
Select * From vPatients;
Go

Declare @NewDoctorID Int;
Declare @Status Int;
Exec @Status = pInsDoctors @DoctorID = @NewDoctorID Output
    ,@DoctorFirstName = 'Kevin'
    ,@DoctorLastName = 'Smith'
    ,@DoctorPhoneNumber = '206-000-9876'
    ,@DoctorAddress = 'Not Main Street'
    ,@DoctorCity = 'Seattle'
    ,@DoctorState = 'WA'
    ,@DoctorZipCode = '98001'
Select Case @Status
  When +1 Then 'Insert was successful!'
  When -1 Then 'Insert failed! Common Issues: Duplicate Data'
  End as [Status];
Select [The New ID Was: ] = @NewDoctorID
Select * From vDoctors;
go 

Declare @NewAppointmentID Int;
Declare @Status Int;
Declare @NewAppointmentPatientID int = IDENT_CURRENT('Patients')
Declare @NewAppointmentDoctorID int = IDENT_CURRENT('Doctors')
Declare @NewAppointmentClinicID int = IDENT_CURRENT('Clinics')
Exec @Status = pInsAppointments @AppointmentID = @NewAppointmentID Output
    ,@AppointmentDateTime ='02-15-2020'
    ,@AppointmentPatientID = @NewAppointmentPatientID
    ,@AppointmentDoctorID = @NewAppointmentDoctorID
    ,@AppointmentClinicID = @NewAppointmentClinicID
Select Case @Status
  When +1 Then 'Insert was successful!'
  When -1 Then 'Insert failed! Common Issues: Duplicate Data'
  End as [Status]; 
Select [The New ID Was: ] = @NewAppointmentID
Select * From vAppointments;
Go

-------- Test Updates
Declare @Status int;
Declare @NewClinicID int = IDENT_CURRENT('ClinicID')
Exec @Status = pUpdClinics 
     @ClinicID = @NewClinicID
    ,@ClinicName = 'Hello Clinic'
	,@ClinicPhoneNumber= '205-444-1204'
 	,@ClinicAddress = 'Hi Street'
 	,@ClinicCity= 'San Francisco'
	,@ClinicState = 'CA'
 	,@ClinicZipCode = '67803'
Select Case @Status
When +1 Then 'Update was successful!'
When -1 Then 'Update failed! Common Issue: Check Value'
End as [Status]
Select * From Clinics;
go 

Declare @Status int;
Declare @NewPatientID int = IDENT_CURRENT('PatientID')
Exec @Status = pUpdPatients 
     @PatientID = @NewPatientID
    ,@PatientFirstName = 'Johny'
	,@PatientLastName= 'Walker'
 	,@PatientPhoneNumber = '240-111-8888'
 	,@PatientAddress= '888 Ave Street'
	,@PatientCity = 'San Francisco'
 	,@PatientState = 'CA'
    ,@PatientZipCode = '24560'
Select Case @Status
When +1 Then 'Update was successful!'
When -1 Then 'Update failed! Common Issue: Check Value'
End as [Status]
Select * From Patients;
go 

Declare @Status int;
Declare @NewDoctorID int = IDENT_CURRENT('DoctorID')
Exec @Status = pUpdDoctors 
     @DoctorID = @NewDoctorID
    ,@DoctorFirstName = 'Oscar'
	,@DoctorLastName= 'Huffman'
 	,@DoctorPhoneNumber = '235-325-1111'
 	,@DoctorAddress= '111 Street'
	,@DoctorCity = 'New York'
 	,@DoctorState = 'NY'
    ,@DoctorZipCode = '10045'
Select Case @Status
When +1 Then 'Update was successful!'
When -1 Then 'Update failed! Common Issue: Check Value'
End as [Status]
Select * From Doctors;
go 

Declare @Status int;
Declare @NewAppointmentID int = IDENT_CURRENT('AppointmentID')
Exec @Status = pUpdAppointments 
     @AppointmentID = @NewAppointmentID
    ,@AppointmentDateTime = '02－15－2020'
	,@AppointmentPatientID= '2'
 	,@AppointmentDoctorID = '2'
 	,@AppointmentClinicID = '2'
Select Case @Status
When +1 Then 'Update was successful!'
When -1 Then 'Update failed! Common Issue: Check Value'
End as [Status]
Select * From Appointments;
go 

-------- Test Deletes
Declare @Status int;
Declare @NewAppointmentID int = IDENT_CURRENT('AppointmentID')
Exec @Status = pDelAppointments @AppointmentID = @NewAppointmentID;
Select Case @Status
  When +1 Then 'Delete was successful!'
  When -1 Then 'Delete failed! Common Issue: Foreign Key values must be delete first'
  End as [Status]
Select * From Appointments;
go 

Declare @Status int;
Declare @NewClinicID int = IDENT_CURRENT('ClinicID')
Exec @Status = pDelClinics @ClinicID = @NewClinicID;
Select Case @Status
  When +1 Then 'Delete was successful!'
  When -1 Then 'Delete failed! Common Issue: Foreign Key values must be delete first'
  End as [Status]
Select * From Clinics;
go 

Declare @Status int;
Declare @NewPatientID int = IDENT_CURRENT('PatientID')
Exec @Status = pDelPatients @PatientID = @NewPatientID;
Select Case @Status
  When +1 Then 'Delete was successful!'
  When -1 Then 'Delete failed! Common Issue: Foreign Key values must be delete first'
  End as [Status]
Select * From Patients;
go 

Declare @Status int;
Declare @NewDoctorID int = IDENT_CURRENT('DoctorID')
Exec @Status = pDelDoctors @DoctorID = @NewDoctorID;
Select Case @Status
  When +1 Then 'Delete was successful!'
  When -1 Then 'Delete failed! Common Issue: Foreign Key values must be delete first'
  End as [Status]
Select * From Doctors;
go 

