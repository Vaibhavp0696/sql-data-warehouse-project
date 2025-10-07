-------------------------------- DIMENSIONS EXPLORATION ----------------------------------------

/* Identifying the unique values (or categories) in each dimension.
Recognizing how data might be grouped or segmented, which is useful for later analysis. */

-- Explore All Countries our Customers come from.

SELECT DISTINCT Country FROM Gold.dim_customers

-- Explore All Categories "The Major Divisions "

SELECT DISTINCT Category, Subcategory, product_name FROM Gold.dim_Products
ORDER BY 1,2,3