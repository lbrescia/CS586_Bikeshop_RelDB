-- customers table domain
CREATE TABLE IF NOT EXISTS customers (
	customer_id  SERIAL PRIMARY KEY,  -- Primary key
	first_name	 VARCHAR(50),
	last_name 	 VARCHAR(50),
	phone		 VARCHAR(15),
	email		 VARCHAR(50),
	street		 VARCHAR(100),
	city		 VARCHAR(100),
	"state"		 VARCHAR(14),
	zip_code	 VARCHAR(10)
);

-- brands table domain
CREATE TABLE IF NOT EXISTS brands (
	brand_id	 SERIAL PRIMARY KEY,  -- Primary key
	brand_name	 VARCHAR(50) NOT NULL
);

-- categories table domain
CREATE TABLE IF NOT EXISTS categories (
	category_id	 SERIAL PRIMARY KEY,   -- Primary key
	category_name VARCHAR(50) NOT NULL
);

-- products table domain
CREATE TABLE IF NOT EXISTS products (
	product_id	 SERIAL PRIMARY KEY,  -- Primary key
	product_name VARCHAR(150),
	brand_id	 INT NOT NULL,
	category_id	 INT NOT NULL,
	model_year	 VARCHAR(9) NOT NULL,
	list_price	 MONEY,
	FOREIGN KEY (brand_id) REFERENCES brands(brand_id), -- Foreign key to brands table
	FOREIGN KEY (category_id) REFERENCES categories(category_id) -- Foreign key to categories table
);

-- stores table domain
CREATE TABLE IF NOT EXISTS stores (
	store_id	 SERIAL PRIMARY KEY,  -- Primary key
	store_name	 VARCHAR(50),
	phone		 VARCHAR(15),
	email		 VARCHAR(50),
	street		 VARCHAR(100),
	city		 VARCHAR(100),
	"state"		 VARCHAR(14), 
	zip_code	 VARCHAR(10)
);

-- stocks table domain
CREATE TABLE IF NOT EXISTS stocks (
	store_id	 INT NOT NULL,
	product_id	 INT NOT NULL,
	quantity	 INT,
	PRIMARY KEY (store_id, product_id), -- Composite primary key
	FOREIGN KEY (product_id) REFERENCES products(product_id), -- Foreign key to products table
	FOREIGN KEY (store_id) REFERENCES stores(store_id) -- Foreign key to stores table
);

-- orders table domain
CREATE TABLE IF NOT EXISTS orders (
	order_id	  SERIAL PRIMARY KEY,   -- Primary key
	customer_id   INT NOT NULL,
	order_status  VARCHAR(50),
	order_date	  DATE DEFAULT CURRENT_DATE, 
	required_date DATE NOT NULL,
	shipped_date  DATE,
	store_id	  INT NOT NULL,
	staff_id	  INT NOT NULL,
	FOREIGN KEY (customer_id) REFERENCES customers(customer_id),  -- Foreign key to customers table
	FOREIGN KEY (store_id) REFERENCES stores(store_id)			  -- Foreign key to stores table
);

-- Explaining the order_status column values and their meanings
COMMENT ON COLUMN orders.order_status IS '1: Pending, 2: Processing, 3: Rejected, 4: Completed';

-- order_items table domain
CREATE TABLE IF NOT EXISTS order_items (
	order_id     INT,
	item_id 	 INT,
	product_id   INT NOT NULL,
	quantity     INT NOT NULL,
	list_price   MONEY,
	discount	 DECIMAL(3, 2),      -- 2 digits, 2 decimal places
	PRIMARY KEY (order_id, product_id), -- Composite primary key
	FOREIGN KEY (order_id) REFERENCES orders(order_id),   	  -- Foreign key to orders table
	FOREIGN KEY (product_id) REFERENCES products(product_id)  -- Foreign key to products table
);

-- staffs table domain
CREATE TABLE IF NOT EXISTS staffs (
	staff_id	 SERIAL PRIMARY KEY,  -- Primary key
	first_name	 VARCHAR(50),
	last_name	 VARCHAR(50),
	email		 VARCHAR(50),
	phone		 VARCHAR(15),
	active		 BOOLEAN,
	store_id	 INT NOT NULL,
	manager_id	 INT,
	FOREIGN KEY (manager_id) REFERENCES staffs(staff_id), -- Self-referencing foreign key
	FOREIGN KEY (store_id) REFERENCES stores(store_id)	  -- Foreign key to stores table
);
