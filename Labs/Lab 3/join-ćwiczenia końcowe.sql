-- Ćwiczenie 1:
-- Dla każdego zamówienia podaj łączną liczbę zamówionych jednostek towaru oraz nazwę klienta
select [Order Details].OrderID, sum(Quantity) as 'quantity', CompanyName from [Order Details]
left outer join Orders on [Order Details].OrderID = Orders.OrderID
left outer join Customers on Orders.CustomerID = Customers.CustomerID
group by [Order Details].OrderID, CompanyName order by OrderID

-- Zmodyfikuj poprzedni przykład, aby pokazać tylko takie zamówienia, dla których łączna liczbę zamówionych jednostek jest większa niż 250
select [Order Details].OrderID, sum(Quantity) as 'quantity', CompanyName from [Order Details]
left outer join Orders on [Order Details].OrderID = Orders.OrderID
left outer join Customers on Orders.CustomerID = Customers.CustomerID
group by [Order Details].OrderID, CompanyName having sum(Quantity) > 250 order by OrderID

-- Dla każdego zamówienia podaj łączną wartość tego zamówienia oraz nazwę klienta
select [Order Details].OrderID, sum(UnitPrice*Quantity*(1-Discount)) as 'total value', CompanyName
from [Order Details]
left outer join Orders on [Order Details].OrderID = Orders.OrderID
left outer join Customers on Orders.CustomerID = Customers.CustomerID
group by [Order Details].OrderID, CompanyName

-- Zmodyfikuj poprzedni przykład, aby pokazać tylko takie zamówienia, dla których łączna liczba jednostek jest większa niż 250
select [Order Details].OrderID, sum(UnitPrice*Quantity*(1-Discount)) as 'total value', CompanyName
from [Order Details]
left outer join Orders on [Order Details].OrderID = Orders.OrderID
left outer join Customers on Orders.CustomerID = Customers.CustomerID
group by [Order Details].OrderID, CompanyName having sum(Quantity) > 250

-- Zmodyfikuj poprzedni przykład tak żeby dodać jeszcze imię i nazwisko pracownika obsługującego zamówienie
select [Order Details].OrderID, sum(UnitPrice*Quantity*(1-Discount)) as 'total value', CompanyName, FirstName, LastName
from [Order Details]
inner join Orders on [Order Details].OrderID = Orders.OrderID
inner join Customers on Orders.CustomerID = Customers.CustomerID
inner join Employees on Orders.EmployeeID = Employees.EmployeeID
group by [Order Details].OrderID, CompanyName, FirstName, LastName having sum(Quantity) > 250

-- Ćwiczenie 2:
-- Dla każdej kategorii produktu (nazwa), podaj łączną liczbę zamówionych przez klientów jednostek towarów z tej kategorii
select CategoryName, sum(Quantity) as 'total quantity' from Products
inner join Categories on Products.CategoryID = Categories.CategoryID
inner join [Order Details] on Products.ProductID = [Order Details].ProductID
group by Products.CategoryID, CategoryName

-- Dla każdej kategorii produktu (nazwa), podaj łączną wartość zamówionych przez klientów jednostek towarów z tek kategorii
select CategoryName, sum(Quantity*[Order Details].UnitPrice*(1-Discount)) as 'total value' from Products
inner join Categories on Products.CategoryID = Categories.CategoryID
inner join [Order Details] on Products.ProductID = [Order Details].ProductID
group by Products.CategoryID, CategoryName

-- Posortuj wyniki w zapytaniu z poprzedniego punktu wg łącznej wartości zamówień
select CategoryName, sum(Quantity*[Order Details].UnitPrice*(1-Discount)) as 'total value' from Products
inner join Categories on Products.CategoryID = Categories.CategoryID
inner join [Order Details] on Products.ProductID = [Order Details].ProductID
group by Products.CategoryID, CategoryName order by [total value]

-- Posortuj wyniki w zapytaniu z poprzedniego punktu wg łącznej liczby zamówionych przez klientów jednostek towarów
select CategoryName, sum(Quantity) as 'total quantity' from Products
inner join Categories on Products.CategoryID = Categories.CategoryID
inner join [Order Details] on Products.ProductID = [Order Details].ProductID
group by Products.CategoryID, CategoryName order by [total quantity]

