------------------------------------------------------------------------------------------------------------------------


/*
Dynamic Table Drop PL/SQL Block:

This PL/SQL block is designed to dynamically drop specified tables using the EXECUTE IMMEDIATE statement.
It utilizes a custom collection type to store table names and iterates through them in a loop, attempting
to drop each table. It outputs success or failure messages for each table to the console using DBMS_OUTPUT.
*/
DECLARE
    -- Declaration of custom collection type
    TYPE type_table_name IS TABLE OF VARCHAR2(20);
    -- Initialization of the collection with table names to drop
    var_table_names type_table_name := type_table_name('tbl_SERVICE', 'tbl_CLIENT', 'tbl_PAYMENT');
BEGIN
    -- Loop for processing each table in the collection
    FOR i IN 1..var_table_names.COUNT LOOP
        BEGIN
            -- Dynamic execution of DROP TABLE SQL command
            EXECUTE IMMEDIATE 'DROP TABLE ' || var_table_names(i) || ' PURGE';
            -- Outputting success message for the dropped table
            DBMS_OUTPUT.PUT_LINE('Table ' || var_table_names(i) || ' successfully dropped!');
        EXCEPTION
            -- Handling exceptions that may occur during DROP TABLE execution
            WHEN OTHERS THEN
                -- Outputting an error message or indicating the absence of the table
                DBMS_OUTPUT.PUT_LINE('Table ' || var_table_names(i) ||
                                     ' does not exist or there was an error during the drop.');
        END;
    END LOOP;
END;


------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------


-- Table creation for Client
CREATE TABLE tbl_CLIENT (
    col_id NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY NOT NULL,
    col_first_name VARCHAR2(15) NOT NULL,
    col_last_name VARCHAR2(15) NOT NULL,
    col_phone VARCHAR2(12) NOT NULL,
    col_email VARCHAR2(45),
    col_privilege_type VARCHAR2(10) DEFAULT 'Standard' NOT NULL,
    col_service_count NUMBER DEFAULT 0 NOT NULL
);
ALTER TABLE tbl_CLIENT ADD CONSTRAINT pk_client PRIMARY KEY (col_id);
ALTER TABLE tbl_CLIENT ADD CONSTRAINT chk_privilege_type CHECK (col_privilege_type IN ('Standard', 'Gold', 'Platinum'));

----

-- Table creation for Payment
CREATE TABLE tbl_PAYMENT (
    col_id NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY NOT NULL,
    col_type VARCHAR2(30) NOT NULL,
    col_is_printed_invoice CHAR(1) NOT NULL
);
ALTER TABLE tbl_PAYMENT ADD CONSTRAINT pk_payment PRIMARY KEY (col_id);
ALTER TABLE tbl_PAYMENT ADD CONSTRAINT chk_type CHECK (col_type IN ('Bank transfer', 'Cash', 'Card'));
ALTER TABLE tbl_PAYMENT ADD CONSTRAINT chk_is_printed_invoice CHECK (col_is_printed_invoice IN ('Y', 'N'));

----

-- Table creation for Service
CREATE TABLE tbl_SERVICE (
    col_id NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY NOT NULL,
    col_client_id NUMBER NOT NULL,
    col_payment_id NUMBER NOT NULL,
    col_cost NUMBER NOT NULL,
    col_datetime TIMESTAMP NOT NULL
);
ALTER TABLE tbl_SERVICE ADD CONSTRAINT pk_service PRIMARY KEY (col_id);
ALTER TABLE tbl_SERVICE ADD CONSTRAINT chk_datetime
    CHECK (col_datetime >= TIMESTAMP '2021-01-01 00:00:00'
    AND EXTRACT(HOUR FROM col_datetime) >= 9 AND EXTRACT(HOUR FROM col_datetime) < 18);

ALTER TABLE tbl_SERVICE ADD CONSTRAINT fk_client
    FOREIGN KEY (col_client_id) REFERENCES tbl_CLIENT (col_id) ON DELETE CASCADE;
ALTER TABLE tbl_SERVICE ADD CONSTRAINT fk_payment
    FOREIGN KEY (col_payment_id) REFERENCES tbl_PAYMENT (col_id) ON DELETE CASCADE;


------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------


-- Output success message
BEGIN
    DBMS_OUTPUT.PUT_LINE('All tables successfully created!');
END;


------------------------------------------------------------------------------------------------------------------------
