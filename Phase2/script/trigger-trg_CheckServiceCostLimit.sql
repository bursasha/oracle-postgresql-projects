------------------------------------------------------------------------------------------------------------------------


CREATE OR REPLACE TRIGGER trg_CheckServiceCostLimit BEFORE INSERT ON tbl_SERVICE FOR EACH ROW
DECLARE
    var_privilege_type VARCHAR2(10);
    var_month_service_cost NUMBER;
    var_month_service_cost_limit NUMBER;
    var_month_first_day TIMESTAMP;
    var_next_month_first_day TIMESTAMP;
BEGIN
    var_month_first_day := TRUNC(:NEW.col_datetime, 'MM');
    var_next_month_first_day := ADD_MONTHS(var_month_first_day, 1);

    SELECT col_privilege_type INTO var_privilege_type FROM tbl_CLIENT WHERE col_id = :NEW.col_client_id;

    CASE var_privilege_type
        WHEN 'Standard' THEN var_month_service_cost_limit := 500;
        WHEN 'Gold' THEN var_month_service_cost_limit := 1500;
        WHEN 'Platinum' THEN var_month_service_cost_limit := 2500;
        ELSE var_month_service_cost_limit := 500;
    END CASE;

    SELECT SUM(col_cost) INTO var_month_service_cost FROM tbl_SERVICE
        WHERE col_client_id = :NEW.col_client_id AND
              col_datetime >= var_month_first_day AND col_datetime < var_next_month_first_day;

    IF var_month_service_cost + :NEW.col_cost > var_month_service_cost_limit THEN
        RAISE_APPLICATION_ERROR(-20021, 'Service cost limit exceeded for client with: {id: ' ||
                                        :NEW.col_client_id || '}.');
    END IF;
END;


------------------------------------------------------------------------------------------------------------------------