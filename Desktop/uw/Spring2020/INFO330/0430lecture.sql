-- Do the following 
-- use the northwind database to produce a report
-- that shows a list of products sold in 1996, 
-- using a temporary table


Use Northwind;
go 
Select * From Products;
go 
Select ProductName From Products;
go
Select ProductName From Products 
Where Year(OrderDate) = 1996; -- no such data details
go 
Select Distinct ProductName  
From Products as p 
Join [Order Details] as od 
    On p.ProductID = od.ProductID
Join Orders as o 
    on o.OrderID = od.OrderID
Where Year(OrderDate) = 1996
Order By 1;
go

Create Table #ProductsIn1996 (ProductName nvarchar(100)); 
go 
Insert Into #ProductsIn1996
Select Distinct ProductName  
From Products as p 
Join [Order Details] as od 
    On p.ProductID = od.ProductID
Join Orders as o 
    on o.OrderID = od.OrderID
Where Year(OrderDate) = 1996
Order By 1;
go
Select * From #ProductsIn1996

Insert Into #ProductsIn1996 
Select ProductName From Products  
Where ProductId in (Select Distinct ProductID 
                    From [Order Details] as od
                    Join Orders as o 
                        On od.OrderID = o.OrderID 
                    Where Year(OrderDate) = 1996)


-- Do the following
-- Use the northwind database to produce a report 
-- that shows a list of Products sold in 1996
-- using a CTE 
Use Northwind
go 
With ProductsIn1996 
As
(
    Select ProductName From Products  
    Where ProductId in (Select Distinct ProductID 
                        From [Order Details] as od
                        Join Orders as o 
                            On od.OrderID = o.OrderID 
                        Where Year(OrderDate) = 1996) 
)
Select * From ProductsIn1996;