-- If there are any tables in the database, delete them and reset the sequence
TRUNCATE TABLE stocks, brands, order_items, products, categories, orders, staffs, customers, stores RESTART IDENTITY CASCADE;

-- change the directory to the current script directory
\cd :scriptdir

-- Load the customers.csv file into the database
\set csvfile :scriptdir'/csv/customers.csv'
COPY customers(customer_id, first_name, last_name, phone, email, street, city, "state", zip_code)
FROM :'csvfile'
DELIMITER ','
CSV HEADER
NULL AS 'NULL';

-- Load the brands.csv file into the database
\set csvfile :scriptdir'/csv/brands.csv'
COPY brands(brand_id, brand_name)
FROM :'csvfile'
DELIMITER ','
CSV HEADER
NULL AS 'NULL';

-- Load the categories.csv file into the database
\set csvfile :scriptdir'/csv/categories.csv'
COPY categories(category_id, category_name)
FROM :'csvfile'
DELIMITER ','
CSV HEADER
NULL AS 'NULL';

-- Load the products.csv file into the database
\set csvfile :scriptdir'/csv/products.csv'
COPY products(product_id, product_name, brand_id, category_id, model_year, list_price)
FROM :'csvfile'
DELIMITER ','
CSV HEADER
NULL AS 'NULL';

-- Load the stores.csv file into the database
\set csvfile :scriptdir'/csv/stores.csv'
COPY stores(store_id, store_name, phone, email, street, city, "state", zip_code)
FROM :'csvfile'
DELIMITER ','
CSV HEADER
NULL AS 'NULL';

-- Load the stocks.csv file into the database
\set csvfile :scriptdir'/csv/stocks.csv'
COPY stocks(store_id, product_id, quantity)
FROM :'csvfile'
DELIMITER ','
CSV HEADER
NULL AS 'NULL';

-- Load the orders.csv file into the database
\set csvfile :scriptdir'/csv/orders.csv'
COPY orders(order_id, customer_id, order_status, order_date, required_date, shipped_date, store_id, staff_id)
FROM :'csvfile'
DELIMITER ','
CSV HEADER
NULL AS 'NULL';

-- Load the order_items.csv file into the database
\set csvfile :scriptdir'/csv/order_items.csv'
COPY order_items(order_id, item_id, product_id, quantity, list_price, discount)
FROM :'csvfile'
DELIMITER ','
CSV HEADER
NULL AS 'NULL';

-- Load the staffs.csv file into the database
\set csvfile :scriptdir'/csv/staffs.csv'
COPY staffs(staff_id, first_name, last_name, email, phone, active, store_id, manager_id)
FROM :'csvfile'
DELIMITER ','
CSV HEADER
NULL AS 'NULL';
