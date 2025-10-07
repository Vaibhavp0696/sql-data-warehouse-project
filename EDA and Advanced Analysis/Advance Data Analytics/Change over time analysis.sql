------------------------------ Chnage Over Time --------------------------------------

-- Analyze how a measure evolves over time.
-- Helps Track trends and identify seasonality in your data.

SELECT
YEAR(order_date) AS Order_Year,
SUM(sales_amount) AS Total_Sales,
COUNT(Customer_Key) AS Total_customers,
SUM(Quantity) AS Total_quantity
FROM Gold.fact_Sales
WHERE Order_Date IS NOT NULL
GROUP BY YEAR(Order_Date)
ORDER BY YEAR(Order_Date)

------------------------------------ FOR MONTHS ---------------------------------------

SELECT
DATETRUNC(MONTH, order_date) AS Order_date,
SUM(sales_amount) AS Total_Sales,
COUNT(Customer_Key) AS Total_customers,
SUM(Quantity) AS Total_quantity
FROM Gold.fact_Sales
WHERE Order_Date IS NOT NULL
GROUP BY DATETRUNC(MONTH, order_date)
ORDER BY DATETRUNC(MONTH, order_date)

-- How many new customers were added each year

SELECT
DATETRUNC(year, create_date) AS Create_year,
COUNT (Customer_Key) AS Total_Customers
FROM Gold.dim_customers
GROUP BY DATETRUNC(year, create_date)
ORDER BY DATETRUNC(year, create_date)