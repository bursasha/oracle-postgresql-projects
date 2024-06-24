# 5. Data Processing and Audit in PostgreSQL 🛠️


## Project Structure 📁

- `data/`: Contains data files used in the project.
- `function/`: Contains functions for data processing.
- `procedure/`: Contains PL/pgSQL procedures.
- `script/`: Contains PL/pgSQL scripts for various tasks.
- `server/`: Contains server configuration and setup files.
- `LOG.md`: Log file for tracking project progress.
- `README.md`: The main README file for the project.
- `run.sh`: Script to start the Docker container.
- `stop.sh`: Script to stop the Docker container.

## Docker Setup and Scripts 🚀
The PostgreSQL server is set up using **Docker**, which simplifies the deployment and management of the database. 
The Docker configuration is specified in the `docker-compose.yml` file. The **Docker** environment can be managed using the following scripts:
- `run.sh`: Launches the Docker container.
- `stop.sh`: Stops the Docker container.

## Description of the Entire Phase 🔎
In this phase, we focus on processing and auditing data within the PostgreSQL database environment. 
The main objectives include loading data from a CSV file into the database, 
processing and validating this data, and generating an audit report for a specified month. 
The approach involves creating procedures to handle data loading, ensuring data integrity, 
and exporting audit reports to a CSV file.

## Objectives 📍
1. Load data from a **CSV file** into the database.
2. Process and validate the data using **PL/pgSQL procedures**.
3. Generate an audit report for a specified month.
4. Export the audit report to a **CSV file**.

## Database Structure and Records 📊
The following tables and their structures are used in this phase:

### 1. `Client` Table: 👩🏼
- **Objective:** Store client information.
- **Columns:**
  - `id`: Auto-generated unique identifier.
  - `first_name`: Client's first name.
  - `last_name`: Client's last name.
  - `phone`: Client's phone number.
  - `email`: Client's email address.
- **Constraints:**
  - Primary Key: `pk_client`.

### 2. `Payment` Table: 💰
- **Objective:** Track payment details.
- **Columns:**
  - `id`: Auto-generated unique identifier.
  - `type`: Payment type ('Bank transfer', 'Cash', 'Card').
  - `is_printed_invoice`: Indicates if the invoice is printed ('Y' or 'N').
- **Constraints:**
  - Primary Key: `pk_payment`.
  - Check Constraints: `chk_type`, `chk_is_printed_invoice`.

### 3. `Service` Table: 🔧
- **Objective:** Record service transactions.
- **Columns:**
  - `id`: Auto-generated unique identifier.
  - `client_id`: Foreign key referencing `Client`.
  - `payment_id`: Foreign key referencing `Payment`.
  - `cost`: Cost of the service.
  - `datetime`: Timestamp of the service.
- **Constraints:**
  - Primary Key: `pk_service`.
  - Check Constraint: `chk_datetime`.
  - Foreign Keys: `fk_client`, `fk_payment`.

## Procedures Implemented 🌟
1. **Data Loading Procedure** `load_csv_data`:  🔎
   - This procedure loads data from a specified CSV file into the `Client`, `Payment`, and `Service` tables 
     using temporary tables to buffer the data and ensure integrity. 
```sql
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
```

2. **Audit Report Generation Procedure** `save_csv_audit`: 📝
   - This procedure generates an audit report for a specified month and saves it to a CSV file. 
   - The report includes various statistics for each client regarding their services during the specified month.
```sql
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
```

## Usage Scenario 📚
- **Concept**:
  - The primary goal of this project is to streamline the process of loading client, payment, and service data from 
  a CSV file into a PostgreSQL database and to perform an audit on this data for a specified month. 
  - This scenario can be broken down into two main procedures: data loading and audit reporting.

- **Data Loading**:
  - The `load_csv_data` procedure is designed to take a CSV file containing client, payment, and service information 
    and load it into the respective tables in the PostgreSQL database. 
  - This procedure ensures data integrity by using temporary tables to buffer the data before inserting it into the main tables.
  - **Usage Example**: 
  ```sql 
  CALL load_csv_data('/path/to/your/file.csv');
  ```
  
- **Audit Reporting**:
  - The save_csv_audit procedure generates an audit report for a specified month, detailing various statistics 
    for each client based on their service records. 
  - This procedure helps in understanding client activity and service utilization over the specified period.
- **Usage Example**: 
  ```sql 
  CALL save_csv_audit('2021-01', '/path/to/your/audit_output.csv');
  ```
  
- **Practical Application**:
  - This process is highly practical for businesses that need to manage and audit service transactions. 
  - For example, a service-based company can use these procedures to:
	1.	**Load Monthly Data**: Regularly load monthly service data into the database from operational CSV reports.
	2.	**Generate Monthly Reports**: Generate detailed audit reports at the end of each month to review client activity and service performance.
	3.	**Ensure Data Integrity**: Maintain data integrity and accuracy through automated transaction management and error handling.

## Conclusion 📝
- This phase demonstrates the complete data processing and auditing workflow within a **PostgreSQL environment** using **Docker** for easy deployment. 
- The implementation ensures data integrity and provides a robust mechanism for data auditing, making it practical for real-world applications.
