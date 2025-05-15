-- AJUSTED for MySQL
-- Create the database
CREATE DATABASE pizza_runner;
USE pizza_runner;

-- Create runners table
DROP TABLE IF EXISTS runners;
CREATE TABLE runners (
	runner_id INT,
	registration_date DATE
);

INSERT INTO runners (runner_id, registration_date)
VALUES
	(1, '2021-01-01'),
	(2, '2021-01-03'),
	(3, '2021-01-08'),
	(4, '2021-01-15');

-- Create customer_orders table
DROP TABLE IF EXISTS customer_orders;
CREATE TABLE customer_orders (
	order_id INT,
	customer_id INT,
	pizza_id INT,
	exclusions VARCHAR(10),
	extras VARCHAR(10),
	order_time DATETIME
);

INSERT INTO customer_orders (order_id, customer_id, pizza_id, exclusions, extras, order_time)
VALUES
	('1', '101', '1', '', '', '2020-01-01 18:05:02'),
	('2', '101', '1', '', '', '2020-01-01 19:00:52'),
	('3', '102', '1', '', '', '2020-01-02 23:51:23'),
	('3', '102', '2', '', NULL, '2020-01-02 23:51:23'),
	('4', '103', '1', '4', '', '2020-01-04 13:23:46'),
	('4', '103', '1', '4', '', '2020-01-04 13:23:46'),
	('4', '103', '2', '4', '', '2020-01-04 13:23:46'),
	('5', '104', '1', 'null', '1', '2020-01-08 21:00:29'),
	('6', '101', '2', 'null', 'null', '2020-01-08 21:03:13'),
	('7', '105', '2', 'null', '1', '2020-01-08 21:20:29'),
	('8', '102', '1', 'null', 'null', '2020-01-09 23:54:33'),
	('9', '103', '1', '4', '1, 5', '2020-01-10 11:22:59'),
	('10', '104', '1', 'null', 'null', '2020-01-11 18:34:49'),
	('10', '104', '1', '2, 6', '1, 4', '2020-01-11 18:34:49');

-- Create runner_orders table
DROP TABLE IF EXISTS runner_orders;
CREATE TABLE runner_orders (
	order_id INT,
	runner_id INT,
	pickup_time VARCHAR(20),
	distance VARCHAR(10),
	duration VARCHAR(10),
	cancellation VARCHAR(30)
);

INSERT INTO runner_orders (order_id, runner_id, pickup_time, distance, duration, cancellation)
VALUES
	('1', '1', '2020-01-01 18:15:34', '20km', '32 minutes', ''),
	('2', '1', '2020-01-01 19:10:54', '20km', '27 minutes', ''),
	('3', '1', '2020-01-03 00:12:37', '13.4km', '20 mins', NULL),
	('4', '2', '2020-01-04 13:53:03', '23.4', '40', NULL),
	('5', '3', '2020-01-08 21:10:57', '10', '15', NULL),
	('6', '3', 'null', 'null', 'null', 'Restaurant Cancellation'),
	('7', '2', '2020-01-08 21:30:45', '25km', '25mins', 'null'),
	('8', '2', '2020-01-10 00:15:02', '23.4 km', '15 minute', 'null'),
	('9', '2', 'null', 'null', 'null', 'Customer Cancellation'),
	('10', '1', '2020-01-11 18:50:20', '10km', '10minutes', 'null');
  
-- Create pizza_names table
DROP TABLE IF EXISTS pizza_names;
CREATE TABLE pizza_names (
	pizza_id INT,
	pizza_name VARCHAR(20)
);

INSERT INTO pizza_names (pizza_id, pizza_name)
VALUES
	(1, 'Meatlovers'),
	(2, 'Vegetarian');

-- Create pizza_recipes table
DROP TABLE IF EXISTS pizza_recipes;
CREATE TABLE pizza_recipes (
	pizza_id INT,
	toppings VARCHAR(30)
);

INSERT INTO pizza_recipes (pizza_id, toppings)
VALUES
	(1, '1, 2, 3, 4, 5, 6, 8, 10'),
	(2, '4, 6, 7, 9, 11, 12');

