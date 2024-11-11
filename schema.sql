-- customers table domain
CREATE TABLE IF NOT EXISTS customers (
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

-- orders table domain
CREATE TABLE IF NOT EXISTS orders (
	order_id	  SERIAL PRIMARY KEY,
	customer_id   INT,
	order_status  VARCHAR(50),
	order_date	  DATE,
	required_date DATE,
	shipped_date  DATE,
	store_id	  INT,
	staff_id	  INT,
	FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Explaining the order_status column values and their meanings
COMMENT ON COLUMN orders.order_status IS '1: Pending, 2: Processing, 3: Rejected, 4: Completed';

CREATE TABLE IF NOT EXISTS order_items (
	order_id     INT,
	item_id 	 INT,
	product_id   INT,
	quantity     INT,
	list_price   MONEY,
	discount	 DECIMAL(3, 2),      -- 2 digits, 2 decimal places
	PRIMARY KEY (order_id, item_id), -- Composite primary key
	FOREIGN KEY (order_id) REFERENCES orders(order_id) 
	--FOREIGN KEY (product_id) REFERENCES products(product_id)  UNCOMMENT THIS LINE AFTER CREATING THE PRODUCTS TABLE
);

CREATE TABLE IF NOT EXISTS staffs (
	staff_id	 SERIAL PRIMARY KEY,
	first_name	 VARCHAR(50),
	last_name	 VARCHAR(50),
	email		 VARCHAR(50),
	phone		 VARCHAR(15),
	active		 BOOLEAN,
	store_id	 INT,
	manager_id	 INT,
	FOREIGN KEY (manager_id) REFERENCES staffs(staff_id) -- Self-referencing foreign key
	--FOREIGN KEY (store_id) REFERENCES stores(store_id)  UNCOMMENT THIS LINE AFTER CREATING THE STORES TABLE
);