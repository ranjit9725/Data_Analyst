use sqlproject;

#1 Which is the most loss making category in the East region?
SELECT 
	Region,
	Category,
	Profit
FROM orders
WHERE Profit < 0 AND Region ='East'
ORDER BY profit ASC
LIMIT 1;

#2 Give me the top 3 product ids by most returns?


WITH CTE AS (SELECT 
	COUNT(r.Returned) AS no_of_return,
	o.`Product ID`,
	ROW_NUMBER() OVER (ORDER BY COUNT(r.Returned)DESC) AS rnk 
FROM orders o
JOIN returns r ON r.`Order ID` = o.`Order ID`
GROUP BY o.`Product ID`
ORDER BY  (no_of_return) DESC) 
SELECT `Product ID`
FROM CTE
WHERE rnk in (1,2,3);

#3)In which city the most number of returns are being recorded?



 SELECT
	CITY
    FROM 
    (SELECT
	(l.`city`) AS CITY,
	(r.Returned) as ret
FROM location l
JOIN orders o ON l.`Postal Code` = o.`Postal Code`
JOIN returns r ON o.`Order ID` = r.`Order ID`) T1
limit 1;

#4) Find the relationship between days between order date , ship date and profit?
SELECT 
		(`Ship Date` - `Order Date`) AS Days,
		ROUND(SUM(Profit),2) AS Total_profit,
RANK() OVER (ORDER BY SUM(Profit) DESC) AS Profit_ranking
FROM orders
GROUP BY Days
ORDER BY total_profit DESC,
		(days);
        
#5)Find the region wise profits for all the regions and give the output of the most profitable region
 SELECT * FROM location;
 SELECT * FROM orders;
 SELECT * FROM returns;
 
SELECT
	Region,
	Max_profit
FROM
(SELECT 
	Region,
 	ROUND(SUM(profit),2) AS Max_profit,
    RANK() OVER (ORDER BY ROUND(SUM(profit),2) DESC) rnk
FROM orders 
GROUP BY region) t1
WHERE rnk = 1;

#6) Which month observe the highest number of orders placed and return placed for each year?

WITH CTE AS (SELECT
	MONTHNAME(`Order Date`) AS months,
    COUNT(MONTHNAME(`Order Date`)) AS counts,
DENSE_RANK() OVER (ORDER BY  COUNT(MONTHNAME(`Order Date`)) DESC) AS rnk
FROM orders 
GROUP BY months
ORDER BY counts DESC)
SELECT months
FROM CTE
WHERE rnk = 1;

 SELECT * FROM orders;

#7)Calculate percentage change in sales for the entire dataset? X-axis should be year_month Y-axis percent change

SELECT 
	Dates,
    ROUND((((Tot_sales - previous)/previous)*100),2) AS Change_in_Percentage
FROM
(SELECT 
DATE_FORMAT(`Order Date`, '%Y-%m') AS Dates,
SUM(Sales) AS Tot_sales,
LAG(SUM(Sales),1,0) OVER (ORDER BY DATE_FORMAT(`Order Date`, '%Y-%m')) AS previous
FROM orders
GROUP BY Dates) t1;

# 2)Find out if any sales pattern exists for all the region?
SELECT
	Region,
	Dates,
    ROUND((((Tot_sales - previous)/previous)*100),2) AS Change_in_Percentage
FROM
(SELECT 
Region,
DATE_FORMAT(`Order Date`, '%Y') AS Dates,
SUM(Sales) AS Tot_sales,
LAG(SUM(Sales),1,0) OVER (ORDER BY DATE_FORMAT(`Order Date`, '%Y')) AS previous
FROM orders
GROUP BY Dates,
		 Region) t1;
         
 SELECT * FROM orders;
#8)Top and bottom selling product for each region
SELECT
	`Region`,	
	`Product Name`,
    Max(Sales) AS Max_Price,
    MIN(Sales) AS Min_Price
FROM Orders 
Group BY Region,
		`Product Name`;

    
#9Why are returns initiated? Are there any specific characteristics for all the returns? Hint: Find return across all categories to observe any pattern
SELECT 
o.Category,
COUNT(r.Returned) AS Total_return
FROM orders AS o
JOIN returns AS r ON r.`Order ID` = o.`Order ID`
GROUP BY o.Category
ORDER BY Total_return



