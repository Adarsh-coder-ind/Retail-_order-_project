create database Retail_order_project;
use  Retail_order_project;
 
DROP TABLE IF EXISTS Retail_order_project;
CREATE TABLE IF NOT EXISTS Retail_order_project (
    `Order id` INT PRIMARY KEY,
    `Order date` DATE,
    `Ship mode` VARCHAR(50),
    `Segment` VARCHAR(50),
    `Country` VARCHAR(100),
    `City` VARCHAR(100),
    `State` VARCHAR(100),
    `Postal code` VARCHAR(20),
    `Region` VARCHAR(50),
    `Category` VARCHAR(50),
    `Sub category` VARCHAR(50),
    `Product id` VARCHAR(50),
    `Cost price` DECIMAL(10,2),
    `List price` DECIMAL(10,2),
    `Quantity` INT,
    `Discount percent` DECIMAL(5,2),
    `Discount` DECIMAL(10,2),
    `sale_price` DECIMAL(10,2),
    `profit` DECIMAL(10,2)
);

#find top 10 highest revenue generating product
WITH cte AS (
  SELECT `Region`, `Product id`, SUM(`sale_price`) AS sales
  FROM Retail_order_project
  GROUP BY `Region`, `Product id`
),
ranked_cte AS (
  SELECT *,
         ROW_NUMBER() OVER (PARTITION BY `Region` ORDER BY sales DESC) AS rn
  FROM cte
)

SELECT `Region`, `Product id`, sales
FROM ranked_cte
WHERE rn <= 5;

#find month over month growth comparision for 2023 sales eg : jan 2022 vs jan 2023

WITH cte AS (
    SELECT
        EXTRACT(YEAR FROM `order date`) AS order_year,
        EXTRACT(MONTH FROM `order date`) AS order_month,
        SUM(sale_price) AS sales
    FROM retail_order_project
    GROUP BY
        EXTRACT(YEAR FROM `order date`),
        EXTRACT(MONTH FROM `order date`)
)

SELECT 
    order_month,
    SUM(CASE WHEN order_year = 2022 THEN sales ELSE 0 END) AS sales_2022,
    SUM(CASE WHEN order_year = 2023 THEN sales ELSE 0 END) AS sales_2023
FROM cte
GROUP BY order_month
ORDER BY order_month;

#for each category had highest growth by profit in 2023 compare to 2022

SELECT 
  category,
  DATE_FORMAT(`order date`, '%Y%m') AS order_year_month,
  SUM(sale_price) AS sales
FROM 
  retail_order_project
GROUP BY 
  category,
  DATE_FORMAT(`order date`, '%Y%m');
  
  





