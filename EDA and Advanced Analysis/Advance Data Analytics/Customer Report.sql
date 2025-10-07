/*
===============================================================================
Customer Report
===============================================================================
Purpose:
    - This report consolidates key customer metrics and behaviors

Highlights:
    1. Gathers essential fields such as names, ages, and transaction details.
	2. Segments customers into categories (VIP, Regular, New) and age groups.
    3. Aggregates customer-level metrics:
	   - total orders
	   - total sales
	   - total quantity purchased
	   - total products
	   - lifespan (in months)
    4. Calculates valuable KPIs:
	    - recency (months since last order)
		- average order value
		- average monthly spend
===============================================================================
*/

-- =============================================================================
-- Create Report: gold.report_customers
-- =============================================================================
IF OBJECT_ID('gold.report_customers', 'V') IS NOT NULL
    DROP VIEW gold.report_customers;
GO

CREATE VIEW gold.report_customers AS

WITH base_query AS(
/*---------------------------------------------------------------------------
1) Base Query: Retrieves core columns from tables
---------------------------------------------------------------------------*/
SELECT 
f.Order_Number,
f.Product_key,
f.Order_Date,
f.Sales_Amount,
f.Quantity,
c.customer_key,
c.customer_number,
CONCAT(c.first_name, ' ', c.last_name) AS Customer_Name,
DATEDIFF(year, c.birthdate, GETDATE()) Age
FROM Gold.fact_Sales f
LEFT JOIN Gold.dim_customers c
ON c.customer_key = f.Customer_key
WHERE Order_Date IS NOT NULL
)

, customer_aggregation AS (
/*---------------------------------------------------------------------------
2) Customer Aggregations: Summarizes key metrics at the customer level
---------------------------------------------------------------------------*/
SELECT
	Customer_Key,
	Customer_Number,
	Customer_Name,
	Age,
	COUNT(Distinct Order_Number) AS Total_Orders,
	SUM(Sales_Amount) AS Total_Sales,
	SUM(Quantity) AS Total_Quantity,
	COUNT(Distinct Product_key) AS Total_Products,
	MAX(Order_Date) Last_order,
	DATEDIFF(MONTH, Min(order_date), Max(order_date)) AS lifespan
FROM base_query
GROUP BY
	Customer_Key,
	Customer_Number,
	Customer_Name,
	Age
)
SELECT
customer_key,
customer_number,
customer_name,
age,
CASE 
	 WHEN age < 20 THEN 'Under 20'
	 WHEN age between 20 and 29 THEN '20-29'
	 WHEN age between 30 and 39 THEN '30-39'
	 WHEN age between 40 and 49 THEN '40-49'
	 ELSE '50 and above'
END AS age_group,
CASE 
    WHEN lifespan >= 12 AND total_sales > 5000 THEN 'VIP'
    WHEN lifespan >= 12 AND total_sales <= 5000 THEN 'Regular'
    ELSE 'New'
END AS customer_segment,
last_order,
DATEDIFF(month, last_order, GETDATE()) AS recency,
total_orders,
total_sales,
total_quantity,
total_products
lifespan,
-- Compuate average order value (AOV)
CASE WHEN total_sales = 0 THEN 0
	 ELSE total_sales / total_orders
END AS avg_order_value,
-- Compuate average monthly spend
CASE WHEN lifespan = 0 THEN total_sales
     ELSE total_sales / lifespan -- lifespan like months----==============
END AS avg_monthly_spend
FROM customer_aggregation

SELect * from gold.report_customers