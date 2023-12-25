-- Total sales and total profit per year.

	SELECT strftime('%Y', order_date) AS year,
	 ROUND(SUM(Sales)) AS total_sales,
	 ROUND(SUM(profit)) AS total_profit
	FROM Superstore
	GROUP BY 1;
	
---------------------------------------------------------------------------------------------

-- The average total profit has increased in every quarter and peaked in quarter 4.
	WITH temp_table AS
	(
	SELECT  NTILE(4) OVER(ORDER BY strftime('%m', order_date)) AS quarter,
	 strftime('%m', order_date) As month,
	 ROUND(SUM(Sales)) AS total_sales,
	 ROUND(SUM(profit)) AS total_profit
	FROM Superstore
	GROUP BY 2
	)

	SELECT *,
	ROUND(AVG(total_profit) OVER(PARTITION BY quarter)) AS avg_total_profit
	FROM temp_table;
	
---------------------------------------------------------------------------------------------

-- Most of the orders have shipped by Standard Class.

	SELECT Ship_mode,
	 ROUND(SUM(sales)) AS total_sales,
	 ROUND(SUM(profit)) AS total_profit,
	 COUNT(*) AS order_count
	FROM superstore
	GROUP BY 1
	ORDER BY 2 DESC;
	
---------------------------------------------------------------------------------------------

-- Unique Customer

	SELECT COUNT(DISTINCT customer_id)
	FROM superstore
---------------------------------------------------------------------------------------------

-- The average sales per customer
	WITH total_sales_per_cus AS
	(
	SELECT Customer_ID,
	 ROUND(SUM(sales)) AS total_sales
	FROM superstore
	GROUP BY 1
	)

	SELECT ROUND(AVG(total_sales)) AS avg_sales_per_cus
	FROM total_sales_per_cus;

-- The average sales per order.

	WITH total_sales_per_order AS
	(
	SELECT Order_ID,
	 ROUND(SUM(sales)) AS total_sales
	FROM superstore
	GROUP BY 1
	)

	SELECT ROUND(AVG(total_sales)) AS avg_sales_per_order
	FROM total_sales_per_order;
		
-- The average product per order	

	WITH product_per_order AS
	(
	SELECT Order_ID,
	 COUNT(*) AS product
	FROM superstore
	GROUP BY 1)

	SELECT ROUND(AVG(product)) AS avg_product_per_order
	FROM product_per_order;

---------------------------------------------------------------------------------------------

-- Top 100 customers by profit
	SELECT Customer_ID,
	 Customer_Name,
	 COUNT(*) AS order_count,
	 ROUND(SUM(Profit),2) AS profit
	FROM superstore
	GROUP BY 1,2
	ORDER BY profit DESC
	LIMIT 100;

-- Top 100 customers by total_sales
	SELECT Customer_ID,
	 Customer_Name,
	 COUNT(*) AS order_count,
	 ROUND(SUM(sales),2) AS total_sales
	FROM superstore
	GROUP BY 1,2
	ORDER BY total_sales DESC
	LIMIT 100;

---------------------------------------------------------------------------------------------

-- Although Sean Miller is the top spender, his profit is entirely negative.

	SELECT Customer_ID,
	 Customer_name,
	 ROUND(SUM(sales)) AS total_sales,
	 ROUND(SUM(profit)) AS total_profit,
	 COUNT(*) AS order_count
	FROM superstore
	GROUP BY 1
	ORDER BY 3 DESC;

-- Look like Cisco TelePresence System EX90 Videoconferencing Unit is the problem

	SELECT *
	FROM superstore
	WHERE Customer_name = 'Sean Miller' AND profit < 0
---------------------------------------------------------------------------------------------

-- The West is the region that gains the highest profit margin.
	
	SELECT Region,
	 ROUND(SUM(sales)) AS total_sales,
	 ROUND(SUM(profit)) AS total_profit,
	 ROUND(SUM(profit) / SUM(sales) * 100,2) AS profit_margin_ratio
	FROM superstore
	GROUP BY 1
	ORDER BY 4 DESC;
	
-- The Central region has low profits on Office Supplies and Furniture compared to other regions.

	SELECT Region,
	 Category,
	 ROUND(SUM(sales)) AS total_sales,
	 ROUND(SUM(profit)) AS total_profit,
	 ROUND(SUM(profit) / SUM(sales) * 100,2) AS profit_margin_ratio
	FROM superstore
	GROUP BY 1,2
	ORDER BY 1, 4 DESC;
	
-- 	We experienced a significant loss in profit in Texas and Illinois within the Central Region.
-- Office Supplies

	SELECT State,
	 ROUND(SUM(sales)) AS total_sales,
	 ROUND(SUM(profit)) AS total_profit,
	 ROUND(SUM(Profit) / ROUND(SUM(Sales)) * 100,2) AS profit_margin_ratio
	FROM superstore
	WHERE Category = 'Office Supplies' AND Region = 'Central'
	GROUP BY 1
	ORDER BY 3;
	
-- Furniture	

	SELECT State,
	 ROUND(SUM(sales)) AS total_sales,
	 ROUND(SUM(profit)) AS total_profit,
	 ROUND(SUM(Profit) / ROUND(SUM(Sales)) * 100,2) AS profit_margin_ratio
	FROM superstore
	WHERE Category = 'Furniture' AND Region = 'Central'
	GROUP BY 1
	ORDER BY 3;
	
