/*
Procedure to save an audit report for a specific month to a CSV file.

This PL/pgSQL procedure generates an audit report for a specified month and saves it to a CSV file.
The report includes various statistics for each client regarding their services during the specified month.
If any error occurs during the process, the transaction is rolled back to maintain data integrity.

Parameters:
- month: The target month in the format 'YYYY-MM'.
- path: Path to the CSV file where the audit data will be saved.

Data Generation:
- The procedure creates a temporary table to hold the audit data.
- It calculates the required statistics for each client and inserts them into the temporary table.
- The data is then exported to the specified CSV file.

Usage Example:
CALL save_csv_audit('2021-01', '/path/to/your/audit_output.csv');
*/
CREATE OR REPLACE PROCEDURE save_csv_audit(month TEXT, path TEXT)
LANGUAGE plpgsql
AS $$

DECLARE
    start_month_date DATE;
    end_month_date DATE;

BEGIN
    -- Parse the target month into start and end dates
    start_month_date := (month || '-01')::DATE;
    end_month_date := (start_month_date + INTERVAL '1 month')::DATE;

    -- Create a temporary table to hold the audit data
    CREATE TEMP TABLE TmpAudit (
        month TEXT,

        client_id INT,
        client_first_name VARCHAR(15),
        client_last_name VARCHAR(15),
        client_phone VARCHAR(12),
        client_email VARCHAR(45),

        month_total_service_count INT,
        month_total_service_cost NUMERIC,
        month_max_service_cost NUMERIC,
        month_min_service_cost NUMERIC,
        month_avg_service_cost NUMERIC
    );

    BEGIN
        -- Insert audit data into the temporary table
        INSERT INTO TmpAudit (month,
                              client_id, client_first_name, client_last_name, client_phone, client_email,
                              month_total_service_count, month_total_service_cost, month_max_service_cost,
                              month_min_service_cost, month_avg_service_cost)
        SELECT
            to_char(start_month_date, 'YYYY-MM') AS month,

            client.id AS client_id,
            client.first_name AS client_first_name,
            client.last_name AS client_last_name,
            client.phone AS client_phone,
            client.email AS client_email,

            COUNT(service.id) AS month_total_service_count,
            COALESCE(SUM(service.cost), 0) AS month_total_service_cost,
            COALESCE(MAX(service.cost), 0) AS month_max_service_cost,
            COALESCE(MIN(service.cost), 0) AS month_min_service_cost,
            COALESCE(AVG(service.cost), 0) AS month_avg_service_cost
        FROM Client client
        LEFT JOIN Service service ON client.id = service.client_id
        AND service.datetime >= start_month_date AND service.datetime < end_month_date
        GROUP BY client.id, client.first_name, client.last_name
        ORDER BY client.id, client.first_name, client.last_name, month_total_service_cost;

        -- Export the data to CSV
        EXECUTE format('COPY TmpAudit TO %L WITH (FORMAT csv, HEADER true)', path);

    EXCEPTION
        WHEN OTHERS THEN
            -- Rollback the transaction in case of any error
            ROLLBACK;
            RAISE NOTICE 'Error occurred while saving audit data: %.', SQLERRM;
            RETURN;

    END;

    -- Drop the temporary table
    DROP TABLE TmpAudit;

    -- Output success message
    RAISE NOTICE 'Audit table data saved to file %: "Client", "Service"!', path;

END;
$$;
