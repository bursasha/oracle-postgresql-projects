------------------------------------------------------------------------------------------------------------------------


BEGIN
    pkg_iFix_management.proc_AddClient('John', 'Doe',
                            '1234567890', 'johndoe@example.com');
    pkg_iFix_management.proc_AddClient('Jane', 'Doe',
                            '1234567891', 'janedoe@example.com');
    pkg_iFix_management.proc_AddClient('Jim', 'Beam',
                            '1234567892', 'jimbeam@example.com');
    pkg_iFix_management.proc_AddClient('Jack', 'Daniels',
                            '1234567893', 'jackdaniels@example.com');
    pkg_iFix_management.proc_AddClient('Jill', 'Valentine',
                            '1234567894', 'jillv@example.com');

    DBMS_OUTPUT.PUT_LINE('Test 1.a Passed: Clients added successfully!');

    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Test 1.a Failed: ' || SQLERRM || ' Error code: ' || SQLCODE || '.');
END;

----

BEGIN
    pkg_iFix_management.proc_AddClient('JohnJohnJohnJohn', 'DoeDoeDoeDoeDoeDoe',
                            '12345678901234567890', 'johndoe@example.com');

    DBMS_OUTPUT.PUT_LINE('Test 1.b Passed: Client added successfully!');

    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Test 1.b Failed: ' || SQLERRM || ' Error code: ' || SQLCODE || '.');
END;

------------------------------------------------------------------------------------------------------------------------

BEGIN
    pkg_iFix_management.proc_UpdateClient(par_id => 1, par_new_first_name => 'UpdatedJohn');
    pkg_iFix_management.proc_UpdateClient(par_id => 2, par_new_last_name => 'UpdatedDoe');
    pkg_iFix_management.proc_UpdateClient(par_id => 3, par_new_phone => '999999999');
    pkg_iFix_management.proc_UpdateClient(par_id => 4, par_new_email => 'updatedjackdaniels@example.com');
    pkg_iFix_management.proc_UpdateClient(par_id => 5, par_new_first_name => 'UpdatedJill',
                                          par_new_last_name => 'UpdatedVal');

    DBMS_OUTPUT.PUT_LINE('Test 2.a Passed: Clients updated successfully!');

    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Test 2.a Failed: ' || SQLERRM || ' Error code: ' || SQLCODE || '.');
END;

----

BEGIN
    pkg_iFix_management.proc_UpdateClient(par_id => 6, par_new_first_name => 'Updated');

    DBMS_OUTPUT.PUT_LINE('Test 2.b Passed: Client updated successfully!');

    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Test 2.b Failed: ' || SQLERRM || ' Error code: ' || SQLCODE || '.');
END;

------------------------------------------------------------------------------------------------------------------------

BEGIN
    pkg_iFix_management.proc_AddClient('Holly', 'Molly',
                            '987654321', 'hollymolly@example.com');
    pkg_iFix_management.proc_DeleteClient(7);

    DBMS_OUTPUT.PUT_LINE('Test 3.a Passed: Client added and deleted successfully!');

    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Test 3.a Failed: ' || SQLERRM || ' Error code: ' || SQLCODE || '.');
END;

----

BEGIN
    pkg_iFix_management.proc_DeleteClient(100);

    DBMS_OUTPUT.PUT_LINE('Test 3.b Passed: Client deleted successfully!');

    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Test 3.b Failed: ' || SQLERRM || ' Error code: ' || SQLCODE || '.');
END;


------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------


BEGIN
    pkg_iFix_management.proc_AddPayment('Bank transfer', 'Y');
    pkg_iFix_management.proc_AddPayment('Cash', 'N');
    pkg_iFix_management.proc_AddPayment('Card', 'Y');

    DBMS_OUTPUT.PUT_LINE('Test 4.a Passed: payments added successfully!');

    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Test 4.a Failed: ' || SQLERRM || ' Error code: ' || SQLCODE || '.');
END;

----

BEGIN
    pkg_iFix_management.proc_AddPayment('Paypal', '?');

    DBMS_OUTPUT.PUT_LINE('Test 4.b Passed: payment added successfully!');

    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Test 4.b Failed: ' || SQLERRM || ' Error code: ' || SQLCODE || '.');
END;

------------------------------------------------------------------------------------------------------------------------

