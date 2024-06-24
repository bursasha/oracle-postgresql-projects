/*
Procedure to populate the "Service" table with random data.

This PL/pgSQL procedure populates the "Service" table with random data. It checks if the table is already filled
before proceeding. If the table is empty, it generates random values for each column in the specified
number of records and inserts them into the table.

Parameters:
- count: Number of service records to be generated and inserted.

Data Generation:
- Client ID (client_id): Random client ID from the "Client" table.
- Payment ID (payment_id): Random payment ID from the "Payment" table.
- Cost (cost): Random cost value between 100 and 1000.
- Datetime (datetime): Random timestamp within the range of '2021-01-01 09:00:00' and '2021-12-31 18:00:00'.

Usage Example:
CALL populate_service_table(50);
*/
CREATE OR REPLACE PROCEDURE populate_service_table(count INT)
LANGUAGE plpgsql
AS $$

DECLARE
    -- Arrays to hold the client and payment IDs
    original_client_ids INT[];
    original_payment_ids INT[];

    -- Constants to hold the maximum and minimum cost values
    MIN_COST CONSTANT INT := 100;
    MAX_COST CONSTANT INT := 1000;

    -- Constants for datetime generation
    START_DATE CONSTANT TIMESTAMP := '2021-01-01 09:00:00'::timestamp;
    WORKING_DAYS CONSTANT INT := 365;
    WORKING_DAY_SECONDS CONSTANT INT := 9 * 60 * 60;

    -- Arrays to hold generated data for each column
    client_ids INT[] := '{}';
    payment_ids INT[] := '{}';
    costs INT[] := '{}';
    datetimes TIMESTAMP[] := '{}';

BEGIN
    -- Check if the "Service" table is already filled
    IF EXISTS (SELECT 1 FROM Service) THEN
        RAISE NOTICE 'Table is already filled: "Service".';
        RETURN;
    END IF;

    -- Fetch client IDs and payment IDs
    SELECT array_agg(id) INTO original_client_ids FROM Client;
    SELECT array_agg(id) INTO original_payment_ids FROM Payment;

    -- Check if the "Client" or "Payment" tables are empty
    IF array_length(original_client_ids, 1) IS NULL OR array_length(original_payment_ids, 1) IS NULL THEN
        RAISE NOTICE 'One of the tables is empty: "Client", "Payment".';
        RETURN;
    END IF;

    -- Generate random service data and store in arrays
    FOR i IN 1..count LOOP
        -- Random client ID from the "Client" table
        client_ids := array_append(client_ids,
                                   original_client_ids[random_num(1, array_length(original_client_ids, 1))]);

        -- Random payment ID from the "Payment" table
        payment_ids := array_append(payment_ids,
                                    original_payment_ids[random_num(1, array_length(original_payment_ids, 1))]);

        -- Random cost value between "MIN_COST" and "MAX_COST"
        costs := array_append(costs, random_num(MIN_COST, MAX_COST));

        -- Random timestamp within the range of '2021-01-01 09:00:00' and '2021-12-31 18:00:00'
        datetimes := array_append(datetimes,
                                  START_DATE +
                                  (random_num(0, WORKING_DAYS) || ' days')::interval +
                                  (random_num(0, WORKING_DAY_SECONDS) || ' seconds')::interval);
    END LOOP;

    -- Perform a bulk insert of all generated data into the "Service" table
    INSERT INTO Service (client_id, payment_id, cost, datetime)
        SELECT unnest(client_ids), unnest(payment_ids), unnest(costs), unnest(datetimes);

    -- Display the number of records in the "Service" table after insertion
    RAISE NOTICE 'Table was filled with % records: "Service"!', (SELECT COUNT(*) FROM Service);

END;
$$;
