/*
Procedure to load data from a CSV file into the "Client", "Payment", and "Service" tables.

This PL/pgSQL procedure loads data from a specified CSV file into the "Client", "Payment", and "Service" tables.
It uses temporary tables to buffer the data and ensures that data is inserted into the main tables in the correct order.
If any error occurs during the process, the transaction is rolled back to maintain data integrity.

Parameters:
- path: Path to the CSV file containing the data to be loaded.

Data Loading:
- The procedure loads data from the CSV file into a temporary table using the `COPY` command.
- Data is then processed and inserted into the original tables: "Client", "Payment", and "Service".

Usage Example:
CALL load_csv_data('/path/to/your/file.csv');
*/
CREATE OR REPLACE PROCEDURE load_csv_data(path TEXT)
LANGUAGE plpgsql
AS $$

DECLARE
    tmp_client_id INT;
    tmp_payment_id INT;
    tmp_record RECORD;

BEGIN
    -- Create a temporary table to load all data
    CREATE TEMP TABLE TmpData (
        client_first_name VARCHAR(15),
        client_last_name VARCHAR(15),
        client_phone VARCHAR(12),
        client_email VARCHAR(45),

        payment_type VARCHAR(30),
        payment_is_printed_invoice BOOLEAN,

        service_cost NUMERIC,
        service_datetime TIMESTAMP
    );

    BEGIN
        -- Load data from CSV file into the temporary table
        EXECUTE format('COPY TmpData (' ||
                       'client_first_name, client_last_name, client_phone, client_email, ' ||
                       'payment_type, payment_is_printed_invoice, ' ||
                       'service_cost, service_datetime' ||
                       ') FROM %L WITH (FORMAT csv, HEADER true)', path);

        -- Process the data and insert into the main tables
        FOR tmp_record IN (SELECT * FROM TmpData) LOOP
            -- Insert data into the Client table and get the client_id
            INSERT INTO Client (first_name, last_name, phone, email)
                VALUES (tmp_record.client_first_name, tmp_record.client_last_name, 
                        tmp_record.client_phone, tmp_record.client_email)
                RETURNING id INTO tmp_client_id;

            -- Insert data into the Payment table and get the payment_id
            INSERT INTO Payment (type, is_printed_invoice)
                VALUES (tmp_record.payment_type, tmp_record.payment_is_printed_invoice)
                RETURNING id INTO tmp_payment_id;

            -- Insert data into the Service table using the obtained client_id and payment_id
            INSERT INTO Service (client_id, payment_id, cost, datetime)
                VALUES (tmp_client_id, tmp_payment_id, tmp_record.service_cost, tmp_record.service_datetime);
        END LOOP;

    EXCEPTION
        WHEN OTHERS THEN
            -- Rollback the transaction in case of any error
            ROLLBACK;
            RAISE NOTICE 'Error occurred while loading data: %.', SQLERRM;
            RETURN;

    END;

    -- Drop the temporary table
    DROP TABLE TmpData;

    -- Output success message
    RAISE NOTICE 'Table data loaded from file %: "Client", "Payment", "Service"!', path;

END;
$$;
