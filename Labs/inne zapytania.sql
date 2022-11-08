-- Wyświetl imię i nazwisko dziecka wraz ze swoim opiekunem.
select member.member_no as 'dziecko', member.firstname, member.lastname, m2.member_no as 'opiekun', m2.firstname, m2.lastname
from member
inner join juvenile on member.member_no = juvenile.member_no
inner join member as m2 on m2.member_no = adult_member_no
order by m2.member_no

-- Wypisz dzieci wraz z adresem, które nie wypożyczyły książki z biblioteki w twoje urodziny.
select member.member_no, member.firstname, member.lastname, city, street, state
from member
inner join juvenile on member.member_no = juvenile.member_no
inner join adult on juvenile.adult_member_no = adult.member_no
left outer join loanhist on juvenile.member_no = loanhist.member_no and
year(out_date) = 2001 and month(out_date) = 12 and day(out_date) = 6
where out_date is null

-- Sumowanie wartości z dwóch kolumn (np. ilość wypożyczeń danej książki, uwzględniając jeszcze nie oddane egzemplarze - tabela "loan")
select title_no, count(*) + (select count(*) from loan where loanhist.title_no = loan.title_no group by loan.title_no)
as 'quantity' from loanhist group by title_no

-- Znajdź najpopularniejszego autora książek wśród czytelników w Arizonie w 2001 roku.
;with aux as
(select author, count(*) as 'quantity' from title
inner join loanhist on title.title_no = loanhist.title_no and year(out_date) = 2001
inner join juvenile on juvenile.member_no = loanhist.member_no
inner join adult on juvenile.adult_member_no = adult.member_no and state = 'AZ'
group by author),

aux2 as
(select author, count(*) as 'quantity' from title
inner join loanhist on title.title_no = loanhist.title_no and year(out_date) = 2001
inner join adult on adult.member_no = loanhist.member_no and state = 'AZ'
group by author),

aux3 as
(select * from aux
union
select * from aux2)

select author, sum(quantity) as 'total sum' from aux3
group by author
order by [total sum] desc