BEGIN
    pkg_iFix_management.proc_UpdatePayment(par_id => 1, par_new_type => 'Cash');
    pkg_iFix_management.proc_UpdatePayment(par_id => 2, par_new_is_printed_invoice => 'Y');
    pkg_iFix_management.proc_UpdatePayment(par_id => 3, par_new_type => 'Bank transfer',
                                           par_new_is_printed_invoice => 'N');

    DBMS_OUTPUT.PUT_LINE('Test 5.a Passed: payments updated successfully!');

    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Test 5.a Failed: ' || SQLERRM || ' Error code: ' || SQLCODE || '.');
END;

----

BEGIN
    pkg_iFix_management.proc_UpdatePayment(par_id => 4, par_new_type => 'Card');

    DBMS_OUTPUT.PUT_LINE('Test 5.b Passed: payment updated successfully!');

    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Test 5.b Failed: ' || SQLERRM || ' Error code: ' || SQLCODE || '.');
END;

------------------------------------------------------------------------------------------------------------------------

BEGIN
    pkg_iFix_management.proc_AddPayment('Cash', 'N');
    pkg_iFix_management.proc_DeletePayment(5);

    DBMS_OUTPUT.PUT_LINE('Test 6.a Passed: payment created and deleted successfully!');

    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Test 6.a Failed: ' || SQLERRM || ' Error code: ' || SQLCODE || '.');
END;

----

BEGIN
    pkg_iFix_management.proc_DeletePayment(100);

    DBMS_OUTPUT.PUT_LINE('Test 6.b Passed: payment deleted successfully!');

    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Test 6.b Failed: ' || SQLERRM || ' Error code: ' || SQLCODE || '.');
END;


------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------


BEGIN
    pkg_iFix_management.proc_AddService(1, 1, 150,
                           TO_TIMESTAMP('2023-01-15 10:00:00', 'YYYY-MM-DD HH24:MI:SS'));
    pkg_iFix_management.proc_AddService(1, 1, 160,
                           TO_TIMESTAMP('2023-01-15 11:00:00', 'YYYY-MM-DD HH24:MI:SS'));
    pkg_iFix_management.proc_AddService(1, 1, 170,
                           TO_TIMESTAMP('2023-01-15 12:00:00', 'YYYY-MM-DD HH24:MI:SS'));
    pkg_iFix_management.proc_AddService(1, 1, 180,
                           TO_TIMESTAMP('2023-01-15 13:00:00', 'YYYY-MM-DD HH24:MI:SS'));
    pkg_iFix_management.proc_AddService(1, 1, 190,
                           TO_TIMESTAMP('2023-01-15 14:00:00', 'YYYY-MM-DD HH24:MI:SS'));

    pkg_iFix_management.proc_AddService(2, 2, 100,
                           TO_TIMESTAMP('2023-02-01 10:00:00', 'YYYY-MM-DD HH24:MI:SS'));
    pkg_iFix_management.proc_AddService(2, 2, 110,
                           TO_TIMESTAMP('2023-02-02 10:00:00', 'YYYY-MM-DD HH24:MI:SS'));
    pkg_iFix_management.proc_AddService(2, 2, 120,
                           TO_TIMESTAMP('2023-02-03 10:00:00', 'YYYY-MM-DD HH24:MI:SS'));
    pkg_iFix_management.proc_AddService(2, 2, 130,
                           TO_TIMESTAMP('2023-02-04 10:00:00', 'YYYY-MM-DD HH24:MI:SS'));
    pkg_iFix_management.proc_AddService(2, 2, 140,
                           TO_TIMESTAMP('2023-02-05 10:00:00', 'YYYY-MM-DD HH24:MI:SS'));
    pkg_iFix_management.proc_AddService(2, 2, 200,
                           TO_TIMESTAMP('2023-04-01 10:00:00', 'YYYY-MM-DD HH24:MI:SS'));
    pkg_iFix_management.proc_AddService(2, 2, 210,
                           TO_TIMESTAMP('2023-04-02 10:00:00', 'YYYY-MM-DD HH24:MI:SS'));
    pkg_iFix_management.proc_AddService(2, 2, 220,
                           TO_TIMESTAMP('2023-04-03 10:00:00', 'YYYY-MM-DD HH24:MI:SS'));
    pkg_iFix_management.proc_AddService(2, 2, 230,
                           TO_TIMESTAMP('2023-04-04 10:00:00', 'YYYY-MM-DD HH24:MI:SS'));
    pkg_iFix_management.proc_AddService(2, 2, 240,
                           TO_TIMESTAMP('2023-04-05 10:00:00', 'YYYY-MM-DD HH24:MI:SS'));
    pkg_iFix_management.proc_AddService(2, 2, 300,
                           TO_TIMESTAMP('2023-06-01 10:00:00', 'YYYY-MM-DD HH24:MI:SS'));

    DBMS_OUTPUT.PUT_LINE('Test 7.a Passed: services added successfully!');

    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Test 7.a Failed: ' || SQLERRM || ' Error code: ' || SQLCODE || '.');
