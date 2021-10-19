--reporting View
Create View vLittleView
As Select
    a.AppointmentID
    ,[AppointmentDate] = Format(AppointmentDateTime,'mm-dd-yyyy')
    ,[AppointmentTime] = Format(AppointmentDateTime,'hh:mm')
    ,p.PatientID
    ,[PatientName] = PatientFirstName + ' ' + PatientLastName
    ,PatientPhoneNumber
    ,d.DoctorID
    ,[DoctorName] = DoctorFirstName + ' ' + DoctorLastName
    ,DoctorPhoneNumber
    ,c.ClinicID
    ,ClinicName
    ,ClinicPhoneNumber
From Appointments as a
Join Patients as p On a.AppointmentPatientID = p.PatientID
Join Doctors as d On a.AppointmentDoctorID = d.DoctorID
Join Clinics as c On a.AppointmentClinicID = c.ClinicID;
go

--reporting View
Create View vNumberOfPatients
As Select
    ClinicName,
    [Amount of Patient] =Count(Distinct p.PatientID)
From Appointments as a
Join Patients as p  On a.AppointmentPatientID = p.PatientID
Join Doctors as d On a.AppointmentDoctorID = d.DoctorID
Join Clinics as c On a.AppointmentClinicID = c.ClinicID
Group by ClinicName;
go


/*
--reporting View
Create View vLittleView
As Select
    a.AppointmentID
    ,[AppointmentDate] = Format(AppointmentDateTime,'mm-dd-yyyy')
    ,[AppointmentTime] = Format(AppointmentDateTime,'hh:mm')
    ,p.PatientID
    ,[PatientName] = PatientFirstName + '' + PatientLastName
    ,PatientPhoneNumber
    ,d.DoctorID
    ,[DoctorName] = DoctorFirstName + '' + DoctorLastName
    ,DoctorPhoneNumber
    ,c.ClinicID
    ,ClinicName
    ,ClinicPhoneNumber
From Appointments as a
Join Patients as p On a.AppointmentPatientID = p.PatientID
Join Doctors as d On a.AppointmentDoctorID = d.DoctorID
Join Clinics as c On a.AppointmentClinicID = c.ClinicID;
go

--reporting View
Create View vAppointmentByClinic
As Select
    a.AppointmentID
    ,[AppointmentDate] = Format(AppointmentDateTime,'mm-dd-yyyy')
    ,[AppointmentTime] = Format(AppointmentDateTime,'hh:mm')
    ,c.ClinicID
    ,ClinicName
    ,ClinicPhoneNumber
    ,ClinicAddress
    ,ClinicCity
    ,ClinicState
    ,ClinicZipCode
From Appointments as a
Join Clinics as c On a.AppointmentClinicID = c.ClinicID;
go

--reporting View
Create View vAppointmentByPatientByDoctor
As Select
    a.AppointmentID
    ,[AppointmentDate] = Format(AppointmentDateTime,'mm-dd-yyyy')
    ,[AppointmentTime] = Format(AppointmentDateTime,'hh:mm')
    ,p.PatientID
    ,[PatientName] = PatientFirstName + '' + PatientLastName
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
From Appointments as a
Join Patients as p 
    On a.AppointmentPatientID = p.PatientID
Join Doctors as d 
    On a.AppointmentDoctorID = d.DoctorID
go
*/