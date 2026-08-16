USE ecommerce_analytics;
SELECT
sum(quantity*unit_price)  AS Total_sales
FROM order_items;

SELECT
COUNT(order_id) AS ORDER_COUNT
FROM orders;

SELECT COUNT(distinct customer_id) AS customer_count
FROM orders;
WITH revenue AS(
SELECT i.quantity AS quantity,i.unit_price AS PRICE ,MONTH(o.order_date) AS MONTHH,YEAR(o.order_date) AS years
FROM ORDERS O
JOIN ORDER_ITEMS I
ON O.order_id=i.order_id)

SELECT monthh,years,
SUM(quantity*price) AS revenue
FROM revenue
GROUP BY monthh,years
ORDER BY MONTHH,years;

SELECT
	SUM(quantity*unit_price)/count(distinct order_id) AS Avg_order_value
    FROM order_items;
    
WITH products_revenue AS(
SELECT p.product_name AS product_name,
SUM(i.quantity*i.unit_price) AS REVENUE
FROM products p
JOIN order_items i
ON p.product_id=i.product_id
GROUP BY p.product_name),

RANKED AS(
SELECT PRODUCT_NAME,REVENUE,
dense_rank()OVER(order by revenue DESC) AS PRODUCT_REVENUE1
FROM products_revenue)

SELECT*
FROM ranked
WHERE PRODUCT_REVENUE1<=5;

WITH cat AS (
SELECT c.category_name AS CATEGORI,p.product_name AS product,
SUM(i.quantity*i.unit_price) AS revenue
FROM categories c
JOIN products p
ON c.category_id=p.category_id
JOIN order_items i
ON p.product_id=i.product_id
GROUP BY c.category_name,p.product_name),

RANKS AS(
SELECT *,
dense_rank()OVER(partition by categori ORDER BY revenue DESC) AS RN
FROM cat)

SELECT*
FROM RANKS
WHERE RN <=3;

SELECT customer_id,
COUNT(order_id) AS order_count,
CASE 
when count(order_id)=1 THEN "NEW CUSTOMER"
ELSE "OLD CUSTOMER"
END AS CUSTOMER_STATUS
FROM orders
GROUP BY customer_id;

SELECT c.customer_id ,
SUM(i.quantity*i.unit_price) AS total_spend
FROM order_items i
JOIN orders c
ON i.order_id=c.order_id
GROUP BY c.customer_id;

WITH customer_spend AS(
SELECT  distinct O.customer_id,
SUM(i.quantity*i.unit_price) AS Total_Spend
FROM orders o
JOIN order_items i
ON o.order_id=i.order_id
GROUP BY o.customer_id),

RANKS AS (
SELECT *,
dense_rank()OVER(ORDER BY total_spend DESC) AS RN
FROM customer_spend)

SELECT*
FROM RANKS;

WITH REVENUES AS (
SELECT MONTH(o.order_date) AS months,
SUM(i.quantity*i.unit_price) AS REVENUE
FROM order_items i
JOIN orders o
on i.order_id=o.order_id
GROUP BY MONTH(order_date)),

GROWTH AS(
SELECT MONTHS,REVENUE,
LAG(REVENUE)OVER(order by months ) AS previous_MN_revenue
FROM REVENUES),

PERCENTAGE AS(
SELECT MONTHS,REVENUE,REVENUE-PREVIOUS_MN_REVENUE AS PREVIOUS_REVENUE,
ROUND((revenue-PREVIOUS_MN_REVENUE)/previous_mn_revenue*100,2) AS PERCENT
FROM GROWTH)

SELECT*
FROM percentage;
WITH AV AS(
SELECT MONTH(o.order_date) AS months,
SUM(i.quantity*i.unit_price) AS revenue
FROM orders o
JOIN order_items i
ON o.order_id=i.order_id
GROUP BY MONTH(o.order_date)),

Z AS (
SELECT months,revenue,
 sum(REVENUE)OVER(order by months) RUNNING_TOTAL
 FROM AV)
 
 SELECT*FROM Z;
 WITH mon AS(
 SELECT month(o.order_date ) AS MONTHS,
 SUM(i.quantity*i.unit_price) AS revenue
 FROM orders o
 JOIN order_items i
 ON o.order_id=i.order_id
 GROUP BY month(o.order_date)),
 
 PRE AS(
 SELECT months,revenue,
 LAG(revenue) OVER(order by months) AS previous_revenue
 FROM MON)
 
 SELECT*
 FROM pre;
 WITH RN AS(
 SELECT i.product_id,
 sum(r.return_quantity) AS RETURN_COUNT,
 SUM(i.quantity) AS Total_orders
 FROM returns r
 JOIN order_items i
 ON r.order_item_id=i.order_item_id
 GROUP BY i.product_id),
  
RR AS(
select *,
(RETURN_COUNT/TOTAL_ORDERS)*100 AS RETURN_RATIO
FROM RN)

SELECT*
FROM RR;

WITH total as(
SELECT o.customer_id AS customer_id,
sum(i.quantity*i.unit_price) AS TOTAL_SPEND
FROM ORDERS O
JOIN ORDER_ITEMS I
ON O.order_id=i.order_id
GROUP BY o.customer_id),

AVGS AS(
SELECT TOTAL_SPEND,customer_id,
AVG(TOTAl_spend)OVER() AS AVG_SPEND
FROM total)

SELECT*
FROM avgs
where TOTAL_SPEND>AVG_SPEND;

WITH heighest AS(
SELECT c.city AS CITY,c.customer_id AS CUSTOMER,
SUM(i.quantity*i.unit_price) AS TOTAL_REVENUE
FROM customers c
JOIN orders o
ON c.customer_id=o.customer_id
JOIN order_items i
ON o.order_id=i.order_id
GROUP BY C.CITY,c.customer_id),

