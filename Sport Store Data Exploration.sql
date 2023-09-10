/* Sports Store Data Exploration */

SELECT *
  FROM public."Orders";
  
SELECT *
  FROM public."Customers";
   
-- 1.KPIs for Total Revenue, Profit, number of orders, profit margin

SELECT SUM(revenue) AS Total_Revenue, 
       SUM(profit) AS Total_Profit,
	   COUNT(order_id) AS num_orders,
	   ROUND(CAST((SUM(profit) / SUM(revenue))*100 AS numeric),2) AS profit_margin
  FROM public."Orders";
  
-- 2.Total Revenue, Profit, number of orders, profit margin for each sport

SELECT sport,
       ROUND(CAST(SUM(revenue) AS numeric), 2) AS Total_Revenue, 
       ROUND(CAST(SUM(profit) AS numeric), 2) AS Total_Profit,
	   COUNT(order_id) AS num_orders,
	   ROUND(CAST((SUM(profit) / SUM(revenue))*100 AS numeric),2) AS profit_margin
  FROM public."Orders"
 GROUP BY sport
 ORDER BY profit_margin DESC;

-- 3.Number of customer ratings and the average rating

SELECT COUNT(rating) AS num_review,
       ROUND(AVG(rating),2) AS average_rating
  FROM public."Orders"
 WHERE rating IS NOT NULL;
 
--  4. Number of people for each rating and its revenue, profit, profit margin

SELECT rating,
       ROUND(CAST(SUM(revenue) AS numeric), 2) AS Total_Revenue, 
       ROUND(CAST(SUM(profit) AS numeric), 2) AS Total_Profit,
	   ROUND(CAST((SUM(profit) / SUM(revenue))*100 AS numeric),2) AS profit_margin
  FROM public."Orders"
 WHERE rating IS NOT NULL
 GROUP BY rating
 ORDER BY rating DESC;
 
-- 5. Total Revenue, Profit, number of orders, profit margin for each state

SELECT c.state,
	   ROW_NUMBER() OVER (ORDER BY SUM(o.revenue) DESC) AS revenue_rank,
       ROUND(CAST(SUM(o.revenue) AS numeric), 2) AS Total_Revenue, 
	   ROW_NUMBER() OVER (ORDER BY SUM(o.profit) DESC) AS profit_rank,
       ROUND(CAST(SUM(o.profit) AS numeric), 2) AS Total_Profit,
	   ROW_NUMBER() OVER (ORDER BY SUM(o.profit)/SUM(o.revenue) DESC) AS profit_margin_rank,
	   ROUND(CAST((SUM(o.profit) / SUM(o.revenue))*100 AS numeric),2) AS profit_margin
  FROM public."Orders" AS o
 INNER JOIN public."Customers" AS c
    ON o.customer_id = c.customer_id
 GROUP BY c.state
 ORDER BY profit_margin_rank;
 
-- 6.Monthly Profits

WITH monthly_profit AS (
SELECT EXTRACT(MONTH FROM date) AS date_month,
       ROUND(CAST(SUM(profit) AS numeric), 2) AS Total_Profit 
  FROM public."Orders" 
 GROUP BY date_month
 ORDER BY date_month
)
 
SELECT date_month,
       Total_Profit,
	   LAG(Total_Profit) OVER(ORDER BY date_month) AS previous_month_profit,
	   Total_profit - LAG(Total_Profit) OVER(ORDER BY date_month) AS profit_difference
  FROM monthly_profit;

