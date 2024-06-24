/*
Function to generate a random string of lowercase alphabetic characters.

This PL/pgSQL function generates a random string consisting of lowercase alphabetic characters ('a' to 'z').
It uses PostgreSQL's built-in functions to create the random string of specified length.

Parameters:
- length: The desired length of the random string.

Data Generation:
- The function uses the ASCII codes for lowercase letters ('a' to 'z'), which range from 97 to 122.
- For each character in the output string, a random integer between 0 and 25 is generated.
- This integer is added to the ASCII code of 'a' to produce a random lowercase letter.

Return Value:
- A TEXT value containing the random string of lowercase alphabetic characters.

Usage Example:
SELECT random_alpha_string(10);
*/
CREATE OR REPLACE FUNCTION random_alpha_string(length INT) RETURNS TEXT
LANGUAGE plpgsql
AS $$

DECLARE
    -- ASCII code for 'a'
    alphabet_start CONSTANT INT := 97;
    -- Number of letters in the alphabet
    alphabet_length CONSTANT INT := 26;

BEGIN
    -- Loop to generate each character of the random string
    RETURN string_agg(chr(alphabet_start + floor(random() * alphabet_length)::INT), '')
        FROM generate_series(1, length);

END;
$$;
