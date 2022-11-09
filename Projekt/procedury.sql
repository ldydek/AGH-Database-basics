-- finalize
CREATE PROCEDURE FinalizeOrder (@OrderID int)
AS
    BEGIN
        IF (EXISTS(SELECT * FROM Orders WHERE OrderID = @OrderID))
            UPDATE Orders
            SET Finalized = 1
            WHERE OrderID = @OrderID
        ELSE
            PRINT 'Zamówienie nie znajduje się w bazie'
    END

-- cancel
CREATE PROCEDURE CancelOrder (@OrderID int)
AS
    BEGIN
        IF (EXISTS(SELECT * FROM Orders WHERE OrderID = @OrderID))
            UPDATE Orders
            SET Cancelled = 1
            WHERE OrderID = @OrderID
        ELSE
            PRINT 'Zamówienie nie znajduje się w bazie'
    END

-- accept
CREATE PROCEDURE AcceptOrder (@OrderID int)
AS
    BEGIN
        IF (EXISTS(SELECT * FROM Orders WHERE OrderID = @OrderID))
            UPDATE Orders
            SET Accepted = 1
            WHERE OrderID = @OrderID
        ELSE
            PRINT 'Zamówienie nie znajduje się w bazie'
    END

-- add to invoice
CREATE PROCEDURE AddOrderToInvoice (@OrderID int, @InvoiceID int)
AS
    BEGIN
        UPDATE Orders
        SET InvoiceID = @InvoiceID
        WHERE OrderID = @OrderID
    END

-- add dish to order
CREATE PROCEDURE AddDishToOrder
    @OrderID int,
    @DishID int,
    @Quantity int
AS BEGIN
    IF (EXISTS(SELECT 1 FROM OrderDetails WHERE OrderID = @OrderID and DishID = @DishID))
        UPDATE OrderDetails
        SET Quantity = (SELECT Quantity FROM OrderDetails WHERE @OrderID = OrderID and DishID = @DishID) + @Quantity
        WHERE OrderID = @OrderID and DishID = @DishID
    ELSE
        INSERT INTO OrderDetails(OrderID, DishID, Quantity)
        SELECT @OrderID, @DishID, @Quantity FROM Dishes WHERE DishID = @DishID
END