---------------------------------------------------------------------------------------------

-- Total_sales & Total_profit by State.

	SELECT State,
	 ROUND(SUM(sales)) AS total_sales,
	 ROUND(SUM(profit)) AS total_profit,
	 ROUND(SUM(Profit) / ROUND(SUM(Sales)) * 100,2) AS profit_margin_ratio
	FROM superstore
	GROUP BY 1
	ORDER BY 3 DESC;
		
---------------------------------------------------------------------------------------------

-- Total_sales & Total_profit by City.

	SELECT City,
	 ROUND(SUM(sales)) AS total_sales,
	 ROUND(SUM(profit)) AS total_profit,
	 ROUND(SUM(Profit) / ROUND(SUM(Sales)) * 100,2) AS profit_margin_ratio
	FROM superstore
	GROUP BY 1
	ORDER BY 3 DESC;

-- Out of 90 cities in Texas, a staggering 70 are not making a profit!
-- Houston, San Antonio, and Dallas are cities in Texas with significant losses.

	SELECT City,
	 Category,
	 ROUND(SUM(sales)) AS total_sales,
	 ROUND(SUM(profit)) AS total_profit,
	 ROUND(SUM(Profit) / ROUND(SUM(Sales)) * 100,2) AS profit_margin_ratio
	FROM superstore
	WHERE (Category = 'Office Supplies' OR Category = 'Furniture')  AND State = 'Texas'
	GROUP BY 1,2
	ORDER BY 4;

	
-- Out of 47 cities in Illinois, a staggering 39 are not making a profit!	
-- Chicago and Aurora are cities in Illinois with significant losses.

	SELECT City,
	 Category,
	 ROUND(SUM(sales)) AS total_sales,
	 ROUND(SUM(profit)) AS total_profit,
	 ROUND(SUM(Profit) / ROUND(SUM(Sales)) * 100,2) AS profit_margin_ratio
	FROM superstore
	WHERE (Category = 'Office Supplies' OR Category = 'Furniture')  AND State = 'Illinois'
	GROUP BY 1,2
	ORDER BY 4;
	
---------------------------------------------------------------------------------------------

-- Even though consumers are the segment with the highest spending, the Home Office has a higher profit margin.

	SELECT Segment,
	 ROUND(SUM(Sales)) AS total_sales,
	 ROUND(SUM(Profit)) AS total_profit,
	 ROUND(SUM(Profit) / ROUND(SUM(Sales)) * 100,2) AS profit_margin_ratio,
	 COUNT(*) AS order_count
	FROM superstore
	GROUP BY 1;
	
---------------------------------------------------------------------------------------------

-- The top 10 products in each segment that generate the highest profit.

	WITH top_10_highest AS
	(
	SELECT Segment,
	 Product_name,
	 ROUND(SUM(Profit)) AS total_profit,
	 DENSE_RANK() OVER(PARTITION BY Segment ORDER BY SUM(Profit) DESC) AS rank
	FROM superstore
	GROUP BY 1,2
	)
	
	SELECT * FROM top_10_highest
	WHERE rank BETWEEN 1 AND 10;
---------------------------------------------------------------------------------------------	

-- The top 10 products in each segment that generate the lowest profit.

	WITH top_10_lowest AS
	(
	SELECT Segment,
	 Product_name,
	 ROUND(SUM(Profit)) AS total_profit,
	 DENSE_RANK() OVER(PARTITION BY Segment ORDER BY SUM(Profit)) AS rank
	FROM superstore
	GROUP BY 1,2
	)
	
	SELECT * FROM top_10_lowest
	WHERE rank BETWEEN 1 AND 10;
	
	SELECT *
	FROM superstore
	WHERE Product_Name IN ('Lexmark MX611dhe Monochrome Laser Printer', 'Cubify CubeX 3D Printer Triple Head Print') 
---------------------------------------------------------------------------------------------	

-- Furniture has the lowest profit margin gain, even though total sales are closest to Office Supplies.

	SELECT Category,
	 ROUND(SUM(sales)) AS total_sales,
	 ROUND(SUM(profit)) AS total_profit,
	 ROUND(SUM(Profit) / ROUND(SUM(Sales)) * 100,2) AS profit_margin_ratio
	FROM superstore
	GROUP BY 1
	ORDER BY 3 DESC;
	
---------------------------------------------------------------------------------------------	

-- Copiers generate the highest total profit.

	SELECT Sub_Category,
	 ROUND(SUM(sales)) AS total_sales,
	 ROUND(SUM(profit)) AS total_profit,
	 ROUND(SUM(Profit) / ROUND(SUM(Sales)) * 100,2) AS profit_margin_ratio
	FROM superstore
	GROUP BY 1
	ORDER BY 3 DESC;
	
-- List of product names in the Copiers sub-category that we need to keep an eye on.

	SELECT Product_Name,
	 ROUND(SUM(sales)) AS total_sales,
	 ROUND(SUM(profit)) AS total_profit,
	 ROUND(SUM(Profit) / ROUND(SUM(Sales)) * 100,2) AS profit_margin_ratio
	FROM superstore
	WHERE Sub_Category = 'Copiers'
	GROUP BY 1
	ORDER BY 3 DESC;
	
---------------------------------------------------------------------------------------------	

