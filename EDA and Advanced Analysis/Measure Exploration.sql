----------------------- MEASURES EXPLORATION -------------------------

-- Calculate the key metric of the business (Big Numbers)

-- Highest Level of aggregation | Lowest Level of Details-

-- Find the total Sales
SELECT
SUM(Sales_Amount) Total_sales
FROM Gold.fact_Sales

-- Find how many items are sold
SELECT SUM(Quantity) total_quantity FROM Gold.fact_Sales

-- find the average selling price
SELECT AVG(Price) Avg_selling_price FROM Gold.fact_Sales

-- Find the Total Numbers of Orders
SELECT COUNT(Order_Number) total_orders FROM Gold.fact_Sales
SELECT COUNT(DISTINCT Order_Number) AS Total_Orders FROM Gold.fact_Sales

-- Find the Total Numbers of Products
SELECT COUNT(Product_Number) AS total_Products FROM Gold.dim_Products

-- Find the total Numbers of Customers
SELECT COUNT(customer_key) AS Total_Customer FROM Gold.dim_customers
SELECT COUNT(DISTINCT customer_key) AS Total_Customer FROM Gold.dim_customers

-- Find the total number of customers that has placed an order
SELECT
COUNT(DISTINCT Customer_Key) total_Customer
FROM Gold.fact_Sales


-- GENERATE a report that shows all key metric of the business

SELECT 'Total_Sales' AS Measure_Name, SUM(Sales_Amount) AS Measure_Value FROM Gold.fact_Sales
UNION ALL
SELECT 'Total_Quantity' AS Measure_Name, SUM(Quantity) AS Measure_Value FROM Gold.fact_Sales
UNION ALL
SELECT 'Average_Price' AS Measure_Name, AVG(Price) AS Measure_Value FROM Gold.fact_Sales
UNION ALL
SELECT 'Total NR. Orders' AS Measure_Name, COUNT(DISTINCT Order_Number)  AS Measure_Value FROM Gold.fact_Sales
UNION ALL
SELECT 'Total Nr. Products' AS Measure_Name, COUNT( Product_key)  AS Measure_Value FROM Gold.dim_Products
UNION ALL
SELECT 'Total Nr. Customers' AS Measure_Name, COUNT(Customer_key)  AS Measure_Value FROM Gold.dim_customers
