-- Set logging level to NOTICE
SET client_min_messages TO NOTICE;

------------------------------------------------------------------------------------------------------------------------

/*
Table create script for PostgreSQL.

This script creates three tables: "Client", "Payment", and "Service" with the necessary constraints and checks.

Workflow:
1. Creates the "Client" table with a primary key.
2. Creates the "Payment" table with a primary key and check constraints.
3. Creates the "Service" table with a primary key, foreign keys, and a check constraint on datetime.
*/

-- Table creation for "Client"
CREATE TABLE Client (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(15) NOT NULL,
    last_name VARCHAR(15) NOT NULL,
    phone VARCHAR(12) NOT NULL,
    email VARCHAR(45)
);

-- Output success message
DO $$
BEGIN
    RAISE NOTICE 'Table successfully created: "Client"!';
END $$;

-- Table creation for "Payment"
CREATE TABLE Payment (
    id SERIAL PRIMARY KEY,
    type VARCHAR(30) NOT NULL,
    is_printed_invoice BOOLEAN NOT NULL,

    CONSTRAINT chk_type CHECK (type IN ('Bank transfer', 'Cash', 'Card'))
);

-- Output success message
DO $$
BEGIN
    RAISE NOTICE 'Table successfully created: "Payment"!';
END $$;

-- Table creation for "Service"
CREATE TABLE Service (
    id SERIAL PRIMARY KEY,
    client_id INTEGER NOT NULL,
    payment_id INTEGER NOT NULL,
    cost NUMERIC NOT NULL,
    datetime TIMESTAMP NOT NULL,

    CONSTRAINT chk_datetime CHECK (
        datetime >= '2021-01-01 00:00:00'
        AND EXTRACT(HOUR FROM datetime) >= 9
        AND EXTRACT(HOUR FROM datetime) < 18
    ),
    CONSTRAINT fk_client FOREIGN KEY (client_id) REFERENCES Client (id) ON DELETE CASCADE,
    CONSTRAINT fk_payment FOREIGN KEY (payment_id) REFERENCES Payment (id) ON DELETE CASCADE
);

-- Output success message
DO $$
BEGIN
    RAISE NOTICE 'Table successfully created: "Service"!';
END $$;

-- Output success message
DO $$
BEGIN
    RAISE NOTICE 'DB successfully created: "iFix"!';
END $$;
