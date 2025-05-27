# Case Study #2: Pizza Dinner
This case study is taken from the website [SQL challenge](https://8weeksqlchallenge.com/case-study-1/).
<br>This is the **second case study**.

## Introduction
Danny saw a new opportunity in pizza deliveries, so the Pizza Runner was born. With a team of “runners” delivering from his home and a mobile app, he set out to revolutionize pizza delivery.

Danny knows that the data is his key to success, but needs help cleaning data and applying calculations to optimize operations.
He has shared samples of three datasets regarding orders: *runners*, *customer_orders*, and *runner_orders*, and additional three datasets for pizza offers: *pizza_names*, *pizza_recipes, and *pizza_toppings*.

Before using the datasets in our queries, they need to be cleaned up.


## Database and Tables
We will be using MySQL Workbench as our primary editor.
Please note that MySQL differs in syntax and functionality from other SQL platforms, so we have made a few necessary adjustments to ensure compatibility.

````sql
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
````

## DATA CLEANING

Looking at the *customer_orders* and *runner_orders* tables, we can see that in some columns there are missing spaces or there are blank or null values. In the second table, we also need to adjust the format of the numeric columns. 

At first, we will replace and unify all 'null' values in certain columns. Data cleaning consists of replacing invalid values ('null' or empty strings) with `NULL`. Additionally, we will remove unwanted text from distance column (removing 'km') and duration column (removing variations of 'minutes') in runner_orders table.
These adjustments ensure data consistency and usability for analysis.

````sql
-- A. customer_orders table
SELECT *
FROM customer_orders;

DESCRIBE customer_orders;

-- Cleaning the table
UPDATE customer_orders
SET exclusions =
    	CASE
	    WHEN exclusions = 'null' OR exclusions = ''
            THEN NULL
            ELSE exclusions
        END,
    extras =
        CASE
	    WHEN extras = 'null' OR extras = ''
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
````


## Questions
### A. PIZZA METRICS

**1. How many pizzas were ordered?**

````sql
SELECT COUNT(pizza_id) AS orders_total
FROM customer_orders;
````

#### Explanation:
- With the **COUNT** function, we counted all the ordered pizzas. 

#### Answer:
| orders_total |
| ------------ |
| 14           |

14 pizzas were ordered in total.

***

**2. How many unique customer orders were made?**

````sql
SELECT COUNT(DISTINCT order_id) AS unique_customers
FROM customer_orders;
````

#### Explanation:
- With the **COUNT DISTINCT** function, we determind the unique number of customers.

#### Answer:
| unique_customers |
| ---------------- |
| 10               |

There were 10 unique customers.

***

**3. How many successful orders were delivered by each runner?**

````sql
SELECT 
    runner_id,
    COUNT(order_id) AS successful_delivery
FROM runner_orders
WHERE cancellation IS NULL
GROUP BY runner_id;
````

#### Explanation:
- With the **COUNT** aggregate function, we counted all the orders.
- With the **WHERE** statement, we only selected the rows where the order wasn't canceled.

#### Answer:
| runner_id | successful_delivery | 
| --------- | ------------------- |
| A         | 4                   | 
| B         | 3                   | 
| C         | 1                   |

Runner 1 had 4 successfully delivered orders.
<br>Runner 2 had 3 successfully delivered orders.
<br>Runner 3 had 1 successfully delivered order.

***

**4. How many of each type of pizza was delivered?**

````sql
SELECT 
    p.pizza_name, 
    COUNT(c.pizza_id) AS delivered_pizza
FROM customer_orders c
INNER JOIN runner_orders r
    ON c.order_id = r.order_id
INNER JOIN pizza_names p
    ON c.pizza_id = p.pizza_id
WHERE cancellation IS NULL
GROUP BY p.pizza_name;
````

#### Explanation:
- With the **COUNT** aggregation function, we calculated the total number of delivered pizzas.
- Using **INNER JOIN**, we combined data from customer_orders, runner_orders, and pizza_names tables to match pizzas with their deliveries.
- Applying the **WHERE** clause ensured only non-canceled orders were considered.

#### Answer:
| pizza_name | delivered_pizza | 
| ---------- | --------------- |
| Meatlovers | 9               |
| Vegetarian | 3               |

Meatlovers pizza was delivered 9 times.
<br>Vegeterian pizza was delivered 3 times.

***

**5. How many Vegetarian and Meatlovers were ordered by each customer?**

````sql
SELECT 
    c.customer_id, 
    p.pizza_name, 
    COUNT(p.pizza_name) AS order_count
FROM customer_orders c
INNER JOIN pizza_names p
    ON c.pizza_id= p.pizza_id
GROUP BY c.customer_id, p.pizza_name
ORDER BY c.customer_id;
````

#### Explanation:
- With the **COUNT** aggregation function, we calculated the total orders for each pizza type per customer.
- Using **INNER JOIN**, we linked customer_orders with pizza_names to retrieve pizza names.
- Applying **GROUP BY**, we grouped the data by customer_id and pizza_name to show individual order counts.
- Using **ORDER BY**, we sorted the results by customer ID for easier reference. Let me know if you need further refinements!

#### Answer:
| customer_id | pizza_name | order_count |
| ----------- | ---------- | ----------- |
| 101         | Meatlovers | 2           |
| 101         | Vegetarian | 1           |
| 102         | Meatlovers | 2           |
| 102         | Vegetarian | 1           |
| 103         | Meatlovers | 3           |
| 103         | Vegetarian | 1           |
| 104         | Meatlovers | 3           |
| 105         | Vegetarian | 1           |

Customer 101 ordered 2 Meatlovers pizzas and 1 Vegetarian pizza.
<br>Customer 102 ordered 2 Meatlovers pizzas and 1 Vegetarian pizza.
<br>Customer 103 ordered 3 Meatlovers pizzas and 1 Vegetarian pizza.
<br>Customer 104 ordered 3 Meatlovers pizzas.
<br>Customer 105 ordered 1 Vegetarian pizza.

***

**6. What was the maximum number of pizzas delivered in a single order?**

```sql
SELECT
    c.order_id,
    COUNT(pizza_id) AS max_pizzas
FROM customer_orders c
INNER JOIN runner_orders r
    ON c.order_id = r.order_id
        AND r.cancellation IS NULL
GROUP BY c.order_id
ORDER BY max_pizzas DESC
LIMIT 1;
```

#### Explanation:
- With the **COUNT** aggregation function, we calculated the total number of pizzas in each order.
- Using **INNER JOIN**, we linked customer_orders with runner_orders tables to filter out canceled orders.
- Applying **GROUP BY**, we aggregated data by order_id to determine the number of pizzas per order.
- With using **ORDER BY** in descending order, we identified the order with the highest pizza count, and with **LIMIT** clause we displayed only the top result.

#### Answer:
| order_id | max_pizzas |
| -------- | ---------- |
| 4        | 3          |

The order with the highest number of pizzas is order 4 with 3 pizzas.

***

**7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?**

````sql
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
INNER JOIN runner_orders r
    ON c.order_id = r.order_id
WHERE r.cancellation IS NULL
GROUP BY c.customer_id;
````

#### Explanation:
- With the **SUM** function, followed with **CASE**, we counted delivered pizzas based on specific criteria, where at least one change (exclusions or extras) was made.
- Another **SUM(CASE ...)** function counted pizzas with no changes, ensuring both conditions were tracked separately.
- Using **INNER JOIN**, we combined customer_orders with runner_orders table to exclude canceled orders.
- Applying **WHERE**, we filtered out canceled deliveries, keeping only successful ones.
- Using **GROUP BY**, we grouped the results by customer_id to display individual customer modifications.

#### Answer:
| customer_id | changes_made | no_changes |
| ----------- | ------------ | ---------- |
| 101         | 0            | 2          |
| 102         | 0            | 3          |
| 103         | 3            | 0          |
| 104         | 2            | 1          |
| 105         | 1            | 0          |

- Customer 101 had 2 pizzas with no changes.
- Customer 102 had 3 pizzas with no changes.
- Customer 103 had 3 pizzas with changes.
- Customer 104 had 2 pizzas with changes and 1 pizza with no changes.
- Customer 105 had 1 pizza with changes.

***

**8. How many pizzas were delivered that had both exclusions and extras?**

```sql
SELECT
    customer_id,
    COUNT(pizza_id) AS changed_order
FROM customer_orders c
INNER JOIN runner_orders r
    ON c.order_id = r.order_id
WHERE r.cancellation IS NULL
    AND c.exclusions IS NOT NULL
    AND c.extras IS NOT NULL
GROUP BY customer_id;
```

#### Explanation:
- With **COUNT**, we calculated the number of pizzas that had both exclusions and extras.
- Using **INNER JOIN**, we connected customer_orders and runner_orders tables to track delivered pizzas.
- Applying **WHERE**, we filtered out canceled orders and ensured only pizzas with both modifications were included.

#### Answer:
| customer_id | changed_order |
| ----------- | ------------- |
| 104         | 1             |

Only customer 104 had a pizza with both exclusions and extras, totaling 1 changed order.

***

**9. What was the total volume of pizzas ordered for each hour of the day?**

```sql
SELECT 
    HOUR(order_time) AS hour_in_day,
    COUNT(pizza_id) AS total_orders
FROM customer_orders
GROUP BY HOUR(order_time)
ORDER BY hour_in_day;
```

#### Explanation:
- With **HOUR** function, we extracted the hour from each order timestamp.
- Using **COUNT**, we calculated the total number of pizzas ordered in each hour.
- Applying **GROUP BY**, we grouped orders by hour to determine the volume per time slot.
- Using **ORDER BY**, we sorted the results chronologically for a clear time-based trend.

#### Answer:
| hour_in_day | total_orders | 
| ----------- | ------------ |
| 11          | 1            |
| 13          | 3            |
| 18          | 3            |
| 19          | 1            |
| 21          | 3            |
| 23          | 3            |

The biggest volume of pizzas were ordered at 13:00, 18:00, 21:00, and 23:00, when 3 pizzas were ordered each time.
<br>The lowest volume of pizzas were ordered at 11:00, and 19:00, when only 1 pizza was ordered each time.

***

**10. What was the volume of orders for each day of the week?**

```sql
SELECT 
    DAYNAME(order_time) AS day_of_week,
    COUNT(pizza_id) AS total_orders
FROM customer_orders
GROUP BY day_of_week
ORDER BY FIELD(day_of_week, 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday');
```

#### Explanation:
- With the **DAYNAME** function, we extracted the weekday from each order timestamp.
- Using **COUNT**, we calculated the total number of pizzas ordered per day.
- Applying **GROUP BY**, we grouped the data by day of the week to summarize daily order volume.
- Using **ORDER BY FIELD**, we ensured the days are sorted in chronological order instead of alphabetical order.

#### Answer:
| day_of_week | total_orders | 
| ----------- | ------------ |
| Wednesday   | 5            |
| Thursday    | 3            |
| Friday      | 1            |
| Saturday    | 5            |

5 pizzas were ordered on Wednesday and Saturday.
<br>3 pizzas were ordered on Thursday.
<br>1 pizza was ordered on Friday.

***

## Questions
### B. RUNNER AND CUSTOMER EXPERIENCE

**1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)**

