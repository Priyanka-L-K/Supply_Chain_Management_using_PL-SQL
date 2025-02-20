-- Table Definitions: Define the schema for inventory and production management.

-- Components Table: Stores all components used in module manufacturing.
--    Each component has a unique ID, name, quantity, and supplier reference.
CREATE TABLE Components( 
    cid INT NOT NULL, 
    cname VARCHAR(25) NOT NULL, 
    qty INT NOT NULL, 
    sup_id CHAR(5) NOT NULL, 
    PRIMARY KEY(cid), 
    CONSTRAINT fk_supplier FOREIGN KEY(sup_id) REFERENCES Supplier(sup_id) ON DELETE SET NULL 
);

-- Com_mod Table: Establishes a many-to-many relationship between components and modules.
--    Tracks which components belong to which modules.
CREATE TABLE Com_mod( 
    cid INT NOT NULL, 
    mid INT NOT NULL, 
    PRIMARY KEY(cid, mid), 
    CONSTRAINT fk_com FOREIGN KEY(cid) REFERENCES Components(cid) ON DELETE SET NULL, 
    CONSTRAINT fk_mod FOREIGN KEY(mid) REFERENCES Modules(mid) ON DELETE SET NULL 
);

-- Modules Table: Stores different types of modules used in miPad assembly.
--    Tracks module ID, name, and available quantity.
CREATE TABLE Modules( 
    mid INT NOT NULL, 
    mname VARCHAR(25) NOT NULL, 
    mQty INT NOT NULL, 
    PRIMARY KEY(mid) 
);

-- Types Table: Defines miPad product variations, including RAM, color, and associated modules.
--    Links to the Modules table to track required parts.
CREATE TABLE Types( 
    type CHAR(5) NOT NULL, 
    ram CHAR(5) NOT NULL, 
    color CHAR(5) NOT NULL, 
    caseid INT NOT NULL, 
    motherboardid INT NOT NULL, 
    accessoryid INT NOT NULL, 
    PRIMARY KEY(type), 
    CONSTRAINT fk_mod1 FOREIGN KEY(caseid) REFERENCES Modules(mid), 
    CONSTRAINT fk_mod2 FOREIGN KEY(motherboardid) REFERENCES Modules(mid), 
    CONSTRAINT fk_mod3 FOREIGN KEY(accessoryid) REFERENCES Modules(mid) 
);

-- MiPad Table: Stores detailed records for each manufactured miPad.
--    Tracks serial number, type, testing result, and sale status.
CREATE TABLE MiPad( 
    serial_no INT NOT NULL, 
    type VARCHAR(5) NOT NULL, 
    test_result VARCHAR(2) NOT NULL, 
    sale_status VARCHAR(2) NOT NULL, 
    PRIMARY KEY(serial_no), 
    CONSTRAINT fk_type FOREIGN KEY(type) REFERENCES Types(type) 
);

-- Inventory Table: Keeps track of available miPads ready for sale.
--    Ensures referential integrity by linking with the Types table.
CREATE TABLE Inventory( 
    type VARCHAR(5) NOT NULL, 
    qty INT, 
    PRIMARY KEY(type), 
    CONSTRAINT fk_type2 FOREIGN KEY(type) REFERENCES Types(type) 
);

-- Orders Table: Manages customer orders and fulfillment tracking.
--    Logs order number, product type, requested quantity, and pending fulfillment.
CREATE TABLE Orders( 
    order_no INT NOT NULL, 
    type VARCHAR(5) NOT NULL, 
    qty INT NOT NULL, 
    to_be_filled INT NOT NULL, 
    PRIMARY KEY(order_no), 
    CONSTRAINT fk_inv FOREIGN KEY(type) REFERENCES Inventory(type) ON DELETE SET NULL 
);
