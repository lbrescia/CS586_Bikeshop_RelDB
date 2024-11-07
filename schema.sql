-- customers table domain
CREATE TABLE customers (
	customer_id  SERIAL PRIMARY KEY,
	first_name	 VARCHAR(50),
	last_name 	 VARCHAR(50),
	phone		 CHAR(11),
	email		 VARCHAR(50),
	street		 VARCHAR(100),
	city		 VARCHAR(100),

