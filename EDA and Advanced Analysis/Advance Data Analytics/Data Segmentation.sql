------------------------------------ DATA SEGMENTATION ----------------------------------------------

-- Group the data based on a specific range.
-- Helps to understand the correlation between two measures.

/* Segment products into cost ranges and count
how many products fall into each segement */

WITH product_segments AS (
SELECT 
Product_Key,
Product_Name,
Cost,
CASE WHEN Cost < 100 THEN 'Below 100'
	 WHEN Cost BETWEEN 100 AND 500 THEN '100 - 500'
	 WHEN Cost BETWEEN 500 AND 1000 THEN '500 - 1000'
	 ELSE 'Above 1000'
END Cost_Range
FROM Gold.dim_Products
)

SELECT 
Cost_Range,
COUNT(Product_Key) AS Total_Products
FROM product_segments
GROUP BY Cost_Range
ORDER BY Total_Products DESC

/* Group Customers into three segments based on their spending behavior :
   - VIP: Customers with atleast 12 months of history and spending more than 5000.
   - Regular: Customers with atleast 12 months of history but spending 5000 or less.
   - New: Customers with a lifespan less than 12 months.
And find the total number of customers by each group
*/

WITH Customer_spending AS (
SELECT
c.Customer_Key,
SUM(f.Sales_Amount) AS Total_Spending,
MIN(order_date) AS First_order,
MAX(order_date) AS Last_Order,
DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan
FROM Gold.fact_Sales f
LEFT JOIN Gold.dim_customers c
ON f.customer_key = c.Customer_key
GROUP BY c.customer_key
) 

SELECT
Customer_segment, 
COUNT(Customer_key) AS Total_Customers
FROM(
	SELECT 
	Customer_Key,
	Total_Spending,
	Lifespan,
	CASE WHEN lifespan >= 12 AND Total_Spending > 5000 THEN 'VIP'
		 WHEN lifespan >= 12 AND Total_Spending <= 5000 THEN 'Regular'
		 ELSE 'New'
	END Customer_Segment
	FROM Customer_spending
)t
GROUP BY Customer_Segment
ORDER BY Total_Customers DESC