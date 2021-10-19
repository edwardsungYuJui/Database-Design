--*************************************************************************--
-- Title: Dynamic SQL and SQL Injection Attacks
-- Author: RRoot
-- Desc: This file demonstrates how to create Dynamic SQL 
-- and avoid SQL Injection Attacks
-- Change Log: When,Who,What
-- 2020-01-01,RRoot,Created File
--**************************************************************************--

--Here is code that executes a simple select statement with dynamically 
--assigns the choice of columns:
Declare @ColumnNames varchar(1000) = 'OrderID, ProductId, Quantity'
Exec (
'Select ' + @ColumnNames + ' From Northwind.dbo.[Order Details] Order By ProductID ;'
);

--If you want to see what the code will evaluate into before you execute 
--it you can replace exec with select like this:
Declare @ColumnNames varchar(1000) = 'OrderID, ProductId, Quantity'
Select (
'Select ' + @ColumnNames + ' From Northwind.dbo.[Order Details] Order By ProductID ;'
);

--One thing to be aware of is how to escape single quotes, which are used 
--to indicate a string of characters. Here is an example:

Declare @FirstName varchar(100) = 'Orin', @LastName varchar(100) = 'O''Day';
Select @FirstName + ' ' + @LastName;
 
--Sometimes developers use dynamic code to perform transaction processing 
--like the examples below:
Use TempDB;
go
Create  -- Drop
Table Contacts 
(FirstName varchar(100)
,LastName varchar(100)
,EmailAddress varchar(100));
go

Declare 
 @FirstName varchar(100) = 'Bob',
 @LastName varchar(100) = 'Smith',
 @EmailAddress varchar(100) = 'BSmith@MyCo.com'

Declare @Code varchar(1000) = 'Insert Into dbo.Contacts
        (FirstName, LastName, EmailAddress)
        Values
        (''' + @FirstName  + ''', ''' + @LastName  + ''', ''' + @EmailAddress + ''');' 
Select @Code -- Insert Into dbo.Contacts (FirstName,LastName, EmailAddress) Values  ('Bob', 'Smith', 'BSmith@MyCo.com');
Exec(@Code)
Select * From Contacts;
Go

-- Example of a SQL Injection Attack 
Declare 
 @FirstName varchar(100) = 'Bob',
 @LastName varchar(100) = 'Smith',
 @EmailAddress varchar(100) = 'BSmith@MyCo.com'');Select * From Pubs.dbo.Sales--'

Declare @Code varchar(1000) = 'Insert Into dbo.Contacts (FirstName,LastName, EmailAddress)
 Values
 (''' + @FirstName  + ''', ''' + @LastName  + ''', ''' + @EmailAddress + ''');' 
Select @Code
Exec (@Code)

-- Instead of using a dynamically generated SQL, we should use a stored procedure like this one:
Create or Alter Proc pInsContacts
 (@FirstName nvarchar(100),@LastName nvarchar(100),@EmailAddress nvarchar(100))
As
 Begin
  Begin Tran;
   Insert Into Contacts (FirstName, LastName, EmailAddress)
    Values (@FirstName, @LastName, @EmailAddress);
  Commit Tran;
 End
go

Exec pInsContacts 
 @FirstName = 'Bob',
 @LastName= 'Smith',
 @EmailAddress = 'BSmith@MyCo.com'
go
Select * From Contacts;
go

Exec pInsContacts 
 @FirstName = 'Bob',
 @LastName= 'Smith',
 @EmailAddress = 'BSmith@MyCo.com'');Select * From Pubs.dbo.Sales--' -- This does not work now!
go
Select * From Contacts;
go
--FirstName	LastName	EmailAddress
--Bob	Smith	BSmith@MyCo.com
--Bob	Smith	BSmith@MyCo.com
--Bob	Smith	BSmith@MyCo.com');Select * From Pubs.dbo.Sales--
