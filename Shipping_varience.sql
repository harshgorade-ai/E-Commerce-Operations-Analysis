select count(*)  from orders;
select count(*) from reviews;
select * from reviews;
select * from orders;

SELECT *
FROM orders o
LEFT JOIN reviews r
ON o.order_id = r.order_id;

-- KPI 1 : general info
select count(Distinct order_id) from orders;
--  total distinct order ids : 99441

-- average review score : 4.0864
select avg(review_score) from reviews;


-- KPI 2 : shipping variance ON time = 89941, LATE 6535
WITH cte AS (
    SELECT
        delivered_customer_date,
        estimated_delivery_date,
        review_score,
		DATEDIFF(delivered_customer_date, estimated_delivery_date) AS var
    FROM orders o
    LEFT JOIN reviews r
    ON o.order_id = r.order_id
)

SELECT 
	delivered_customer_date,
	estimated_delivery_date,
	var,
    review_score
FROM cte
where var is not null;
 
 
SELECT
    CASE
        WHEN delivered_customer_date <= estimated_delivery_date
        THEN 'On Time'
        ELSE 'Late'
    END AS delivery_status,
    COUNT(*) AS orders
FROM orders
WHERE delivered_customer_date IS NOT NULL
GROUP BY delivery_status;

-- KPI 3: Reviews by Delivery Status review scores as ON TIME 4.2898 and late 2.1136
WITH cte AS (
SELECT
    CASE
        WHEN delivered_customer_date <= estimated_delivery_date
        THEN 'On Time'
        ELSE 'Late'
    END AS delivery_status,
    review_score
FROM orders o
LEFT JOIN reviews r
ON o.order_id = r.order_id
)

SELECT
    delivery_status,
    AVG(review_score)
FROM cte
GROUP BY delivery_status;

-- KPI 4: Review Distribution most are 5 stars customer satisfaction
SELECT
    review_score,
    COUNT(*) AS total_reviews
FROM reviews
GROUP BY review_score
ORDER BY review_score;

-- KPI 5 : Review buckets max for on time/early least for 7+ days
WITH cte AS (
    SELECT
        delivered_customer_date,
        estimated_delivery_date,
        review_score,
		DATEDIFF(delivered_customer_date, estimated_delivery_date) AS var
    FROM orders o
    LEFT JOIN reviews r
    ON o.order_id = r.order_id
  
)
SELECT 
	CASE
		WHEN var <= 0 THEN 'On Time/Early'
		WHEN var <= 3 THEN '1-3 Days Late'
		WHEN var <= 7 THEN '4-7 Days Late'
	ELSE '7+ Days Late'
    END AS Delivery_bucket,
	AVG(review_score) AS avg_review
from cte
where var is not null
group by Delivery_bucket;

-- KPI 6 : no of actual orders delivered
select count(*) from orders 
where status = 'delivered';

SELECT
    CASE
        WHEN o.status = 'delivered' THEN 'Delivered'
        ELSE 'Not Delivered'
    END AS delivery_status,
    COUNT(*) AS total_orders,
    AVG(r.review_score) AS avg_review_score
FROM orders o
LEFT JOIN reviews r
ON o.order_id = r.order_id
GROUP BY delivery_status;

-- KPI 7  count as buckets
SELECT
    CASE
        WHEN DATEDIFF(delivered_customer_date, estimated_delivery_date) <= 0
            THEN 'On Time/Early'
        WHEN DATEDIFF(delivered_customer_date, estimated_delivery_date) <= 3
            THEN '1-3 Days Late'
        WHEN DATEDIFF(delivered_customer_date, estimated_delivery_date) <= 7
            THEN '4-7 Days Late'
        ELSE '7+ Days Late'
    END AS delivery_bucket,
    COUNT(*) AS total_orders
FROM orders
WHERE delivered_customer_date IS NOT NULL
GROUP BY delivery_bucket
ORDER BY total_orders DESC;

SELECT 1;

-- END