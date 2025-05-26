# Case Study #1: Danny's Diner 

This case study is taken from the website [SQL challenge](https://8weeksqlchallenge.com/case-study-1/).
<br>This is the **first case study**.

## Introduction
Danny wants insights into customer behavior, spending, and favorite menu items to enhance personalization and assess loyalty program expansion.
He needs help generating basic datasets for easy inspection. He has shared samples of three datasets: *sales*, *menu*, and *members*.

## Database and Tables
We will be using MySQL Workbench as our primary editor.
Please note that MySQL differs in syntax and functionality from other SQL platforms, so we have made a few necessary adjustments to ensure compatibility.

````sql
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
	product_id INT PRIMARY KEY,
	product_name VARCHAR(20),
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
````

## Questions

**1. What is the total amount each customer spent at the restaurant?**

````sql
SELECT
	customer_id,
    SUM(price) as total
FROM sales s
INNER JOIN menu m
    ON m.product_id = s.product_id
GROUP BY customer_id;
````

#### Explanation:
- With **INNER JOIN** we merged two tables. (Althought **JOIN** is functionally equivalent to **INNER JOIN**, we use the longer form for better readability and clearity.)
- With the **SUM** function we calculated the total price paid by each customer.
- Using **GROUP BY** aggregated results by customers. 

#### Answer:
| customer_id | total |
| ----------- | ----- |
| A           | 76    |
| B           | 74    |
| C           | 36    |

Customer A spent $76.
<br>Customer B spent $74.
<br>Customer C spent $36.

***

**2. How many days has each customer visited the restaurant?**

````sql
SELECT
	customer_id,
	COUNT(DISTINCT order_date) as visits
FROM sales 
GROUP BY customer_id;
````

#### Explanation:
- Using **COUNT DISTINCT**, we determined the number of unique visits made by each customer on a given day, ensuring duplicate visits are excluded.
- With **GROUP BY**, we organized the data by customer, allowing us to track individual visit frequencies efficiently.

#### Answer:
| customer_id | visits |
| ----------- | ------ |
| A           | 4      |
| B           | 6      |
| C           | 2      |

Customer A visited 4 times.
<br>Customer B visited 6 times.
<br>Customer C visited 2 times.

***

**3. What was the first item from the menu purchased by each customer?**

````sql
WITH cte_orders AS (
	SELECT
		customer_id,
		order_date,
		product_name,
		ROW_NUMBER() OVER (PARTITION BY customer_id 
			ORDER BY order_date) AS rank_num
	FROM sales s
	INNER JOIN menu m
		ON m.product_id = s.product_id
)

SELECT 
	customer_id,
	product_name
FROM cte_orders
WHERE rank_num = 1;
````

#### Explanation:
- With the Common Table Expression (CTE) named `cte_orders`, we created a new column rank_num, assigning row numbers with the **ROW_NUMBER** window function. With the **PARTITION BY** clause, we grouped the data by customer_id, ensuring row numbering is specific to each customer.
- Using the **ORDER BY** statement, we organized rows within each partition, determining order priority for ranking.
- In the following main query, we selected relevant columns and applied a **WHERE** filter, displaying only the first rows (where the row number equals 1).

#### Answer:
| customer_id | product_name | 
| ----------- | ------------ |
| A           | sushi        | 
| B           | curry        | 
| C           | ramen        |

First order of Customer A is sushi.
<br>First order of Customer B is curry.
<br>First order of Customer C is ramen.

***

**4. What is the most purchased item on the menu and how many times was it purchased by all customers?**

````sql
SELECT 
	product_name AS most_purchased_item,
	COUNT(s.product_id) AS purchased_volume
FROM sales s
INNER JOIN menu m
	ON s.product_id = m.product_id
GROUP BY m.product_name
ORDER BY purchased_volume DESC
LIMIT 1;
````

#### Explanation:
- Using the **COUNT** aggregation function, we calculated the total quantity of purchased items, providing a clear measure of sales volume.
- With **ORDER BY** in descending order, we prioritized the most frequently purchased items, ensuring they appear at the top of the list.
- Applying the **LIMIT** clause, we narrowed the results to display only the highest-ranking purchased items, focusing on top selections efficiently.

#### Answer:
| most_purchased_item | product_volume | 
| ------------------- | -------------- |
| ramen               | 8              |

Most purchased item on the menu is ramen with 8 purchases.

***

**5. Which item was the most popular for each customer?**

````sql
WITH cte_popular_item AS (
	SELECT
		customer_id,
		product_name,
		COUNT(s.product_id) AS ordered,
		DENSE_RANK() OVER (PARTITION BY customer_id 
			ORDER BY COUNT(s.product_id) DESC) AS rank_num
	FROM sales s
	INNER JOIN menu m
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
````

#### Explanation:
- With the CTE named `cte_popular_item`, we joined the sales and menu tables, allowing us to analyze item popularity effectively.
- Applying the **DENSE_RANK()** window function, we assigned a ranking to each customer based on the **COUNT** of orders, ensuring that items with the same order frequency receive the same rank while maintaining distinct ranking levels.
- In the following main query, we selected relevant columns and used a filter in the **WHERE** clause to display only the highest-ranked items, ensuring we focus exclusively on the most frequently purchased choices.

#### Answer:
| customer_id | product_name | ordered |
| ----------- | ------------ |-------  |
| A           | ramen        |  3      |
| B           | curry        |  2      |
| B           | sushi        |  2      |
| B           | ramen        |  2      |
| C           | ramen        |  3      |

Most popular item of Customer A is ramen.
<br>Most popular item of Customer B are all the items on the menu - curry, sushi, and ramen.
<br>Most popular item of Customer C is ramen.

***

**6. Which item was purchased first by the customer after they became a member?**

```sql
WITH cte_becoming_member AS (
	SELECT
		s.customer_id,
		order_date,
        join_date,
		product_id,
		ROW_NUMBER() OVER (PARTITION BY s.customer_id
			ORDER BY order_date) as rank_num
	FROM sales s
	INNER JOIN members m
		ON m.customer_id = s.customer_id
		AND order_date >= join_date
)

SELECT 
	customer_id,
	product_name,
	order_date,
    join_date
FROM cte_becoming_member bm
INNER JOIN menu m
	ON m.product_id = bm.product_id
	AND rank_num = 1
ORDER BY customer_id ASC;
```

#### Explanation:
- With the CTE named `cte_becoming_member`, we selected relevant columns and applied the **ROW_NUMBER** window function to assign a unique rank to each customer. With the **PARTITION BY** clause, we grouped the data by customer, and order it chronologically by date with **ORDER BY** clause.
- Applying **INNER JOIN**, we combined the members and sales tables. Additionally, we applied a **WHERE** clause to ensure that only sales occurring on or after the date a customer became a member are included.
- In the following query, we merged the CTE with the menu table, where we applied a filter so that only the first recorded transaction for each customer was retrieved.
- Using **ORDER BY**, we ordered the final output by customer in ascending order.

#### Answer:
| customer_id | product_name | order_date | join_date  |
| ----------- | ------------ | ---------- | ---------- |
| A           | curry        | 2021-01-07 | 2021-01-07 |
| B           | sushi        | 2021-01-11 | 2021-01-09 |

Customer A became a member on 2021-01-07 and his first order was curry.
<br>Customer B became a member on 2021-01-09 and his first order was sushi.

***

**7. Which item was purchased just before the customer became a member?**

````sql
WITH cte_before_being_member AS (
	SELECT
		s.customer_id,
        product_id,
		order_date,
		join_date,
		ROW_NUMBER() OVER (PARTITION BY s.customer_id
			ORDER BY order_date DESC) AS rank_num
	FROM sales s
	INNER JOIN members m
		ON m.customer_id = s.customer_id
		AND order_date < join_date
)

SELECT 
	customer_id,
	product_name,
	order_date, 
	join_date
FROM cte_before_being_member bbm
INNER JOIN menu m
	ON m.product_id = bbm.product_id
	AND rank_num = 1
ORDER BY customer_id ASC;
````

#### Explanation:
- With the CTE named `cte_before_being_member`, we selected our columns and calculate the rank with the **ROW_NUMBER()** window function. The rank is determined based on the order dates in descending order.
- With **INNER JOIN** we merged sales and members tables, only including sales that were made before the customer became a member.
- In the following querry we used **INNER JOIN** to merge our CTE with the menu table, using a filter to include only the rows where the rank number is 1.
- Using **ORDER BY** we ordered the list by customer in ascending order.

#### Answer:
| customer_id | product_name | order_date | join_date  |
| ----------- | ------------ | ---------- | ---------- |
| A           | sushi        | 2021-01-01 | 2021-01-07 |
| B           | sushi        | 2021-01-04 | 2021-01-09 |

Customers A and B both ordered sushi before becoming members.

***

**8. What is the total items and amount spent for each member before they became a member?**

```sql
SELECT
	s.customer_id,
	COUNT(s.product_id) AS total_items,
	SUM(m.price) AS amount_spent
FROM sales s
INNER JOIN members mb
	ON mb.customer_id = s.customer_id
	AND mb.join_date > s.order_date
INNER JOIN menu m
	ON m.product_id = s.product_id
GROUP BY s.customer_id;
```

#### Explanation:
- We calculated the **SUM** of the prices for all the items bought (using **COUNT** method) for each customer, that became a member later on.
- We used **INNER JOIN** statement to merge sales and members tables, where the order date is prior to becoming a member. And we also added the menu table.
- Using **GROUP BY** we aggregated results by customers.

#### Answer:
| customer_id | total_items | amount_spent |
| ----------- | ----------- |------------  |
| A           | 2           | 25           |
| B           | 3           | 40           |

Customer A spent $25 on 2 items before becoming a member.
<br>Customer B spent $40 on 3 items before becoming a member.

***

**9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier — how many points would each customer have?**

```sql
SELECT
	customer_id,
	SUM(CASE
		WHEN s.product_id = 1 THEN price*20
		ELSE price*10 
	END) AS total_points
FROM sales s
INNER JOIN menu m
	ON m.product_id = s.product_id
GROUP BY customer_id;
```

#### Explanation:
- We calculated the **SUM** of the points for all the products.
- A **CASE** statment was used to give 10 or 2O points for different products.
- We used **INNER JOIN** statement to merge sales and menu tables, so we could define what was bought by each customer.
- Using **GROUP BY** we aggregated results by customers.

#### Answer:
| customer_id | total_points | 
| ----------- | ------------ |
| A           | 860          |
| B           | 940          |
| C           | 360          |

Customer A gained a total of 860 points.
<br>Customer B gained a total of 940 points.
<br>Customer C gained a total of 360 points.
