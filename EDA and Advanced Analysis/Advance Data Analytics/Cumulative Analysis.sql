----------------------------------- Cumulative Analysis -------------------------------

-- Aggregate the data progressively over time..
-- Helps to understand whether our business is growing or declining..

-- Calculate the total sales per month
-- and the running total of sales over time

SELECT
Order_date,
Total_Sales,
SUM(Total_sales) OVER (ORDER BY Order_date) AS Running_Total_sales,
AVG(avg_price) OVER(ORDER BY Order_date) AS Moving_average_price
FROM(
SELECT
DATETRUNC(YEAR,Order_date) AS order_date,
SUM(sales_amount) AS Total_Sales,
AVG(price) AS avg_price
FROM Gold.fact_Sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(YEAR,Order_date)
)t 