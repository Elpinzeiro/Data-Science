-- Write a query to return the top 5 orders in terms of largest total_amt_usd. Include the id, account_id, and total_amt_usd.

SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY total_amt_usd DESC
LIMIT 5;


-- Write a query to return the lowest 20 orders in terms of smallest total_amt_usd. Include the id, account_id, and total_amt_usd.

SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY total_amt_usd 
LIMIT 20;


-- Write a query that displays the order ID, account ID, and total dollar amount for all the orders, 
-- sorted first by the account ID (in ascending order), and then by the total dollar amount (in descending order).

SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY account_id, total_amt_usd DESC;


-- Now write a query that again displays order ID, account ID, and total dollar amount for each order, 
-- but this time sorted first by total dollar amount (in descending order), and then by account ID (in ascending order).

SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY total_amt_usd DESC, account_id ;

-- Pulls the first 5 rows and all columns from the orders table that have a dollar amount of gloss_amt_usd greater than or equal to 1000.
SELECT *
FROM orders
WHERE gloss_amt_usd >= 1000
LIMIT 5;

-- Pulls the first 10 rows and all columns from the orders table that have a total_amt_usd less than 500.
SELECT *
FROM orders
WHERE total_amt_usd <500
LIMIT 10;

-- Filter the accounts table to include the company name, 
-- website, and the primary point of contact (primary_poc) just for the Exxon Mobil company in the accounts table.
SELECT name, website, primary_poc
FROM accounts
WHERE name = 'Exxon Mobil';

-- Create a column that divides the standard_amt_usd by the standard_qty to find the unit price for standard paper for each order. 
-- Limit the results to the first 10 orders, and include the id and account_id fields.

SELECT id, account_id, standard_amt_usd/standard_qty AS unit_price
FROM accounts
LIMIT 10;


-- All the companies whose names start with 'C'.
SELECT name
FROM accounts
WHERE name LIKE 'C%';

-- Use the accounts table to find the account name, primary_poc, and sales_rep_id for Walmart, Target, and Nordstrom.
SELECT name, primary_poc, sales_rep_id
FROM accounts
WHERE name IN ('Walmart', 'Target', 'Nordstrom');

-- Use the accounts table to find the account name, primary poc, and sales rep id for all stores except Walmart, Target, and Nordstrom.

SELECT name, primary_poc, sales_rep_id
FROM accounts
WHERE name NOT IN ('Walmart', 'Target', 'Nordstrom');

-- Use the web_events table to find all information regarding individuals who were contacted via any method except using organic or adwords methods.

SELECT *
FROM web_events
WHERE channel NOT IN ('organic', 'adwords');

-- Provide a table that provides the region for each sales_rep along with their associated accounts.
-- This time only for the Midwest region. Your final table should include three columns: the region name, the sales rep name, and the account name. 
-- Sort the accounts alphabetically (A-Z) according to account name.

SELECT region.name as rn, sales_reps.name as slsn, accounts.name as an
FROM accounts
JOIN sales_reps
ON accounts.sales_rep_id = sales_reps.id
JOIN region 
ON sales_reps.region_id = region.id
WHERE region.name = 'Midwest'
ORDER BY accounts.name 

-- Provide a table that provides the region for each sales_rep along with their associated accounts. 
--This time only for accounts where the sales rep has a first name starting with S and in the Midwest region.
-- Your final table should include three columns: the region name, the sales rep name, and the account name.
-- Sort the accounts alphabetically (A-Z) according to account name.


SELECT region.name region, sales_reps.name sales, accounts.name accounts
FROM accounts
JOIN sales_reps
ON accounts.sales_rep_id = sales_reps.id
JOIN region 
ON sales_reps.region_id = region.id
WHERE sales_reps.name LIKE 'S%' AND region.name = 'Midwest'
ORDER BY accounts.name;

-- SOlution ....
SELECT r.name region, s.name rep, a.name account
FROM sales_reps s
JOIN region r
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
WHERE r.name = 'Midwest' AND s.name LIKE 'S%'
ORDER BY a.name;

