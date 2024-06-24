------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

/*
Query to analyze client stats with sorting:

This SQL query analyzes client and payment statistics, including the total and average cost of services,
the number of different payment types used, and the number of services provided for each client.
The results are sorted by client's first name, last name, and the count of different payment types.

Data Analysis:
- The query joins the tbl_CLIENT, tbl_SERVICE, and tbl_PAYMENT tables.
- Groups the results by client's first and last names and calculates COUNT, SUM, AVG, and distinct payment types.

Query Components:
- First name (first_name): The first name of the client.
- Last name (last_name): The last name of the client.
- Service count (total_service_count): The count of services provided to each client.
- Total cost (total_service_cost): The total cost of services for each client.
- Average cost (average_service_cost): The average cost of services for each client, rounded to 2 decimal places.
- Distinct payment types (distinct_payment_types): The count of different payment types used by each client.

Sorting:
- The results are sorted by client's first name, last name, and the count of different payment types.
*/
SELECT
    client.col_first_name AS first_name,
    client.col_last_name AS last_name,
    COUNT(service.col_id) AS total_service_count,
    SUM(service.col_cost) AS total_service_cost,
    ROUND(AVG(service.col_cost), 2) AS average_service_cost,
    COUNT(DISTINCT payment.col_type) AS distinct_payment_types
FROM tbl_CLIENT client
JOIN tbl_SERVICE service ON client.col_id = service.col_client_id
JOIN tbl_PAYMENT payment ON service.col_payment_id = payment.col_id
GROUP BY client.col_first_name, client.col_last_name
ORDER BY first_name, last_name, distinct_payment_types;

------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
