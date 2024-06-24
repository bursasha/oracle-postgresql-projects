-- Set logging level to NOTICE
SET client_min_messages TO NOTICE;

------------------------------------------------------------------------------------------------------------------------

/*
PL/pgSQL script to save audit data to a CSV file.

This PL/pgSQL block is designed to generate an audit report for a specified month and save it to a CSV file.
It calls the `save_csv_audit` procedure to perform the audit and export the data.

Parameters:
- `TARGET_MONTH`: The target month for the audit in the format 'YYYY-MM'.
- `CSV_FILE_PATH`: Path to the CSV file where the audit data will be saved.

Audit Data Generation:
- The procedure generates an audit report for the specified month, including various statistics for each client.
- The audit data is exported to the specified CSV file.

Usage Example:
CALL save_csv_audit('2021-01', '/path/to/your/audit_output.csv');
*/

DO $$

DECLARE
    TARGET_MONTH CONSTANT TEXT := '2021-01';
    CSV_FILE_PATH CONSTANT TEXT := '/iFix/data/audit.csv';

BEGIN
    -- Call the procedure to save audit data to the specified CSV file
    CALL save_csv_audit(TARGET_MONTH, CSV_FILE_PATH);

    -- Output success message
    RAISE NOTICE 'Audit data for % successfully saved to file %: "iFix"!', TARGET_MONTH, CSV_FILE_PATH;

END $$;