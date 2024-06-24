------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

/*
PL/SQL Block to Fill Tables with Random Data:

This PL/SQL block is designed to populate the `tbl_CLIENT`, `tbl_PAYMENT`, and `tbl_SERVICE` tables
with a specified number of random records. It calls three stored procedures to fill each table:
`proc_FillClientTable`, `proc_FillPaymentTable`, and `proc_FillServiceTable`.

Parameters:
- `с_CLIENT_COUNT`: Number of client records to be generated and inserted into the `tbl_CLIENT` table.
- `c_PAYMENT_COUNT`: Number of payment records to be generated and inserted into the `tbl_PAYMENT` table.
- `c_SERVICE_COUNT`: Number of service records to be generated and inserted into the `tbl_SERVICE` table.

Data Generation:
- The procedures generate random data for each column based on predefined rules and constraints.
- `proc_FillClientTable` generates random client records.
- `proc_FillPaymentTable` generates random payment records.
- `proc_FillServiceTable` generates random service records, linking clients and payments.
*/
DECLARE
    с_CLIENT_COUNT PLS_INTEGER := 50;
    c_PAYMENT_COUNT PLS_INTEGER := 100;
    c_SERVICE_COUNT PLS_INTEGER := 150;
BEGIN
    proc_FillClientTable(с_CLIENT_COUNT);
    proc_FillPaymentTable(c_PAYMENT_COUNT);
    proc_FillServiceTable(c_SERVICE_COUNT);
END;

------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
