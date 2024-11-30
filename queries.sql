-- Indexes
CREATE INDEX IF NOT EXISTS idx_order_items_order_id ON order_items(order_id);
CREATE INDEX IF NOT EXISTS idx_order_items_product_id ON order_items(product_id);
CREATE INDEX IF NOT EXISTS idx_products_category_id ON products(category_id);
CREATE INDEX IF NOT EXISTS idx_categories_category_name ON categories(category_name);

-- 1. What are the 5 customers who had the most purchases between 2016-01-01 and 2018-12-31
SELECT c.customer_id, c.first_name, c.last_name, c.state, c.zip_code, COUNT(o.order_id) AS num_purchases
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_date BETWEEN '2016-01-01' AND '2018-12-31'
GROUP BY c.customer_id, c.first_name, c.last_name, c.state, c.zip_code
ORDER BY num_purchases DESC
LIMIT 5;


-- 2. Which staff member has had the most orders?
WITH staff_orders AS (
	SELECT o.staff_id, COUNT(o.order_id) AS order_count
	FROM orders o
	GROUP BY o.staff_id
)
SELECT s.staff_id, s.first_name, s.last_name, s.store_id, so.order_count
FROM staffs s
JOIN staff_orders so ON s.staff_id = so.staff_id
WHERE so.order_count = (SELECT MAX(order_count) FROM staff_orders);


-- 3. What is the average order value for customers who purchase a Mountain Bike from Trek?
SELECT AVG(order_values::NUMERIC)::MONEY AS avg_order_value
FROM (
	SELECT o.order_id, SUM(oi.list_price * oi.quantity * (1 - oi.discount))::NUMERIC AS order_values
	FROM orders o
	JOIN order_items oi ON o.order_id = oi.order_id
	JOIN products p ON oi.product_id = p.product_id
	JOIN brands b on p.brand_id = b.brand_id
	JOIN categories c on p.category_id = c.category_id
	WHERE b.brand_name = 'Trek' AND c.category_name = 'Mountain Bikes'
	GROUP BY o.order_id
) AS order_values;


-- 4. Which stores have more than two Surly Roadbikes in stock?
SELECT st.store_id, st.store_name, SUM(s.quantity) AS total_surly_roadbikes, b.brand_name, c.category_name
FROM stores st
JOIN stocks s ON st.store_id = s.store_id
JOIN products p ON s.product_id = p.product_id
JOIN brands b ON p.brand_id = b.brand_id
JOIN categories c ON p.category_id = c.category_id
WHERE b.brand_name = 'Surly' AND c.category_name = 'Road Bikes'
GROUP BY st.store_id, st.store_name, b.brand_name, c.category_name
HAVING SUM(s.quantity) > 2
ORDER BY st.store_name;


-- 5. What is the name and phone number of the staff member who applied the most discounts to orders?
WITH discount_count AS (
	SELECT st.first_name, st.last_name, st.phone, COUNT(oi.discount) AS num_discounts
	FROM orders o
	JOIN order_items oi ON o.order_id = oi.order_id
	JOIN staffs st ON o.staff_id = st.staff_id
	WHERE oi.discount > 0
	GROUP BY st.first_name, st.last_name, st.phone
)
SELECT first_name, last_name, phone, num_discounts
FROM discount_count
WHERE num_discounts = (SELECT MAX(num_discounts) FROM discount_count)
ORDER BY discount_count DESC;


-- 6. What are the minimum, maximum, and average list prices for all products by category?
-- Create a view to utilize for the next question
CREATE OR REPLACE VIEW price_stats AS
SELECT c.category_name, MIN(p.list_price::numeric)::MONEY AS min_price,
MAX(p.list_price::numeric)::MONEY AS max_price, AVG(p.list_price::numeric)::MONEY AS avg_price
FROM products p
JOIN categories c ON p.category_id = c.category_id
GROUP BY c.category_name
ORDER BY c.category_name;
-- Have to execute the query after the view is created
SELECT * FROM price_stats;


-- 7. What categories have a difference greater than $800 between their highest and lowest list prices?
SELECT category_name, max_price - min_price AS price_difference
FROM price_stats
WHERE (max_price - min_price)::numeric > 800;


