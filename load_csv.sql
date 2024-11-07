-- Load all of the csv files into the database
\cd :scriptdir

\set csvfile :scriptdir'/csv/customers.csv'

COPY customers(customer_id, first_name, last_name, phone, email, street, city, "state", zip_code)
FROM :'csvfile'
DELIMITER ','
CSV HEADER
NULL AS 'NULL';