-- Create pizza_toppings table
DROP TABLE IF EXISTS pizza_toppings;
CREATE TABLE pizza_toppings (
	topping_id INT,
	topping_name VARCHAR(50)
);

INSERT INTO pizza_toppings (topping_id, topping_name)
VALUES
	(1, 'Bacon'),
	(2, 'BBQ Sauce'),
	(3, 'Beef'),
	(4, 'Cheese'),
	(5, 'Chicken'),
	(6, 'Mushrooms'),
	(7, 'Onions'),
	(8, 'Pepperoni'),
	(9, 'Peppers'),
	(10, 'Salami'),
	(11, 'Tomatoes'),
	(12, 'Tomato Sauce');


## DATA CLEANING
----------------
-- A. customer_orders table
SELECT *
FROM customer_orders;

DESCRIBE customer_orders;

-- Cleaning the table
UPDATE customer_orders
SET exclusions =
	CASE
		WHEN exclusions = 'null'
        OR exclusions = ''
        THEN NULL
        ELSE exclusions
	END,
    extras =
    CASE
		WHEN extras = 'null'
        OR extras = ''
        THEN NULL
        ELSE extras
	END;

-- B. runner_orders table
SELECT *
FROM runner_orders;

DESCRIBE runner_orders;

-- Cleaning the table
UPDATE runner_orders
SET pickup_time =
	CASE
		WHEN pickup_time = 'null' OR pickup_time = '' THEN NULL
        ELSE pickup_time
	END,    
    distance =
    CASE
		WHEN distance = 'null' OR distance = '' THEN NULL
		ELSE REPLACE(distance, 'km', '')
    END,    
    duration =
	CASE
		WHEN duration = 'null' OR duration = '' THEN NULL
		ELSE REPLACE(REPLACE(REPLACE(duration, 'minutes', ''), 'minute', ''), 'mins', '')
        END,
    cancellation =
    CASE
		WHEN cancellation = 'null' OR cancellation = '' THEN NULL
        ELSE cancellation
        END;


## EXCERCISE
------------
-- A. PIZZA METRICS

## 1. How many pizzas were ordered?
SELECT COUNT(pizza_id) AS orders_total
FROM customer_orders;


## 2. How many unique customer orders were made?
SELECT COUNT(DISTINCT order_id) AS unique_customers
FROM customer_orders;


## 3. How many successful orders were delivered by each runner?
SELECT 
	runner_id,
	COUNT(order_id) AS successful_delivery
FROM runner_orders
WHERE cancellation IS NULL
GROUP BY runner_id;


## 4. How many of each type of pizza was delivered?
SELECT 
	p.pizza_name, 
	COUNT(c.pizza_id) AS delivered_pizza
FROM customer_orders c
JOIN runner_orders r
	ON c.order_id = r.order_id
JOIN pizza_names p
	ON c.pizza_id = p.pizza_id
WHERE cancellation IS NULL
GROUP BY p.pizza_name;


## 5. How many Vegetarian and Meatlovers were ordered by each customer?
SELECT 
	c.customer_id, 
	p.pizza_name, 
	COUNT(p.pizza_name) AS order_count
FROM customer_orders c
JOIN pizza_names p
	ON c.pizza_id= p.pizza_id
GROUP BY c.customer_id, p.pizza_name
ORDER BY c.customer_id;


## 6. What was the maximum number of pizzas delivered in a single order?
SELECT
	c.order_id,
	COUNT(pizza_id) AS max_pizzas
FROM customer_orders c
JOIN runner_orders r
	ON c.order_id = r.order_id
	AND r.cancellation IS NULL
GROUP BY c.order_id
ORDER BY max_pizzas DESC
LIMIT 1;


## 7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
SELECT 
	c.customer_id,
	SUM(CASE
		WHEN c.exclusions IS NOT NULL
			OR c.extras IS NOT NULL
            THEN 1
		ELSE 0
	END) AS changes_made,
	SUM(CASE
		WHEN c.exclusions IS NULL
			AND c.extras IS NULL
            THEN 1
		ELSE 0
	END) AS no_changes
