---------------------------------------
-- Title: Mod03-Lab03
-- Desc: Answer for lab03
-- ChangeLog(When,Who,What)
-- 4/5, ESung, Created Script
---------------------------------------
Use Master;
go
If Exists(Select Name From SysDatabases Where Name = 'Mod02Lab03ESung')
    Drop Database Mod02Lab03ESung;
go 
Create Database Mod02Lab03ESung;
go 
Use Mod02Lab03ESung;
go

Create Table Attendees
(AttendeeID int Constraint pkAttendees Primary Key Not Null Identity(1,1)
,AttendeeName nvarchar (100) Not Null
,AttendeeEmail nvarchar (100) Not Null Constraint ckAttendeeEmailPattern 
                                        Check(AttendeeEmail like '%@%.%')
,AttendeePhone nvarchar (100) Not Null Constraint ckAttendeePhonePattern 
                                        Check(AttendeePhone like '([0-9][0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9])')
);

Create Table ConferenceRooms
(ConferenceRoomID int Constraint pkConferenceRooms Primary Key Not Null Identity(1,1)
,ConferenceRoomName	nvarchar (100) Not Null
,ConferenceRoomFloor int Not Null
,ConferenceRoomLocation	nvarchar (100) Not Null
);
go
Alter Table ConferenceRooms
    Add Constraint uqConferenceRoomLocation Unique (ConferenceRoomLocation)
go 
Alter Table ConferenceRooms
    Add Constraint uqConferenceRoomNameAndFloor Unique (ConferenceRoomName,ConferenceRoomFloor)
go 
Alter Table ConferenceRooms
    Add Constraint ckConferenceFloorGTZero Check (ConferenceRoomFloor > 0)
go 
Create Table Meetings
(MeetingID int Constraint pkMeetings Primary Key Not Null Identity(1,1)
,MeetingSubject nvarchar(100) Not Null
,MeetingDate date Not Null
,MeetingHour int Not Null
,ConferenceRoomID int Not Null
);
go 
Alter Table Meetings
    Add Constraint ckMeetingDateGTNow Check (MeetingDate >= GetDate())
go 
Alter Table Meetings
    Add Constraint ckMeetingHourLTNow Check (MeetingHour < 24)
go 
Alter Table Meetings
    Add Constraint dfMeetingDateNow Default (GetDate()) For MeetingDate
go 
Alter Table Meetings
    Add Constraint fkConferenceRoomID Foreign Key (ConferenceRoomID)
      References ConferenceRooms(ConferenceRoomID);
go 

Create Table MeetingsAttendees
(MeetingID int Not Null
,AttendeeID int Not Null
,Constraint pkMeetingsAttendees Primary Key (MeetingID, AttendeeID)
);
Alter Table MeetingsAttendees
    Add Constraint fkMeetingID Foreign Key (MeetingID)
      References Meetings(MeetingID);
go 
Alter Table MeetingsAttendees
    Add Constraint fkAttendeeID Foreign Key (AttendeeID)
      References Attendees(AttendeeID);
go 
sp_helpConstraint ConferenceRooms;
go
sp_helpConstraint Meetings;
go
sp_helpConstraint Attendees;
go
sp_helpConstraint MeetingsAttendees;
