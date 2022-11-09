-- tables
-- Table: Clients
CREATE TABLE Clients (
  ClientID int NOT NULL IDENTITY(1, 1),
  Phone int NOT NULL,
  email varchar(64) NOT NULL,
  CONSTRAINT Clients_pk PRIMARY KEY (ClientID)
);

-- Table: CorporateClients
CREATE TABLE CorporateClients (
  ClientID int NOT NULL,
  CompanyName varchar(64) NOT NULL,
  NIP varchar(10) NULL,
  Address varchar(128) NOT NULL,
  City varchar(64) NOT NULL,
  PostalCode varchar(16) NOT NULL,
  Country varchar(64) NOT NULL,
  CONSTRAINT NIP UNIQUE (NIP),
  CONSTRAINT CorporateClients_pk PRIMARY KEY (ClientID)
);

-- Table: DiscountRequirements
CREATE TABLE DiscountRequirements (
  DateFrom date NOT NULL,
  DateTo date NOT NULL,
  MinOrdersCountZ1 int NOT NULL,
  MinOrdersPriceK1 int NOT NULL,
  DiscountR1 int NOT NULL,
  CumulativePriceK2 int NOT NULL,
  DiscountR2 int NOT NULL,
  DurationD1 int NOT NULL,
  CONSTRAINT DiscountRequirements_pk PRIMARY KEY (DateFrom, DateTo)
);

-- Table: Dishes
CREATE TABLE Dishes (
  DishID int NOT NULL IDENTITY(1,1),
  DishName varchar(64) NOT NULL,
  BasePrice money NOT NULL, -- minimalna cena, za którą opłaca się danie sprzedawać
  SeaFood bit NOT NULL,
  Discount bit NOT NULL,
  CONSTRAINT Dishes_pk PRIMARY KEY (DishID)
);

-- Table: Invoices
CREATE TABLE Invoices (
  InvoiceID int NOT NULL IDENTITY (1,1),
  IssueDate date NOT NULL,
  NIP int NOT NULL,
  CompanyName varchar(64) NOT NULL,
  Address varchar(128) NOT NULL,
  City varchar(64) NOT NULL,
  PostalCode varchar(64) NOT NULL,
  Country varchar(64) NOT NULL,
  CONSTRAINT Invoice_pk PRIMARY KEY (InvoiceID)
);

-- Table: Menu
CREATE TABLE Menu (
  MenuID int NOT NULL IDENTITY (1,1),
  DateFrom date NOT NULL,
  DateTo date NOT NULL,
  Ready bit NOT NULL,
  CONSTRAINT Menu_pk PRIMARY KEY (MenuID)
);

-- Table: MenuDetails
CREATE TABLE MenuDetails (
  MenuID int NOT NULL,
  DishID int NOT NULL,
  Price money NOT NULL,
  CONSTRAINT MenuDetails_pk PRIMARY KEY (MenuID,DishID)
);

-- Table: ObtainedDiscounts
CREATE TABLE ObtainedDiscounts (
  ObtainedDiscountID int NOT NULL IDENTITY (1,1),
  DateObtained date NOT NULL,
  ClientID int NOT NULL,
  Type bit NOT NULL,
  Used bit NOT NULL,
  CONSTRAINT ObtainedDiscounts_pk PRIMARY KEY (ObtainedDiscountID)
);

-- Table: OrderDetails
CREATE TABLE OrderDetails (
  OrderID int NOT NULL,
  DishID int NOT NULL,
  Quantity int NOT NULL,
  CONSTRAINT OrderDetails_pk PRIMARY KEY (OrderID,DishID)
);

-- Table: OrderNames
CREATE TABLE OrderNames (
  OrderNamesID int NOT NULL IDENTITY(1,1),
  OrderID int NOT NULL,
  FirstName varchar(32) NULL,
  LastName varchar(32) NULL,
  CONSTRAINT OrderNames_pk PRIMARY KEY (OrderNamesID)
);

-- Table: Orders
CREATE TABLE Orders (
  OrderID int NOT NULL IDENTITY (1,1),
  ClientID int NOT NULL,
  DateFrom datetime NOT NULL,
  DateTo datetime NOT NULL,
  PlacedDate datetime NOT NULL,
  Finalized bit NOT NULL,
  Cancelled bit NOT NULL,
  Takeaway bit NOT NULL,
  Accepted bit NOT NULL,
  Discount money NOT NULL,
  InvoiceID int NULL,
  CONSTRAINT Orders_pk PRIMARY KEY (OrderID)
);

-- Table: PrivateClients
CREATE TABLE PrivateClients (
  ClientID int NOT NULL,
  LastName varchar(64) NOT NULL,
  FirstName varchar(32) NOT NULL,
  Address varchar(128) NULL,
  City varchar(64) NULL,
  PostalCode varchar(16) NULL,
  CONSTRAINT PrivateClients_pk PRIMARY KEY (ClientID)
);

