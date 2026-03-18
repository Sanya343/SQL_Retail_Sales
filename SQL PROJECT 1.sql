-- Creating Database
CREATE DATABASE Sql_Project_2;

-- Creating staging table
DROP TABLE IF EXISTS retail_sales_staging;

CREATE TABLE retail_sales_staging (
    transactions_id VARCHAR(50),
    sale_date VARCHAR(50),
    sale_time VARCHAR(50),
    customer_id VARCHAR(50),
    gender VARCHAR(50),
    age VARCHAR(50),
    category VARCHAR(100),
    quantiy VARCHAR(50),
    price_per_unit VARCHAR(50),
    cogs VARCHAR(50),
    total_sale VARCHAR(50)
);

SELECT count(*) FROM retail_sales_staging;


-- Cheking for bad rows
SELECT *
FROM retail_sales_staging
WHERE TRIM(age) = ''
   OR TRIM(quantiy) = ''
   OR TRIM(price_per_unit) = ''
   OR TRIM(cogs) = ''
   OR TRIM(total_sale) = '';


-- Creating Final table
DROP TABLE IF EXISTS retail_sales;

CREATE TABLE retail_sales (
    transactions_id INT PRIMARY KEY,
    sale_date DATE NOT NULL,
    sale_time TIME NOT NULL,
    customer_id INT NOT NULL,
    gender VARCHAR(10) NOT NULL,
    age INT NULL,
    category VARCHAR(50) NOT NULL,
    quantiy INT NULL,
    price_per_unit DECIMAL(10,2) NULL,
    cogs DECIMAL(10,2) NULL,
    total_sale DECIMAL(10,2) NULL
);

-- Inserting data from staging to final
INSERT INTO retail_sales (
    transactions_id,
    sale_date,
    sale_time,
    customer_id,
    gender,
    age,
    category,
    quantiy,
    price_per_unit,
    cogs,
    total_sale
)
SELECT
    CAST(transactions_id AS UNSIGNED),
    STR_TO_DATE(sale_date, '%Y-%m-%d'),
    sale_time,
    CAST(customer_id AS UNSIGNED),
    TRIM(gender),
    CASE 
        WHEN TRIM(age) = '' THEN NULL
        ELSE CAST(age AS UNSIGNED)
    END,
    TRIM(category),
    CASE 
        WHEN TRIM(quantiy) = '' THEN NULL
        ELSE CAST(quantiy AS UNSIGNED)
    END,
    CASE 
        WHEN TRIM(price_per_unit) = '' THEN NULL
        ELSE CAST(price_per_unit AS DECIMAL(10,2))
    END,
    CASE 
        WHEN TRIM(cogs) = '' THEN NULL
        ELSE CAST(cogs AS DECIMAL(10,2))
    END,
    CASE 
        WHEN TRIM(total_sale) = '' THEN NULL
        ELSE CAST(total_sale AS DECIMAL(10,2))
    END
FROM retail_sales_staging;
SELECT * FROM retail_sales;
SELECT COUNT(*) FROM RETAIL_SALES;

-- DATA Cleaning Step
SELECT * FROM retail_sales
WHERE 
    transactions_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantiy IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;
    
-- Deleting rows with null values
DELETE FROM retail_sales
WHERE 
    transactions_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantiy IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;

SELECT COUNT(*) FROM retail_sales;


-- Data Exploration
-- How many sales do we have
SELECT COUNT(*) AS Total_Sale FROM retail_sales;

-- How many customers do we have?
SELECT COUNT(DISTINCT(customer_id))  AS Unique_Customers FROM retail_sales;

-- How many categories do we have
SELECT DISTINCT(CATEGORY) AS Total_Unique_Categories FROM RETAIL_SALES;

-- Data Analysis & Business Key Problems & Answers

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
SELECT *
FROM retail_sales 
WHERE sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
SELECT *
FROM retail_sales
WHERE category = 'Clothing'
  AND DATE_FORMAT(sale_date, '%Y-%m') = '2022-11'
  AND quantiy > 2;

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

SELECT Category, 
SUM(total_sale) AS Total_Sales
 FROM retail_sales 
 GROUP BY category;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

SELECT 
AVG(AGE) AS AVG_AGE 
FROM retail_sales 
WHERE category = 'Beauty';

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT * FROM RETAIL_SALES WHERE TOTAL_SALE> 1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT CATEGORY, GENDER, 
COUNT(*) AS TOTAL_TRANSACTIONS 
FROM RETAIL_SALES 
GROUP BY CATEGORY, GENDER;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
SELECT
YEAR(sale_date) AS year,
 MONTH(SALE_DATE) AS month,
 AVG(total_SALE) as avg_sale
 FROM retail_sales 
 GROUP BY YEAR(sale_date), MONTH(SALE_DATE) 
 ORDER BY Year, month;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 

SELECT  
customer_ID , sum(total_sale)
FROM retail_sales 
GROUP BY CUSTOMER_ID 
ORDER BY SUM(TOTAL_SALE) 
LIMIT 5;


-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

SELECT category, 
count(distinct(customer_id)) AS Unique_Customers 
FROM retail_sales 
Group By Category;


-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)

WITH HOURLY_SALES
 AS 
(
SELECT *,
    CASE 
        WHEN HOUR(sale_time) < 12 THEN 'Morning'
        WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS shift
FROM retail_sales
) 
SELECT SHIFT, COUNT(*) AS TOTAL_ORDERS FROM HOURLY_SALES GROUP BY SHIFT;

-- END OF PROJECT