-- Provide a table that provides the region for each sales_rep along with their associated accounts.
-- This time only for accounts where the sales rep has a last name starting with K and in the Midwest region.
-- Your final table should include three columns: the region name, the sales rep name, and the account name.
-- Sort the accounts alphabetically (A-Z) according to account name.

SELECT r.name region, s.name rep, a.name account
FROM sales_reps s
JOIN region r
ON s.region_id = r.id
JOIN accounts a
ON a.sales_rep_id = s.id
WHERE r.name = 'Midwest' AND s.name LIKE '% K%'
ORDER BY a.name;


-- Provide the name for each region for every order, as well as the account name and the unit price they paid (total_amt_usd/total) for the order.
-- However, you should only provide the results if the standard order quantity exceeds 100. 
-- Your final table should have 3 columns: region name, account name, and unit price.
-- In order to avoid a division by zero error, adding .01 to the denominator here is helpful total_amt_usd/(total+0.01).

SELECT r.name region_name, a.name acc_name, o.total_amt_usd/(o.total + 0.01) unit_price
FROM accounts a
JOIN sales_reps s
ON a.sales_rep_id = s.id
JOIN region r
ON s.region_id = r.id
JOIN orders o
ON a.id = o.account_id
WHERE o.standard_qty > 100;

-- Provide the name for each region for every order, as well as the account name and the unit price they paid (total_amt_usd/total) for the order. 
-- However, you should only provide the results if the standard order quantity exceeds 100 and the poster order quantity exceeds 50.
-- Your final table should have 3 columns: region name, account name, and unit price. Sort for the smallest unit price first.
-- In order to avoid a division by zero error, adding .01 to the denominator here is helpful (total_amt_usd/(total+0.01).

SELECT r.name region_name, a.name acc_name, o.total_amt_usd/(o.total + 0.01) unit_price
FROM accounts a
JOIN sales_reps s
ON a.sales_rep_id = s.id
JOIN region r
ON s.region_id = r.id
JOIN orders o
ON a.id = o.account_id
WHERE o.standard_qty > 100 AND o.poster_qty > 50
ORDER BY unit_price; 


-- What are the different channels used by account id 1001? 
-- Your final table should have only 2 columns: account name and the different channels.
-- You can try SELECT DISTINCT to narrow down the results to only the unique values.

SELECT DISTINCT a.id acc_id, w.channel web_ch
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
WHERE a.id = 1001;


-- Find all the orders that occurred in 2015.
-- Your final table should have 4 columns: occurred_at, account name, order total, and order total_amt_usd.

SELECT o.occurred_at, a.name, o.total, o.total_amt_usd
FROM accounts a
JOIN orders o
ON o.account_id = a.id
WHERE o.occurred_at BETWEEN '01-01-2015' AND '01-01-2016'
ORDER BY o.occurred_at DESC;

-- Find the total dollar amount of sales using the total_amt_usd in the orders table.
SELECT SUM(total_amt_usd) amount
FROM orders


--When was the earliest order ever placed?
SELECT MIN(occurred_at) 
FROM orders;

--Try performing the same query as in question 1 without using an aggregation function.
SELECT occurred_at 
FROM orders 
ORDER BY occurred_at
LIMIT 1;

-- Which account (by name) placed the earliest order? Your solution should have the account name and the date of the order.
SELECT a.name, o.occurred_at
FROM accounts a
JOIN orders o
ON a.id = o.account_id
ORDER BY o.occurred_at
LIMIT 1;

-- Find the total sales in usd for each account. You should include two columns - the total sales for each company's orders in usd and the company name.
SELECT SUM(o.total_amt_usd) total_sales, a.name company_name
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.name;

-- Via what channel did the most recent (latest) web_event occur, which account was associated with this web_event? 
-- Your query should return only three values - the date, channel, and account name.
SELECT w.occurred_at date, w.channel channel, a.name AS name
FROM accounts a 
JOIN web_events w
ON a.id = w.account_id
ORDER BY w.occurred_at DESC
LIMIT 1;

-- Find the total number of times each type of channel from the web_events was used.
-- Your final table should have two columns - the channel and the number of times the channel was used.

SELECT w.channel channel, COUNT(w.id) times_used
FROM web_events w
GROUP BY channel;

-- Who was the primary contact associated with the earliest web_event?

SELECT a.primary_poc primary_contact
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
ORDER BY w.occurred_at
LIMIT 1;

-- What was the smallest order placed by each account in terms of total usd. 
-- Provide only two columns - the account name and the total usd. Order from smallest dollar amounts to largest.

SELECT a.name as name, MIN(o.total_amt_usd) total
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.name
ORDER BY total;

-- Find the number of sales reps in each region.
-- Your final table should have two columns - the region and the number of sales_reps. Order from fewest reps to most reps.
SELECT r.name region, COUNT(s.region_id) sales
FROM sales_reps s
JOIN region r
ON s.region_id = r.id
GROUP BY r.name
ORDER BY sales;

-- For each account, determine the average amount of each type of paper they purchased across their orders.
-- Your result should have four columns - one for the account name and one for the average quantity purchased for each of the paper types for each account.

SELECT a.name AS name, AVG(standard_qty) avg_stand, AVG(poster_qty) avg_poster, AVG(glossy_qty) avg_glossy
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.name



-- Determine the number of times a particular channel was used in the web_events table for each region. 
-- Your final table should have three columns - the region name, the channel, and the number of occurrences. 
-- Order your table with the highest number of occurrences first.
SELECT r.name AS name, w.channel AS channel, COUNT(s.id) occurrences
FROM accounts a
JOIN sales_reps s
ON a.sales_rep_id = s.id
JOIN region r
ON s.region_id = r.id 
JOIN web_events w
ON a.id = w.account_id
GROUP BY r.name,w.channel
ORDER BY occurrences DESC;



-- How many of the sales reps have more than 5 accounts that they manage?
SELECT s.id, s.name, COUNT(*) num_accounts
FROM accounts a
JOIN sales_reps s
ON s.id = a.sales_rep_id
GROUP BY s.id, s.name
HAVING COUNT(*) > 5
ORDER BY num_accounts;

-- How many accounts have more than 20 orders?
SELECT a.id as aid, a.name, COUNT(*) orders
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id, a.name
HAVING COUNT(*) > 20
ORDER BY orders;

-- Which accounts spent more than 30,000 usd total across all orders?
SELECT a.id, a.name, SUM(o.total_amt_usd) total
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id, a.name
HAVING SUM(o.total_amt_usd) > 30000
ORDER BY total;

--Which accounts used facebook as a channel to contact customers more than 6 times?
SELECT a.id, a.name, w.channel, COUNT(w.channel) times
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
WHERE w.channel LIKE 'facebook'
GROUP BY a.id, a.name, w.channel
HAVING COUNT(w.channel) >6
ORDER BY times;



-- Find the sales in terms of total dollars for all orders in each year, ordered from greatest to least.
-- Do you notice any trends in the yearly sales totals?

SELECT DATE_PART('year',  occurred_at) years, SUM (total_amt_usd) AS TOTAL
FROM orders
GROUP BY DATE_PART('year',  occurred_at)
ORDER BY 2 DESC;


-- In which month of which year did Walmart spend the most on gloss paper in terms of dollars?
SELECT DATE_TRUNC('month',  occurred_at) AS month, a.name AS name, SUM (gloss_amt_usd) AS TOTAL
FROM orders o
JOIN accounts a
ON a.id = o.account_id
WHERE a.name LIKE 'Walmart'
GROUP BY DATE_TRUNC('month',  occurred_at), a.name
ORDER BY 3 DESC
LIMIT 1	;

-- Write a query to display for each order, the account ID, total amount of the order,
-- and the level of the order - ‘Large’ or ’Small’ - depending on if the order is $3000 or more, or smaller than $3000.

SELECT a.id AS ID, o.total_amt_usd AS TOTAL, CASE WHEN o.total_amt_usd > 3000 THEN 'Large'
ELSE 'Small' END AS Dimension 
FROM accounts a
JOIN orders o
ON a.id = o.account_id

-- Write a query to display the number of orders in each of three categories, based on the total number of items in each order.
-- The three categories are: 'At Least 2000', 'Between 1000 and 2000' and 'Less than 1000'.

SELECT CASE WHEN o.total >= 2000 THEN 'At Least 2000' WHEN o.total >1000 AND o.total < 2000 THEN 'Between 1000 and 2000' 
ELSE 'Less than 1000' END AS NUM_ORDERS,
COUNT(*) AS Dimension
FROM orders o
GROUP BY 1 


--We would like to understand 3 different levels of customers based on the amount associated with their purchases.
--The top level includes anyone with a Lifetime Value (total sales of all orders) greater than 200,000 usd.
--The second level is between 200,000 and 100,000 usd. The lowest level is anyone under 100,000 usd. 
--Provide a table that includes the level associated with each account. 
--You should provide the account name, the total sales of all orders for the customer, and the level.
--Order with the top spending customers listed first.

SELECT a.name AS ACC_NAME, SUM(total_amt_usd) AS Total, CASE WHEN SUM(total_amt_usd) > 200000 THEN 'TOP' 
WHEN SUM(total_amt_usd) <= 200000 AND SUM(total_amt_usd) > 100000 THEN 'MEDIUM'
ELSE 'LOW' END AS LEVEL_OF_SELLS
FROM orders o
JOIN accounts a
ON o.account_id = a.id
GROUP BY a.name
ORDER BY SUM(o.total_amt_usd) DESC


-- We would now like to perform a similar calculation to the first, but we want to obtain the total amount spent by customers only in 2016 and 2017.
-- Keep the same levels as in the previous question. Order with the top spending customers listed first.


SELECT DATE_PART('year',  occurred_at) years, a.name AS ACC_NAME, SUM(total_amt_usd) AS Total, CASE WHEN SUM(total_amt_usd) > 200000 THEN 'TOP' 
WHEN SUM(total_amt_usd) <= 200000 AND SUM(total_amt_usd) > 100000 THEN 'MEDIUM'
ELSE 'LOW' END AS LEVEL_OF_SELLS
FROM orders o
JOIN accounts a
ON o.account_id = a.id
WHERE DATE_PART('year',  occurred_at) = '2016' OR DATE_PART('year',  occurred_at) = '2017' 
GROUP BY a.name, DATE_PART('year',  occurred_at)
ORDER BY SUM(o.total_amt_usd) DESC

--We would like to identify top performing sales reps, which are sales reps associated with more than 200 orders. 
--Create a table with the sales rep name, the total number of orders, and a column with top or not depending on if they have more than 200 orders.
--Place the top sales people first in your final table.

SELECT s.name, COUNT(*) num_ords,
     CASE WHEN COUNT(*) > 200 THEN 'top'
     ELSE 'not' END AS sales_rep_level
FROM orders o
JOIN accounts a
ON o.account_id = a.id 
JOIN sales_reps s
ON s.id = a.sales_rep_id
GROUP BY s.name
ORDER BY 2 DESC;

--The previous didn't account for the middle, nor the dollar amount associated with the sales.
--Management decides they want to see these characteristics represented as well. 
--We would like to identify top performing sales reps, which are sales reps associated with more than 200 orders or more than 750000 in total sales.
--The middle group has any rep with more than 150 orders or 500000 in sales. 
--Create a table with the sales rep name, the total number of orders, total sales across all orders, and a column with top, middle, or low depending on this criteria.
--Place the top sales people based on dollar amount of sales first in your final table.
SELECT s.name, COUNT(*) num_ords, SUM(o.total_amt_usd) TOT,
     CASE WHEN COUNT(*) > 200 OR SUM(o.total_amt_usd) > 750000 THEN 'top'
     WHEN COUNT(*) > 150 OR SUM(o.total_amt_usd) > 500000 THEN 'medium'
     ELSE 'low' END AS sales_rep_level
FROM orders o
JOIN accounts a
ON o.account_id = a.id 
JOIN sales_reps s
ON s.id = a.sales_rep_id
GROUP BY s.name
ORDER BY SUM(o.total_amt_usd) DESC;

-- Subqueries: Provide the name of the sales_rep in each region with the largest amount of total_amt_usd sales.
    SELECT t3.rep_name, t3.region_name, t3.total_amt
FROM(SELECT region_name, MAX(total_amt) total_amt
     FROM(SELECT s.name rep_name, r.name region_name, SUM(o.total_amt_usd) total_amt
             FROM sales_reps s
             JOIN accounts a
             ON a.sales_rep_id = s.id
             JOIN orders o
             ON o.account_id = a.id
             JOIN region r
             ON r.id = s.region_id
             GROUP BY 1, 2) t1
     GROUP BY 1) t2
JOIN (SELECT s.name rep_name, r.name region_name, SUM(o.total_amt_usd) total_amt
     FROM sales_reps s
     JOIN accounts a
     ON a.sales_rep_id = s.id
     JOIN orders o
     ON o.account_id = a.id
     JOIN region r
     ON r.id = s.region_id
     GROUP BY 1,2
     ORDER BY 3 DESC) t3
ON t3.region_name = t2.region_name AND t3.total_amt = t2.total_amt;

-- Max for each region join the other table
SELECT region_name, MAX(total_amt) total_amt
     FROM(SELECT s.name rep_name, r.name region_name, SUM(o.total_amt_usd) total_amt
             FROM sales_reps s
             JOIN accounts a
             ON a.sales_rep_id = s.id
             JOIN orders o
             ON o.account_id = a.id
             JOIN region r
             ON r.id = s.region_id
             GROUP BY 1, 2) t1
     GROUP BY 1;

     SELECT t3.rep_name, t3.region_name, t3.total_amt
FROM(SELECT region_name, MAX(total_amt) total_amt
     FROM(SELECT s.name rep_name, r.name region_name, SUM(o.total_amt_usd) total_amt
             FROM sales_reps s
             JOIN accounts a
             ON a.sales_rep_id = s.id
             JOIN orders o
             ON o.account_id = a.id
             JOIN region r
             ON r.id = s.region_id
             GROUP BY 1, 2) t1
     GROUP BY 1) t2
JOIN (SELECT s.name rep_name, r.name region_name, SUM(o.total_amt_usd) total_amt
     FROM sales_reps s
     JOIN accounts a
     ON a.sales_rep_id = s.id
     JOIN orders o
     ON o.account_id = a.id
     JOIN region r
     ON r.id = s.region_id
     GROUP BY 1,2
     ORDER BY 3 DESC) t3
ON t3.region_name = t2.region_name AND t3.total_amt = t2.total_amt;


--For the region with the largest (sum) of sales total_amt_usd, how many total (count) orders were placed?

(SELECT r.name region_name, SUM(o.total_amt_usd) total_amt
     FROM sales_reps s
     JOIN accounts a
     ON a.sales_rep_id = s.id
     JOIN orders o
     ON o.account_id = a.id
     JOIN region r
     ON r.id = s.region_id
     GROUP BY 1
     ORDER BY 2 DESC
     LIMIT 1 ) t1


(SELECT r.name region_name, COUNT(o.total) total_amt
     FROM sales_reps s
     JOIN accounts a
     ON a.sales_rep_id = s.id
     JOIN orders o
     ON o.account_id = a.id
     JOIN region r
     ON r.id = s.region_id
     GROUP BY 1
     ORDER BY 2 DESC
     LIMIT 1 ) t2     
     
-- final query is join of two 
SELECT t1.region_name, t2.total_amt
FROM (SELECT r.name region_name, SUM(o.total_amt_usd) total_amt
     FROM sales_reps s
     JOIN accounts a
     ON a.sales_rep_id = s.id
     JOIN orders o
     ON o.account_id = a.id
     JOIN region r
     ON r.id = s.region_id
     GROUP BY 1
     ORDER BY 2 DESC
     LIMIT 1 ) t1
JOIN (SELECT r.name region_name, COUNT(o.total) total_amt
     FROM sales_reps s
     JOIN accounts a
     ON a.sales_rep_id = s.id
     JOIN orders o
     ON o.account_id = a.id
     JOIN region r
     ON r.id = s.region_id
     GROUP BY 1
     ORDER BY 2 DESC
     LIMIT 1 ) t2     
ON t1.region_name = t2.region_name

-- How many accounts had more total purchases than the account name which has bought the most standard_qty paper 
-- throughout their lifetime as a customer?

--First of all get most standard_qty paper total purchase threshold
SELECT COUNT(*)
FROM (SELECT a.name
       FROM orders o
       JOIN accounts a
       ON a.id = o.account_id
       GROUP BY 1
       HAVING SUM(o.total) > (SELECT total 
                   FROM (SELECT a.name act_name, SUM(o.standard_qty) tot_std, SUM(o.total) total
                         FROM accounts a
                         JOIN orders o
                         ON o.account_id = a.id
                         GROUP BY 1
                         ORDER BY 2 DESC
                         LIMIT 1) inner_tab)
             ) counter_tab;

-- For the customer that spent the most (in total over their lifetime as a customer) total_amt_usd,
-- how many web_events did they have for each channel?

SELECT a.name, w.channel, COUNT(*)
FROM accounts a
JOIN web_events w
ON a.id = w.account_id AND a.id =  (SELECT id
                     FROM (SELECT a.id, a.name, SUM(o.total_amt_usd) tot_spent
                           FROM orders o
                           JOIN accounts a
                           ON a.id = o.account_id
                           GROUP BY a.id, a.name
                           ORDER BY 3 DESC
                           LIMIT 1) inner_table)
GROUP BY 1, 2
ORDER BY 3 DESC;


-- What is the lifetime average amount spent in terms of total_amt_usd for the top 10 total spending accounts?
SELECT AVG(tot_spent)
FROM (SELECT a.id, a.name, SUM(o.total_amt_usd) tot_spent
      FROM orders o
      JOIN accounts a
      ON a.id = o.account_id
      GROUP BY a.id, a.name
      ORDER BY 3 DESC
       LIMIT 10) temp;


-- What is the lifetime average amount spent in terms of total_amt_usd, 
-- including only the companies that spent more per order, on average, than the average of all orders. 
SELECT AVG(avg_amt)
FROM (SELECT o.account_id, AVG(o.total_amt_usd) avg_amt
    FROM orders o
    GROUP BY 1
    HAVING AVG(o.total_amt_usd) > (SELECT AVG(o.total_amt_usd) avg_all
                                   FROM orders o)) temp_table;

-- Provide the name of the sales_rep in each region with the largest amount of total_amt_usd sales. (USING WITH)
     
WITH t1 AS (
  SELECT s.name rep_name, r.name region_name, SUM(o.total_amt_usd) total_amt
   FROM sales_reps s
   JOIN accounts a
   ON a.sales_rep_id = s.id
   JOIN orders o
   ON o.account_id = a.id
   JOIN region r
   ON r.id = s.region_id
   GROUP BY 1,2
   ORDER BY 3 DESC), 
t2 AS (
   SELECT region_name, MAX(total_amt) total_amt
   FROM t1
   GROUP BY 1)
SELECT t1.rep_name, t1.region_name, t1.total_amt
FROM t1
JOIN t2
ON t1.region_name = t2.region_name AND t1.total_amt = t2.total_amt;

-- For the region with the largest sales total_amt_usd, how many total orders were placed?

WITH t1 AS (
   SELECT r.name region_name, SUM(o.total_amt_usd) total_amt
   FROM sales_reps s
   JOIN accounts a
   ON a.sales_rep_id = s.id
   JOIN orders o
   ON o.account_id = a.id
   JOIN region r
   ON r.id = s.region_id
   GROUP BY 1
   ORDER BY 2 DESC
   LIMIT 1),
   t2 AS (
   SELECT r.name region_name, COUNT(o.total) total
   FROM sales_reps s
   JOIN accounts a
   ON a.sales_rep_id = s.id
   JOIN orders o
   ON o.account_id = a.id
   JOIN region r
   ON r.id = s.region_id
   GROUP BY 1
   ORDER BY 2 DESC
   )
SELECT t1.region_name, t2.total
FROM t1
JOIN t2
ON t1.region_name = t2.region_name

-- For the account that purchased the most (in total over their lifetime as a customer) standard_qty paper,
-- how many accounts still had more in total purchases?

WITH t1 AS (SELECT a.name , SUM(o.standard_qty) sum_stand, SUM(o.total) total
FROM orders o
JOIN accounts a
ON o.account_id = a.id
GROUP BY a.name
ORDER BY 2 DESC
LIMIT 1),
t2 AS (
  SELECT a.name
  FROM orders o
  JOIN accounts a
  ON a.id = o.account_id
  GROUP BY 1
  HAVING SUM(o.total) > (SELECT total FROM t1))

SELECT COUNT(*)
FROM t2 



-- For the customer that spent the most (in total over their lifetime as a customer) total_amt_usd, 
-- how many web_events did they have for each channel?

WITH t1 AS (
     SELECT a.name, a.id, SUM(o.total_amt_usd) total_usd
     FROM orders o 
     JOIN accounts a
     ON o.account_id = a.id
     GROUP BY 2,1
     ORDER BY 3 DESC
     LIMIT 1
)

SELECT a.name, w.channel channel, COUNT(*)
FROM web_events w
JOIN accounts a
ON w.account_id = a.id
WHERE w.account_id = (SELECT id FROM t1)
GROUP BY a.name, w.channel
ORDER BY 3 DESC


-- What is the lifetime average amount spent in terms of total_amt_usd for the top 10 total spending accounts?
WITH t1 AS (
     SELECT a.name, a.id, SUM(o.total_amt_usd) total_usd
     FROM orders o 
     JOIN accounts a
     ON o.account_id = a.id
     GROUP BY 2,1
     ORDER BY 3 DESC
     LIMIT 10
)

SELECT AVG(t1.total_usd)
FROM t1


-- What is the lifetime average amount spent in terms of total_amt_usd, including only the companies that spent more per order,
-- on average, than the average of all orders.

WITH t1 AS (
     SELECT AVG(o.total_amt_usd)
     FROM orders o
     ),
     t2 AS (
     SELECT a.name, AVG(o.total_amt_usd) sum_amt_usd
     FROM orders o 
     JOIN accounts a
     ON a.id = o.account_id
     GROUP BY a.name 
     HAVING AVG(o.total_amt_usd) > (SELECT AVG(o.total_amt_usd)
     FROM orders o)    
     )
SELECT AVG(t2.sum_amt_usd)
FROM t2



-- In the accounts table, there is a column holding the website for each company.
-- The last three digits specify what type of web address they are using. 
-- A list of extensions (and pricing) is provided here. 
-- Pull these extensions and provide how many of each website type exist in the accounts table

SELECT RIGHT(website, 3) AS domain, COUNT(*) num_companies
FROM accounts
GROUP BY 1
ORDER BY 2 DESC;

-- There is much debate about how much the name (or even the first letter of a company name) matters.
-- Use the accounts table to pull the first letter of each company name to see the distribution of company names that begin with each letter (or number).
SELECT LEFT(a.name, 1) AS first, COUNT(*) AS tot
FROM accounts a
GROUP BY first
ORDER BY 2 DESC;

-- There are 350 company names that start with a letter and 1 that starts with a number.
-- This gives a ratio of 350/351 that are company names that start with a letter or 99.7%.

SELECT SUM(num) nums, SUM(letter) letters
FROM (SELECT name, CASE WHEN LEFT(UPPER(name), 1) IN ('0','1','2','3','4','5','6','7','8','9') 
                       THEN 1 ELSE 0 END AS num, 
         CASE WHEN LEFT(UPPER(name), 1) IN ('0','1','2','3','4','5','6','7','8','9') 
                       THEN 0 ELSE 1 END AS letter
      FROM accounts) t1;

-- Consider vowels as a, e, i, o, and u. What proportion of company names start with a vowel, and what percent start with anything else?

WITH t1 AS (SELECT name, CASE WHEN LEFT(UPPER(name), 1) IN ('A','E','I','O','U')
             THEN 1 ELSE 0 END AS vocal,
             CASE WHEN LEFT(UPPER(name), 1) IN ('A','E','I','O','U')
             THEN 0 ELSE 1 END AS consonant
FROM accounts)

SELECT SUM(t1.vocal) AS vocal_sum, SUM(t1.consonant) AS consonant_sum
FROM t1


-- Use the accounts table to create first and last name columns that hold the first and last names for the primary_poc.
SELECT LEFT(primary_poc, STRPOS(primary_poc, ' ')) AS firstname, RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' ')) AS lasttname, primary_poc
FROM accounts

