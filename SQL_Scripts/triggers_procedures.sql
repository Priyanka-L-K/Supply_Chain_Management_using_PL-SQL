-- 1. Order Processing Trigger: Triggers when a new order is placed and calls the inventory check.
CREATE OR REPLACE TRIGGER new_order
AFTER INSERT ON Orders
FOR EACH ROW
BEGIN
    DBMS_OUTPUT.PUT_LINE('New order received: ' || :NEW.qty || ' units of ' || :NEW.type);
    procInventory(:NEW.qty, :NEW.type, :NEW.order_no);
END;
/

-- 2. Inventory Management Procedure: Checks stock levels and determines if production is needed.
CREATE OR REPLACE PROCEDURE procInventory (qty IN INT, typeInput IN VARCHAR, orderId IN INT)
IS
    current_stock INT;
    additional_needed INT;
BEGIN
    SELECT qty INTO current_stock FROM Inventory WHERE type = typeInput;
    
    IF qty <= current_stock THEN
        deliver(qty, typeInput, orderId);
    ELSE
        additional_needed := qty - current_stock;
        searchProductionRequirements(additional_needed, typeInput, orderId);
    END IF;
END;
/

-- 3. Production Requirements Check: Determines if enough modules exist or if more components are needed.
CREATE OR REPLACE PROCEDURE searchProductionRequirements (neededQty IN INT, typeInput IN VARCHAR, orderId IN INT)
IS
    available_modules INT;
BEGIN
    SELECT COUNT(*) INTO available_modules FROM Modules WHERE type = typeInput;
    
    IF available_modules >= neededQty THEN
        assembleProduct(neededQty, typeInput, orderId);
    ELSE
        procureComponents(neededQty, typeInput, orderId);
    END IF;
END;
/

-- 4. Product Assembly: Uses available modules to create new products and update inventory.
CREATE OR REPLACE PROCEDURE assembleProduct (qty IN INT, typeInput IN VARCHAR, orderId IN INT)
IS
BEGIN
    UPDATE Modules SET qty = qty - qty WHERE type = typeInput;
    INSERT INTO MiPad (serial_no, type, test_result, sale_status)
    VALUES (SEQ_MiPad.NEXTVAL, typeInput, 'not tested', 'not available');
    DBMS_OUTPUT.PUT_LINE('Assembled ' || qty || ' units of ' || typeInput);
END;
/

-- 5. Component Procurement: Orders components if modules are insufficient for production.
CREATE OR REPLACE PROCEDURE procureComponents (qty IN INT, typeInput IN VARCHAR, orderId IN INT)
IS
BEGIN
    UPDATE Components SET qty = qty - qty WHERE cid IN (SELECT cid FROM Com_mod WHERE mid IN (SELECT mid FROM Modules WHERE type = typeInput));
    DBMS_OUTPUT.PUT_LINE('Components procured for ' || qty || ' units of ' || typeInput);
END;
/

-- 6. Delivery Procedure: Ships completed products and updates order fulfillment.
CREATE OR REPLACE PROCEDURE deliver (qty IN INT, typeInput IN VARCHAR, orderId IN INT)
IS
BEGIN
    UPDATE Inventory SET qty = qty - qty WHERE type = typeInput;
    UPDATE Orders SET to_be_filled = 0 WHERE order_no = orderId;
    DBMS_OUTPUT.PUT_LINE('Delivered ' || qty || ' units of ' || typeInput);
END;
/

-- 7. Testing Procedure: Simulates product testing before marking it available for sale.
CREATE OR REPLACE PROCEDURE testMipad (serial_no IN INT)
IS
BEGIN
    DBMS_OUTPUT.PUT_LINE('Testing MiPad with serial number ' || serial_no);
    UPDATE MiPad SET test_result = 'success', sale_status = 'for sale' WHERE serial_no = serial_no;
END;
/
