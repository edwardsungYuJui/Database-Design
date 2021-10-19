--**********************************************************************************************--
-- Title: Assigment09
-- Author: ESung
-- Desc: This file demonstrates how to design and create; 
--       tables, constraints, views, stored procedures, and permissions
-- Change Log: When,Who,What
-- 2020-05-31,ESung,Created File
--***********************************************************************************************--
Use PatientAppointmentsDB_ESung;
go 


Insert Into Clinics(ClinicName
                    ,ClinicPhoneNumber
                    ,ClinicAddress
                    ,ClinicCity
                    ,ClinicState
                    ,ClinicZipCode)

Values('one111Clinic', '111-111-1111', '111 Main St', 'Seattle', 'WA', '98111')
,('two111Clinic', '222-222-2222', '222 Main St', 'Seattle', 'WA', '98222')
,('three111Clinic', '333-333-3333', '333 Main St', 'Seattle', 'WA', '98333')
,('four111Clinic', '444-444-4444', '444 Main St', 'Seattle', 'WA', '98444')
,('five111Clinic', '555-555-5555', '555 Main St', 'Seattle', 'WA', '98555')
;
Go

Insert Into Doctors(DoctorFirstName
                    ,DoctorLastName
                    ,DoctorPhoneNumber
                    ,DoctorAddress
                    ,DoctorCity
                    ,DoctorState
                    ,DoctorZipCode)
Values('Alvin', 'Bryant', '001-234-5678', '01 Main St', 'Seattle', 'WA', '98001')
,('Bob', 'Kerr', '002-234-5678', '1 Main St', 'Seattle', 'WA', '98002')
,('Calvin', 'Ren', '003-234-5678', '2 Main St', 'Seattle', 'WA', '98003')
,('David', 'James', '004-234-5678', '3 Main St', 'Seattle', 'WA', '98004')
,('Edwin', 'Howard', '005-234-5678', '4 Main St', 'Seattle', 'WA', '98005')
,('Hency', 'Loveless', '006-234-5678', '5 Main St', 'Seattle', 'WA', '98006')
,('Greg', 'York', '007-234-5678', '6 Main St', 'Seattle', 'WA', '98007')
,('Henry', 'Ko', '008-234-5678', '7 Main St', 'Seattle', 'WA', '98008')
,('Ian', 'Chen', '009-234-5678', '8 Main St', 'Seattle', 'WA', '98009')
,('Jerry', 'Lin', '010-234-5678', '9 Main St', 'Seattle', 'WA', '98010')
;
Go

Insert Into Patients(PatientFirstName
            ,PatientLastName
            ,PatientPhoneNumber
            ,PatientAddress
            ,PatientCity
            ,PatientState
            ,PatientZipCode)
Values('Abe1', 'Hency1', '101-234-5678', '111 Main St', 'Seattle', 'WA', '98001')
,('Abe2', 'Hency2', '102-234-5678', '112 Main St', 'Seattle', 'WA', '98002')
,('Abe3', 'Hency3', '103-234-5678', '113 Main St', 'Seattle', 'WA', '98003')
,('Abe4', 'Hency4', '104-234-5678', '114 Main St', 'Seattle', 'WA', '98004')
,('Abe5', 'Hency5', '105-234-5678', '115 Main St', 'Seattle', 'WA', '98005')
,('Abe6', 'Hency6', '106-234-5678', '116 Main St', 'Seattle', 'WA', '98006')
,('Abe7', 'Hency7', '107-234-5678', '117 Main St', 'Seattle', 'WA', '98007')
,('Abe8', 'Hency8', '108-234-5678', '118 Main St', 'Seattle', 'WA', '98008')
,('Abe9', 'Hency9', '109-234-5678', '119 Main St', 'Seattle', 'WA', '98009')
,('Abe10', 'Hency10', '110-234-5678', '120 Main St', 'Seattle', 'WA', '98010')
;
Go

Insert Into Appointments(AppointmentDateTime
                        ,AppointmentPatientID
                        ,AppointmentDoctorID
                        ,AppointmentClinicID)
Values('02-01-2020 00:00', '1', '10', '1')
,('02-02-2020 00:00', '2', '11', '1')
,('02-03-2020 00:00', '3', '12', '2')
,('02-04-2020 00:00', '4', '13', '3')
,('02-05-2020 00:00', '5', '14', '2')
,('02-06-2020 00:00', '6', '15', '1')
,('02-07-2020 00:00', '7', '14', '4')
,('02-08-2020 00:00', '8', '11', '1')
,('02-09-2020 00:00', '9', '10', '4')
,('02-10-2020 00:00', '10', '12', '1')
;
Go