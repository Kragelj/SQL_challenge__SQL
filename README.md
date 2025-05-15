# SQL Challenge
This repository contains solutions for **#8WeekSQLChallenge**, which can be found here: [**SQL challenge**](https://8weeksqlchallenge.com/).
<br>Individual challenges present a diverse set of case studies, allowing us to develop, practice, and refine our SQL skills across various real-world scenarios.
<br>
<br>Throughout this SQL challenge, I worked extensively with **MySQL Workbench**, leveraging different SQL techniques to analyze and manipulate data efficiently. The case studies provided opportunities to explore complex queries, optimize performance, and improve data structuring.

## Key Learnings & SQL Skills Developed
Through solving case studies, I strengthened my ability to:
- Design structured, efficient queries and optimize data retrieval.
- Handle missing or inconsistent data using data cleaning techniques.
- Enhance query readability with CTEs and subqueries.
- Work effectively with window functions, aggregations, and ranking methods.
- Implement advanced filtering logic with CASE statements. 
- Use joins effectively to combine relational datasets.

This repository showcases sturctured SQL problem-solving, query optimization, and analytical skilly.
<br>If you’re exploring similar challenges or need an inspiration, feel free to browse through the solutions given.

## Overview of SQL Techniques Used
#### Data Cleaning & Transformation
Data cleaning was essential for ensuring accuracy and consistency across datasets. I used functions like:
- TRIM(), REPLACE(), and COALESCE() to handle missing values and standardize text data.
- CAST() and CONVERT() for datatype transformation when adjusting formats for analysis.

#### Aggregations & Grouping
To summarize and analyze large datasets, I utilized:
- COUNT(), SUM(), AVG(), MAX(), MIN() for numerical insights.
- GROUP BY and HAVING to segment and filter aggregated results.

#### Joins and Unions
Connecting multiple tables effectively was crucial for gaining valuable insights:
- INNER JOIN for retrieving matching records across multiple tables.
- Leveraged LEFT and RIGHT JOIN to preserve unmatched records in specific datasets.
- FULL OUTER JOIN where necessary to retrieve comprehensive comparisons across tables.
- UNION and UNION ALL to merge query results while distinguishing duplicate entries.

#### Common Table Expressions (CTEs) & Subqueries
To enhance query readability and performance:
- Used CTEs to break down complex queries into manageable steps.
- Applied subqueries within SELECT, WHERE, and FROM clauses to filter and preprocess data before main query execution.

#### Window Functions and Ranking
I incorporated window functions for analytical calculations without aggregating data into groups:
- ROW_NUMBER() for ranking data while preserving distinct entries.
- RANK() and DENSE_RANK() for ordering records efficiently based on specific criteria.

#### CASE Statements
Conditional logic within queries was applied through CASE statements to:
- Categorize data dynamically based on specific rules.
- Implement SUM(CASE WHEN ... THEN ...) for selective aggregation of records.
- Adjust filtering.

#### Date & Time Functions
For time-based calculations, I used:
- TIMESTAMPDIFF() to measure differences between timestamps.
- DATE_FORMAT() for transforming and presenting date-based data.
- WEEK(), MONTH(), DAYNAME() for temporal aggregations.

#### Filtering, Sorting & Optimization
Refining query outputs and structuring results effectively involved:
- WHERE clauses to filter datasets based on logical conditions.
- ORDER BY to arrange results for better readability.
- LIMIT to restrict query outputs for focused analysis.
