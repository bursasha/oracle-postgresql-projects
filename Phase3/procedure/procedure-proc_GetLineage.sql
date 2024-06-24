------------------------------------------------------------------------------------------------------------------------

/*
Procedure to Get Lineage of an Otter:

This PL/SQL procedure, `proc_GetLineage`, retrieves the ancestral lineage of a specified otter based on its name
and the desired lineage type (male, female, or both).

Parameters:
- par_otter_name (IN VYDRA.JMENO%TYPE): The name of the otter for which the lineage is requested.
- par_lineage_type (IN VARCHAR2): The type of lineage to retrieve ('MALE', 'FEMALE', or 'BOTH').

Procedure Logic:
1. Validates the existence of the otter with the given name in the 'VYDRA' table.
2. Validates the lineage type parameter.
3. Uses a parameterized cursor `cur_Lineage`, which utilizes a recursive Common Table Expression (CTE) to traverse
   the lineage. The CTE constructs the ancestral lineage based on the otter's ID and the specified lineage type.
4. The cursor fetches distinct records to avoid duplication and maintains the order based on generation, otter ID, name.
5. Outputs the lineage in a formatted way, showing the generation, ID, name, sex, and IDs of parents of each ancestor.

Exception Handling:
- Throws an error if no otter with the specified name is found.
- Throws an error if multiple otters with the same name are found.
- Throws an error if the lineage type is not one of 'MALE', 'FEMALE', or 'BOTH'.

Cursor Description:
- `cur_Lineage` is a parameterized cursor that takes otter ID and lineage type as parameters.
  It uses a recursive CTE to traverse through the otter family tree based on the specified lineage type.
  The cursor ensures unique and ordered retrieval of ancestor information.

Usage Example:
DECLARE
    var_otter_name VYDRA.JMENO%TYPE := 'Iason';
    var_lineage_type VARCHAR2(10) := 'MALE';
BEGIN
    proc_GetLineage(var_otter_name, var_lineage_type);
END;
*/
CREATE OR REPLACE PROCEDURE proc_GetLineage (par_otter_name IN VYDRA.JMENO%TYPE,
                                             par_lineage_type IN VARCHAR2) AUTHID DEFINER
AS
    c_LINEAGE_TYPES CONSTANT SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST('MALE', 'FEMALE', 'BOTH');
    c_NO_OTTER_FOUND_CODE CONSTANT NUMBER := -20001;
    c_MULTIPLE_OTTERS_FOUND_CODE CONSTANT NUMBER := -20002;
    c_INVALID_LINEAGE_TYPE_CODE CONSTANT NUMBER := -20003;

    ----

    var_otter_id VYDRA.CV%TYPE;

    CURSOR cur_Lineage (par_otter_id VYDRA.CV%TYPE, par_lineage_type VARCHAR2) IS
        SELECT DISTINCT col_GENERATION, col_ID, col_NAME, col_SEX, col_FATHER, col_MOTHER FROM (
            WITH rec_Lineage (col_GENERATION, col_ID, col_NAME, col_SEX, col_FATHER, col_MOTHER) AS (
                SELECT 1, CV, JMENO, POHLAVI, OTEC, MATKA FROM vydra WHERE CV = par_otter_id
                UNION ALL
                SELECT rl.col_GENERATION + 1, otter.CV, otter.JMENO, otter.POHLAVI, otter.OTEC, otter.MATKA
                    FROM VYDRA otter
                JOIN rec_Lineage rl ON
                    (par_lineage_type = c_LINEAGE_TYPES(1) AND rl.col_FATHER = otter.CV)
                    OR (par_lineage_type = c_LINEAGE_TYPES(2) AND rl.col_MOTHER = otter.CV)
                    OR (par_lineage_type = c_LINEAGE_TYPES(3) AND
                        (rl.col_FATHER = otter.CV OR rl.col_MOTHER = otter.CV))
            ) SELECT * FROM rec_Lineage
        ) ORDER BY col_GENERATION, col_ID, col_NAME;

