

````md
# Retail Sales Analysis using SQL

## Overview
This project performs a complete **Retail Sales Analysis using SQL**.  
The objective is to load transactional retail data, clean invalid records, explore the dataset, and answer key business questions using SQL queries.

The analysis covers **data cleaning, exploratory analysis, and 10 business-driven SQL queries (Q1–Q10)**.

---

## Objectives
- Create and structure a retail sales database table
- Identify and remove records with missing values
- Perform basic exploration on customers and product categories
- Answer real-world business questions using SQL (filtering, aggregation, window functions)

---

## Dataset
- **File:** `SQL - Retail Sales Analysis_utf .csv`


The dataset contains transaction-level retail sales data including:
- Date and time of sale
- Customer demographics
- Product category
- Quantity, price, cost, and total sale amount

---

## Table Schema

```sql
DROP TABLE IF EXISTS retail_sales;

CREATE TABLE retail_sales
(
    transaction_id INT PRIMARY KEY,
    sale_date DATE,
    sale_time TIME,
    customer_id INT,
    gender VARCHAR(15),
    age INT,
    category VARCHAR(15),
    quantity INT,
    price_per_unit FLOAT,
    cogs FLOAT,
    total_sale FLOAT
);
````

---

## Data Cleaning (Handling NULL Values)

```sql
SELECT *
FROM retail_sales
WHERE
    transaction_id IS NULL OR
    sale_date IS NULL OR
    sale_time IS NULL OR
    customer_id IS NULL OR
    gender IS NULL OR
    age IS NULL OR
    category IS NULL OR
    quantity IS NULL OR
    price_per_unit IS NULL OR
    cogs IS NULL OR
    total_sale IS NULL;

DELETE FROM retail_sales
WHERE
    transaction_id IS NULL OR
    sale_date IS NULL OR
    sale_time IS NULL OR
    customer_id IS NULL OR
    gender IS NULL OR
    age IS NULL OR
    category IS NULL OR
    quantity IS NULL OR
    price_per_unit IS NULL OR
    cogs IS NULL OR
    total_sale IS NULL;
```

---

## Exploratory Analysis

```sql
-- Total number of sales
SELECT COUNT(*) AS total_sales FROM retail_sales;

-- Total unique customers
SELECT COUNT(DISTINCT customer_id) AS total_customers FROM retail_sales;

-- Distinct product categories
SELECT DISTINCT category FROM retail_sales;
```

---

## Business Problems and Solutions

### Q1. Retrieve all sales made on `2022-11-05`

```sql
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';
```

---

### Q2. Retrieve all `Clothing` transactions in November 2022 with quantity ≥ 4

```sql
SELECT *
FROM retail_sales
WHERE category = 'Clothing'
  AND TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
  AND quantity >= 4;
```

---

### Q3. Calculate total sales and total number of orders for each category

```sql
SELECT
    category,
    SUM(total_sale) AS net_sale,
    COUNT(*) AS total_orders
FROM retail_sales
GROUP BY category;
```

---

### Q4. Find the average age of customers who purchased from the `Beauty` category

```sql
SELECT
    ROUND(AVG(age), 2) AS avg_age
FROM retail_sales
WHERE category = 'Beauty';
```

---

### Q5. Find all transactions where total sale value is greater than 1000

```sql
SELECT *
FROM retail_sales
WHERE total_sale > 1000;
```

---

### Q6. Find the total number of transactions by gender in each category

```sql
SELECT
    category,
    gender,
    COUNT(*) AS total_transactions
FROM retail_sales
GROUP BY category, gender
ORDER BY category;
```

---

### Q7. Find the best-selling month in each year (based on average total sale)

```sql
SELECT
    year,
    month,
    avg_sale
FROM (
    SELECT
        EXTRACT(YEAR FROM sale_date) AS year,
        EXTRACT(MONTH FROM sale_date) AS month,
        AVG(total_sale) AS avg_sale,
        RANK() OVER (
            PARTITION BY EXTRACT(YEAR FROM sale_date)
            ORDER BY AVG(total_sale) DESC
        ) AS rank
    FROM retail_sales
    GROUP BY year, month
) ranked_sales
WHERE rank = 1;
```

---

### Q8. Find the top 5 customers based on total sales

```sql
SELECT
    customer_id,
    SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;
```

---

### Q9. Find the number of unique customers in each category

```sql
SELECT
    category,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sales
GROUP BY category;
```

---

### Q10. Create sales shifts (Morning, Afternoon, Evening) and count orders per shift

```sql
WITH hourly_sales AS (
    SELECT *,
        CASE
            WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
            WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
        END AS shift
    FROM retail_sales
)
SELECT
    shift,
    COUNT(*) AS total_orders
FROM hourly_sales
GROUP BY shift;
```

---

## Conclusion

This project demonstrates how SQL can be used to:

* Clean and prepare real-world retail data
* Analyze customer behavior and category performance
* Identify high-value customers and peak sales periods
* Perform time-based and demographic analysis

The analysis can be further extended by adding:

* Profit calculations (`total_sale - cogs`)
* Monthly trend analysis
* Customer lifetime value (CLV) estimation

---

## Author

**Akshay Pawar**


```


