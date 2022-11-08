-- Ćwiczenie 1:
-- Wybierz nazwy i numery telefonów klientów , którym w 1997 roku przesyłki dostarczała firma United Package

-- 1) łączenie tabel
select distinct Customers.CompanyName, Customers.Phone from Customers, Orders, Shippers
where Orders.CustomerID = Customers.CustomerID and ShipVia = Shippers.ShipperID
and Shippers.CompanyName = 'United Package' and year(ShippedDate) = 1997

-- 2) łączenie tabel
select distinct Customers.CompanyName, Customers.Phone from Customers
left outer join Orders on Customers.CustomerID = Orders.CustomerID
left outer join Shippers on Orders.ShipVia = Shippers.ShipperID
where Shippers.CompanyName = 'United Package' and year(ShippedDate) = 1997

-- 3) podzapytanie
select distinct Customers.CompanyName, Customers.Phone from Customers
left outer join Orders on Customers.CustomerID = Orders.CustomerID
where year(Shippeddate) = 1997
and ShipVia = (select ShipperId from Shippers where Shippers.CompanyName = 'United Package')

--Wybierz nazwy i numery telefonów klientów, którzy kupowali produkty z kategorii Confections.
-- 1) łączenie tabel
select distinct CompanyName, Phone from Customers
inner join Orders on Customers.CustomerID = Orders.CustomerID
inner join [Order Details] on Orders.OrderID = [Order Details].OrderID
inner join Products on Products.ProductID = [Order Details].ProductID
inner join Categories on Products.CategoryID = Categories.CategoryID
where CategoryName = 'Confections'

-- 2) łączenie tabel wraz z podzapytaniem
select distinct CompanyName, Phone from Customers
inner join Orders on Customers.CustomerID = Orders.CustomerID
inner join [Order Details] on Orders.OrderID = [Order Details].OrderID
inner join Products on Products.ProductID = [Order Details].ProductID
where CategoryID = (select CategoryID from Categories where CategoryName = 'Confections')

-- 3) operator "in"
select CompanyName, Phone
from Customers
where Customers.CustomerID in
(select distinct Orders.CustomerID from Orders
inner join [Order Details] on Orders.OrderID = [Order Details].OrderID
inner join Products on [Order Details].ProductID = Products.ProductID
inner join Categories on Products.CategoryID = Categories.CategoryID
where CategoryName = 'Confections')

-- Wybierz nazwy i numery telefonów klientów, którzy nie kupowali produktów z kategorii Confections.
-- 1) operator "not in"
select CompanyName, Phone
from Customers
where Customers.CustomerID not in
(select distinct Orders.CustomerID from Orders
inner join [Order Details] on Orders.OrderID = [Order Details].OrderID
inner join Products on [Order Details].ProductID = Products.ProductID
inner join Categories on Products.CategoryID = Categories.CategoryID
where CategoryName = 'Confections')

-- Ćwiczenie 2:
-- Dla każdego produktu podaj maksymalną liczbę zamówionych jednostek

-- 1) modyfikator "group by"
select ProductID, max(Quantity) as 'maximum quantity' from [Order Details] group by ProductID order by ProductID

-- 2) podzapytanie
select distinct pzew.ProductID,
(select max(Quantity) from [Order Details] as pwew where pzew.ProductID = pwew.ProductID) as 'maximum quantity'
from [Order Details] as pzew

-- Podaj wszystkie produkty których cena jest mniejsza niż średnia cena produktu
-- 1) podzapytanie
select ProductID, ProductName, UnitPrice from Products
where UnitPrice < (select avg(UnitPrice) from Products)

-- Podaj wszystkie produkty których cena jest mniejsza niż średnia cena produktu danej kategorii
-- 1) podzapytanie
select pzew.ProductID, pzew.ProductName, pzew.UnitPrice from Products as pzew
where pzew.UnitPrice < (select avg(UnitPrice) as 'average' from Products as pwew
where pzew.CategoryID = pwew.CategoryID)

-- Ćwiczenie 3:
-- Dla każdego produktu podaj jego nazwę, cenę, średnią cenę wszystkich produktów oraz różnicę między ceną produktu
-- a średnią ceną wszystkich produktów
-- 1) podzapytanie
select ProductName, UnitPrice, (select avg(UnitPrice) from Products) as 'average',
UnitPrice - (select avg(UnitPrice) from Products) as 'difference'
from Products

-- Dla każdego produktu podaj jego nazwę kategorii, nazwę produktu, cenę, średnią cenę wszystkich produktów danej
-- kategorii oraz różnicę między ceną produktu a średnią ceną wszystkich produktów danej kategorii
-- 1) łączenie tabel wraz z podzapytaniem
select CategoryName, ProductName, UnitPrice,
(select avg(UnitPrice) from Products as pwew where pwew.CategoryID = pzew.CategoryID) as 'average price',
(UnitPrice - (select avg(UnitPrice) from Products as pwew where pwew.CategoryID = pzew.CategoryID)) as 'difference'
from Products as pzew
inner join Categories on pzew.CategoryID = Categories.CategoryID

--2) tylko podzapytania
select (select CategoryName from Categories as cwew where cwew.CategoryID = pzew.CategoryID) as 'category name',
       ProductName, UnitPrice,
       (select avg(UnitPrice) from Products as pwew where pwew.CategoryID = pzew.CategoryID) as 'average price',
       UnitPrice - (select avg(UnitPrice) from Products as pwew where pwew.CategoryID = pzew.CategoryID) as 'difference'
from Products as pzew

-- Ćwiczenie 4:
--Podaj łączną wartość zamówienia o numerze 1025 (uwzględnij cenę za przesyłkę)
-- 1) łączenie tabel
select sum(UnitPrice*Quantity*(1-Discount)) + Freight as 'value' from Orders
inner join [Order Details] on Orders.OrderID = [Order Details].OrderID and Orders.OrderID = 10250
group by Freight

-- 2) podzapytanie
select (select sum(UnitPrice*Quantity*(1-Discount)) from [Order Details] where OrderID = 10250) + Freight as 'value'
from Orders where OrderID = 10250

-- Podaj łączną wartość zamówień każdego zamówienia (uwzględnij cenę za przesyłkę)
-- 1) podzapytanie
select OrderID, (select sum(UnitPrice*Quantity*(1-Discount)) from [Order Details]
where Orders.OrderID = [Order Details].OrderID) + Freight as 'values' from Orders

-- Czy są jacyś klienci którzy nie złożyli żadnego zamówienia w 1997 roku? Jeśli tak to pokaż ich dane adresowe.
-- 1) modyfikator "join"
select CompanyName, Address, City, PostalCode from Customers
left outer join Orders on Customers.CustomerID = Orders.CustomerID and year(OrderDate) = 1997
where Orders.CustomerID is null

--2) modyfikator "not in"
select CompanyName, Address, City, PostalCode from Customers
where CustomerID not in (select Orders.CustomerID from Orders where year(OrderDate) = 1997)

-- Podaj produkty kupowane przez więcej niż jednego klienta
select ProductID, count(CustomerID) as 'customer quantity' from [Order Details], Orders
where Orders.OrderID = [Order Details].OrderID
group by ProductID having count(CustomerID) > 1
order by ProductID