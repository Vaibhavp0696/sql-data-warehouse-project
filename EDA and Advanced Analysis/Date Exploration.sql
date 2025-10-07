---------------------------- DATE EXPLORATION -------------------------------

-- Identify the earliest and latest dates (boundaries).
-- Understand the scope of data and the timespan..

-- Find the date of first and last order

SELECT 
MAX(order_Date) Latest_date,
MIN(order_date) Oldest_date,
DATEDIFF(year, MIN(Order_date), MAX(Order_date)) AS Order_range_years
from Gold.fact_Sales

--- Find the youngest and oldest customer

SELECT
MIN(birthdate) Oldest_cust,
Max(birthDate) Youngest_cust,
DATEDIFF (year, MIN(birthdate), GETDATE()) AS Oldest_age,
DATEDIFF (year, MAX(birthdate), GETDATE()) AS Oldest_age
FROM Gold.dim_customers