SELECT LEFT(name, STRPOS(name, ' ')) AS firstname, RIGHT(name, LENGTH(name) - STRPOS(name, ' ')) AS lasttname, name
FROM sales_reps


-- Each company in the accounts table wants to create an email address for each primary_poc.
-- The email address should be the first name of the primary_poc . last name primary_poc @ company name .com.
WITH t1 AS (
     SELECT LEFT(primary_poc, STRPOS(primary_poc, ' ') -1) AS firstname, RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' ')) AS lastname, LOWER(name) AS name 
     FROM accounts
)
SELECT LOWER(firstname)||'.'||LOWER(lastname)||'@'||name||'.com' AS email
FROM t1


--Using substring replace(string text, from text, to text)	text	Replace all occurrences in string of substring from with substring to	replace( 'abcdefabcdef', 'cd', 'XX')	abXXefabXXef
WITH t1 AS (
 SELECT LEFT(primary_poc, STRPOS(primary_poc, ' ') -1 ) first_name, RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' ')) last_name, name
 FROM accounts)
SELECT first_name, last_name, CONCAT(first_name, '.', last_name, '@', REPLACE(name, ' ', ''), '.com')
FROM  t1;


WITH t1 AS (
 SELECT LEFT(primary_poc,     STRPOS(primary_poc, ' ') -1 ) first_name,  RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' ')) last_name, name
 FROM accounts)
