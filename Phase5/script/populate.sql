-- Set logging level to NOTICE
SET client_min_messages TO NOTICE;

------------------------------------------------------------------------------------------------------------------------

/*
PL/pgSQL script to fill tables with random data.

This PL/pgSQL block is designed to populate the "Client", "Payment", and "Service" tables
with a specified number of random records. It calls three stored procedures to fill each table:
`populate_client_table`, `populate_payment_table`, and `populate_service_table`.

Parameters:
- `client_count`: Number of client records to be generated and inserted into the "Client" table.
- `payment_count`: Number of payment records to be generated and inserted into the "Payment" table.
- `service_count`: Number of service records to be generated and inserted into the "Service" table.

Data Generation:
- The procedures generate random data for each column based on predefined rules and constraints.
- `populate_client_table` generates random client records.
- `populate_payment_table` generates random payment records.
- `populate_service_table` generates random service records, linking clients and payments.
*/

DO $$

DECLARE
    CLIENT_COUNT CONSTANT INT := 50;
    PAYMENT_COUNT CONSTANT INT := 100;
    SERVICE_COUNT CONSTANT INT := 150;

BEGIN
    -- Call procedures to populate each table
    CALL populate_client_table(CLIENT_COUNT);
    CALL populate_payment_table(PAYMENT_COUNT);
    CALL populate_service_table(SERVICE_COUNT);

    -- Output success message
    RAISE NOTICE 'DB successfully populated: "iFix"!';

END $$;
