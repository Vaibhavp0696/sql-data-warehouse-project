--------------------------------- Performance Analysis ----------------------------------

-- Comparing the current value to target value
-- Help measure success and compare performance

/* Analyze the yearly performance of products by comparing their sales
to both the average sales perfomance of the product and the previous year's sales */

WITH yearly_product_sales AS(
	SELECT
	YEAR(f.Order_date) AS Order_year,
	p.Product_Name,
	SUM(f.Sales_Amount) AS Current_Sales
	FROM Gold.fact_Sales f
	LEFT JOIN Gold.dim_Products p
	ON f.Product_key = p.Product_Key 
	WHERE Order_Date IS NOT NULL
	GROUP BY 
	YEAR(f.order_date),
	p.product_Name
)
SELECT 
order_year, 
Product_Name,
current_sales,
AVG(Current_sales) OVER (Partition BY Product_Name) Avg_Sales,
Current_Sales - AVG(Current_sales) OVER (Partition BY Product_Name) AS diff_avg,
CASE WHEN current_sales - AVG(current_sales) OVER (Partition BY Product_Name) > 0 THEN 'Above_Avg'
     WHEN current_sales - AVG(current_sales) OVER (Partition BY Product_Name) < 0 THEN 'Below_Avg'
	 ELSE 'Avg'
END Avg_change,
-- Year-over-year Analysis
LAG(Current_sales) OVER (Partition BY Product_Name Order BY Order_year) AS py_sales, 
Current_Sales - LAG(Current_sales) OVER (Partition BY Product_Name Order BY Order_year)  AS diff_py,
CASE WHEN current_sales - LAG(Current_sales) OVER (Partition BY Product_Name Order BY Order_year) > 0 THEN 'Increase'
     WHEN current_sales - LAG(Current_sales) OVER (Partition BY Product_Name Order BY Order_year) < 0 THEN 'Decrease'
	 ELSE 'No Change'
END py_change
FROM yearly_product_sales
ORDER BY Product_Name, Order_year