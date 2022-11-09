-- widok statystyk zamówień z zeszłego miesiąca
CREATE VIEW MonthlyDishesStats AS
select DishID, Suma, Liczba
from dbo.MonthlyDishesStatsF(getdate());

-- widok statystyk zamówień z zeszłego tygodnia
CREATE VIEW WeeklyDishesStats AS
select DishID, Suma, Liczba
from dbo.WeeklyDishesStatsF(getdate())

-- widok wolnych stolików przez następną godzinę
CREATE VIEW FreeTablesOneHour AS
select TableID, Seats
from dbo.TimePeriodFreeTablesF(
    getdate(),
    DATEADD(HOUR,1,getdate())
)

-- widok dzisiejszego menu
CREATE VIEW MenuToday AS
select d.DishName, md.Price
from Menu as m
join MenuDetails as md
on md.MenuID = m.MenuID
join Dishes as d
on md.DishID = d.DishID
where GETDATE() between m.DateFrom and m.DateTo;

-- widok aktualnie wolnych stolików
CREATE VIEW FreeTablesNow AS
select distinct t.TableID, t.seats
from Tables as t
where t.TableID not in (select TableID from TableInUse as tiu
join Orders as o
on tiu.OrderID = o.OrderID
where GETDATE() between o.DateFrom and o.DateTo)
and t.Available = 1;