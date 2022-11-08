-- Dla każdego roku i miesiąca wybierz firmy, które miały dochody ze sprzedaży większe od średniego dochodu ze sprzedaży
-- za dany okres oraz wypisz im ich przychód.
select CompanyName, year(OrderDate) as 'years', month(OrderDate) as 'months',
sum([Order Details].UnitPrice*(Quantity*(1-Discount))) as 'value' from Suppliers
inner join Products on Suppliers.SupplierID = Products.SupplierID
inner join [Order Details] on Products.ProductID = [Order Details].ProductID
inner join Orders on [Order Details].OrderID = Orders.OrderID
group by CompanyName, year(OrderDate), month(OrderDate)
having sum([Order Details].UnitPrice*(Quantity*(1-Discount))) >
       (select avg(od2.UnitPrice*od2.Quantity*(1-od2.Discount))
 from [Order Details] as od2 inner join orders as
o2 on od2.OrderID = o2.OrderID
 where year(o2.OrderDate) = year(OrderDate)
and month(o2.OrderDate) = month(OrderDate))

-- Wybierz imiona, nazwiska i adresy członków biblioteki z Kalifornii (dzieci i dorosłych) oraz tych dorosłych,
-- którzy wypożyczyli ponad 3 książki (włącznie z obecnie wypożyczonymi).
select member.member_no, firstname, lastname from member
inner join adult on member.member_no = adult.member_no and state = 'CA'
union
select member.member_no, firstname, lastname from member
inner join juvenile on member.member_no = juvenile.member_no
inner join adult on juvenile.adult_member_no = adult.member_no and state = 'CA'
order by member_no

select member.member_no, firstname, lastname from member
where member_no in
(select member_no from loanhist
group by member_no having count(*) > 3)