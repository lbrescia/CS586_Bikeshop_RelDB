-- What are the 5 customers who had the most purchases between 2016-01-01 and 2018-12-31
SELECT c.customer_id, c.first_name, c.last_name, c.state, c.zip_code, COUNT(o.order_id) AS num_purchases
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_date BETWEEN '2016-01-01' AND '2018-12-31'
GROUP BY c.customer_id, c.first_name, c.last_name, c.state, c.zip_code
ORDER BY num_purchases DESC
LIMIT 5;


-- Which staff member has had the most orders?
WITH staff_orders AS (
	SELECT o.staff_id, COUNT(o.order_id) AS order_count
	FROM orders o
	GROUP BY o.staff_id
)
SELECT s.staff_id, s.first_name, s.last_name, s.store_id, so.order_count
FROM staffs s
JOIN staff_orders so ON s.staff_id = so.staff_id
WHERE so.order_count = (SELECT MAX(order_count) FROM staff_orders);


-- What is the average order value for customers who purchase a Mountain Bike from Trek?
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


-- Which stores have more than two Surly Roadbikes in stock?
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


-- What is the name and phone number of the staff member who applied the most discounts to orders?
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


-- What are the minimum, maximum, and average list prices for all products by category?
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


-- What categories have a difference greater than $800 between their highest and lowest list prices?
SELECT category_name, max_price - min_price AS price_difference
FROM price_stats
WHERE (max_price - min_price)::numeric > 800;