-- 8. Which customers have ordered items from at least 6 different categories?
SELECT c.customer_id, c.first_name, c.last_name, COUNT(DISTINCT p.category_id) AS num_categories 
FROM orders o 
JOIN order_items oi ON o.order_id = oi.order_id 
JOIN products p ON oi.product_id = p.product_id 
JOIN customers c ON o.customer_id = c.customer_id 
GROUP BY c.customer_id, c.first_name, c.last_name 
HAVING COUNT(DISTINCT p.category_id) >= 6 
ORDER BY num_categories DESC;


-- 9. What is the average monthly revenue for each store?
-- Link to reference for converting date with TO_CHAR: https://www.sqlines.com/oracle-to-sql-server/to_char_datetime
SELECT st.store_id, st.store_name, COUNT(DISTINCT TO_CHAR(o.order_date, 'YYYY-MM')) AS month_count,
       SUM(oi.quantity * oi.list_price * (1 - oi.discount)) / COUNT(DISTINCT TO_CHAR(o.order_date, 'YYYY-MM')) AS avg_monthly_revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN stores st ON o.store_id = st.store_id
GROUP BY st.store_id, st.store_name
ORDER BY st.store_name;


-- 10. What is the most popular category based on the number of orders across all of the stores?
SELECT c.category_name, COUNT(DISTINCT o.order_id) AS num_orders
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
JOIN categories c ON p.category_id = c.category_id
GROUP BY c.category_name
HAVING COUNT(DISTINCT o.order_id) = (
  SELECT MAX(order_count)
  FROM (
    SELECT COUNT(DISTINCT o.order_id) AS order_count
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products p ON oi.product_id = p.product_id
    JOIN categories c ON p.category_id = c.category_id
    GROUP BY c.category_name
  ) AS category_order_counts
);


-- 11. What is the total revenue generated from all categories across all of the stores, listed from highest to lowest? 
SELECT c.category_name, 
       SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
JOIN categories c ON p.category_id = c.category_id
GROUP BY c.category_name
ORDER BY total_revenue DESC;


-- 12. What is the first name, city name, state, and zip code of the top 5 customers of the brand Haro?
SELECT c.first_name, c.city AS city_name, c.state, c.zip_code, SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue 
FROM customers c 
JOIN orders o ON c.customer_id = o.customer_id 
JOIN order_items oi ON o.order_id = oi.order_id 
JOIN products p ON oi.product_id = p.product_id 
JOIN brands b ON p.brand_id = b.brand_id 
WHERE b.brand_name = 'Haro' 
GROUP BY c.customer_id, c.first_name, c.city, c.state, c.zip_code 
ORDER BY total_revenue DESC 
LIMIT 5;


-- 13. What customers have spent more than $17000 in two or more categories in 2017?
SELECT c.first_name, c.last_name, SUM(oi.quantity * oi.list_price * (1- oi.discount)) AS spent, COUNT(DISTINCT p.category_id) AS num_categories
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE o.order_date >= '2017-01-01' AND o.order_date <= '2017-12-31'
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(DISTINCT p.category_id) >= 2 AND SUM(oi.quantity * oi.list_price * (1- oi.discount)) > 17000::MONEY
ORDER BY num_categories DESC;


-- 14. Which customers from Santa Cruz or Oakland only placed one order, and what were the order details?
SELECT c.first_name, c.last_name, c.city, o.*
FROM orders o
JOIN
    (SELECT customer_id
     FROM orders
     GROUP BY customer_id
     HAVING COUNT(order_id) = 1) AS single_order_customers
ON o.customer_id = single_order_customers.customer_id
JOIN
    customers c ON o.customer_id = c.customer_id
WHERE c.city = 'Santa Cruz' OR c.city = 'Oakland'
ORDER BY c.first_name;