FROM customer_orders c
JOIN runner_orders r
	ON c.order_id = r.order_id
WHERE r.cancellation IS NULL
GROUP BY c.customer_id;


## 8. How many pizzas were delivered that had both exclusions and extras?
SELECT
	customer_id,
	COUNT(pizza_id) AS changed_order
FROM customer_orders c
JOIN runner_orders r
	ON c.order_id = r.order_id
WHERE r.cancellation IS NULL
	AND c.exclusions IS NOT NULL
	AND c.extras IS NOT NULL
GROUP BY customer_id;


## 9. What was the total volume of pizzas ordered for each hour of the day?
SELECT 
	HOUR(order_time) AS hour_in_day,
	COUNT(pizza_id) AS total_orders
FROM customer_orders
GROUP BY HOUR(order_time)
ORDER BY hour_in_day;


## 10. What was the volume of orders for each day of the week?
SELECT 
    DAYNAME(order_time) AS day_of_week,
    COUNT(pizza_id) AS total_orders
FROM customer_orders
GROUP BY day_of_week
ORDER BY FIELD(day_of_week, 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday');


------------
-- B. Runner and Customer Experience

## 1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
SELECT DAYNAME('2021-01-01') AS day_of_week;

SELECT 
    WEEK(registration_date, 1) +1 AS each_week,
    COUNT(runner_id) AS runners_signed
FROM runners
GROUP BY WEEK(registration_date, 1) +1
ORDER BY each_week;


## 2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
SELECT 
    runner_id,
    ROUND(AVG(TIMESTAMPDIFF(MINUTE, c.order_time, pickup_time))) AS avg_time_min
FROM runner_orders r
JOIN customer_orders c
	ON c.order_id = r.order_id
GROUP BY runner_id;


## 3. Is there any relationship between the number of pizzas and how long the order takes to prepare?
WITH cte_preparation AS (
	SELECT 
		c.order_id, 
		COUNT(c.pizza_id) AS ordered_pizzas, 
		order_time, 
		pickup_time, 
		TIMESTAMPDIFF(MINUTE, c.order_time, r.pickup_time) AS prep_time_min,
        TIMESTAMPDIFF(MINUTE, c.order_time, r.pickup_time) / COUNT(c.pizza_id) AS time_per_pizza
	FROM customer_orders c
	JOIN runner_orders r
		ON c.order_id = r.order_id
	WHERE r.distance IS NOT NULL
	GROUP BY c.order_id, c.order_time, r.pickup_time
)

SELECT 
	ordered_pizzas, 
	ROUND(AVG(prep_time_min)) AS avg_time_min,
  	ROUND(AVG(time_per_pizza)) AS avg_time_per_pizza
FROM cte_preparation
GROUP BY ordered_pizzas
ORDER BY ordered_pizzas;


## 4. What was the average distance travelled for each customer?
SELECT 
	c.customer_id,
	ROUND(AVG(distance)) AS avg_distance
FROM runner_orders r
JOIN customer_orders c
	ON c.order_id = r.order_id
GROUP BY c.customer_id;


## 5. What was the difference between the longest and shortest delivery times for all orders?
SELECT 
	MAX(duration) - MIN(duration) AS delivery_time_difference
FROM runner_orders;


## 6. What was the average speed for each runner for each delivery and do you notice any trend for these values?
SELECT 
    runner_id,
    order_id,
    distance AS distance_km,
    duration AS duration_min,
    ROUND(distance / duration *60) AS avg_speed_kmh
FROM runner_orders
WHERE distance IS NOT NULL AND duration IS NOT NULL
ORDER BY runner_id, order_id;


## 7. What is the successful delivery percentage for each runner?
SELECT 
	runner_id,	
	COUNT(order_id) AS total_orders,
	COUNT(pickup_time) AS orders_delivered,
	ROUND(COUNT(pickup_time) / COUNT(order_id) * 100) AS delivery_percentage
FROM runner_orders
GROUP BY runner_id;