-- Table: TableInUse
CREATE TABLE TableInUse (
  TableID int NOT NULL,
  OrderID int NOT NULL,
  CONSTRAINT TableInUse_pk PRIMARY KEY (TableID,OrderID)
);

-- Table: Tables
CREATE TABLE Tables (
  TableID int NOT NULL IDENTITY (1,1),
  Seats int NOT NULL,
  Available bit NOT NULL,
  CONSTRAINT Tables_pk PRIMARY KEY (TableID)
);

-- foreign keys
-- Reference: CorporateClients_Clients (table: CorporateClients)
ALTER TABLE CorporateClients ADD CONSTRAINT CorporateClients_Clients
    FOREIGN KEY (ClientID)
    REFERENCES Clients (ClientID);

-- Reference: MenuDetails_Dishes (table: MenuDetails)
ALTER TABLE MenuDetails ADD CONSTRAINT MenuDetails_Dishes
    FOREIGN KEY (DishID)
    REFERENCES Dishes (DishID);

-- Reference: MenuDetails_Menu (table: MenuDetails)
ALTER TABLE MenuDetails ADD CONSTRAINT MenuDetails_Menu
    FOREIGN KEY (MenuID)
    REFERENCES Menu (MenuID);

-- Reference: OrderDetails_Dishes (table: OrderDetails)
ALTER TABLE OrderDetails ADD CONSTRAINT OrderDetails_Dishes
    FOREIGN KEY (DishID)
    REFERENCES Dishes (DishID);

-- Reference: OrderDetails_Orders (table: OrderDetails)
ALTER TABLE OrderDetails ADD CONSTRAINT OrderDetails_Orders
    FOREIGN KEY (OrderID)
    REFERENCES Orders (OrderID);

-- Reference: OrderNames_Orders (table: OrderNames)
ALTER TABLE OrderNames ADD CONSTRAINT OrderNames_Orders
    FOREIGN KEY (OrderID)
    REFERENCES Orders (OrderID);

-- Reference: Orders_Clients (table: Orders)
ALTER TABLE Orders ADD CONSTRAINT Order_Clients
    FOREIGN KEY (ClientID)
    REFERENCES Clients (ClientID);

-- Reference: Orders_Invoices (table: Orders)
ALTER TABLE Orders ADD CONSTRAINT Orders_Invoices
    FOREIGN KEY (InvoiceID)
    REFERENCES Invoices (InvoiceID);

-- Reference: PrivateClients_Clients (table: PrivateClients)
ALTER TABLE PrivateClients ADD CONSTRAINT PrivateClients_Clients
    FOREIGN KEY (ClientID)
    REFERENCES Clients (ClientID);

-- Reference: PrivateClients_Discounts (table: ObtainedDiscounts)
ALTER TABLE ObtainedDiscounts ADD CONSTRAINT PrivateClients_Discounts
    FOREIGN KEY (ClientID)
    REFERENCES PrivateClients (ClientID);

-- Reference: TableInUse_Orders (table: TableInUSe)
ALTER TABLE TableInUse ADD CONSTRAINT TableInUse_Orders
    FOREIGN KEY (OrderID)
    REFERENCES Orders (OrderID);

-- Reference: Tables_TablesInUse (table: TableInUse)
ALTER TABLE TableInUse ADD CONSTRAINT Tables_TableInUse
    FOREIGN KEY (TableID)
    REFERENCES Tables (TableID);

-- Constraints
ALTER TABLE Menu
ADD CONSTRAINT MenuDateCheck CHECK (
    DateTo >= DateFrom
)

ALTER TABLE OrderDetails
ADD CONSTRAINT OrderDetailsQuantityCheck CHECK (
    Quantity > 0
)

ALTER TABLE Orders
ADD CONSTRAINT OrdersDateCheck CHECK (
    DateFrom >= PlacedDate and DateTo > DateFrom
)

ALTER TABLE Tables
ADD CONSTRAINT TablesNumberOfSeats CHECK (
    Seats > 0
)

ALTER TABLE MenuDetails
ADD CONSTRAINT MenuDetailsPricePositiveCheck CHECK (
    Price > 0
)

ALTER TABLE Dishes
ADD CONSTRAINT DishesBasePricePositiveCheck CHECK (
    BasePrice > 0
)

ALTER TABLE Dishes
ADD CONSTRAINT OrdersMoneyNotNegativeCheck CHECK (
    Discount >= 0
)

ALTER TABLE Invoices
ADD CONSTRAINT InvoiceNIPPositiveCheck CHECK (
    NIP > 0
)

ALTER TABLE Clients
ADD CONSTRAINT ClientsPhoneNumberPositiveCheck CHECK (
    Phone > 0
)

ALTER TABLE CorporateClients
ADD CONSTRAINT  CorporateClientsNIPNotNegativeCheck CHECK (
    NIP > 0
)