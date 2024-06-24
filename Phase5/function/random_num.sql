/*
Function to generate a random integer within a specified range.

This PL/pgSQL function generates a random integer between the specified minimum and maximum values (inclusive).
It uses PostgreSQL's built-in `random` function to create the random integer within the given range.

Parameters:
- min: The minimum value of the desired range (inclusive).
- max: The maximum value of the desired range (inclusive).

Data Generation:
- The function generates a random number between 0 and 1 using `random()`.
- It then scales this number to the specified range and shifts it by the minimum value.
- The result is rounded down to the nearest integer using the `floor` function.

Return Value:
- An integer value between the specified minimum and maximum values (inclusive).

Usage Example:
SELECT random_num(100, 1000);
*/
CREATE OR REPLACE FUNCTION random_num(min INT, max INT) RETURNS INT
LANGUAGE plpgsql
AS $$

BEGIN
    RETURN floor(min + random() * (max - min + 1))::INT;

END;
$$;
