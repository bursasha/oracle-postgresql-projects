------------------------------------------------------------------------------------------------------------------------

/*
Program to Trace Otter Lineages:

This PL/SQL program traces the lineages of otters in a wildlife reserve database.
It uses recursive queries to navigate through the 'VYDRA' table, which contains otter records linked to their parents.

Parameters:
- var_chosen_otter_id (VYDRA.CV%TYPE): The ID of the otter for which the lineage is traced.

Program Logic:
- It first outputs the male lineage of the chosen otter, followed by the female lineage,
  and finally a general lineage including both male and female ancestors.
- Each lineage traces back through generations using recursive common table expressions (CTEs).
- The program ensures that each otter is listed only once in the general lineage,
  maintaining the hierarchical order.

Usage Example:
- To use this program, simply declare the ID of the otter whose lineage you want to trace and execute the program block.
*/
DECLARE
    var_chosen_otter_id VYDRA.CV%TYPE := 10;

BEGIN
    DBMS_OUTPUT.PUT_LINE('                          The chosen otter with ID = ' || var_chosen_otter_id);

    ----

    DBMS_OUTPUT.PUT_LINE('----------------------------------Male Lineage------------------------------------------');

    FOR male_ancestor IN (
        WITH rec_GetMaleLineage (col_GENERATION, col_ID, col_NAME, col_FATHER) AS (
            SELECT 1, CV, JMENO, OTEC FROM VYDRA WHERE CV = var_chosen_otter_id
            UNION ALL
            SELECT rgml.col_GENERATION + 1, otter.CV, otter.JMENO, otter.OTEC FROM VYDRA otter
            INNER JOIN rec_GetMaleLineage rgml ON rgml.col_FATHER = otter.CV
        )
        SELECT * FROM rec_GetMaleLineage
    )
    LOOP
        DBMS_OUTPUT.PUT_LINE('{ Generation = ' || male_ancestor.col_GENERATION ||
                             ', ID = ' || male_ancestor.col_ID ||
                             ', Name = ' || male_ancestor.col_NAME ||
                             ', Father ID = ' || NVL(TO_CHAR(male_ancestor.col_FATHER), 'NONE') || ' }');
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('----------------------------------------------------------------------------------------');

    ----

    DBMS_OUTPUT.PUT_LINE('----------------------------------Female Lineage----------------------------------------');

    FOR female_ancestor IN (
        WITH rec_GetFemaleLineage (col_GENERATION, col_ID, col_NAME, col_MOTHER) AS (
            SELECT 1, CV, JMENO, MATKA FROM VYDRA WHERE CV = var_chosen_otter_id
            UNION ALL
            SELECT rgfl.col_GENERATION + 1, otter.CV, otter.JMENO, otter.MATKA FROM VYDRA otter
            INNER JOIN rec_GetFemaleLineage rgfl ON rgfl.col_MOTHER = otter.CV
        )
        SELECT * FROM rec_GetFemaleLineage
    )
    LOOP
        DBMS_OUTPUT.PUT_LINE('{ Generation = ' || female_ancestor.col_GENERATION ||
                             ', ID = ' || female_ancestor.col_ID ||
                             ', Name = ' || female_ancestor.col_NAME ||
                             ', Mother ID = ' || NVL(TO_CHAR(female_ancestor.col_MOTHER), 'NONE') || ' }');
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('----------------------------------------------------------------------------------------');

    ----

    DBMS_OUTPUT.PUT_LINE('----------------------------------General Lineage---------------------------------------');

    FOR ancestor IN (
        SELECT DISTINCT col_GENERATION, col_ID, col_NAME, col_SEX, col_FATHER, col_MOTHER FROM (
            WITH rec_GetGeneralLineage (col_GENERATION, col_ID, col_NAME, col_SEX, col_FATHER, col_MOTHER) AS (
                SELECT 1, CV, JMENO, POHLAVI, OTEC, MATKA FROM VYDRA WHERE CV = var_chosen_otter_id
                UNION ALL
                SELECT rggl.col_GENERATION + 1, otter.CV, otter.JMENO, otter.POHLAVI, otter.OTEC, otter.MATKA
                    FROM VYDRA otter
                INNER JOIN rec_GetGeneralLineage rggl ON rggl.col_FATHER = otter.CV OR rggl.col_MOTHER = otter.CV
            )
            SELECT * FROM rec_GetGeneralLineage
        )
        ORDER BY col_GENERATION, col_ID, col_NAME
    )
    LOOP
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