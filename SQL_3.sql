select * from orders;
select count(*) from customer;
select count(*) from name;
select count(*) from products_cleaned;
select count(*) from order_items;
-- KPI 1: Retention
-- total not retained orders are 96096 that is 96.63%


with cte as(
select distinct c.customer_unique_id,c.customer_id, 
row_number() over(partition by customer_unique_id )  as r
from orders o
join customer c on o.customer_id = c.customer_id
join order_items oi on oi.order_id = o.order_id
join product p on p.product_id = oi.product_id
join name n on n.product_category_name = p.product_category_name
WHERE p.product_category_name IS NOT NULL	
) 
select count(*) as c from cte ;



-- 94088
-- 111023 

WITH customer_orders AS (
    SELECT
        c.customer_unique_id,
        o.order_id,
        o.purchase_date,
        ROW_NUMBER() OVER (
            PARTITION BY c.customer_unique_id
            ORDER BY o.purchase_date
        ) AS order_number
    FROM orders o
    JOIN customer c
        ON o.customer_id = c.customer_id
)
SELECT *
FROM customer_orders;



-- whether the customer returned

WITH customer_orders AS (
    SELECT
        c.customer_unique_id,
        o.order_id,
        o.purchase_date,
        ROW_NUMBER() OVER (
            PARTITION BY c.customer_unique_id
            ORDER BY o.purchase_date
        ) AS order_number,
        COUNT(*) OVER (
            PARTITION BY c.customer_unique_id
        ) AS total_orders
    FROM orders o
    JOIN customer c
        ON o.customer_id = c.customer_id
)

SELECT
    customer_unique_id,
    order_id,
    CASE
        WHEN total_orders > 1 THEN 'Repeat'
        ELSE 'One-time'
    END AS customer_type
FROM customer_orders
WHERE order_number = 1;


-- Add the first order's review

WITH customer_orders AS (
    SELECT
        c.customer_unique_id,
        o.order_id,
        o.purchase_date,
        ROW_NUMBER() OVER (
            PARTITION BY c.customer_unique_id
            ORDER BY o.purchase_date
        ) AS order_number,
        COUNT(*) OVER (
            PARTITION BY c.customer_unique_id
        ) AS total_orders
    FROM orders o
    JOIN customer c
        ON o.customer_id = c.customer_id
)

SELECT
    co.customer_unique_id,
    r.review_score,
    CASE
        WHEN co.total_orders > 1 THEN 'Repeat'
        ELSE 'One-time'
    END AS customer_type
FROM customer_orders co
JOIN reviews r
    ON co.order_id = r.order_id
WHERE co.order_number = 1;