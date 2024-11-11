-- If there are any tables in the database, delete them and reset the sequence
TRUNCATE TABLE order_items, orders, customers RESTART IDENTITY CASCADE;

-- Load all of the csv files into the database
\cd :scriptdir

\set csvfile :scriptdir'/csv/customers.csv'
COPY customers(customer_id, first_name, last_name, phone, email, street, city, "state", zip_code)
FROM :'csvfile'
DELIMITER ','
CSV HEADER
NULL AS 'NULL';

\set csvfile :scriptdir'/csv/orders.csv'
COPY orders(order_id, customer_id, order_status, order_date, required_date, shipped_date, store_id, staff_id)
FROM :'csvfile'
DELIMITER ','
CSV HEADER
NULL AS 'NULL';

\set csvfile :scriptdir'/csv/order_items.csv'
COPY order_items(order_id, item_id, product_id, quantity, list_price, discount)
FROM :'csvfile'
DELIMITER ','
CSV HEADER
NULL AS 'NULL';

