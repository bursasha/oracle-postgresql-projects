------------------------------------------------------------------------------------------------------------------------


BEGIN
    pkg_iFix_management.proc_AddClient('Ella', 'Kungs',
                            '123123123', 'ellakungs@example.com');
    pkg_iFix_management.proc_AddPayment('Card', 'Y');
    pkg_iFix_management.proc_AddService(1, 1, 100,
                           TO_TIMESTAMP('2024-03-01 10:00:00', 'YYYY-MM-DD HH24:MI:SS'));

    DBMS_OUTPUT.PUT_LINE('Test 1.a Passed: Service added within limit!');

    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Test 1.a Failed: ' || SQLERRM || ' Error code: ' || SQLCODE || '.');
END;

----

BEGIN
    pkg_iFix_management.proc_AddService(1, 1, 1000,
                           TO_TIMESTAMP('2024-03-01 10:00:00', 'YYYY-MM-DD HH24:MI:SS'));

    DBMS_OUTPUT.PUT_LINE('Test 1.b Passed: Service added successfully!');

    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Test 1.b Failed: ' || SQLERRM || ' Error code: ' || SQLCODE || '.');
END;


------------------------------------------------------------------------------------------------------------------------