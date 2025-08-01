              -- Creating The Database --
			  
create database Project_RetailAnalysis;


               -- Creating the Table--

drop table if exists retail_sales;
Create Table retail_sales
(
transactions_id	INT PRIMARY KEY,
sale_date DATE,	
sale_time TIME,	
customer_id	INT,
gender VARCHAR(15),	
age	INT,
category VARCHAR(15),	
quantiy	INT,
price_per_unit FLOAT,	
cogs FLOAT,	
total_sale FLOAT
);

Select * from retail_sales;

              
			  
			  -- Cleaning the Data --

select * from retail_sales
where
		transactions_id is NULL
		OR
		sale_date is NULL
		OR
		sale_time is NULL
		OR
		customer_id is NULL
		OR
		gender is NULL
		OR
		age is NULL
		OR
		category is NULL
		OR
		quantiy is NULL
		OR
		price_per_unit is NULL
		OR
		cogs is NULL
		OR 
		total_sale is NULL;
		
		
Delete from retail_sales
where
        transactions_id is NULL
		OR
		sale_date is NULL
		OR
		sale_time is NULL
		OR
		customer_id is NULL
		OR
		gender is NULL
		OR
		age is NULL
		OR
		category is NULL
		OR
		quantiy is NULL
		OR
		price_per_unit is NULL
		OR
		cogs is NULL
		OR 
        total_sale is NULL;



                    -- Exploring the Data --

-- How many sales do we have? --

select count(*) as total_sale from retail_sales;

-- How many Unique Customers are there? --

select count(distinct customer_id) as unique_customers from retail_sales;


-- How many Categories are there? --

select count(distinct category) as Categories from retail_sales;


		

          -- Key Business Problems and their Answers (Data Analysis) --
		  
--1. What were the sales in the months of November and December?

SELECT 
    EXTRACT(MONTH FROM sale_date) AS Month,
    SUM(total_sale) AS total_sales
FROM retail_sales
WHERE EXTRACT(MONTH FROM sale_date) IN (11, 12)
GROUP BY EXTRACT(MONTH FROM sale_date)
ORDER BY Month;

--2. Are festive season promotions in November and December 2023 influencing 
--   small basket sizes across different categories, compared to the
--   same festive period in 2022?

SELECT 
    category,
    TO_CHAR(sale_date, 'YYYY-MM') AS sale_month_year,
    COUNT(*) AS small_basket_orders,
    ROUND(AVG(quantiy)::Numeric, 2) AS avg_quantity_per_order
FROM retail_sales
WHERE quantiy BETWEEN 1 AND 3
  AND TO_CHAR(sale_date, 'YYYY-MM') IN ('2022-11', '2022-12', '2023-11', '2023-12')
GROUP BY category, TO_CHAR(sale_date, 'YYYY-MM')
ORDER BY category, sale_month_year;

--3. Which product categories generate the highest revenue and number of orders?

SELECT 
    category, 
    SUM(total_sale) AS revenue, 
    COUNT(transactions_id) AS order_count
FROM retail_sales
GROUP BY category
ORDER BY revenue DESC, order_count DESC;

-- 4. What is the average age of customers buying beauty products — 
--   are we attracting younger or older demographics?

Select ROUND(AVG(age)::Numeric,2) as Avg_Age from retail_sales
Where category = 'Beauty';

-- 5. Which high-value transactions (above 1000) should be 
--    flagged for potential VIP customer treatment?

Select * from retail_sales
Where total_sale > 1000;

--6.  How does gender influence product 
--    category preferences in terms of number of purchases?

Select 
gender, category, 
Sum(quantiy) as Total_Items_Purchased, 
Count(transactions_id) as purchase_count
from retail_sales
group by gender, category
Order by gender, category desc;

--7.  Which month in each year had the highest average sale value — 
--    indicating peak sales efficiency?


Select 
Year, Month, Avg_Sales, Rank from 
(Select 
	   Extract(Year from sale_date) as Year,
	   Extract(Month from sale_date) as Month,
	   ROUND(AVG(total_sale)::Numeric,2) as Avg_Sales,
	   Rank() OVER(Partition by Extract(Year from sale_date) order by ROUND(AVG(total_sale)::Numeric,2) Desc)
	   as Rank
	   FROM retail_sales
Group by 1,2) as T1
where rank=1;

--8. Who are our top 5 revenue-generating customers — 
--   potential for loyalty programs?

Select customer_id, SUM(total_sale) as total_sale 
from retail_sales
Group by customer_id
order by total_sale desc
Limit 5;

--9. How many unique customers contributed to sales 
--   in each product category — revealing category reach?

Select category, Count(Distinct customer_id) as Unique_Customers
From retail_sales
group by category;

--10. Which time of day (morning, afternoon, evening) 
--    sees the highest sales activity — useful for staffing?

With Hourly_sales AS
(Select *,
        CASE
		When Extract(Hour from sale_time) < 12 then 'Morning'
		When Extract(Hour from sale_time) between 12 and 17 then 'Afternoon'
		Else 'Evening'
End as Shift
From retail_sales)
Select Shift, Count(transactions_id) as sales_activity from Hourly_Sales
Group by Shift
Order by sales_activity desc;



		
		

	   
	   












