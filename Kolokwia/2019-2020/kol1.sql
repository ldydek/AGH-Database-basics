-- Wypisz nazwy klientów, którzy złożyli zamówienia w dniu 23/05/1997 oraz jeśli obsługiwali te zamówienia pracownicy, którzy mają podwłanych, to ich wypisz (imię i nazwisko). (Northwind) Warto tutaj zauważyć, iż wypisywanie imion i nazwisk dzieje się niezależnie w stosunku do wypisywania nazw klientów.
select CompanyName, (select EmployeeID from Employees as a where a.EmployeeID = Orders.EmployeeID
    and a.EmployeeID in (select distinct a.EmployeeID from Employees as a
left outer join Employees as b on a.EmployeeID = b.ReportsTo where b.EmployeeID is not null )) as 'workers' from Orders
inner join Customers on Orders.CustomerID = Customers.CustomerID
where year(OrderDate) = 1997 and month(OrderDate) = 5 and day(OrderDate) = 23

-- Zamówienia z Freight większym niż AVG danego roku. (Northwind)
with aux as
(select avg(Freight) as 'average', year(OrderDate) as 'years' from Orders
group by year(OrderDate))

select Orders.OrderID, Freight, aux.average, aux.years from Orders
inner join aux on year(Orders.OrderDate) = years
where Freight > average

-- Wypisz dla każdego klienta najczęściej zamawianą kategorię. (Northwind)
with aux as
(select Customers.CustomerID, CategoryID, count(*) as 'quantity' from Customers
left outer join Orders on Customers.CustomerID = Orders.CustomerID
left outer join [Order Details] on Orders.OrderID = [Order Details].OrderID
left outer join Products on [Order Details].ProductID = Products.ProductID
group by Customers.CustomerID, CategoryID)

select CustomerID, CategoryID, quantity from aux as a1
where (select max(quantity) from aux as a2
where a1.CustomerID = a2.CustomerID group by CustomerID) = quantity

-- Jaki był najpopularniejszy autor wśród dzieci w Arizonie w 2001? (Library)
select top 1 author, count(*) as 'quantity' from title
inner join loanhist on title.title_no = loanhist.title_no and year(out_date) = 2001
inner join juvenile on juvenile.member_no = loanhist.member_no
inner join adult on juvenile.adult_member_no = adult.member_no and state = 'AZ'
group by author
order by quantity desc

-- Wybierz klientów, którzy kupili przedmioty wyłącznie z jednej kategorii w marcu 1997 i wypisz nazwę tej kategorii. (Northwind)
with aux as
(select Customers.CustomerID, CategoryName, count(*) as 'quantity' from Customers
inner join Orders on Customers.CustomerID = Orders.CustomerID and year(OrderDate) = 1997 and month(OrderDate) = 3
inner join [Order Details] on Orders.OrderID = [Order Details].OrderID
inner join Products on [Order Details].ProductID = Products.ProductID
inner join Categories on Products.CategoryID = Categories.CategoryID
group by Customers.CustomerID, CategoryName)

select CustomerID, CategoryName from aux
where CustomerID in
(select CustomerID from aux
group by CustomerID having count(*) = 1)

-- Wybierz kategorię, która w danym roku 1997 najwięcej zarobiła z podziałem na miesiące. (Northwind)
with aux as
(select CategoryID, month(OrderDate) as 'months', sum([Order Details].UnitPrice*Quantity*(1-Discount))
as 'value' from Products
inner join [Order Details] on Products.ProductID = [Order Details].ProductID
inner join Orders on [Order Details].OrderID = Orders.OrderID
where year(OrderDate) = 1997
group by CategoryID, month(OrderDate))

select CategoryID, months, value from aux as a1
where value = (select max(value) from aux as a2
where a1.months = a2.months group by months)
order by months