BEGIN
    BEGIN
        SELECT CV INTO var_otter_id FROM VYDRA WHERE JMENO = par_otter_name;

        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                RAISE_APPLICATION_ERROR(c_NO_OTTER_FOUND_CODE, 'No Otter found with name: ' ||
                                                               par_otter_name || '.');

            WHEN TOO_MANY_ROWS THEN
                RAISE_APPLICATION_ERROR(c_MULTIPLE_OTTERS_FOUND_CODE, 'Multiple Otters found with name: ' ||
                                                                      par_otter_name || '.');
    END;

    ----

    IF par_lineage_type NOT IN ('MALE', 'FEMALE', 'BOTH') THEN
        RAISE_APPLICATION_ERROR(c_INVALID_LINEAGE_TYPE_CODE, 'Invalid Lineage Type: ' || par_lineage_type || '.');
    END IF;

    ----

    DBMS_OUTPUT.PUT_LINE('                 The chosen Otter with name = ' || par_otter_name ||
                         ' and with ID = ' || var_otter_id || ':');
    DBMS_OUTPUT.PUT_LINE('----------------------------------' || par_lineage_type ||
                         ' Lineage------------------------------------------');

    FOR ancestor IN cur_Lineage(var_otter_id, par_lineage_type) LOOP
        DBMS_OUTPUT.PUT_LINE('{ Generation = ' || ancestor.col_GENERATION ||
                             ', ID = ' || ancestor.col_ID ||
                             ', Name = ' || ancestor.col_NAME ||
                             ', Sex = ' || ancestor.col_SEX ||
                             ', Father ID = ' || NVL(TO_CHAR(ancestor.col_FATHER), 'NONE') ||
                             ', Mother ID = ' || NVL(TO_CHAR(ancestor.col_MOTHER), 'NONE') ||' }');
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('----------------------------------------------------------------------------------------');

END;

------------------------------------------------------------------------------------------------------------------------

/*
Test Block for Procedure proc_GetLineage:

This PL/SQL block is designed to test the `proc_GetLineage` procedure.

It executes the procedure with various combinations of otter names and lineage types,
and handles any exceptions that might occur.

Test Combinations:
- Otter Name: 'Iason', Lineage Types: 'MALE', 'FEMALE', 'BOTH'
- Otter Name: 'Zoran', Lineage Type: 'BOTH'
- Otter Name: 'Celestyn', Lineage Type: 'BOTH'

Procedure:
1. Calls `proc_GetLineage` for each test combination.
2. Captures and outputs any exceptions that occur during the execution.
*/
DECLARE
    var_test_otter_names SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST('Iason', 'Zoran', 'Celestyn');
    var_test_lineage_types SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST('MALE', 'FEMALE', 'BOTH');

BEGIN
    BEGIN
        proc_GetLineage(var_test_otter_names(1), var_test_lineage_types(1));

        EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Test Failed: ' || SQLERRM || ' Error code: ' || SQLCODE || '.');
    END;

    ----

    BEGIN
        proc_GetLineage(var_test_otter_names(1), var_test_lineage_types(2));

        EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Test Failed: ' || SQLERRM || ' Error code: ' || SQLCODE || '.');
    END;

    ----

    BEGIN
        proc_GetLineage(var_test_otter_names(1), var_test_lineage_types(3));

        EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Test Failed: ' || SQLERRM || ' Error code: ' || SQLCODE || '.');
    END;

    ----

    BEGIN
        proc_GetLineage(var_test_otter_names(2), var_test_lineage_types(3));

        EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Test Failed: ' || SQLERRM || ' Error code: ' || SQLCODE || '.');
    END;

    ----

    BEGIN
        proc_GetLineage(var_test_otter_names(3), var_test_lineage_types(3));

        EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Test Failed: ' || SQLERRM || ' Error code: ' || SQLCODE || '.');
    END;

END;


------------------------------------------------------------------------------------------------------------------------