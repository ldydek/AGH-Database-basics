-- Ćwiczenie 1:
-- Wybierz nazwy i ceny produktów (baza northwind) o cenie jednostkowej pomiędzy 20.00 a 30.00, dla każdego produktu podaj dane adresowe dostawcy
select ProductName, UnitPrice, Address, City, PostalCode from Products, Suppliers
where Products.SupplierID = Suppliers.SupplierID and UnitPrice between 20 and 30

-- Wybierz nazwy produktów oraz inf. o stanie magazynu dla produktów dostarczanych przez firmę ‘Tokyo Traders’
select ProductName, UnitsInStock from Products, Suppliers
where Products.SupplierID = Suppliers.SupplierID and CompanyName = 'Tokyo Traders'

-- Czy są jacyś klienci którzy nie złożyli żadnego zamówienia w 1997 roku? Jeśli tak to pokaż ich dane adresowe
select CompanyName,Address,City,Region,PostalCode,Country from Customers
left join Orders o on Customers.CustomerID = O.CustomerID and YEAR(OrderDate)=1997
where OrderID is null

-- Wybierz nazwy i numery telefonów dostawców, dostarczających produkty, których aktualnie nie ma w magazynie
select CompanyName, Phone from Suppliers, Products
where Products.SupplierID = Suppliers.SupplierID and UnitsInStock = 0

-- Ćwiczenie 2:
-- Napisz polecenie, które wyświetla listę dzieci będących członkami biblioteki (baza library). Interesuje nas imię, nazwisko i data urodzenia dziecka.
select firstname, lastname, birth_date from member, juvenile
where member.member_no = juvenile.member_no

-- Napisz polecenie, które podaje tytuły aktualnie wypożyczonych książek
select distinct title from copy, title where copy.title_no = title.title_no and on_loan = 'Y'

-- Podaj informacje o karach zapłaconych za przetrzymywanie książki o tytule ‘Tao Teh King’. Interesuje nas data oddania książki, ile dni była przetrzymywana i jaką zapłacono karę
select fine_paid, due_date, in_date, datediff(day, in_date, due_date) as 'difference'
from title, loanhist where title.title_no = loanhist.title_no and title = 'Tao Teh King'
and datediff(day, in_date, due_date) > 0 and fine_paid is not null

-- Napisz polecenie które podaje listę książek (numery ISBN) zarezerwowanych przez osobę o nazwisku: Stephen A. Graff
select isbn from reservation, member where member.member_no = reservation.member_no and lastname = 'Graff' and
firstname = 'Stephen' and middleinitial = 'A'

-- Ćwiczenie 3:
-- Wybierz nazwy i ceny produktów (baza northwind) o cenie jednostkowej pomiędzy 20.00 a 30.00, dla każdego produktu podaj dane adresowe dostawcy, interesują nas tylko produkty z kategorii ‘Meat/Poultry’z
select ProductName, UnitPrice, Address, City, PostalCode from Products, Suppliers, Categories
where Products.CategoryID = Categories.CategoryID and Products.SupplierID = Suppliers.SupplierID
and UnitPrice between 20 and 30 and CategoryName = 'Meat/Poultry'

-- Wybierz nazwy i ceny produktów z kategorii ‘Confections’ dla każdego produktu podaj nazwę dostawcy.
select ProductName, UnitPrice, CompanyName from Products, Categories, Suppliers
where Products.CategoryID = Categories.CategoryID and Products.SupplierID = Suppliers.SupplierID
and CategoryName = 'Confections'

-- Wybierz nazwy i numery telefonów klientów , którym w 1997 roku przesyłki dostarczała firma ‘United Package’
select distinct Customers.CompanyName, Customers.Phone from Customers, Orders, Shippers
where Orders.CustomerID = Customers.CustomerID and ShipVia = ShipperID and Shippers.CompanyName = 'united package'
and year(ShippedDate) = '1997'

-- Wybierz nazwy i numery telefonów klientów, którzy kupowali produkty z kategorii ‘Confections’
select distinct CompanyName, Phone from Customers, Categories, Orders, [Order Details], Products
where Orders.CustomerID = Customers.CustomerID and Orders.OrderID = [Order Details].OrderID
and Products.ProductID = [Order Details].ProductID and Products.CategoryID = Categories.CategoryID and
CategoryName = 'Confections'

