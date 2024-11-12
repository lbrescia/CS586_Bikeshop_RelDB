-- Update the order_status to text values
-- cited from https://neon.tech/postgresql/postgresql-tutorial/postgresql-case
UPDATE orders
SET order_status = CASE
    WHEN order_status = '1' THEN 'Pending'
    WHEN order_status = '2' THEN 'Processing'
    WHEN order_status = '3' THEN 'Rejected'
    WHEN order_status = '4' THEN 'Completed'
    ELSE order_status
END;

-- Update the Null phone numbers in customers to 'Not Provided'
UPDATE customers
SET phone = 'Not Provided'
WHERE phone IS NULL;