SELECT first_name, last_name, CONCAT(first_name, '.', last_name, '@', name, '.com') AS mail, LEFT(LOWER(first_name), 1) || RIGHT(LOWER(first_name), 1) || LEFT(LOWER(last_name), 1) || RIGHT(LOWER(last_name), 1) || LENGTH(first_name) || LENGTH(last_name) || REPLACE(UPPER(name), ' ', '')  AS pwd
FROM t1;




-- Provide the name of the sales_rep in each region with the largest amount of total_amt_usd sales. 
-- How many accounts had more total purchases than the account name which has bought the most standard_qty paper throughout their lifetime
-- as a customer?

    

-- HAVING instead of WHERE if filter with aggregate function 
-- DATE_TRUNC allows you to truncate your date to a particular part of your date-time column. Common trunctions are day, month, and year. Here is a great blog post by Mode Analytics on the power of this function.
-- DATE_PART can be useful for pulling a specific portion of a date, but notice pulling month or day of the week (dow) means that you are no longer keeping the years in order. Rather you are grouping for certain components regardless of which year they belonged in.


-- POSITION (symbol IN string) example: POSITION(',' IN city_state) 
-- STRPOS (string , symbol) example: STRPOS(city_state, ',')
-- Very similar functions

-- CONCAT( name,' ',lastname) oppure || example firstname || ' ' || lastname

-- CAST function CAST( AS ) oppure ()::datatype (es date)
-- COALESCE function returns the first non null value passed from each row, aggiungendo un secondo valore alla lista successivo alla colonna farò in modo
-- di offrire alternativa nel caso in cui sia presente un NULL.

-- A window function call always contains an OVER clause directly following the window function's name and argument(s). The PARTITION BY list within OVER specifies dividing the rows into groups,
-- or partitions, that share the same values of the PARTITION BY expression(s).