````sql
SELECT DAYNAME('2021-01-01') AS day_of_week;

SELECT 
    WEEK(registration_date, 1) +1 AS each_week,
    COUNT(runner_id) AS runners_signed
FROM runners
GROUP BY WEEK(registration_date, 1) +1
ORDER BY each_week;
````

#### Explanation:
- With the first query (**DAYNAME**) we determined the day of the week on the stated date.
- With the **WEEK** function, we determined the registration week for each runner, and with following '+1' we ensured the week starts on Monday with week number 1, aligning it with 2021-01-01.
- Using **COUNT**, we calculated the total number of runners who registered in each week.
- Applying **GROUP BY**, we grouped signups by their respective weeks to summarize registrations over time.
- Using **ORDER BY**, we sorted the results chronologically by week number for easy reference.

#### Answer:
| each_week | runners_signed | 
| --------- | -------------- |
| 1         | 2              |
| 2         | 1              |
| 3         | 1              |

In the first week of January 2021, two new runners registered.
<br>During weeks two and three, one runner joined each week.

***

**2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?**

````sql
SELECT 
    runner_id,
    ROUND(AVG(TIMESTAMPDIFF(MINUTE, c.order_time, pickup_time))) AS avg_time_min
FROM runner_orders r
INNER JOIN customer_orders c
    ON c.order_id = r.order_id
