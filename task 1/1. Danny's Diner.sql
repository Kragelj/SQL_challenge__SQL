-- ADJUSTED for MySQL
-- Create the database
CREATE DATABASE dannys_diner;
USE dannys_diner;

-- Create sales table
DROP TABLE IF EXISTS sales;
CREATE TABLE sales (
	customer_id VARCHAR(5), -- Adjusted size for flexibility
	order_date DATE,
	product_id INT
);

-- Insert data into sales
INSERT INTO sales (customer_id, order_date, product_id)
VALUES
	('A', '2021-01-01', 1),
	('A', '2021-01-01', 2),
	('A', '2021-01-07', 2),
	('A', '2021-01-10', 3),
	('A', '2021-01-11', 3),
	('A', '2021-01-11', 3),
	('B', '2021-01-01', 2),
	('B', '2021-01-02', 2),
	('B', '2021-01-04', 1),
	('B', '2021-01-11', 1),
	('B', '2021-01-16', 3),
	('B', '2021-02-01', 3),
	('C', '2021-01-01', 3),
	('C', '2021-01-01', 3),
	('C', '2021-01-07', 3);

-- Create menu table
DROP TABLE IF EXISTS menu;
CREATE TABLE menu (
	product_id INT PRIMARY KEY, -- Ensuring product_id is unique
	product_name VARCHAR(20), -- Increased size for longer product names
	price INT
);

-- Insert data into menu
INSERT INTO menu (product_id, product_name, price)
VALUES
	(1, 'sushi', 10),
	(2, 'curry', 15),
	(3, 'ramen', 12);

-- Create members table
DROP TABLE IF EXISTS members;
CREATE TABLE members (
	customer_id VARCHAR(5),
	join_date DATE
);

-- Insert data into members
INSERT INTO members (customer_id, join_date)
VALUES
	('A', '2021-01-07'),
	('B', '2021-01-09');


## EXCERCISE 
------------
## 1. What is the total amount each customer spent at the restaurant?
SELECT
	customer_id,
    SUM(price) as total
FROM sales s,
JOIN menu m
    ON m.product_id = s.product_id
GROUP BY customer_id;


## 2. How many days has each customer visited the restaurant?
SELECT
	customer_id,
	COUNT(DISTINCT order_date) as visits
FROM sales 
GROUP BY customer_id;


## 3. What was the first item from the menu purchased by each customer?
WITH cte_orders AS (
	SELECT
		customer_id,
		order_date,
		product_name,
		ROW_NUMBER() OVER (PARTITION BY customer_id 
			ORDER BY order_date) AS rank_num
	FROM sales s
	JOIN menu m
		ON m.product_id = s.product_id
)

SELECT 
	customer_id,
	product_name
FROM cte_orders
WHERE rank_num = 1;


## 4. What is the most purchased item on the menu and how many times was it purchased by all customers?
SELECT 
	product_name AS most_purchased_item,
	COUNT(s.product_id) AS purchased_volume
FROM sales s
JOIN menu m
	ON s.product_id = m.product_id
GROUP BY m.product_name
ORDER BY purchased_volume DESC
LIMIT 1;


## 5. Which item was the most popular for each customer?
WITH cte_popular_item AS (
	SELECT
		customer_id,
		product_name,
		COUNT(s.product_id) AS ordered,
		DENSE_RANK() OVER (PARTITION BY customer_id 
			ORDER BY COUNT(s.product_id) DESC) AS rank_num
	FROM sales s
	JOIN menu m
		ON m.product_id = s.product_id
	GROUP BY
		customer_id,
		product_name
)

SELECT 
	customer_id,
	product_name,
	ordered
FROM cte_popular_item
WHERE rank_num = 1;


## 6. Which item was purchased first by the customer after they became a member?
WITH cte_becoming_member AS (
	SELECT
		s.customer_id,
		order_date,
        join_date,
		product_id,
		ROW_NUMBER() OVER (PARTITION BY s.customer_id
			ORDER BY order_date) as rank_num
	FROM sales s
	JOIN members m
		ON m.customer_id = s.customer_id
		AND order_date >= join_date
)

SELECT 
	customer_id,
	product_name,
	order_date,
    join_date
FROM cte_becoming_member bm
JOIN menu m
	ON m.product_id = bm.product_id
	AND rank_num = 1;


## 7. Which item was purchased just before the customer became a member?
WITH cte_before_being_member AS (
	SELECT
		s.customer_id,
        product_id,
		order_date,
		join_date,
		ROW_NUMBER() OVER (PARTITION BY s.customer_id
			ORDER BY order_date DESC) AS rank_num
	FROM sales s
	JOIN members m
		ON m.customer_id = s.customer_id
		AND order_date < join_date
)

SELECT 
	customer_id,
	product_name,
	order_date, 
	join_date
FROM cte_before_being_member bbm
JOIN menu m
	ON m.product_id = bbm.product_id
	AND rank_num = 1;


## 8. What is the total items and amount spent for each member before they became a member?
SELECT
	s.customer_id,
	COUNT(s.product_id) AS total_items,
	SUM(m.price) AS amount_spent
FROM sales s
JOIN members mb
	ON mb.customer_id = s.customer_id
	AND mb.join_date > s.order_date
JOIN menu m
	ON m.product_id = s.product_id
GROUP BY s.customer_id;


## 9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
SELECT
	customer_id,
	SUM(CASE
		WHEN s.product_id = 1 THEN price*20
		ELSE price*10 
	END) AS total_points
FROM sales s
JOIN menu m
	ON m.product_id = s.product_id
GROUP BY customer_id;


## 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?
-- NOT SOLVED --