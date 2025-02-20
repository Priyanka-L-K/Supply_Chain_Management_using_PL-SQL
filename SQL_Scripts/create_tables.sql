-- The table Components records the components we purchase from Team A’s suppliers and use in creating 
-- modules. The table records a unique identifier for each component (cid)--the value of which is the same 
-- across Team A and Team B--the name of each component (cname), the amount of each component we 
-- have in stock (qty), and the id of the supplier that we order each component from (supp). When our orders 
-- to Team A are fulfilled, the qty field will be updated to reflect the number of components added. The table 
-- references Team A’s Supplier table to keep the supplier names consistent. Components also has a 
-- relationship with Com_mod, specifying which components are used for which modules. 

CREATE TABLE Components( 
cid INT NOT NULL, 
cname VARCHAR(25) NOT NULL, 
qty INT NOT NULL, 
sup_id Char(5) NOT NULL, 
PRIMARY KEY(cid), 
CONSTRAINT fk_xx 
FOREIGN KEY(sup_id) 
REFERENCES Supplier(sup_id ) ON DELETE SET NULL 
);

-- The table Com_mod connects the components to the modules they are used to create. The entities 
-- “components” and “modules” have a many-to-many relationship, so this table bridges that. 

CREATE TABLE Com_mod( 
cid INT NOT NULL, 
mid INT NOT NULL, 
CONSTRAINT com_mod_pk PRIMARY KEY(cid, mid), 
CONSTRAINT fk_com 
FOREIGN KEY(cid) 
REFERENCES Components(cid) ON DELETE SET NULL, 
CONSTRAINT fk_mod 
FOREIGN KEY(mid) 
REFERENCES Modules(mid) ON DELETE SET NULL 
);

-- The table Modules records information about each module type that is manufactured. It includes a unique 
-- id for each type of module (mid), the name of the module (mname), and the number of each type of 
-- module we currently have in stock (qty). It is related to the table Com_mod, which records what 
-- components go into making each module, and to the table Types, which records what modules are used to 
-- create which types of miPad. 
  
CREATE TABLE Modules( 
mid INT NOT NULL, 
mname VARCHAR(25) NOT NULL, 
mQty INT NOT NULL, 
CONSTRAINT mod_pk PRIMARY KEY(mid, qty) 
); 

-- The table Types records information about the types of miPads we assemble. Each type has a unique 
-- name (type), a given amount of RAM (ram), a color (color), and is made up of three modules: a case 
-- (caseid), an integrated motherboard (motherboardid), and a module holding several other parts and 
-- accessories (accessoryid). The modules fields reference the Modules table. The Types table is also related 
-- to both the MiPad table, which records information about the individual miPads produced, and to the 
-- inventory table, which tracks the number of miPads of each type we have. 
  
CREATE TABLE Types( 
type CHAR(5) NOT NULL, 
ram CHAR(5) NOT NULL, 
color CHAR(5) NOT NULL, 
caseid INT NOT NULL, 
motherboardid INT NOT NULL, 
accessoryid INT NOT NULL, 
CONSTRAINT types_pk PRIMARY KEY(type), 
CONSTRAINT fk_mod1 
FOREIGN KEY(caseid) 
REFERENCES Modules(mid), 
CONSTRAINT fk_mod2 
FOREIGN KEY(motherboardid) 
REFERENCES Modules(mid), 
CONSTRAINT fk_mod3 
FOREIGN KEY(accessoryid) 
REFERENCES Modules(mid), 
); 

-- The table MiPad records information for each individual miPad we make. Each miPad has a unique 
-- identifier (pid), is of a given type (type), and is sold or unsold (sale_status). The table also records 
-- whether or not a miPad has been tested yet and, if it has been tested, if it passed or failed the test 
-- (test_result). MiPad references the Types table to indicate what types of miPad can be and are present. 

  
CREATE TABLE MiPad( 
serial_no INT NOT NULL, 
type VARCHAR(5) NOT NULL, 
test_result VARCHAR(2) NOT NULL, 
sale_status VARCHAR(2) NOT NULL, 
CONSTRAINT mipad_pk PRIMARY KEY(pid), 
CONSTRAINT fk_type 
FOREIGN KEY(type) 
REFERENCES Types(type),  
); 

-- The table Inventory records numbers of currently-in-stock, ready-to-be-sold miPads. The table includes 
-- the type of miPad (type) and the number of that type of miPad that are available for immediate sale 
-- (inventQty). Like the MiPad table, Inventory references the Types table for referential integrity on the 
-- types of miPads available. 
  
CREATE TABLE Inventory( 
type VARCHAR(5) NOT NULL, 
qty INT, 
CONSTRAINT Inventory_pk PRIMARY KEY(type), 
CONSTRAINT fk_type2 
FOREIGN KEY(type) 
REFERENCES Types(type), 
); 

-- The table Orders records the orders that we receive from Team C. Each order has a unique, identifying 
-- number (oid), is for a type of miPad (type), gives the number of miPads wanted (qty), and records how 
-- many miPads still need to be provided to Team C to complete the order (to_be_filled). This is the table 
-- Team C will insert into the order miPads from us.

CREATE TABLE Orders( 
order_no INT NOT NULL, 
type VARCHAR(5) NOT NULL, 
qty INT NOT NULL, 
to_be_filled INT NOT NULL, 
CONSTRAINT order_pk PRIMARY KEY(oid), 
CONSTRAINT fk_inv 
FOREIGN KEY(type) 
REFERENCES Inventory(type) ON DELETE SET NULL 
); 