GROUP BY runner_id;
````

#### Explanation:
- With the **TIMESTAMPDIFF** function, we calculated the time difference in minutes between the order time and the pick up time.
- We used the **AVG** aggreggation function to determine the average time it took for each runner to arrive, combined with the **ROUND** function, to round the result to the nearest whole number.
- Using **INNER JOIN**, we linked customer_orders with runner_orders table to correlate order placement times with pickup times.
- Applying **GROUP BY**, we grouped results by runner_id to calculate individual performance for each runner.

#### Answer:
| runner_id | avg_time_min | 
| --------- | ------------ |
| 1         | 15           |
| 2         | 23           |
| 3         | 10           |

Runner 1 had an average pickup time of 15 minutes.
<br>Runner 2 took 23 minutes on average to arrive.
<br>Runner 3 was the fastest, with an average pickup time of 10 minutes.

***

**3. Is there any relationship between the number of pizzas and how long the order takes to prepare?**

````sql
WITH cte_preparation AS (
    SELECT 
	c.order_id, 
	COUNT(c.pizza_id) AS ordered_pizzas, 
	order_time, 
	pickup_time, 
	TIMESTAMPDIFF(MINUTE, c.order_time, r.pickup_time) AS prep_time_min,
        TIMESTAMPDIFF(MINUTE, c.order_time, r.pickup_time) / COUNT(c.pizza_id) AS time_per_pizza
    FROM customer_orders c
    INNER JOIN runner_orders r
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
````

#### Explanation:
- With the Common Table Expression (CTE) named `cte_preparation` we recompute preparation time.
- With **COUNT**, we calculated the number of pizzas ordered in each order.
- Using the **TIMESTAMPDIFF** function, we determined the total preparation time in minutes for each order and computed the average preparation time per pizza.
- Applying **WHERE**, we ensured only orders with recorded travel distances were included, eliminating null values.
- Using **GROUP BY**, we grouped data by order_id to ensure aggregation aligns with unique orders.
- In the followed query, we used the **AVG** function to calculate the average preparation time across different order sizes. With **ROUND**, to round the average preparation times for clarity.
- Using **ORDER BY**, we sorted results by ordered_pizzas

#### Answer:
| ordered_pizzas | avg_time_min | avg_time_pre_pizza |
| -------------- | ------------ | ------------------ |
| 1              | 12           | 12                 |
| 2              | 18           | 9                  |
| 3              | 29           | 10                 |

A typical single pizza order is prepared in 12 minutes on average.
<br>For orders with 3 pizzas, preparation time extends to 29 minutes, averaging 10 minutes per pizza.
<br>Orders containing 2 pizzas are completed in 16 minutes, whic is 8 minutes per pizza, making 2-pizza orders the most time-efficient.

***

**4. What was the average distance travelled for each customer?**

````sql
SELECT 
    c.customer_id,
    ROUND(AVG(distance)) AS avg_distance
FROM runner_orders r
INNER JOIN customer_orders c
    ON c.order_id = r.order_id
GROUP BY c.customer_id;
````

#### Explanation:
- Using the **AVG** function, we calculated the average distance traveled by runners for each customer’s order. Applying ROUND, we rounded the values to make the results more readable.
- With the **INNER JOIN** statement, we linked runner_orders with customer_orders table to associate travel distances with customer IDs.
- Using **GROUP BY**, we grouped the results by customer_id, ensuring individual calculations for each customer.

#### Answer:
| customer_id | avg_distance | 
| ----------- | ------------ |
| 101         | 20           |
| 102         | 17           |
| 103         | 23           |
| 104         | 10           |
| 105         | 25           |

Customer 101 had an average travel distance of 20 km.
<br>Customer 102 had an average travel distance of 17 km.
<br>Customer 103 had an average travel distance of 23 km.
<br>Customer 104 had an average travel distance of 10 km, which was the shortest distance.
<br>Customer 105 had the longest average travel distance, at 25 km.

***

**5. What was the difference between the longest and shortest delivery times for all orders?**

````sql
SELECT 
    MAX(duration) - MIN(duration) AS delivery_time_difference
FROM runner_orders;
````

#### Explanation:
- With the **MAX** and the **MIN** functions, we identified the longest and the shortest delivery times recorded. Applying subtraction, we calculated the difference between them.

#### Answer:
| delivery_time_difference |
| ------------------------ |
| 30                       | 

The difference between the longest and shortest delivery times for all orders was 30 minutes.

***

**6. What was the average speed for each runner for each delivery and do you notice any trend for these values?**

```sql
SELECT 
    runner_id,
    order_id,
    distance AS distance_km,
    duration AS duration_min,
    ROUND(distance / duration *60) AS avg_speed_kmh
FROM runner_orders
WHERE distance IS NOT NULL AND duration IS NOT NULL
ORDER BY runner_id, order_id;
```

#### Explanation:
- Using a formula, we calculated the average speed in km/h for each delivery. Applying **ROUND**, we rounded speed values to whole numbers for better readability.
- With the **WHERE** statement, we filtered out incomplete records (distance IS NOT NULL AND duration IS NOT NULL), ensuring accurate calculations.
- Using **ORDER BY**, we sorted the results by runner_id and order_id to clearly display speeds for each individual delivery.

#### Answer:
| runner_id | order_id | distance_km | duration_min | avg_speed_kmh |
| --------- | -------- | ----------- | ------------ | ------------- |
| 1         | 1        | 20          | 32           | 38            |
| 1         | 2        | 20          | 27           | 44            |
| 1         | 3        | 13.4        | 20           | 40            |
| 1         | 10       | 10          | 10           | 60            |
| 2         | 4        | 23.4        | 40           | 35            |
| 2         | 7        | 25          | 25           | 60            |
| 2         | 8        | 23.4        | 15           | 94            |
| 3         | 5        | 10          | 15           | 40            |

Runner 1 had varying speeds, ranging from 38 km/h to 60 km/h, with quicker deliveries for shorter distances.
<br>Runner 2 displayed the highest peak speed of 94 km/h, but his speeds ranged significantly across deliveries (35 km/h to 94 km/h), indicating different travel conditions or urgency levels.
<br>Runner 3 maintained a steady average speed of 40 km/h, suggesting consistency in travel times.
<br>The data reveals that Runner 1 and Runner 3 maintain fairly consistent speeds across deliveries, indicating steady performance. However, Runner 2 shows significant fluctuations in speed, ranging from moderate to extremely fast. This inconsistency could be worth investigating—factors like route conditions, urgency of deliveries, or external influences may be affecting speed variations.

***

**7. What is the successful delivery percentage for each runner?**

````sql
SELECT 
    runner_id,	
    COUNT(order_id) AS total_orders,
    COUNT(pickup_time) AS orders_delivered,
    ROUND(COUNT(pickup_time) / COUNT(order_id) * 100) AS delivery_percentage
FROM runner_orders
GROUP BY runner_id;
````

#### Explanation:
- Using **COUNT**, we determined the total number of orders assigned to each runner and we also counted the number of successfully picked-up (delivered) orders.
- Applying the formula within the **ROUND** function, we calculated the successful delivery percentage for each runner.
- Using **GROUP BY**, we grouped data by runner_id to compute individual runner success rates.

#### Answer:
| runner_id | total_orders | orders_deliverd | delivery_percentage |
| --------- | ------------ | --------------- | ------------------- |
| 1         | 4            | 4               | 100                 |
| 2         | 4            | 3               | 75                  |
| 3         | 2            | 1               | 50                  |

Runner 1 had a 100% success rate, delivering all assigned orders.
<br>Runner 2 completed 75% of deliveries, missing one order.
<br>Runner 3 had a 50% success rate, successfully delivering only one of the two assigned orders.
