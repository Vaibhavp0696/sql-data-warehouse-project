---------------------------------- Part To Whole Analysis ------------------------------------

/* Analyze how an individual part is performing compared to the overall, allowing us to
   understand which category has the greatest impact on the business */

-- Which categories contribute the most to overall sales 

WITH category_sales AS(
SELECT
Category,
SUM(Sales_Amount) AS Total_Sales
FROM Gold.fact_Sales f
LEFT JOIN Gold.dim_Products p
ON p.Product_Key = f.Product_key
GROUP BY Category
)
SELECT
Category,
Total_sales,
SUM(Total_Sales) OVER () AS Overall_sales,
CONCAT(ROUND((CAST(total_sales AS FLOAT)/ SUM(Total_Sales) OVER() ) * 100, 2), '%') AS Percentage_of_Total
FROM category_sales
ORDER BY Total_Sales DESC



SELECT
Category,
Total_Orders,
SUM(Total_Orders) OVER () AS Overall_Orders,
CONCAT(ROUND((CAST(Total_Orders AS FLOAT) / SUM(Total_Orders) OVER ()) * 100, 2),'%') Per_of_Total
FROM
(
	SELECT
		Category,
		COUNT(Order_Number) AS Total_Orders
	FROM Gold.fact_Sales f
	LEFT JOIN Gold.dim_Products p
	ON p.Product_Key = f.Product_key
	GROUP BY Category
)t
ORDER BY Total_Orders DESC