-- Ćwiczenie 1:
-- Podaj liczbę produktów o cenach mniejszych niż 10$ lub większych niż 20$
select count(*) from Products
where UnitPrice > 20 or UnitPrice < 10

-- Podaj maksymalną cenę produktu dla produktów o cenach poniżej 20$
select max(unitprice) from Products where UnitPrice < 20

-- Podaj maksymalną, minimalną i średnią cenę produktu dla produktów o produktach sprzedawanych w butelkach (‘bottle’)
select max(UnitPrice) as max, min(UnitPrice) as min, avg(UnitPrice) as avg
from Products where QuantityPerUnit like '%bottle%'

-- Wypisz informację o wszystkich produktach o cenie powyżej średniej
select * from Products
where UnitPrice > (select avg(UnitPrice) from Products)

--Podaj sumę/wartość zamówienia o numerze 10250
select sum((1-discount)*Quantity*UnitPrice) as sum from [Order Details] where OrderID = '10250'

-- Ćwiczenie 2:
-- Podaj maksymalną cenę zamawianego produktu dla każdego zamówienia
select max(UnitPrice) as 'max price', OrderID from [Order Details] group by OrderID

-- Posortuj zamówienia wg maksymalnej ceny produktu
select max(UnitPrice) as 'max price', OrderID from [Order Details] group by OrderID order by [max price]

-- Podaj maksymalną i minimalną cenę zamawianego produktu dla każdego zamówienia
select orderid, max(unitprice) as max, min(UnitPrice) as min from [Order Details] group by orderid

-- Podaj liczbę zamówień dostarczanych przez poszczególnych spedytorów (przewoźników)
select ShipVia, count(*) as 'order quantity' from Orders group by ShipVia

-- Który z spedytorów był najaktywniejszy w 1997 roku?
select top 1 ShipVia, count(*) as 'order quantity' from Orders where year(ShippedDate) = '1997' group by ShipVia
order by [order quantity] desc

-- Ćwiczenie 3:
-- Wyświetl zamówienia dla których liczba pozycji zamówienia jest większa niż 5
select orderid, count(*) as 'order quantity' from [Order Details] group by orderid having count(*) > 5

-- Wyświetl klientów dla których w 1998 roku zrealizowano więcej niż 8 zamówień (wyniki posortuj malejąco wg łącznej kwoty za dostarczenie zamówień dla każdego z klientów)
select CustomerID, count(*) as 'order quantity', SUM(Freight) AS 'Freight sum' from Orders where year(ShippedDate) = '1998'
group by CustomerID having count(*) > 8 order by sum(Freight) desc

-- Ćwiczenie 4:
-- Ile lat przepracował w firmie każdy z pracowników?
select datediff(month, HireDate, getdate())/12 as 'experience' from Employees

-- Policz sumę lat przepracowanych przez wszystkich pracowników i średni czas pracy w firmie
select sum(datediff(month, HireDate, getdate())/12) as 'experience sum',
       avg(datediff(month, HireDate, getdate())/12) as 'average experience' from Employees

-- Dla każdego pracownika wyświetl imię, nazwisko oraz wiek
select FirstName, LastName, datediff(month, BirthDate, getdate())/12 as 'age' from Employees

-- Policz średni wiek wszystkich pracowników
select avg(datediff(month, BirthDate, getdate())/12)  as 'average age' from Employees

-- Wyświetl wszystkich pracowników, którzy mają teraz więcej niż 25 lat
select FirstName, LastName from Employees where datediff(month, BirthDate, getdate())/12 > 25

-- Policz średnią liczbę miesięcy przepracowanych przez każdego pracownika
select avg(datediff(month, HireDate, getdate())) as 'average work in months' from Employees

-- Wyświetl dane wszystkich pracowników, którzy przepracowali w firmie co najmniej 320 miesięcy, ale nie więcej niż 333
select * from Employees where datediff(month, HireDate, getdate()) between 320 and 333