RN AS(
SELECT CITY,TOTAL_REVENUE,CUSTOMER,
dense_rank()over( PARTITION BY CITY ORDER BY total_revenue DESC) AS HEIGHEST_CUS
FROM HEIGHEST)

SELECT*
FROM RN
WHERE HEIGHEST_CUS=1;
WITH HS AS(
SELECT c.customer_name,c.city,
SUM(i.quantity*i.unit_price) AS TOTAL_SPEND
FROM customers c
JOIN orders o
ON c.customer_id=o.customer_id
JOIN order_items i
ON I.order_id=o.order_id
GROUP BY C.CUSTOMER_NAME,C.CITY),

RN AS(
SELECT*,
dense_rank()OVER(ORDER BY TOTAL_SPEND DESC) AS RANKS
FROM HS)

SELECT*
FROM RN
WHERE RANKS<=5;

WITH HS AS(
SELECT c.category_name C_N,p.product_name p_N,
SUM(I.QUANTITY*I.UNIT_PRICE) AS REVENUE
FROM categories c
JOIN products p
ON c.category_id=p.category_id
JOIN order_items i
ON i.product_id=p.product_id
GROUP BY C.CATEGORY_NAME,P.PRODUCT_NAME),

RN AS(
SELECT P_N ,C_N,revenue,
dense_rank()OVER(partition by C_N ORDER BY REVENUE DESC) H_REVENUE
FROM HS)

SELECT*
FROM RN
WHERE h_REVENUE=1;
WITH X AS(
SELECT o.customer_id,i.order_id as oo
FROM Order_items i
LEFT JOIN ORDERS O
ON o.order_id=i.order_id
GROUP BY o.customer_id,i.order_id)

SELECT*FROM X WHERE OO IS NULL;

SELECT
    c.customer_id,
    c.customer_name
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;


SELECT customer_id,
count(order_id) AS total_orders
FROM orders
GROUP BY customer_id
HAVING count(*)>3;

WITH HS AS(
SELECT c.customer_name,c.city,
SUM(i.quantity*i.unit_price) AS TOTAL_SPEND
FROM customers c
JOIN orders o
ON c.customer_id=o.customer_id
JOIN order_items i
ON I.order_id=o.order_id
GROUP BY C.CUSTOMER_NAME,C.CITY),

RN AS(
SELECT*,
dense_rank()OVER(ORDER BY TOTAL_SPEND DESC) AS RANKS
FROM HS)

SELECT*
FROM RN
WHERE RANKS=2;

SELECT o.customer_id ,
COUNT(distinct c.category_id) AS ORDER_COUNT
FROM categories c
JOIN products p
ON c.category_id=p.category_id
JOIN order_items i
ON i.product_id=p.product_id
JOIN orders o
ON i.order_id=o.order_id
GROUP BY o.customer_id
HAVING count(distinct c.category_id)>=3;

WITH HS AS(
SELECT p.product_name AS product,
sum(I.quantity) AS Total_quantity
FROM products p
JOIN order_items i
ON p.product_id=i.product_id
GROUP BY p.product_name),

RN AS(
SELECT *,
dense_rank()OVER(ORDER BY TOTAL_QUANTITY DESC) AS RANKS
FROM hs)

SELECT*
FROM RN;

SELECT  customer_id,
MIN(order_date) AS first_order_date
FROM orders
GROUP BY customer_id
ORDER BY first_order_date
;
WITH C AS(
SELECT customer_id,
MAX(order_date) AS FIRST_ORDER,
MIN(order_date) AS last_order
FROM orders
GROUP BY customer_id)

SELECT customer_id ,FIRST_ORDER,LAST_ORDER,
datediff(last_order, first_order) AS DAYS
FROM C;

SELECT customer_id,
COUNT(order_id) ORDER_COUNT
FROM orders
GROUP BY customer_id
HAVING count(order_id)>=2;

SELECT  customer_id,
Max(order_date) AS latest_order
FROM orders
GROUP BY customer_id
ORDER BY LATEST_ORDER;

WITH TOTAL AS(
SELECT p.product_name AS product,p.category_id AS c_n,
SUM(i.quantity*i.unit_price) AS TOTAL_P_REVENUE
FROM products p
JOIN order_items i
ON p.product_id=i.product_id
GROUP BY p.product_name,p.category_id),

category_avg AS (
  SELECT c_n,
         AVG(total_p_revenue) AS avg_c_revenue
  FROM TOTAL
  GROUP BY c_n )
  

SELECT t.product,ca.c_n,t.TOTAL_P_REVENUE,ca.AVG_c_REVENUE
FROM total t
JOIN category_avg ca
ON t.c_n=ca.c_n
WHERE t.TOTAL_P_REVENUE>ca.AVG_c_REVENUE;

SELECT month(o.order_date),
SUM(i.quantity*i.unit_price) AS REVENUE
FROM orders o
JOIN order_items i
ON o.order_id=i.order_id
GROUP BY MONTH(o.order_date)
ORDER BY REVENUE DESC
LIMIT 1; 

SELECT o.customer_id,
SUM(i.quantity*i.unit_price) AS REVENUE,
 CASE 
 when sum(i.quantity*i.unit_price)>100000 THEN 'HIGH VALUE'
 WHEN sum(i.quantity*i.unit_price) between 50000 and 99999 THEN 'medium'
 ELSE 'LOW VALUE' END AS customer_segment
 FROM orders o
 JOIN order_items i
 ON o.order_id =i.order_id
 GROUP BY o.customer_id;


