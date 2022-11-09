-- complex constraint: Danie w zamówieniu występuje w menu dla daty zamówienia
ALTER TABLE OrderDetails
ADD CONSTRAINT DishInOrderInMenuCheck CHECK (
    dbo.DishInOrderInMenu(DishID, OrderID) = 0
)

CREATE FUNCTION DishInOrderInMenu (@DishID int, @OrderID int) RETURNS bit AS
BEGIN
   if exists
       (select 1
       from Orders as o
       join MenuDetails as md
       on md.DishID = @DishID
       join Menu as m
       on m.MenuID = md.MenuID
       where o.OrderID = @OrderID and (m.DateFrom between o.DateTo and m.DateTo)
       )
       RETURN 1
   RETURN 0
END

-- complex constraint: nie możemy dokonać zamówienia do stolika zajętego bądź zepsutego
ALTER TABLE Orders
ADD CONSTRAINT FreeTable
CHECK (dbo.FreeTable(OrderID) = 1)

CREATE FUNCTION FreeTableCheck (
    @OrderID int
)
RETURNS bit
AS
    BEGIN
        if exists (select * from Orders
           inner join TableInUse on Orders.OrderID = TableInUse.OrderID
           inner join Tables on TableInUse.TableID = Tables.TableID
           where Tables.Available = 0 and Orders.OrderID = @OrderID)
           RETURN 0
        RETURN 1
    END

-- complex constraint: ceny dań w menu większe bądź równe do cen bazowych tych dań
ALTER TABLE MenuDetails
ADD CONSTRAINT menuPriceHigherThanBase
CHECK (dbo.BasePriceDiff(DishID) = 1)

CREATE FUNCTION BasePriceDiff (
    @DishID int
)
RETURNS bit
AS
    BEGIN
       IF (select Price-BasePrice
           from Dishes join MenuDetails on Dishes.DishID = MenuDetails.DishID
           where Dishes.DishID = @DishID) >= 0 -- dania nie opłaca się wówczas sprzedawać
           RETURN 1
       RETURN 0
    END

-- complex constraint: nie możemy dokonać zamówienia, które bierze danie
-- z niegotowego menu
ALTER TABLE Orders
ADD CONSTRAINT OrderFromReadyMenu
CHECK (dbo.OrderFromReadyMenuCheck(OrderID) = 1)

CREATE FUNCTION OrderDetailsQuantityCheck (
    @OrderID int
)
RETURNS bit
AS
    BEGIN
       IF exists (select * from Orders
           inner join OrderDetails on OrderDetails.OrderID = Orders.OrderID
           inner join Dishes on Dishes.DishID = OrderDetails.DishID
           inner join MenuDetails on MenuDetails.DishID = Dishes.DishID
           inner join Menu on Menu.MenuID = MenuDetails.MenuID
           where Menu.Ready = 0 and Orders.OrderID = @OrderID)
           RETURN 0
       RETURN 1
    END

-- complex constraint: seafood
ALTER TABLE OrderDetails
ADD CONSTRAINT SeaFood
CHECK (dbo.SeaFoodCheck(OrderID) = 1)

CREATE FUNCTION SeaFoodCheck (
    @OrderID int
)
RETURNS bit
AS
    BEGIN
       IF exists (select * from Orders o where OrderID=@OrderID and
                DATEPART(weekday, DateFrom) in (5,6,7) and
                PlacedDate<=DATEADD(DD,-(DATEPART(weekday, DateFrom)+5)%7,
                DateFrom)) or not exists (select * from Orders o join OrderDetails OD
                on o.OrderID = OD.OrderID and o.OrderID=@OrderID join Dishes D on OD.DishID = D.DishID
                and SeaFood = 1)
                RETURN 1
       RETURN 0
    END

-- add order to invoice constraint
ALTER TABLE Orders
ADD CONSTRAINT SameInvoiceAndClientOrderNIP
CHECK (dbo.InvoiceAndClientOrderNIPCheck(OrderID, Invoices.InvoiceID) = 1)

CREATE FUNCTION InvoiceAndClientOrderNIPCheck (
    @OrderID int,
    @InvoiceID int
)
RETURNS bit
AS
    BEGIN
       IF (select NIP from Orders join Clients C on Orders.ClientID = C.ClientID and
            OrderID = @OrderID join CorporateClients CC on C.ClientID = CC.ClientID)
            = (select NIP from Invoices where InvoiceID=@InvoiceID) or @InvoiceID IS NULL
            RETURN 1
       RETURN 0
    END

-- complex constraint: warunek, aby żadne dwa menu nie zachodziły na siebie data wystawienia
ALTER TABLE Menu
ADD CONSTRAINT MenuCheck CHECK (
    dbo.MenuCon(MenuID)
)

CREATE FUNCTION MenuCon (@MenuID int)
RETURNS bit
AS
    BEGIN
        DECLARE @startdate AS date=(select DateFrom from Menu where MenuID=@MenuID)
        DECLARE @enddate AS date=(select DateTo from Menu where MenuID=@MenuID)
        if exists (select 1 from Menu as m where m.MenuID != @MenuID
            and ((@startdate < m.DateTo and m.DateFrom < @enddate) or
                 (m.DateFrom < @enddate and @startdate < m.DateTo)))
            RETURN 1
        RETURN 0
    END