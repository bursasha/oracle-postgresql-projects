/*
Procedure to fill tbl_CLIENT table with random data:

This PL/SQL procedure populates the tbl_CLIENT table with random data. It checks if the table is already
filled before proceeding. If the table is empty, it generates random values for each column in the specified
number of records and inserts them into the table using bulk processing with FORALL.

Parameters:
- par_client_count: Number of client records to be generated and inserted.

Data Generation:
- First name (col_first_name): Random string of uppercase alphabets (A) with length between 3 and 15.
- Last name (col_last_name): Random string of uppercase alphabets (A) with length between 4 and 14.
- Phone number (col_phone): Random numeric string (N) with the value between 1E8 (100000000) and 1E9 - 1 (999999999).
- Email (col_email): Concatenation of first name, last name, and '@example.com'.

Exception Handling:
- Any errors that occur during the bulk insert operation are caught, and the error message is outputted to DBMS_OUTPUT.

Usage Example:
DECLARE
    var_client_count PLS_INTEGER := 100;
BEGIN
    proc_FillClientTable(var_client_count);
END;
*/
CREATE OR REPLACE PROCEDURE proc_FillClientTable (par_client_count IN PLS_INTEGER) AUTHID DEFINER
IS
    -- Declare a collection type for storing client records
    TYPE type_client IS TABLE OF tbl_CLIENT%ROWTYPE INDEX BY PLS_INTEGER;
    var_clients type_client;

    -- Declare variable to store the existing count of records in tbl_CLIENT
    var_existing_client_count PLS_INTEGER;
BEGIN
    -- Check if the table is already filled
    SELECT COUNT(*) INTO var_existing_client_count FROM tbl_CLIENT;
    IF var_existing_client_count > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Table tbl_CLIENT is already filled.');
        RETURN;
    END IF;

    -- Generate random data for each client
    FOR i IN 1..par_client_count LOOP
        -- Random first name using uppercase alphabets (A) with length between 3 and 15
        var_clients(i).col_first_name := DBMS_RANDOM.STRING('A', TRUNC(DBMS_RANDOM.VALUE(3, 15)));
        -- Random last name using uppercase alphabets (A) with length between 4 and 14
        var_clients(i).col_last_name := DBMS_RANDOM.STRING('A', TRUNC(DBMS_RANDOM.VALUE(4, 14)));
        -- Random phone number as a numeric string (N) with a value between 1E8 (100000000) and 1E9 - 1 (999999999)
        var_clients(i).col_phone := TO_CHAR(TRUNC(DBMS_RANDOM.VALUE(100000000, 999999999)));
        -- Concatenate first name, last name, and '@example.com' to generate a random email
        var_clients(i).col_email :=
            var_clients(i).col_first_name || '.' || var_clients(i).col_last_name || '@example.com';
    END LOOP;

    -- Bulk insert with exception handling
    BEGIN
        FORALL j IN var_clients.FIRST..var_clients.LAST
            INSERT INTO tbl_CLIENT VALUES var_clients(j);
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error during bulk insert: ' || SQLERRM);
            RAISE;
    END;

    -- Display the number of records in tbl_CLIENT after the insert
    SELECT COUNT(*) INTO var_existing_client_count FROM tbl_CLIENT;
    DBMS_OUTPUT.PUT_LINE('Table tbl_CLIENT was filled with ' || var_existing_client_count || ' records!');
END proc_FillClientTable;


-- Fill the table with var_client_count records
DECLARE
    var_client_count PLS_INTEGER := 50;
BEGIN
    proc_FillClientTable(var_client_count);
END;
