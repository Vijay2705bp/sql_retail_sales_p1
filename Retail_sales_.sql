-- SQL Retail Sales Analysis - P1

CREATE DATABASE sql_project_p1;

-- Create TABLE
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
	(
			transactions_id	INT PRIMARY KEY,
			sale_date	DATE,
			sale_time	TIME,
			customer_id	INT,
			gender	VARCHAR(15),
			age	INT,
			category VARCHAR(15),
			quantiy	INT,
			price_per_unit FLOAT,	
			cogs	FLOAT,
			total_sale FLOAT

	)
	
TRUNCATE TABLE retail_sales;
SELECT * FROM retail_sales
LIMIT 10;

SELECT 
	COUNT(*) 
	FROM retail_sales;
	
SELECT * FROM retail_sales;

-- CHECKING IS THERE ANY NULL VALUES
SELECT * FROM retail_sales
WHERE transactions_id IS NULL;

SELECT * FROM retail_sales
WHERE sale_date IS NULL;

SELECT * FROM retail_sales
WHERE sale_time IS NULL;

--DATA cleaning
SELECT * FROM retail_sales
WHERE transactions_id IS NULL
	OR 
	sale_date IS NULL
	OR 
	sale_time IS NULL
	OR 
	customer_id IS NULL
	OR 
	gender IS NULL
	OR 
	age IS NULL
	OR 
	category IS NULL
	OR 
	quantiy IS NULL
	OR 
	price_per_unit IS NULL
	OR 
	cogs IS NULL
	OR 
	total_sale IS NULL
	;
	
	
--Deleting the NULL values
DELETE FROM retail_sales
WHERE transactions_id IS NULL
	OR 
	sale_date IS NULL
	OR 
	sale_time IS NULL
	OR 
	customer_id IS NULL
	OR 
	gender IS NULL
	OR 
	age IS NULL
	OR 
	category IS NULL
	OR 
	quantiy IS NULL
	OR 
	price_per_unit IS NULL
	OR 
	cogs IS NULL
	OR 
	total_sale IS NULL
	;
	
-- DATA EXPLORATION

--How many sales we have?
SELECT COUNT(*) AS total_sales FROM retail_sales;

--How many unique customers we have?
SELECT COUNT(DISTINCT(customer_id)) AS total_customers FROM retail_sales;

--How many unique category we have?
SELECT DISTINCT category FROM retail_sales;
 
 
-- Data Analysis & Business Key Problems and Answers

--Q.1 write a SQL query to retrieve all columns for sales made on '2022-11-05'
SELECT * FROM retail_sales
WHERE sale_date ='2022-11-05';

/*Q.2 write a SQL query to retrieve all transactions where the category is 'Clothing' 
and the quantity is sold more than 5 in a month of Nov-2022 */

SELECT * FROM retail_sales
WHERE 
	category = 'Clothing'
	AND 
	TO_CHAR(sale_date,'YYYY-MM') = '2022-11'
	AND 
	quantiy>=4;
	
--Q.3 write a SQL query to calculate the total sales (total_sale) in each category.

SELECT 
	category,SUM(total_sale) AS total_sales,COUNT(*) as total_orders
	FROM retail_sales
	GROUP BY CATEGORY;
	
--Q.4 write a SQL query to find the average of customers who purchased items from the 'Beauty' category
SELECT AVG(age) FROM retail_sales
WHERE category='Beauty';

SELECT 
	ROUND(AVG(age),2) AS avg_age 
	FROM retail_sales
	WHERE category='Beauty';
	
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT * FROM retail_sales
	WHERE total_sale>1000;
	
-- Q.6 Write a SQL query to find the total number of transactions(transaction_id) made by each gender in each category
SELECT category,gender,COUNT(*) AS total_trans 
	FROM retail_sales
	GROUP BY category,gender
	ORDER BY category;

-- Q.5 Write a SQL query to calculate the average sale for each month.Find out best selling month in each year.
SELECT 
	year,month,avg_sales 
	FROM
(
	SELECT
		EXTRACT(YEAR FROM sale_date) AS year,
		EXTRACT(MONTH FROM sale_date) AS month,
		AVG(total_sale) AS avg_sales,
		RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale)DESC)AS RANK
		FROM retail_sales
		GROUP BY 1,2
) AS t1
WHERE rank =1;
--ORDER BY 1,3 DESC;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales.

SELECT customer_id,SUM(total_sale) AS total_sales
	FROM retail_sales
	GROUP BY customer_id
	ORDER BY total_sales DESC LIMIT 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT 
	COUNT(DISTINCT customer_id) AS customer_id,
	category 
	FROM retail_sales
	GROUP BY category
;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <  12, Afternoon between 12 & 17, Evening >17)

WITH hourly_sale
as
(
	SELECT *,
		CASE 
			WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
			WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
			ELSE 'Evening '
		END as shift

	FROM retail_sales
)
SELECT shift,COUNT(transactions_id) as num_orders
FROM hourly_sale
GROUP BY shift;

--End of project