--------------------------------- Ranking Analysis ---------------------------------------------

-- Order the values of dimensions by measure.
-- Top N performers | Bottom N Performers.

-- Which 5 products generate the highest revenue?

SELECT TOP 5 
SUM(f.Sales_Amount) Total_Revenue,
p.Product_Name
FROM Gold.fact_Sales f
LEFT JOIN Gold.dim_Products p
ON  p.Product_Key = f.Product_key
GROUP BY p.Product_Name
Order BY Total_Revenue DESC

SELECT 
* FROM (
	SELECT 
	SUM(f.Sales_Amount) Total_Revenue,
	p.Product_Name,
	ROW_NUMBER() OVER ( ORDER BY SUM(f.Sales_Amount)) Rank_products
	FROM Gold.fact_Sales f
	LEFT JOIN Gold.dim_Products p
	ON  p.Product_Key = f.Product_key
	GROUP BY p.Product_Name)t
	WHERE Rank_products <= 5

-- What are the 5 worst-performing products in term of sales?

SELECT TOP 5
SUM(f.Sales_Amount) Total_Revenue,
p.Product_Name
FROM Gold.fact_Sales f
LEFT JOIN Gold.dim_Products p
ON  p.Product_Key = f.Product_key
GROUP BY p.Product_Name
Order BY Total_Revenue ASC

-- Find the top 10 customers who have generated the highest revenue
SELECT TOP 10
c.customer_key,
c.First_Name,
c.Last_Name,
SUM(f.Sales_Amount) AS total_revenue
FROM Gold.fact_Sales f
LEFT JOIN Gold.dim_customers c
ON c.customer_key = f.Customer_key
GROUP BY 
c.customer_key,
c.First_Name,
c.Last_Name
ORDER BY total_revenue DESC

-- The 3 customers with the fewest orders placed

SELECT TOP 3
c.customer_key,
c.First_Name,
c.Last_Name,
Count(DISTINCT Order_Number) AS total_order
FROM Gold.fact_Sales f
LEFT JOIN Gold.dim_customers c
ON c.customer_key = f.Customer_key
GROUP BY 
c.customer_key,
c.First_Name,
c.Last_Name
ORDER BY total_order 