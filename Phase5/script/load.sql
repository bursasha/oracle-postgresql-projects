-- Set logging level to NOTICE
SET client_min_messages TO NOTICE;

------------------------------------------------------------------------------------------------------------------------

/*
PL/pgSQL script to load data from a CSV file into the "Client", "Payment", and "Service" tables.

This PL/pgSQL block is designed to load data from a specified CSV file into the "Client", "Payment", and "Service" tables.
It calls the `load_csv_data` procedure to load the data.

Parameters:
- `csv_file_path`: Path to the CSV file containing the data to be loaded.

Data Loading:
- The procedure loads data from the CSV file into the respective tables using the `COPY` command and inserts the data
  into the original tables.
*/

DO $$

DECLARE
    CSV_FILE_PATH CONSTANT TEXT := '/iFix/data/test.csv';

BEGIN
    -- Call procedure to load data from the CSV file
    CALL load_csv_data(CSV_FILE_PATH);

    -- Output success message
    RAISE NOTICE 'DB data successfully loaded from file %: "iFix"!', CSV_FILE_PATH;

END $$;
