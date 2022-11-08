--Ćwiczenie 1:

--Napisz polecenie select, za pomocą którego uzyskasz tytuł i numer książki
select title_no, title from title

--Napisz polecenie, które wybiera tytuł o numerze 10
select title from title where title_no = '10'

--Napisz polecenie select, za pomocą którego uzyskasz numer książki (nr tyułu) i autora
-- z tablicy title dla wszystkich książek, których autorem jest Charles Dickens lub Jane Austen
select title_no, author from title where author = 'Charles Dickens' OR author = 'Jane Austen'

--Ćwiczenie 2:

--Napisz polecenie, które wybiera numer tytułu i tytuł dla wszystkich książek,
-- których tytuły zawierających słowo „adventure”
select title_no, title from title where title like '%adventure%'

--Napisz polecenie, które wybiera numer czytelnika, oraz zapłaconą karę
select member_no, fine_paid from loanhist where fine_assessed != fine_paid

--Napisz polecenie, które wybiera wszystkie unikalne pary miast i stanów z tablicy adult
select distinct city, state from adult

--Napisz polecenie, które wybiera wszystkie tytuły z tablicy title i wyświetla je w porządku alfabetycznym
select title from title order by title

--Ćwiczenie 3:
--Napisz polecenie, które wybiera numer członka biblioteki (member_no), isbn książki (isbn)
-- i watrość naliczonej kary (fine_assessed) z tablicy loanhist dla wszystkich wypożyczeń,
-- dla których naliczono karę (wartość nie NULL w kolumnie fine_assessed)
select member_no, isbn, fine_assessed from loanhist where fine_assessed is not null

--Stwórz kolumnę wyliczeniową zawierającą podwojoną wartość kolumny fine_assessed
select 2*fine_assessed from loanhist

--Stwórz alias ‘double fine’ dla tej kolumny
select 2*fine_assessed as 'double fine' from loanhist

--Ćwiczenie 4:

--Napisz polecenie, które generuje pojedynczą kolumnę, która zawiera kolumny:
-- firstname (imię członka biblioteki), middleinitial (inicjał drugiego imienia)
-- i lastname (nazwisko) z tablicy member dla wszystkich członków biblioteki, którzy nazywają się Anderson
select firstname + ' ' + middleinitial + ' ' + lastname from member where lastname = 'Anderson'

-- Nazwij tak powstałą kolumnę email_name (użyj aliasu email_name dla kolumny
select firstname + ' ' + middleinitial + ' ' + lastname as email_name from member where lastname = 'Anderson'

-- Zmodyfikuj polecenie, tak by zwróciło „listę proponowanych loginów e-mail” utworzonych przez
-- połączenie imienia członka biblioteki, z inicjałem drugiego imienia i pierwszymi dwoma literami nazwiska
-- (wszystko małymi małymi literami)
select lower(firstname + middleinitial + substring(lastname, 1, 2)) as 'email_name' from member where lastname = 'Anderson'

-- Ćwiczenie 5:

-- Napisz polecenie, które wybiera title i title_no z tablicy title. Wynikiem powinna być
-- pojedyncza kolumna o formacie jak w przykładzie poniżej: The title is: Poems, title number 7
select 'The title is: ' + title + ', title number ' + convert(char, title_no) as titles from title