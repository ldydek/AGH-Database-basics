-- funkcja: menu na wybrany dzień
CREATE FUNCTION DishesInMenuF (@date datetime)
RETURNS TABLE as
    RETURN
        (select D.DishID, DishName, Price
        from MenuDetails
        join Menu on Menu.MenuID = MenuDetails.MenuID
        join Dishes D on MenuDetails.DishID = D.DishID
        where @date between Menu.DateFrom and Menu.DateTo)
    GO

-- funckja: oblicza sumaryczną cenę zamówienia
CREATE FUNCTION OrderPrice (@orderid int)
RETURNS INT as
    BEGIN RETURN
        (select SUM((Price*Quantity)*(1-Discount))
        from Orders O
        join OrderDetails OD on O.OrderID = OD.OrderID and O.OrderID = @orderid
        join Dishes D on OD.DishID = D.DishID
        join MenuDetails MD on D.DishID = MD.DishID
        join Menu M on MD.MenuID = M.MenuID and
        (O.DateFrom between M.DateFrom and M.DateTo)
            GROUP BY O.OrderID)
    END

-- funkcja: wolne stoliki na wybrany okres
CREATE FUNCTION TimePeriodFreeTablesF (
    @DateStart datetime, @DateEnd datetime)
RETURNS TABLE AS
    RETURN
        (select t.TableID, t.Seats from Tables as t
        join TableInUse as tiu on t.TableID = tiu.TableID
        join Orders as o on tiu.OrderID = o.OrderID
        where t.Available = 1 and
        (@DateStart not between o.DateFrom and o.DateTo) and
        (@DateEnd not between o.DateFrom and o.DateTo) and
        (o.DateFrom not between @DateStart and @DateEnd) and
        (o.DateTo not between @DateStart and @DateEnd))

-- funkcja: statystyki klientów z dowolnego miesiąca (wybieramy początkową datę)
CREATE FUNCTION MonthlyClientsStatsF (@Date datetime)
RETURNS table AS RETURN
(select * from TimePeriodClientsStatsF(@Date, DATEADD(MONTH, 1, @Date)))

-- funkcja: statystyki klientów z dowolnego tygodnia (wybieramy początkową datę)
CREATE FUNCTION WeeklyCleintsStatsF (@Date datetime)
RETURNS table AS RETURN
(select * from TimePeriodClientsStatsF(@Date, DATEADD(WEEK, 1, @Date)))

-- funkcja: statystyki klientów z dowolnego okresu czasu
CREATE FUNCTION TimePeriodClientsStatsF
(@DateStart datetime, @DateEnd datetime)
RETURNS TABLE as RETURN (
    select c.ClientID, sum(od.Quantity * md.Price * (1-Discount)) Suma, sum(od.Quantity) Liczba
    from Clients as c
    join Orders as o on c.ClientID = o.ClientID
    join OrderDetails as od on o.OrderID = od.OrderID
    join MenuDetails as md on od.DishID = md.DishID
    join Menu as m on md.MenuID = m.MenuID
    where (o.DateFrom between @DateStart and @DateEnd) and
    ((m.DateFrom between CONVERT(date,@DateStart) and CONVERT(date,@DateEnd))
    or (m.DateTo between CONVERT(date,@DateStart) and CONVERT(date,@DateEnd))
    or (CONVERT(date,@DateEnd) between m.DateFrom and m.DateTo)
    or (CONVERT(date,@DateStart) between m.DateFrom and m.DateTo))
    group by c.ClientID
)

-- funkcja: statystyki dań z dowolnego miesiąca (wybieramy początkową datę)
CREATE FUNCTION MonthlyDishesStatsF (@Date datetime)
RETURNS table AS RETURN
(select * from TimePeriodStatsF(@Date, DATEADD(MONTH, 1, @Date)))

-- funkcja: statystyki dań z dowolnego tygodnia (wybieramy początkową datę)
CREATE FUNCTION WeeklyDishesStatsF (@Date datetime)
RETURNS table AS RETURN
(select * from TimePeriodStatsF(@Date, DATEADD(WEEK, 1, @Date)))

-- funkcja: statystyki zamówień z dowolnego okresu
CREATE FUNCTION TimePeriodStatsF
(@DateStart datetime, @DateEnd datetime)
RETURNS TABLE AS RETURN (
    select md.DishID, sum(od.Quantity * md.Price) Suma, sum(Quantity) Liczba
    from Orders as o
    join OrderDetails as od on o.OrderID = od.OrderID
    join MenuDetails as md on md.DishID = od.DishID
    join Menu as m on m.MenuID = md.MenuID
    where o.Finalized = 1
    and (o.DateFrom between @DateStart and @DateEnd)
    and ((m.DateFrom between @DateStart and @DateEnd)
    or (m.DateTo between @DateStart and @DateEnd)
    or (@DateEnd between m.DateFrom and m.DateTo)
    or (@DateStart between m.DateFrom and m.DateTo))
    group by md.DishID
)