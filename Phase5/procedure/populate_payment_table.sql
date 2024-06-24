/*
Procedure to populate the "Payment" table with random data.

This PL/pgSQL procedure populates the "Payment" table with random data. It checks if the table is already filled
before proceeding. If the table is empty, it generates random values for each column in the specified
number of records and inserts them into the table.

Parameters:
- count: Number of payment records to be generated and inserted.

Data Generation:
- Payment type (type): Random string from the set ('Bank transfer', 'Cash', 'Card').
- Printed invoice indicator (is_printed_invoice): Random boolean value TRUE or FALSE.

Usage Example:
CALL populate_payment_table(70);
*/
CREATE OR REPLACE PROCEDURE populate_payment_table(count INT)
LANGUAGE plpgsql
AS $$

DECLARE
    -- Variable to hold the possible payment types
    payment_types TEXT[] := ARRAY['Bank transfer', 'Cash', 'Card'];

    -- Arrays to hold generated data for each column
    types TEXT[] := '{}';
    printed_invoices BOOLEAN[] := '{}';

BEGIN
    -- Check if the "Payment" table is already filled
    IF EXISTS (SELECT 1 FROM Payment) THEN
        RAISE NOTICE 'Table is already filled: "Payment".';
        RETURN;
    END IF;

    -- Loop to generate random payment data and store in arrays
    FOR i IN 1..count LOOP
        -- Generate a random payment type
        types := array_append(types, payment_types[random_num(1, array_length(payment_types, 1))]);

        -- Generate a random printed invoice indicator
        printed_invoices := array_append(printed_invoices, (random() < 0.5));
    END LOOP;

    -- Perform a bulk insert of all generated data into the "Payment" table
    INSERT INTO Payment (type, is_printed_invoice)
        SELECT unnest(types), unnest(printed_invoices);

    -- Display the number of records in the "Payment" table after insertion
    RAISE NOTICE 'Table was filled with % records: "Payment"!', (SELECT COUNT(*) FROM Payment);

END;
$$;