END;

----

BEGIN
    pkg_iFix_management.proc_AddService(1, 1, 200,
                           TO_TIMESTAMP('2023-01-15 15:00:00', 'YYYY-MM-DD HH24:MI:SS'));

    DBMS_OUTPUT.PUT_LINE('Test 7.b Passed: service added successfully!');

    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Test 7.b Failed: ' || SQLERRM || ' Error code: ' || SQLCODE || '.');
END;

------------------------------------------------------------------------------------------------------------------------

BEGIN
    pkg_iFix_management.proc_UpdateService(par_id => 1, par_new_cost => 151);
    pkg_iFix_management.proc_UpdateService(par_id => 2, par_new_cost => 161);
    pkg_iFix_management.proc_UpdateService(par_id => 3, par_new_cost => 171);

    DBMS_OUTPUT.PUT_LINE('Test 8.a Passed: services updated successfully!');

    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Test 8.a Failed: ' || SQLERRM || ' Error code: ' || SQLCODE || '.');
END;

----

BEGIN
    pkg_iFix_management.proc_UpdateService(par_id => 100, par_new_cost => 100);

    DBMS_OUTPUT.PUT_LINE('Test 8.b Passed: payment updated successfully!');

    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Test 8.b Failed: ' || SQLERRM || ' Error code: ' || SQLCODE || '.');
END;

------------------------------------------------------------------------------------------------------------------------

BEGIN
    pkg_iFix_management.proc_AddService(3, 3, 1000,
                           TO_TIMESTAMP('2023-05-11 11:00:00', 'YYYY-MM-DD HH24:MI:SS'));
    pkg_iFix_management.proc_AddService(3, 3, 1100,
                           TO_TIMESTAMP('2023-05-11 12:00:00', 'YYYY-MM-DD HH24:MI:SS'));
    pkg_iFix_management.proc_AddService(3, 3, 1200,
                           TO_TIMESTAMP('2023-05-11 13:00:00', 'YYYY-MM-DD HH24:MI:SS'));
    pkg_iFix_management.proc_AddService(3, 3, 1300,
                           TO_TIMESTAMP('2023-05-11 14:00:00', 'YYYY-MM-DD HH24:MI:SS'));
    pkg_iFix_management.proc_AddService(3, 3, 1400,
                           TO_TIMESTAMP('2023-05-11 15:00:00', 'YYYY-MM-DD HH24:MI:SS'));
    pkg_iFix_management.proc_AddService(3, 3, 1000,
                           TO_TIMESTAMP('2023-07-11 11:00:00', 'YYYY-MM-DD HH24:MI:SS'));
    pkg_iFix_management.proc_AddService(3, 3, 1100,
                           TO_TIMESTAMP('2023-07-11 12:00:00', 'YYYY-MM-DD HH24:MI:SS'));
    pkg_iFix_management.proc_AddService(3, 3, 1200,
                           TO_TIMESTAMP('2023-07-11 13:00:00', 'YYYY-MM-DD HH24:MI:SS'));
    pkg_iFix_management.proc_AddService(3, 3, 1300,
                           TO_TIMESTAMP('2023-07-11 14:00:00', 'YYYY-MM-DD HH24:MI:SS'));
    pkg_iFix_management.proc_AddService(3, 3, 1400,
                           TO_TIMESTAMP('2023-07-11 15:00:00', 'YYYY-MM-DD HH24:MI:SS'));
    pkg_iFix_management.proc_DeleteService(26);

    DBMS_OUTPUT.PUT_LINE('Test 9.a Passed: services created and deleted successfully!');

    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Test 9.a Failed: ' || SQLERRM || ' Error code: ' || SQLCODE || '.');
END;

----

BEGIN
    pkg_iFix_management.proc_DeleteService(100);

    DBMS_OUTPUT.PUT_LINE('Test 9.b Passed: service deleted successfully!');

    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Test 9.b Failed: ' || SQLERRM || ' Error code: ' || SQLCODE || '.');
END;


------------------------------------------------------------------------------------------------------------------------