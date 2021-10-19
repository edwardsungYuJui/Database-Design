Use Northwind;
Select * 
    From Sys.Tables
        Where type = 'u'
            Order By Name;

Select * From Orders Order By ShipName;
Select * From [Order Details];

Exec sp_help 'Orders';
Exec sp_help 'Order Details';