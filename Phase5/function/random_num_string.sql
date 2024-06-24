/*
Function to generate a random string of numeric characters.

This PL/pgSQL function generates a random string consisting of numeric characters ('0' to '9').
It uses PostgreSQL's built-in functions to create the random string of specified length.

Parameters:
- length: The desired length of the random string.

Data Generation:
- The function uses the ASCII codes for numeric digits ('0' to '9'), which range from 48 to 57.
- For each character in the output string, a random integer between 0 and 9 is generated.
- This integer is added to the ASCII code of '0' to produce a random numeric character.

Return Value:
- A TEXT value containing the random string of numeric characters.

Usage Example:
SELECT random_num_string(10);
*/
CREATE OR REPLACE FUNCTION random_num_string(length INT) RETURNS TEXT
LANGUAGE plpgsql
AS $$

DECLARE
    -- ASCII code for '0'
    digit_start CONSTANT INT := 48;
    -- Number of digits
    digit_count CONSTANT INT := 10;

BEGIN
    -- Generate a random string of the specified length
    RETURN string_agg(chr(digit_start + floor(random() * digit_count)::INT), '')
        FROM generate_series(1, length);

END;
$$;
