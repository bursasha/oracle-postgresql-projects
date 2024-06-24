------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

/*
Procedure to fill tbl_PAYMENT table with random data:

This PL/SQL procedure populates the tbl_PAYMENT table with random data. It checks if the table is already
filled before proceeding. If the table is empty, it generates random values for each column in the specified
number of records and inserts them into the table using bulk processing with FORALL.

Parameters:
- par_payment_count: Number of payment records to be generated and inserted.

Data Generation:
- Payment type (col_type): Random string from the set ('Bank transfer', 'Cash', 'Card').
- Printed invoice indicator (col_is_printed_invoice): Random character 'Y' or 'N'.

Exception Handling:
- Any errors that occur during the bulk insert operation are caught, and the error message is outputted to DBMS_OUTPUT.

Usage Example:
DECLARE
    var_payment_count PLS_INTEGER := 70;
BEGIN
    proc_FillPaymentTable(var_payment_count);
END;
*/
CREATE OR REPLACE PROCEDURE proc_FillPaymentTable (par_payment_count IN PLS_INTEGER) AUTHID DEFINER
IS
    -- Declare a collection type for storing payment records
    TYPE type_payment IS TABLE OF tbl_PAYMENT%ROWTYPE INDEX BY PLS_INTEGER;
    var_payments type_payment;

    -- Declare variable to store the existing count of records in tbl_PAYMENT
    var_existing_payment_count PLS_INTEGER;
BEGIN
    -- Check if the table is already filled
    SELECT COUNT(*) INTO var_existing_payment_count FROM tbl_PAYMENT;
    IF var_existing_payment_count > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Table tbl_PAYMENT is already filled.');
        RETURN;
    END IF;

    -- Generate random data for each payment
    FOR i IN 1..par_payment_count LOOP
        -- Random payment type from the set ('Bank transfer', 'Cash', 'Card')
        var_payments(i).col_type := CASE TRUNC(DBMS_RANDOM.VALUE(1, 4))
                                        WHEN 1 THEN 'Bank transfer'
                                        WHEN 2 THEN 'Cash'
                                        ELSE 'Card'
                                    END;
        -- Random indicator for printed invoice ('Y' or 'N')
        var_payments(i).col_is_printed_invoice := CASE TRUNC(DBMS_RANDOM.VALUE(0, 2))
                                                      WHEN 0 THEN 'Y'
                                                      ELSE 'N'
                                                  END;
    END LOOP;

    -- Bulk insert with exception handling
    BEGIN
        FORALL j IN var_payments.FIRST..var_payments.LAST
            INSERT INTO tbl_PAYMENT VALUES var_payments(j);
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error during bulk insert: ' || SQLERRM);
            RAISE;
    END;

    -- Display the number of records in tbl_PAYMENT after the insert
    SELECT COUNT(*) INTO var_existing_payment_count FROM tbl_PAYMENT;
    DBMS_OUTPUT.PUT_LINE('Table tbl_PAYMENT was filled with ' || var_existing_payment_count || ' records!');
END proc_FillPaymentTable;

------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
