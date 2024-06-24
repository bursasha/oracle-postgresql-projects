-- Set logging level to NOTICE
SET client_min_messages TO NOTICE;

------------------------------------------------------------------------------------------------------------------------

/*
Table drop script for PostgreSQL.

This script drops the specified tables: "Service", "Client", and "Payment" if they exist in the database.
The CASCADE option ensures that any dependent objects are also dropped.

Workflow:
1. Drops the tables "Service", "Client", and "Payment" if they exist.
2. Outputs a success message indicating that the tables have been successfully dropped.
*/

-- Drop the specified tables if they exist, with the CASCADE option
DROP TABLE IF EXISTS Service, Client, Payment CASCADE;

-- Output success message
DO $$
BEGIN
    RAISE NOTICE 'DB successfully dropped: "iFix"!';
END $$;
