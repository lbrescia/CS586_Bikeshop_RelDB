-- customers table domain
CREATE TABLE customers (
	customer_id  SERIAL PRIMARY KEY,
	first_name	 VARCHAR(50),
	last_name 	 VARCHAR(50),
	phone		 VARCHAR(15),
	email		 VARCHAR(50),
	street		 VARCHAR(100),
	city		 VARCHAR(100),
	"state"		 VARCHAR(14),
	zip_code	 VARCHAR(10)
);

