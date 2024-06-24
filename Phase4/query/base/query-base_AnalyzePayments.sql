------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

/*
Query to analyze payments stats:

This SQL query analyzes payment types and their associated service costs. It calculates the total, average, and maximum
cost of services for each payment type within a specific date range.

Data Analysis:
- The query joins the tbl_PAYMENT and tbl_SERVICE tables.
- Filters services based on the col_datetime range from '2021-03-01' to '2021-06-01'.
- Groups the results by payment type and calculates SUM, AVG, and MAX of service costs.

Query Components:
- Payment type (col_type): The type of payment (e.g., 'Bank transfer', 'Cash', 'Card').
- Total cost (total_cost): The total cost of services for each payment type.
- Average cost (average_cost): The average cost of services for each payment type, rounded to 2 decimal places.
- Maximum cost (max_cost): The maximum cost of services for each payment type.
*/
SELECT
    payment.col_type AS payment_type,
    SUM(service.col_cost) AS total_cost,
    ROUND(AVG(service.col_cost), 2) AS average_cost,
    MAX(service.col_cost) AS max_cost
FROM tbl_PAYMENT payment
JOIN tbl_SERVICE service ON payment.col_id = service.col_payment_id
WHERE service.col_datetime >= TIMESTAMP '2021-03-01 00:00:00' AND service.col_datetime < TIMESTAMP '2021-06-01 00:00:00'
GROUP BY payment.col_type;

------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
