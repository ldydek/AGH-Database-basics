-- Ćwiczenie 1:
-- Napisz polecenie, które oblicza wartość sprzedaży dla każdego zamówienia w tablicy order details i zwraca wynik posortowany w malejącej kolejności (wg wartości sprzedaży).
select OrderID, sum(UnitPrice*Quantity*(1-Discount)) as 'value' from [Order Details] group by OrderID
order by value desc

-- Zmodyfikuj zapytanie z poprzedniego punktu, tak aby zwracało pierwszych 10 wierszy
select top 10 OrderID, sum(UnitPrice*Quantity*(1-Discount)) as 'value' from [Order Details] group by OrderID
order by value desc

-- Ćwiczenie 2:
-- Podaj liczbę zamówionych jednostek produktów dla produktów, dla których productid < 3
select ProductID, sum(Quantity) as 'order quantity' from [Order Details] where ProductID < 3 group by ProductID

-- Zmodyfikuj zapytanie z poprzedniego punktu, tak aby podawało liczbę zamówionych jednostek produktu dla wszystkich produktów
select ProductID, sum(Quantity) as 'order quantity' from [Order Details] group by ProductID

-- Podaj nr zamówienia oraz wartość zamówienia, dla zamówień, dla których łączna liczba zamawianych jednostek produktów jest > 250
select OrderID, sum(UnitPrice*Quantity*(1-Discount)) as 'value', sum(Quantity) as 'total sum' from [Order Details]
group by OrderID having sum(Quantity) > 250

-- Ćwiczenie 3:
-- Dla każdego pracownika podaj liczbę obsługiwanych przez niego zamówień
select EmployeeID, count(*) as 'order quantity' from Orders group by EmployeeID

-- Dla każdego spedytora/przewoźnika podaj wartość "opłata za przesyłkę" przewożonych przez niego zamówień
select ShipVia, sum(Freight) as 'opłata za przesyłkę' from Orders group by ShipVia

-- Dla każdego spedytora/przewoźnika podaj wartość "opłata za przesyłkę" przewożonych przez niego zamówień w latach od 1996 do 1997
select ShipVia, sum(Freight) as 'opłata' from Orders where year(ShippedDate) between 1996 and 1997 group by ShipVia

-- Ćwiczenie 4:
-- Dla każdego pracownika podaj liczbę obsługiwanych przez niego zamówień z podziałem na lata i miesiące
select EmployeeID, year(OrderDate) as 'year', month(OrderDate) as 'month', count(*) as 'order quantity'
from Orders
group by EmployeeID, month(OrderDate), year(OrderDate) order by year(OrderDate), month(OrderDate)

-- Dla każdej kategorii podaj maksymalną i minimalną cenę produktu w tej kategorii
select CategoryID, min(UnitPrice) as 'min', max(UnitPrice) as 'max' from Products group by CategoryID