------------------------------------------------------------------------------------------------------------------------


CREATE OR REPLACE PACKAGE pkg_iFix_management AUTHID DEFINER
AS

    --------------------------------------------------------------------------------------------------------------------

    c_STANDARD_SERVICE_LIMIT CONSTANT PLS_INTEGER := 5;
    c_GOLD_SERVICE_LIMIT CONSTANT PLS_INTEGER := 10;
    c_PLATINUM_SERVICE_LIMIT CONSTANT PLS_INTEGER := 15;

    ----

    c_GOLD_SERVICE_THRESHOLD CONSTANT PLS_INTEGER := 10;
    c_PLATINUM_SERVICE_THRESHOLD CONSTANT PLS_INTEGER := 30;

    ----

    c_ERR_CLIENT_NOT_FOUND CONSTANT PLS_INTEGER := -20001;
    c_ERR_PAYMENT_NOT_FOUND CONSTANT PLS_INTEGER := -20002;
    c_ERR_SERVICE_NOT_FOUND CONSTANT PLS_INTEGER := -20003;
    c_ERR_SERVICE_LIMIT_EXCEEDED CONSTANT PLS_INTEGER := -20011;

    --------------------------------------------------------------------------------------------------------------------

    PROCEDURE proc_AddClient(par_first_name IN VARCHAR2,
                             par_last_name IN VARCHAR2,
                             par_phone IN VARCHAR2,
                             par_email IN VARCHAR2);

    ----

    PROCEDURE proc_UpdateClient(par_id IN NUMBER,
                                par_new_first_name IN VARCHAR2 DEFAULT NULL,
                                par_new_last_name IN VARCHAR2 DEFAULT NULL,
                                par_new_phone IN VARCHAR2 DEFAULT NULL,
                                par_new_email IN VARCHAR2 DEFAULT NULL);

    ----

    PROCEDURE proc_DeleteClient(par_id IN NUMBER);

    --------------------------------------------------------------------------------------------------------------------

    PROCEDURE proc_AddPayment(par_type IN VARCHAR2,
                              par_is_printed_invoice IN CHAR);

    ----

    PROCEDURE proc_UpdatePayment(par_id IN NUMBER,
                                 par_new_type IN VARCHAR2 DEFAULT NULL,
                                 par_new_is_printed_invoice IN CHAR DEFAULT NULL);

    ----

    PROCEDURE proc_DeletePayment(par_id IN NUMBER);

    --------------------------------------------------------------------------------------------------------------------

    PROCEDURE proc_AddService(par_client_id IN NUMBER,
                              par_payment_id IN NUMBER,
                              par_cost IN NUMBER,
                              par_datetime IN TIMESTAMP);

    ----

    PROCEDURE proc_UpdateService(par_id IN NUMBER,
                                 par_new_cost IN NUMBER DEFAULT NULL);

    ----

    PROCEDURE proc_DeleteService(par_id IN NUMBER);

    --------------------------------------------------------------------------------------------------------------------

END pkg_iFix_management;


------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------