-- NOTE*** It turns out nobody has shopped at multiplte locations :(
-- 15. Which customers have placed orders from more than one store location and spent over $100 between them?
SELECT
    c.first_name,
    c.last_name,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_spent,
    COUNT(DISTINCT o.store_id) AS num_stores
FROM
    customers c
JOIN
    orders o ON c.customer_id = o.customer_id
JOIN
    order_items oi ON o.order_id = oi.order_id
JOIN
    stores s ON o.store_id = s.store_id
GROUP BY
    c.customer_id, c.first_name, c.last_name
HAVING
    COUNT(DISTINCT o.store_id) > 1
    AND SUM(oi.quantity * oi.list_price * (1 - oi.discount)) > 100::MONEY
ORDER BY
    total_spent DESC;
-- NOTE*** It turns out nobody has shopped at multiplte locations :(


-- 16. Who are the top 15 customers that spent more than the average spent by all customers?
SELECT c.first_name, c.last_name, SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_spent, avg_spent.total_average_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
CROSS JOIN (
    SELECT AVG(total_spent::numeric)::MONEY AS total_average_spent
    FROM (
        SELECT SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_spent
        FROM orders o
        JOIN order_items oi ON o.order_id = oi.order_id
        GROUP BY o.customer_id
    ) AS avg_spent
) avg_spent
GROUP BY c.customer_id, c.first_name, c.last_name, avg_spent.total_average_spent
HAVING SUM(oi.quantity * oi.list_price * (1 - oi.discount)) > avg_spent.total_average_spent
ORDER BY total_spent DESC
LIMIT 15;


-- 17. Which store has the highest average order value, and what is that value?
SELECT s.store_name,
       (AVG((oi.quantity * oi.list_price * (1 - oi.discount))::numeric))::MONEY AS average_order_value
FROM stores s
JOIN orders o ON s.store_id = o.store_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY s.store_id, s.store_name
ORDER BY average_order_value DESC
LIMIT 1;


-- 18. How can we automatically update the stock levels when an order is placed?
CREATE OR REPLACE FUNCTION update_stock_after_order()
RETURNS TRIGGER AS $$
BEGIN
    -- Update the stock level by subtracting the quantity ordered from the stock
    UPDATE stocks
    SET quantity = quantity - NEW.quantity
    FROM orders o
    WHERE o.order_id = NEW.order_id            -- Use the order_id from the inserted row
      AND stocks.store_id = o.store_id         -- Get the store_id from the orders table
      AND stocks.product_id = NEW.product_id;  -- Update stock for the correct product

    -- Return the new row to satisfy the trigger requirement
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger to automatically update stock after an order item is inserted
CREATE OR REPLACE TRIGGER trigger_update_stock
AFTER INSERT ON order_items
FOR EACH ROW
EXECUTE FUNCTION update_stock_after_order();


-- 19. Which products have never been stocked at each store? 
SELECT s.store_id, s.store_name, p.product_id, p.product_name
FROM stores s
CROSS JOIN products p
LEFT JOIN stocks st
  ON s.store_id = st.store_id
  AND p.product_id = st.product_id
WHERE st.product_id IS NULL
ORDER BY s.store_name, p.product_name;


-- 20. Who was the highest average salesperson per month and per store from 2016-2018?
WITH monthly_sales AS (
    SELECT s.store_name, st.first_name AS salesperson_first_name, st.last_name AS salesperson_last_name,
        TO_CHAR(o.order_date, 'YYYY-MM') AS sales_month, SUM((oi.list_price * oi.quantity)::numeric) AS total_sales_amount
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN staffs st ON o.staff_id = st.staff_id
    JOIN stores s ON o.store_id = s.store_id
    WHERE o.order_date BETWEEN '2016-01-01' AND '2018-12-31'
    GROUP BY s.store_name, st.staff_id, st.first_name, st.last_name, TO_CHAR(o.order_date, 'YYYY-MM')
),
average_sales_per_month AS (
    SELECT store_name, salesperson_first_name, salesperson_last_name,
        AVG(total_sales_amount::numeric)::MONEY AS avg_sales_per_month
    FROM monthly_sales
    GROUP BY store_name, salesperson_first_name, salesperson_last_name
)
SELECT asm.store_name, asm.salesperson_first_name, asm.salesperson_last_name, asm.avg_sales_per_month
FROM average_sales_per_month asm
WHERE (asm.store_name, asm.avg_sales_per_month) IN (
    SELECT store_name, MAX(avg_sales_per_month) AS max_avg_sales
    FROM average_sales_per_month
    GROUP BY store_name
)
ORDER BY asm.store_name;
