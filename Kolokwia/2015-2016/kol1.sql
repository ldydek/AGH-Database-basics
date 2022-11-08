-- Dla każdego pracownika, który ma podwładnego podaj wartość obsłużonych przez niego przesyłek w grudniu 1997.
-- Uwzględnij rabat i opłatę za przesyłkę.
select EmployeeID, sum(UnitPrice*Quantity*(1-Discount)) + sum(Freight) as 'total sum' from Orders
inner join [Order Details] on Orders.OrderID = [Order Details].OrderID
where year(OrderDate) = 1997 and month(OrderDate) = 12 and EmployeeID in
(select distinct a.Employeeid from Employees as a
left outer join Employees as b on a.EmployeeID = b.ReportsTo
where b.EmployeeID is not null)
group by EmployeeID

-- Podaj klientów, którzy nie złożyli zamówień w 1997. 3 wersje: join, in, exists.
-- 1) join
select * from Customers
left outer join Orders on Customers.CustomerID = Orders.CustomerID and year(OrderDate) = 1997
where Orderid is null

-- 2) in
select * from Customers
where not CustomerID in
(select CustomerID from Orders where Orders.CustomerID = Customers.CustomerID and year(OrderDate)=1997)

-- Podaj nazwy produktów, które nie były sprzedawane w marcu 1997.
select ProductID, ProductName from Products
where not ProductID in
(select [Order Details].ProductID from [Order Details]
inner join Orders on [Order Details].OrderID = Orders.OrderID
where year(OrderDate) = 1997 and month(OrderDate) = 3)

-- Dla każdego klienta znajdź wartość wszystkich złożonych zamówień (weź pod uwagę koszt przesyłki).
-- Ważna uwaga! Musimy uwzględnić w zapytaniu tabelę "Customers", ponieważ kilku klientów niczego nie zamówiło i nie ma ich w tabeli "Orders"!
select Customers.CustomerID, isnull(sum(UnitPrice*Quantity*(1-Discount)), 0) + isnull(sum(Freight), 0) as 'total value' from Customers
left outer join Orders on Customers.CustomerID = Orders.CustomerID
left outer join [Order Details] on Orders.OrderID = [Order Details].OrderID
group by Customers.CustomerID order by [total value]

-- Dla każdej kategorii produktów wypisz po miesiącach wartość sprzedanych z niej produktów. Interesują nas tylko lata 1996-1997.
select CategoryID, year(ShippedDate) as 'years', month(ShippedDate) as 'months',
sum([Order Details].UnitPrice*Quantity*(1-discount)) as 'total value' from Products
left outer join [Order Details] on Products.ProductID = [Order Details].ProductID
left outer join Orders on [Order Details].OrderID = Orders.OrderID and year(ShippedDate) = 1996 or year(ShippedDate) = 1997
group by CategoryID, year(ShippedDate), month(ShippedDate) order by year(ShippedDate), month(ShippedDate)

-- Dla każdego produktu podaj nazwę jego kategorii, nazwę produktu, cenę, średnią cenę wszystkich produktów danej kategorii,
-- różnicę między ceną produktu a średnią ceną wszystkich produktów danej kategorii, dodatkowo dla każdego produktu podaj
-- wartośc jego sprzedaży w marcu 1997 UWAGA! Wartości prawdopodobnie są błędne w wierszach.
select distinct CategoryName, ProductName, Products.UnitPrice,
(select avg(UnitPrice) from Products as pwew where pwew.CategoryID = Products.CategoryID) as 'average',
Products.UnitPrice - (select avg(UnitPrice) from Products as pwew1 where pwew1.CategoryID = Products.CategoryID) as 'difference',
isnull(sum([Order Details].UnitPrice*(Quantity)*(1-Discount)), 0) as 'value'
from Products inner join Categories on Products.CategoryID = Categories.CategoryID
inner join [Order Details] on Products.ProductID = [Order Details].ProductID
left outer join Orders on [Order Details].OrderID = Orders.OrderID and year(ShippedDate) = 1997 and month(ShippedDate) = 3
group by CategoryName, ProductName, Products.UnitPrice, Products.CategoryID order by value

-- Dla każdego czytelnika wypisz ilość wypożyczonych książek od początku zarejestrowania w systemie. W tym przypadku pobieram
-- dane również z tabeli "loan", która uwzględnia aktualnie przetrzymywane egzemplarze.
select member.member_no, firstname, lastname, (select isnull(count(*), 0) from loan where loan.member_no = member.member_no) +
(select isnull(count(*), 0) from loanhist where member.member_no=loanhist.member_no) as 'quantity' from member
order by quantity desc