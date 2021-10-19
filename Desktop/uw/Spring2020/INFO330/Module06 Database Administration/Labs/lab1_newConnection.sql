Use MyLabsDB_ESung
go 

 Declare @Status int;
 Exec @Status = pInsCategories @CategoryName = 'Cat2';
 Print @Status;
 Select * From vCategories;