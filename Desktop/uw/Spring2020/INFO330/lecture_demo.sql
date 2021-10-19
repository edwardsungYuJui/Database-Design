-- *****
-- Do the following:
-- Use the Northwind database to produce a report
-- that shows a list of products sold in the year 1996,
-- using a subquery
use Northwind;
go 
Select Top 1 * From Products order by ProductID;
Select Top 5 * From [Order Details] order by ProductID;
go 
Select ProductName, OrderID  
From Products as p Join [Order Details] as od 
On p.ProductID = od.ProductID;
go 
Select * From Orders;
go 
Select * From 
(Select o.OrderID, ProductID 
From [Order Details] as od Join Orders as o 
    On od.OrderID = o.OrderID
Where year(o.OrderDate) = 1996) as ProductsSold1996
go 
Select ProductName, Count(ProductsSold1996.OrderID) as NumberOfOrders 
From Products as p 
Left Outer Join (Select o.OrderID, ProductID 
      From [Order Details] as od Join Orders as o 
        On od.OrderID = o.OrderID
      Where year(o.OrderDate) = 1996) as ProductsSold1996
On p.ProductID = ProductsSold1996.ProductID 
Group By p.ProductName 
go 

-- simpler 
Select ProductName, Count(o.OrderID) as [NumberOfOrders] 
From Products as p 
Inner Join [Order Details] as od 
    On p.ProductID = od.ProductID 
Right Outer Join Orders as o 
    On od.OrderID = o.OrderID 
Where Year(o.OrderDate) = 1996 
Group By p.ProductName 
go 
