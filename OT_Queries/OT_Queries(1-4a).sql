### TANGI AMBE ###
### JUMPlus Phase 2 ###
### 04/28/2023 ###

---------------------------------------------------------------------------------------
/* Hello! We're going to practice some SQL with a database
   from Oracle. This database covers:
   - PC component products
   - categories, orders and order items for said products
   - customers and employees
   - warehouses and their inventories
   - locations, countries, regions
   Hoowhee! That's a lot of tables. But when it comes to
   data, the more the merrier :) */
use ot;
---------------------------------------------------------------------------------------


---------------------------------------------------------------------------------------
/*  	*
	1a.) Select the region_id and count of all rows from the countries table. Group 
	by the region_id and order by count descending. Limit to 1 to find the region 
	with the most countries that have company locations. */
---------------------------------------------------------------------------------------
-- SELECT region_id, count(*) as 'amount of countries'
-- FROM countries
-- GROUP BY region_id
-- ORDER BY count(*) DESC
-- LIMIT 1;

SELECT region_id, count(*) as 'amount of countries'
FROM countries
GROUP BY region_id
ORDER BY 'amount of countries' DESC
LIMIT 1;


---------------------------------------------------------------------------------------
/* 	*
	1b.) Looks like we found the region with the most countries, but we don't know 
	the name of the region. Fortunately, that can be found in the regions table. 
	Using the results of the previous problem, find the name of the region with the
	most countries. We want to use an alias of 'region with most locations' for the 
        column label, as well. */
---------------------------------------------------------------------------------------
SELECT region_name
FROM regions
WHERE region_id = ( 
	SELECT region_id
	FROM countries
	GROUP BY region_id
	ORDER BY count(*) DESC
	LIMIT 1
);


---------------------------------------------------------------------------------------
/* 	**
	 1c.) Nice job! Now, here's a more difficult one. Using the locations table, 
	 select the state, city, and postal_code from locations where the country is 
	 NOT the United States (country_id != "US") and the name of the city starts
	 with "S". 
         Hint: Use LIKE and a wildcard. */
---------------------------------------------------------------------------------------
SELECT state, city, postal_code
FROM locations
WHERE country_id != 'US' AND city LIKE 'S%';


---------------------------------------------------------------------------------------
/*  	*
	1d.) As you may have seen in the problem above, there's a "state" column in the 
        locations table, but not all locations are in a state. Select all entries for 
        the locations that are NOT in a state. */
---------------------------------------------------------------------------------------
-- SELECT *
-- FROM locations
-- WHERE state IS NULL;

SELECT state, city, postal_code
FROM locations
WHERE country_id != 'US' AND city LIKE 'S%' AND state IS NULL;


---------------------------------------------------------------------------------------
/* 	**
	1e.) Your employer wants an update on the number of countries that have locations. 
	They note that they want unique countries but they're not sure how to do that 
	and they're asking you for help. Write a query for them. */
---------------------------------------------------------------------------------------
-- SELECT DISTINCT country_id as 'countries with locations'
-- FROM locations;

SELECT COUNT(DISTINCT country_id) AS 'number of countries with locations'
FROM locations;
---------------------------------------------------------------------------------------
/* 	**
	2a.) Why don't we switch gears? Let's take a look at the products in this
	database. Find the product names and prices of all products that have a 
	list_price between 100 and 500. You'll have to find the right table yourself on 
	this one. */
---------------------------------------------------------------------------------------
SELECT product_name, list_price
FROM products
WHERE list_price BETWEEN 100 AND 500;


---------------------------------------------------------------------------------------
/* 	**
	2b.) What do those product names even MEAN? If you don't know much about PC 
       components, it can be difficult to distinguish between different kinds of 
       products. Good thing we have a table for product categories! 
       
       Select the product_name, list_price, and category_name (from product category) 
       rows from the products table joined to the product_categories table on 
       category_id (using an inner join). */
---------------------------------------------------------------------------------------

SELECT 
	product_name, list_price, pc.category_name
FROM 
	products
JOIN product_categories as pc
	ON products.category_id = pc.category_id;
	


---------------------------------------------------------------------------------------
/* 	****
	2c.) Let's try joining more than two tables. You're looking for a popular CPU 
	that has more than 100 units in stock at your local warehouse in Toronto. You 
	only need to find the names of the products, but you'll need to join these 
	tables:
        - warehouses
        - inventories
        - products
        - product_categories
        The only info you need is the product_name and the list_price. */
---------------------------------------------------------------------------------------
-- category_name = CPU
-- quantity > 100
-- warehouse name = Toronto
SELECT 
	product_name, list_price
FROM 
	products
JOIN product_categories as pc
	ON products.category_id = pc.category_id
LEFT JOIN inventories
	ON products.product_id = inventories.product_id
LEFT JOIN warehouses
	ON inventories.warehouse_id = warehouses.warehouse_id
WHERE category_name = 'CPU' AND quantity > 100 AND warehouse_name = 'Toronto';


---------------------------------------------------------------------------------------
/* 	**
	3a.) Now that we have a bit more of an idea of what kinds of products we have, 
	let's investigate prices. Select the avg list_price of all products. */
---------------------------------------------------------------------------------------
SELECT AVG(list_price)
FROM products;


---------------------------------------------------------------------------------------
/* 	***
	3b.) Let's take a closer look at the average prices of each category. Select the 
        category_name and average list_price of each product category, rounded to 2 
        decimals. */
---------------------------------------------------------------------------------------
SELECT
	ROUND(AVG(list_price), 2), category_name AS 'category'
FROM
	products
JOIN product_categories as pc
	ON products.category_id = pc.category_id
GROUP BY category;

---------------------------------------------------------------------------------------
/* 	**
	4a.) We have the mean, now, but the outliers in the data will skew the mean.
	There are other statistics that we can look at as well, like mode!
       
       Let's start by 
	-- selecting list_price and the count of list_prices 
	-- grouped by list_price
        -- ordered with the highest value first 
        -- limited to 2.
        Note: We limit to 2 to see if there are multiple modes. If the top two results 
        of this query have the same count, rerun the query with limit + 1, and repeat
        (do this manually). If there's more than one mode, this is how you find them 
        all without incorporating more advanced functions. */
---------------------------------------------------------------------------------------
SELECT list_price, COUNT(list_price) AS 'amount'
FROM products
GROUP BY list_price
ORDER BY amount DESC
LIMIT 2;