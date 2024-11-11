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

-- stores table domain
CREATE TABLE IF NOT EXISTS stores (
	store_id	 SERIAL PRIMARY KEY,
	store_name	 VARCHAR(50),
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
	FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
	FOREIGN KEY (store_id) REFERENCES stores(store_id)
);

-- Explaining the order_status column values and their meanings
COMMENT ON COLUMN orders.order_status IS '1: Pending, 2: Processing, 3: Rejected, 4: Completed';

-- products table domain
CREATE TABLE IF NOT EXISTS products (
	product_id	 SERIAL PRIMARY KEY,
	product_name VARCHAR(150),
	brand_id	 INT,
	category_id	 INT,
	model_year	 VARCHAR(9),
	list_price	 MONEY
	-- UNCOMMENT THIS!!! FOREIGN KEY (brand_id) REFERENCES brands(brand_id) -- Foreign key to brands table
);

-- order_items table domain
CREATE TABLE IF NOT EXISTS order_items (
	order_id     INT,
	item_id 	 INT,
	product_id   INT,
	quantity     INT,
	list_price   MONEY,
	discount	 DECIMAL(3, 2),      -- 2 digits, 2 decimal places
	PRIMARY KEY (order_id, item_id), -- Composite primary key
	FOREIGN KEY (order_id) REFERENCES orders(order_id),   	  -- Foreign key to orders table
	FOREIGN KEY (product_id) REFERENCES products(product_id)  -- Foreign key to products table
);

-- staffs table domain
CREATE TABLE IF NOT EXISTS staffs (
	staff_id	 SERIAL PRIMARY KEY,
	first_name	 VARCHAR(50),
	last_name	 VARCHAR(50),
	email		 VARCHAR(50),
	phone		 VARCHAR(15),
	active		 BOOLEAN,
	store_id	 INT,
	manager_id	 INT,
	FOREIGN KEY (manager_id) REFERENCES staffs(staff_id), -- Self-referencing foreign key
	FOREIGN KEY (store_id) REFERENCES stores(store_id)	  -- Foreign key to stores table
);