CREATE OR REPLACE PACKAGE BODY pkg_iFix_management
AS

    --------------------------------------------------------------------------------------------------------------------

    FUNCTION func_ExistsClient(par_id IN NUMBER) RETURN BOOLEAN
    IS
        var_client_count PLS_INTEGER;
    BEGIN
        SELECT COUNT(*) INTO var_client_count FROM tbl_CLIENT WHERE col_id = par_id;

        RETURN (var_client_count > 0);
    END func_ExistsClient;

    ----

    FUNCTION func_ExistsPayment(par_id IN NUMBER) RETURN BOOLEAN
    IS
        var_payment_count PLS_INTEGER;
    BEGIN
        SELECT COUNT(*) INTO var_payment_count FROM tbl_PAYMENT WHERE col_id = par_id;

        RETURN (var_payment_count > 0);
    END func_ExistsPayment;

    ----

    FUNCTION func_ExistsService(par_id IN NUMBER) RETURN BOOLEAN
    IS
        var_service_count PLS_INTEGER;
    BEGIN
        SELECT COUNT(*) INTO var_service_count FROM tbl_SERVICE WHERE col_id = par_id;

        RETURN (var_service_count > 0);
    END func_ExistsService;

    ----

    FUNCTION func_CheckServiceLimit(par_client_id IN NUMBER,
                                    par_datetime IN TIMESTAMP) RETURN BOOLEAN
    IS
        var_privilege_type tbl_CLIENT.col_privilege_type%TYPE;
        var_month_service_count PLS_INTEGER;
        var_month_limit PLS_INTEGER;
        var_month_first_day TIMESTAMP;
        var_next_month_first_day TIMESTAMP;
    BEGIN
        SELECT col_privilege_type INTO var_privilege_type FROM tbl_CLIENT WHERE col_id = par_client_id;

        var_month_first_day := TRUNC(par_datetime, 'MM');
        var_next_month_first_day := ADD_MONTHS(var_month_first_day, 1);
        SELECT COUNT(*) INTO var_month_service_count FROM tbl_SERVICE
            WHERE col_client_id = par_client_id AND
                  col_datetime >= var_month_first_day AND col_datetime < var_next_month_first_day;

        CASE var_privilege_type
            WHEN 'Standard' THEN var_month_limit := c_STANDARD_SERVICE_LIMIT;
            WHEN 'Gold' THEN var_month_limit := c_GOLD_SERVICE_LIMIT;
            WHEN 'Platinum' THEN var_month_limit := c_PLATINUM_SERVICE_LIMIT;
            ELSE var_month_limit := c_STANDARD_SERVICE_LIMIT;
        END CASE;

        RETURN var_month_service_count < var_month_limit;
    END func_CheckServiceLimit;

    --------------------------------------------------------------------------------------------------------------------

    PROCEDURE proc_AddClient(par_first_name IN VARCHAR2,
                             par_last_name IN VARCHAR2,
                             par_phone IN VARCHAR2,
                             par_email IN VARCHAR2)
    IS
    BEGIN
        INSERT INTO tbl_CLIENT (col_first_name, col_last_name, col_phone, col_email)
            VALUES (par_first_name, par_last_name, par_phone, par_email);

        COMMIT;

        DBMS_OUTPUT.PUT_LINE('Client successfully added:' ||
                             ' {first name: ' || par_first_name ||
                             ', last name: ' || par_last_name ||
                             ', phone: ' || par_phone ||
                             ', email: ' || par_email || '}!');

        EXCEPTION
            WHEN OTHERS THEN
                ROLLBACK;
                RAISE;
    END proc_AddClient;

    ----

    PROCEDURE proc_UpdateClient(par_id IN NUMBER,
                                par_new_first_name IN VARCHAR2 DEFAULT NULL,
                                par_new_last_name IN VARCHAR2 DEFAULT NULL,
                                par_new_phone IN VARCHAR2 DEFAULT NULL,
                                par_new_email IN VARCHAR2 DEFAULT NULL)
    IS
        var_exists_client BOOLEAN;
    BEGIN
        var_exists_client := func_ExistsClient(par_id);
        IF NOT var_exists_client THEN
            RAISE_APPLICATION_ERROR(c_ERR_CLIENT_NOT_FOUND, 'No client found with: {id: ' || par_id || '}.');
        END IF;

        UPDATE tbl_CLIENT SET col_first_name = COALESCE(par_new_first_name, col_first_name),
            col_last_name = COALESCE(par_new_last_name, col_last_name),
                col_phone = COALESCE(par_new_phone, col_phone), col_email = COALESCE(par_new_email, col_email)
                    WHERE col_id = par_id;

        COMMIT;

        DBMS_OUTPUT.PUT_LINE('Client successfully updated with: {id: ' || par_id || '}!');

    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE;
    END proc_UpdateClient;

    ----

    PROCEDURE proc_DeleteClient(par_id IN NUMBER)
    IS
        var_exists_client BOOLEAN;
    BEGIN
        var_exists_client := func_ExistsClient(par_id);
        IF NOT var_exists_client THEN
            RAISE_APPLICATION_ERROR(c_ERR_CLIENT_NOT_FOUND, 'No client found with: {id: ' || par_id || '}.');
        END IF;

        DELETE FROM tbl_SERVICE WHERE col_client_id = par_id;
        DELETE FROM tbl_CLIENT WHERE col_id = par_id;

        COMMIT;

        DBMS_OUTPUT.PUT_LINE('Client (and associated services) successfully deleted with: {id: ' || par_id || '}!');

        EXCEPTION
            WHEN OTHERS THEN
                ROLLBACK;
                RAISE;
    END proc_DeleteClient;

    --------------------------------------------------------------------------------------------------------------------

    PROCEDURE proc_AddPayment(par_type IN VARCHAR2,
                              par_is_printed_invoice IN CHAR)
    IS
    BEGIN
        INSERT INTO tbl_PAYMENT (col_type, col_is_printed_invoice)
            VALUES (par_type, par_is_printed_invoice);

        COMMIT;

        DBMS_OUTPUT.PUT_LINE('Payment successfully added:' ||
                             ' {type: ' || par_type ||
                             ', is printed invoice: ' || par_is_printed_invoice || '}!');

        EXCEPTION
            WHEN OTHERS THEN
                ROLLBACK;
                RAISE;
    END proc_AddPayment;

    ----

    PROCEDURE proc_UpdatePayment(par_id IN NUMBER,
                                 par_new_type IN VARCHAR2 DEFAULT NULL,
                                 par_new_is_printed_invoice IN CHAR DEFAULT NULL)
    IS
        var_exists_payment BOOLEAN;
    BEGIN
        var_exists_payment := func_ExistsPayment(par_id);
        IF NOT var_exists_payment THEN
            RAISE_APPLICATION_ERROR(c_ERR_PAYMENT_NOT_FOUND, 'No payment found with: {id: ' || par_id || '}.');
        END IF;

        UPDATE tbl_PAYMENT SET col_type = COALESCE(par_new_type, col_type),
            col_is_printed_invoice = COALESCE(par_new_is_printed_invoice, col_is_printed_invoice)
                WHERE col_id = par_id;

        COMMIT;

        DBMS_OUTPUT.PUT_LINE('Payment successfully updated with: {id: ' || par_id || '}!');

        EXCEPTION
            WHEN OTHERS THEN
                ROLLBACK;
                RAISE;
    END proc_UpdatePayment;

    ----

    PROCEDURE proc_DeletePayment(par_id IN NUMBER)
    IS
        var_exists_payment BOOLEAN;
        CURSOR var_clients IS SELECT col_client_id FROM tbl_SERVICE WHERE col_payment_id = par_id GROUP BY col_client_id;
        var_current_client_id tbl_SERVICE.col_client_id%TYPE;
        var_current_privilege_type tbl_CLIENT.col_privilege_type%TYPE;
        var_current_service_count NUMBER;
    BEGIN
        var_exists_payment := func_ExistsPayment(par_id);
        IF NOT var_exists_payment THEN
            RAISE_APPLICATION_ERROR(c_ERR_PAYMENT_NOT_FOUND, 'No payment found with: {id: ' || par_id || '}.');
        END IF;

        DELETE FROM tbl_SERVICE WHERE col_payment_id = par_id;
        DELETE FROM tbl_PAYMENT WHERE col_id = par_id;

        FOR var_client IN var_clients LOOP
            var_current_client_id := var_client.col_client_id;

            SELECT COUNT(*) INTO var_current_service_count FROM tbl_SERVICE
                WHERE col_client_id = var_current_client_id;
            SELECT col_privilege_type INTO var_current_privilege_type FROM tbl_CLIENT
                WHERE col_id = var_current_client_id;
            UPDATE tbl_CLIENT SET col_service_count = var_current_service_count WHERE col_id = var_current_client_id;

            IF var_current_service_count < c_GOLD_SERVICE_THRESHOLD AND var_current_privilege_type = 'Gold' THEN
                UPDATE tbl_CLIENT SET col_privilege_type = 'Standard' WHERE col_id = var_client.col_client_id;
            ELSIF var_current_service_count < c_PLATINUM_SERVICE_THRESHOLD AND var_current_privilege_type = 'Platinum'
                THEN UPDATE tbl_CLIENT SET col_privilege_type = 'Gold' WHERE col_id = var_client.col_client_id;
            END IF;
        END LOOP;

        COMMIT;

        DBMS_OUTPUT.PUT_LINE('Payment (and associated services) successfully deleted with: {id: ' || par_id || '}!');

        EXCEPTION
            WHEN OTHERS THEN
                ROLLBACK;
                RAISE;
    END proc_DeletePayment;

    --------------------------------------------------------------------------------------------------------------------

    PROCEDURE proc_AddService(par_client_id IN NUMBER,
                              par_payment_id IN NUMBER,
                              par_cost IN NUMBER,
                              par_datetime IN TIMESTAMP)
    IS
        var_exists_client BOOLEAN;
        var_exists_payment BOOLEAN;
        var_can_add_service BOOLEAN;
        var_current_service_count tbl_CLIENT.col_service_count%TYPE;
        var_current_privilege_type tbl_CLIENT.col_privilege_type%TYPE;
    BEGIN
        var_exists_client := func_ExistsClient(par_client_id);
        IF NOT var_exists_client THEN
            RAISE_APPLICATION_ERROR(c_ERR_CLIENT_NOT_FOUND, 'No client found with: {id: ' || par_client_id || '}.');
        END IF;

        var_exists_payment := func_ExistsPayment(par_payment_id);
        IF NOT var_exists_payment THEN
            RAISE_APPLICATION_ERROR(c_ERR_PAYMENT_NOT_FOUND, 'No payment found with: {id: ' || par_payment_id || '}.');
        END IF;

        var_can_add_service := func_CheckServiceLimit(par_client_id, par_datetime);
        IF NOT var_can_add_service THEN
            RAISE_APPLICATION_ERROR(c_ERR_SERVICE_LIMIT_EXCEEDED,
                                    'Service limit exceeded for client with: {id: ' || par_client_id || '}.');
        END IF;

        INSERT INTO tbl_SERVICE (col_client_id, col_payment_id, col_cost, col_datetime)
            VALUES (par_client_id, par_payment_id, par_cost, par_datetime);

        DBMS_OUTPUT.PUT_LINE('Service successfully added:' ||
                             ' {client id: ' || par_client_id ||
                             ', payment id: ' || par_payment_id ||
                             ', cost: ' || par_cost ||
                             ', datetime: ' || par_datetime || '}!');

        UPDATE tbl_CLIENT SET col_service_count = col_service_count + 1 WHERE col_id = par_client_id;

        SELECT col_service_count, col_privilege_type INTO var_current_service_count, var_current_privilege_type
            FROM tbl_CLIENT WHERE col_id = par_client_id;
        IF var_current_service_count >= c_GOLD_SERVICE_THRESHOLD AND var_current_privilege_type = 'Standard' THEN
            UPDATE tbl_CLIENT SET col_privilege_type = 'Gold' WHERE col_id = par_client_id;
        ELSIF var_current_service_count >= c_PLATINUM_SERVICE_THRESHOLD AND var_current_privilege_type = 'Gold' THEN
            UPDATE tbl_CLIENT SET col_privilege_type = 'Platinum' WHERE col_id = par_client_id;
        END IF;

        COMMIT;

        EXCEPTION
            WHEN OTHERS THEN
                ROLLBACK;
                RAISE;
    END proc_AddService;

    ----

    PROCEDURE proc_UpdateService(par_id IN NUMBER,
                                 par_new_cost IN NUMBER DEFAULT NULL)
    IS
        var_service_exists BOOLEAN;
    BEGIN
        var_service_exists := func_ExistsService(par_id);
        IF NOT var_service_exists THEN
            RAISE_APPLICATION_ERROR(c_ERR_SERVICE_NOT_FOUND, 'No service found with: {id: ' || par_id || '}.');
        END IF;

        UPDATE tbl_SERVICE SET col_cost = COALESCE(par_new_cost, col_cost) WHERE col_id = par_id;

        COMMIT;

        DBMS_OUTPUT.PUT_LINE('Service successfully updated with: {id: ' || par_id || '}!');

        EXCEPTION
            WHEN OTHERS THEN
                ROLLBACK;
                RAISE;
    END proc_UpdateService;

    ----

    PROCEDURE proc_DeleteService(par_id IN NUMBER) IS
        var_exists_service BOOLEAN;
        var_client_id tbl_SERVICE.col_client_id%TYPE;
        var_current_service_count tbl_CLIENT.col_service_count%TYPE;
        var_current_privilege_type tbl_CLIENT.col_privilege_type%TYPE;
    BEGIN
        var_exists_service := func_ExistsService(par_id);
        IF NOT var_exists_service THEN
            RAISE_APPLICATION_ERROR(c_ERR_SERVICE_NOT_FOUND, 'No service found with: {id: ' || par_id || '}.');
        END IF;

        SELECT col_client_id INTO var_client_id FROM tbl_SERVICE WHERE col_id = par_id;

        DELETE FROM tbl_SERVICE WHERE col_id = par_id;
        UPDATE tbl_CLIENT SET col_service_count = col_service_count - 1 WHERE col_id = var_client_id;

        SELECT col_service_count, col_privilege_type INTO var_current_service_count, var_current_privilege_type
            FROM tbl_CLIENT WHERE col_id = var_client_id;

        IF var_current_service_count < c_GOLD_SERVICE_THRESHOLD AND var_current_privilege_type = 'Gold' THEN
            UPDATE tbl_CLIENT SET col_privilege_type = 'Standard' WHERE col_id = var_client_id;
        ELSIF var_current_service_count < c_PLATINUM_SERVICE_THRESHOLD AND var_current_privilege_type = 'Platinum' THEN
            UPDATE tbl_CLIENT SET col_privilege_type = 'Gold' WHERE col_id = var_client_id;
        END IF;

        COMMIT;

        DBMS_OUTPUT.PUT_LINE('Service successfully deleted with: {id: ' || par_id || '}!');

    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE;
    END proc_DeleteService;

    --------------------------------------------------------------------------------------------------------------------

END pkg_iFix_management;


------------------------------------------------------------------------------------------------------------------------