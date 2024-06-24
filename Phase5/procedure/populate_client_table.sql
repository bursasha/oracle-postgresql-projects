/*
Procedure to populate the "Client" table with random data.

This PL/pgSQL procedure populates the "Client" table with random data. It checks if the table is already filled
before proceeding. If the table is empty, it generates random values for each column in the specified
number of records and inserts them into the table.

Parameters:
- count: Number of client records to be generated and inserted.

Data Generation:
- First name (first_name): Random string of lowercase alphabets (a-z) with the maximum length defined in the table schema.
- Last name (last_name): Random string of lowercase alphabets (a-z) with the maximum length defined in the table schema.
- Phone number (phone): Random numeric string (0-9) with the maximum length defined in the table schema.
- Email (email): Concatenation of first name, last name, and '@example.com'.

Usage Example:
CALL populate_client_table(100);
*/
CREATE OR REPLACE PROCEDURE populate_client_table(count INT)
LANGUAGE plpgsql
AS $$

DECLARE
    -- Variables to hold the maximum lengths of the columns
    max_first_name_length INT;
    max_last_name_length INT;
    max_phone_length INT;

    -- Arrays to hold generated data for each column
    first_names TEXT[] := '{}';
    last_names TEXT[] := '{}';
    phones TEXT[] := '{}';
    emails TEXT[] := '{}';

BEGIN
    -- Check if the "Client" table is already filled
    IF EXISTS (SELECT 1 FROM Client) THEN
        RAISE NOTICE 'Table is already filled: "Client".';
        RETURN;
    END IF;

    -- Retrieve the maximum length of the "first_name" column
    SELECT character_maximum_length INTO max_first_name_length FROM information_schema.columns
        WHERE table_name = 'client' AND column_name = 'first_name';

    -- Retrieve the maximum length of the "last_name" column
    SELECT character_maximum_length INTO max_last_name_length FROM information_schema.columns
        WHERE table_name = 'client' AND column_name = 'last_name';

    -- Retrieve the maximum length of the "phone" column
    SELECT character_maximum_length INTO max_phone_length FROM information_schema.columns
        WHERE table_name = 'client' AND column_name = 'phone';

    -- Loop to generate random client data and store in arrays
    FOR i IN 1..count LOOP
        -- Generate a random first name
        first_names := array_append(first_names, random_alpha_string(max_first_name_length));

        -- Generate a random last name
        last_names := array_append(last_names, random_alpha_string(max_last_name_length));

        -- Generate a random phone number
        phones := array_append(phones, random_num_string(max_phone_length));

        -- Generate an email address based on the first and last name
        emails := array_append(emails, first_names[i] || '.' || last_names[i] || '@example.com');
    END LOOP;

    -- Perform a bulk insert of all generated data into the "Client" table
    INSERT INTO Client (first_name, last_name, phone, email)
        SELECT unnest(first_names), unnest(last_names), unnest(phones), unnest(emails);

    -- Display the number of records in the "Client" table after insertion
    RAISE NOTICE 'Table was filled with % records: "Client"!', (SELECT COUNT(*) FROM Client);

END;
$$;