-- Dla każdego zamówienia podaj jego wartość uwzględniając opłatę za przesyłkę
select [Order Details].OrderID, sum((UnitPrice*Quantity*(1-Discount))) + Freight as 'value' from Orders
inner join [Order Details] on Orders.OrderID = [Order Details].OrderID
group by [Order Details].OrderID, Freight

-- Ćwiczenie 3:
-- Dla każdego przewoźnika (nazwa) podaj liczbę zamówień, które przewieźli w 1997r
select ShipVia, CompanyName, count(*) as 'order quantity' from Orders
inner join Shippers on Orders.ShipVia = Shippers.ShipperID
where year(ShippedDate) = 1997
group by ShipVia, CompanyName

-- Który z przewoźników był najaktywniejszy (przewiózł największą liczbę zamówień) w 1997r? Podaj nazwę tego przewoźnika.
select top 1 ShipVia, CompanyName, count(*) as 'order quantity' from Orders
inner join Shippers on Orders.ShipVia = Shippers.ShipperID
where year(ShippedDate) = 1997
group by ShipVia, CompanyName order by [order quantity] desc

-- Dla każdego pracownika (imię i nazwisko) podaj łączną wartość zamówień obsłużonych przez tego pracownika
select FirstName, LastName, sum(UnitPrice*Quantity*(1-Discount)) as 'total sum' from Orders
inner join Employees on Orders.EmployeeID = Employees.EmployeeID
inner join [Order Details] on Orders.OrderID = [Order Details].OrderID
group by Orders.EmployeeID, FirstName, LastName

-- Który z pracowników obsłużył największą liczbę zamówień w 1997r? Podaj imię i nazwisko takiego pracownika
select top 1 FirstName, LastName, count(*) as 'orders' from Orders
inner join Employees on Orders.EmployeeID = Employees.EmployeeID and year(OrderDate) = 1997
group by Orders.EmployeeID, FirstName, LastName order by orders desc

-- Który z pracowników obsłużył najaktywniejszy (obsłużył zamówienia o największej wartości) w 1997r? Podaj imię i nazwisko takiego pracownika
select top 1 FirstName, LastName, sum(UnitPrice*Quantity*(1-discount)) as 'total profit' from Orders
inner join Employees on Orders.EmployeeID = Employees.EmployeeID
inner join [Order Details] on Orders.OrderID = [Order Details].OrderID and year(OrderDate) = 1997
group by Orders.EmployeeID, FirstName, LastName order by [total profit] desc

-- Ćwiczenie 4:
-- Dla każdego pracownika (imię i nazwisko) podaj łączną wartość zamówień obsłużonych przez tego pracownika. Wynik ogranicz tylko do takich osób, które posiadają podwładnych.
select Orders.EmployeeID, FirstName, LastName, sum(UnitPrice*Quantity*(1-Discount)) as 'total value' from Orders
inner join [Order Details] on Orders.OrderID = [Order Details].OrderID
inner join Employees on Orders.EmployeeID = Employees.EmployeeID
where Employees.EmployeeID in (select a.EmployeeID from Employees as a
    left outer join Employees as b on a.EmployeeID = b.ReportsTo where b.EmployeeID is not null)
group by Orders.EmployeeID, FirstName, LastName

-- Dla każdego pracownika (imię i nazwisko) podaj łączną wartość zamówień obsłużonych przez tego pracownika. Wynik ogranicz tylko do takich osób, które nie posiadają podwładnych.
select Orders.EmployeeID, FirstName, LastName, sum(UnitPrice*Quantity*(1-Discount)) as 'total value' from Orders
inner join [Order Details] on Orders.OrderID = [Order Details].OrderID
inner join Employees on Orders.EmployeeID = Employees.EmployeeID
where not Employees.EmployeeID in (select a.EmployeeID from Employees as a
    left outer join Employees as b on a.EmployeeID = b.ReportsTo where b.EmployeeID is not null)
group by Orders.EmployeeID, FirstName, LastName