-- Ćwiczenie 4:
-- Napisz polecenie, które wyświetla listę dzieci będących członkami biblioteki (baza library). Interesuje nas imię, nazwisko, data urodzenia dziecka i adres zamieszkania dziecka.
select distinct firstname, lastname, birth_date, street, city, state from juvenile, adult, member
where adult.member_no = juvenile.adult_member_no and juvenile.member_no = member.member_no

-- Napisz polecenie, które wyświetla listę dzieci będących członkami biblioteki (baza library). Interesuje nas imię, nazwisko, data urodzenia dziecka, adres zamieszkania dziecka oraz imię i nazwisko rodzica.
select m.firstname, m.lastname, j.birth_date, street, city, state, am.firstname, am.lastname
from juvenile as j
inner join  member m on j.member_no = m.member_no
inner join adult a on a.member_no = j.adult_member_no
inner join member am on a.member_no = am.member_no

-- Ćwiczenie 5:
-- Napisz polecenie, które wyświetla pracowników oraz ich podwładnych (baza northwind)
select * from Employees as a inner join Employees as b on a.EmployeeID = b.ReportsTo

-- Napisz polecenie, które wyświetla pracowników, którzy nie mają podwładnych (baza northwind)
select a.FirstName, a.LastName, a.ReportsTo from Employees as a
left outer join Employees as b on a.EmployeeID = b.ReportsTo
where b.EmployeeID is null

-- Napisz polecenie, które wyświetla adresy członków biblioteki, którzy mają dzieci urodzone przed 1 stycznia 1996
select street, city, state from juvenile as j
inner join adult as a on j.adult_member_no = a.member_no
where birth_date < '01.01.1996'

-- Napisz polecenie, które wyświetla adresy członków biblioteki, którzy mają dzieci urodzone przed 1 stycznia 1996. Interesują nas tylko adresy takich członków biblioteki, którzy aktualnie nie przetrzymują książek.
select distinct a.member_no, street, city, state from juvenile as j
inner join adult as a on j.adult_member_no = a.member_no
left outer join loan as l on l.member_no = a.member_no
where birth_date < '01.01.1996'

-- Ćwiczenie 6:
-- Napisz polecenie które zwraca imię i nazwisko (jako pojedynczą kolumnę – name), oraz informacje o adresie: ulica, miasto, stan kod (jako pojedynczą kolumnę – address) dla wszystkich dorosłych członków biblioteki
select firstname + ' ' + lastname as 'name', street + ',' + city + ',' + state + ',' + zip as 'address' from adult
left outer join member on adult.member_no = member.member_no

-- Napisz polecenie, które zwraca: isbn, copy_no, on_loan, title, translation, cover, dla książek o isbn 1, 500 i 1000. Wynik posortuj wg ISBN
select distinct item.isbn, copy_no, on_loan, title, translation, cover from copy, title, item
where (copy.title_no = title.title_no and copy.isbn = item.isbn)
and (item.isbn = 1 or item.isbn = 500 or item.isbn = 1000)
order by item.isbn

-- Napisz polecenie które zwraca o użytkownikach biblioteki o nr 250, 342, i 1675 (dla każdego użytkownika: nr, imię i nazwisko członka biblioteki), oraz informację o zarezerwowanych książkach (isbn, data)
select member.member_no, firstname, lastname, isbn, log_date from member
left outer join reservation on member.member_no = reservation.member_no
where member.member_no = 250 or member.member_no = 342 or member.member_no = 1675

-- Podaj listę członków biblioteki mieszkających w Arizonie (AZ) mających więcej niż dwoje dzieci zapisanych do biblioteki
select j.adult_member_no, m.firstname, m.lastname, count(*) as 'amount of children'
from member m
join adult a on m.member_no = a.member_no
join juvenile j on m.member_no = j.adult_member_no
where state = 'AZ'
group by j.adult_member_no, m.firstname, m.lastname
having count(*) > 2

-- Podaj listę członków biblioteki mieszkających w Arizonie (AZ) którzy mają więcej niż dwoje dzieci zapisanych do biblioteki oraz takich którzy mieszkają w Kaliforni (CA) i mają więcej niż troje dzieci zapisanych do biblioteki
select j.adult_member_no, m.firstname, m.lastname, count(*) as 'amount of children'
from member m
join adult a on m.member_no = a.member_no
join juvenile j on m.member_no = j.adult_member_no
group by j.adult_member_no, m.firstname, m.lastname, state
having (count(*) > 2 and state='AZ') or (count(*) > 3 and state='CA')