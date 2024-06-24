/*
Procedure to fill tbl_SERVICE table with random data:

This PL/SQL procedure populates the tbl_SERVICE table with random data. It checks if the table is already
filled before proceeding. If the table is empty, it generates random values for each column in the specified
number of records and inserts them into the table using bulk processing with FORALL.

Parameters:
- par_service_count: Number of service records to be generated and inserted.

Data Generation:
- Client ID (col_client_id): Random client ID from tbl_CLIENT.
- Payment ID (col_payment_id): Random payment ID from tbl_PAYMENT.
- Cost (col_cost): Random cost value between 100 and 1000.
- Datetime (col_datetime): Random timestamp within the range of '2021-01-01 09:00:00' and '2021-12-31 18:00:00'.

Exception Handling:
- Any errors that occur during the bulk insert operation are caught, and the error message is outputted to DBMS_OUTPUT.

Usage Example:
DECLARE
    var_service_count PLS_INTEGER := 50;
BEGIN
    proc_FillServiceTable(var_service_count);
END;
*/
CREATE OR REPLACE PROCEDURE proc_FillServiceTable (par_service_count IN PLS_INTEGER) AUTHID DEFINER
IS
    -- Declare a collection type for storing service records
    TYPE type_service IS TABLE OF tbl_SERVICE%ROWTYPE INDEX BY PLS_INTEGER;
    var_services type_service;

    -- Declare variable to store the existing count of records in tbl_SERVICE
    var_existing_service_count PLS_INTEGER;

    -- Declare a collection type for storing client ids
    TYPE type_client_id IS TABLE OF tbl_CLIENT.col_id%TYPE;
    var_client_ids type_client_id;

    -- Declare a collection type for storing payment ids
    TYPE type_payment_id IS TABLE OF tbl_PAYMENT.col_id%TYPE;
    var_payment_ids type_payment_id;
BEGIN
    -- Check if the table is already filled
    SELECT COUNT(*) INTO var_existing_service_count FROM tbl_SERVICE;
    IF var_existing_service_count > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Table tbl_SERVICE is already filled.');
        RETURN;
    END IF;

    -- Fetch client IDs and payment IDs and check if either tbl_CLIENT or tbl_PAYMENT is empty
    SELECT col_id BULK COLLECT INTO var_client_ids FROM tbl_CLIENT;
    SELECT col_id BULK COLLECT INTO var_payment_ids FROM tbl_PAYMENT;
    IF var_client_ids IS EMPTY OR var_payment_ids IS EMPTY THEN
        DBMS_OUTPUT.PUT_LINE('Table tbl_CLIENT or tbl_PAYMENT is empty.');
        RETURN;
    END IF;

    -- Generate random data for each service record
    FOR i IN 1..par_service_count LOOP
        -- Random client ID from tbl_CLIENT
        var_services(i).col_client_id := var_client_ids(TRUNC(DBMS_RANDOM.VALUE(1, var_client_ids.COUNT)));
        -- Random payment ID from tbl_PAYMENT
        var_services(i).col_payment_id := var_payment_ids(TRUNC(DBMS_RANDOM.VALUE(1, var_payment_ids.COUNT)));
        -- Random cost value between 100 and 1000
        var_services(i).col_cost := TRUNC(DBMS_RANDOM.VALUE(100, 1000));
        -- Random timestamp within the range of '2021-01-01 00:00:00' and '2022-01-01 00:00:00'
        var_services(i).col_datetime := TIMESTAMP '2021-01-01 00:00:00' +
                                            NUMTODSINTERVAL(FLOOR(DBMS_RANDOM.VALUE(0, 365)), 'DAY') +
                                            NUMTODSINTERVAL(FLOOR(DBMS_RANDOM.VALUE(9*60*60, 18*60*60)), 'SECOND');
    END LOOP;

    -- Bulk insert with exception handling
    BEGIN
        FORALL j IN var_services.FIRST..var_services.LAST
            INSERT INTO tbl_SERVICE VALUES var_services(j);
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error during bulk insert: ' || SQLERRM);
            RAISE;
    END;

    -- Display the number of records in tbl_SERVICE after the insert
    SELECT COUNT(*) INTO var_existing_service_count FROM tbl_SERVICE;
    DBMS_OUTPUT.PUT_LINE('Table tbl_SERVICE was filled with ' || var_existing_service_count || ' records!');
END proc_FillServiceTable;


-- Fill the table with var_service_count records
DECLARE
    var_service_count PLS_INTEGER := 150;
BEGIN
    proc_FillServiceTable(var_service_count);
END;
