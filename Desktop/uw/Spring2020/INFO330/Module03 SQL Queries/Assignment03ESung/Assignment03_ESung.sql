--*************************************************************************--
-- Title: Assignment03
-- Author: Edward Sung
-- Desc: This file demonstrates how to select data from a database
-- Change Log: When,Who,What
-- 2020-04-20,Edward Sung,Created File
--**************************************************************************--
Use Northwind; 
go 

/********************************* Questions and Answers *********************************/
-- Data Request: 0301
-- Date: 1/1/2020
-- From: Jane Encharge CEO
-- Request: I want a list of customer companies and their contact people
-- Needed By: ASAP
Select * 
From Customers; -- get the whole database
go 
Select CompanyName, ContactName -- filter
From Customers;
go 

-- Data Request: 0302
-- Date: 1/2/2020
-- From: Jane Encharge CEO
-- Request: I want a list of customer companies and their contact people, but only the ones in US and Canada
-- Needed By: ASAP
Select CompanyName, ContactName, Country 
From Customers 
Where Country = 'USA' or Country = 'Canada' -- filter the two countries
Order By Country,CompanyName; -- put in correct order 
go 

-- Data Request: 0303
-- Date: 1/2/2020
-- From: Jane Encharge CEO
-- Request: I want a list of products, their standard price and their categories. Order the results by Category Name 
-- and then Product Name, in alphabetical order
-- Needed By: ASAP
Select * 
From Categories; -- get one of the databases
go
Select * 
From Products; -- get one of the databases
go 
Select c.CategoryName, p.ProductName, [Standard Price] = '$' + cast(p.UnitPrice as nvarchar(100)) -- add dollar sign
From Categories as c -- join from two databases and create alias
Join Products as p  
On c.CategoryID = p.CategoryID 
Order by c.CategoryName, p.ProductName;
go

-- Data Request: 0304
-- Date: 1/3/2020
-- From: Jane Encharge CEO
-- Request: I want a list of how many customers we have in the US
-- Needed By: ASAP
SELECT Count(*) as [Count], Country -- get the total count
FROM Customers
Where Country = 'USA' -- filter
Group By Country; -- group them together
go


-- Data Request: 0305
-- Date: 1/4/2020
-- From: Jane Encharge CEO
-- Request: I want a list of how many customers we have in the US and Canada, with subtotals for each
-- Needed By: ASAP
SELECT Count(Country) as [Count], Country 
FROM Customers
WHERE Country = 'Canada' or Country = 'USA' -- filter out two countries
GROUP BY Country; -- group them 
go  

/***************************************************************************************/