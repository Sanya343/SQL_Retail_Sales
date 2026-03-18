# SQL_Retail_Sales
# Project Overview
This project focuses on analyzing retail sales data using MySQL to extract meaningful business insights.
The workflow includes data ingestion, cleaning, transformation, and analysis using SQL.

The project demonstrates real-world data engineering + data analytics practices, including handling missing values, staging tables, and performing business-driven queries.

# Objectives
Set up a retail sales database: Create and populate a retail sales database with the provided sales data.
Data Cleaning: Identify and remove any records with missing or null values.
Exploratory Data Analysis (EDA): Perform basic exploratory data analysis to understand the dataset.
Business Analysis: Use SQL to answer specific business questions and derive insights from the sales data.

# Dataset Description

The dataset contains retail transaction-level data with the following fields:

transactions_id – Unique transaction identifier
sale_date – Date of transaction
sale_time – Time of transaction
customer_id – Unique customer identifier
gender – Customer gender
age – Customer age
category – Product category (Clothing, Beauty, etc.)
quantiy – Quantity sold
price_per_unit – Price per unit
cogs – Cost of goods sold
total_sale – Total revenue from transaction

# Project Structure
# 1. Database Setup
Database Creation: The project starts by creating a database named p1_retail_db.
Table Creation: A table named retail_sales is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

 '''SQL
CREATE DATABASE p1_retail_db;

CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);
'''
# 2. Data Exploration & Cleaning
Record Count: Determine the total number of records in the dataset.
Customer Count: Find out how many unique customers are in the dataset.
Category Count: Identify all unique product categories in the dataset.
Null Value Check: Check for any null values in the dataset and delete records with missing data.
SELECT COUNT(*) FROM retail_sales;
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;
SELECT DISTINCT category FROM retail_sales;

SELECT * FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

DELETE FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

# 3. Data Analysis & Findings
The following SQL queries were developed to answer specific business questions:

# Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
SELECT *
FROM retail_sales 
WHERE sale_date = '2022-11-05';

# Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
SELECT *
FROM retail_sales
WHERE category = 'Clothing'
  AND DATE_FORMAT(sale_date, '%Y-%m') = '2022-11'
  AND quantiy > 2;

# Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

SELECT Category, 
SUM(total_sale) AS Total_Sales
 FROM retail_sales 
 GROUP BY category;

# Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

SELECT 
AVG(AGE) AS AVG_AGE 
FROM retail_sales 
WHERE category = 'Beauty';

# Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT * FROM RETAIL_SALES WHERE TOTAL_SALE> 1000;

 # Q6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT CATEGORY, GENDER, 
COUNT(*) AS TOTAL_TRANSACTIONS 
FROM RETAIL_SALES 
GROUP BY CATEGORY, GENDER;

# Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
SELECT
YEAR(sale_date) AS year,
 MONTH(SALE_DATE) AS month,
 AVG(total_SALE) as avg_sale
 FROM retail_sales 
 GROUP BY YEAR(sale_date), MONTH(SALE_DATE) 
 ORDER BY Year, month;

# Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 

SELECT  
customer_ID , sum(total_sale)
FROM retail_sales 
GROUP BY CUSTOMER_ID 
ORDER BY SUM(TOTAL_SALE) 
LIMIT 5;


# Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

SELECT category, 
count(distinct(customer_id)) AS Unique_Customers 
FROM retail_sales 
Group By Category;


# Q.10 Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)

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


# Findings
Customer Demographics: The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing and Beauty.
High-Value Transactions: Several transactions had a total sale amount greater than 1000, indicating premium purchases.
Sales Trends: Monthly analysis shows variations in sales, helping identify peak seasons.
Customer Insights: The analysis identifies the top-spending customers and the most popular product categories.

# Reports
Sales Summary: A detailed report summarizing total sales, customer demographics, and category performance.
Trend Analysis: Insights into sales trends across different months and shifts.
Customer Insights: Reports on top customers and unique customer counts per category.

# Conclusion
This project serves as a comprehensive introduction to SQL for data analysts, covering database setup, data cleaning, exploratory data analysis, and business-driven SQL queries. The findings from this project can help drive business decisions by understanding sales patterns, customer behavior, and product performance.

How to Use
Clone the Repository: Clone this project repository from GitHub.
Set Up the Database: Run the SQL scripts provided in the database_setup.sql file to create and populate the database.
Run the Queries: Use the SQL queries provided in the analysis_queries.sql file to perform your analysis.
Explore and Modify: Feel free to modify the queries to explore different aspects of the dataset or answer additional business questions.











