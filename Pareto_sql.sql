select * from name;
select * from product;
select * from order_items;

-- populating null data 610 nows less than 2% hence drop

SELECT
    COUNT(*) AS total_rows,
    COUNT(product_category_name) AS non_null_category
FROM product;

CREATE TABLE products_cleaned AS
SELECT *
FROM product
WHERE product_category_name IS NOT NULL;

select count(*) from products_cleaned;

-- KPI 2 :gross revenue (highest 6929)
select  sum(Round(price + freight_value,0)) as gross_revenue from order_items o; 
-- 15844195
select  sum(Round(price + freight_value,0))/count(order_id) as gross_revenue from order_items o;
-- 140.65

select  *,Round(price + freight_value,0) as gross_revenue from order_items o
join products_cleaned p on p.product_id = o.product_id
ORDER BY gross_revenue desc;

select Round(price + freight_value,0) as gross_revenue ,sum(Round(price + freight_value,0))  over() from order_items o
join products_cleaned p on p.product_id = o.product_id
ORDER BY gross_revenue desc;

-- KPI 3 : category wise
-- health and beauty highest : 1441160
-- security and services lowest : 324

select *, Round(price + freight_value,0) as gross_revenue from 
order_items o join products_cleaned p 
on p.product_id = o.product_id
join name on name.product_category_name = p.product_category_name;

select product_category_name_english, sum(Round(price + freight_value,0)) as gross_revenue from 
order_items o join products_cleaned p 
on p.product_id = o.product_id
join name on name.product_category_name = p.product_category_name
group by product_category_name_english
order by gross_revenue desc;

-- KPI 4 category order velocity
-- maximum : bed_bath_table(11115)
-- minimim : security_and_services(2)

select product_category_name_english,sum(Round(price + freight_value,0)) as gross_revenue, count(order_id) as transaction_frequency from 
order_items o join products_cleaned p 
on p.product_id = o.product_id
join name on name.product_category_name = p.product_category_name
group by product_category_name_english
order by gross_revenue desc;

-- KPI 5 : Average order value
-- computers has highest AOV as 1146.83
-- home comfort 2 has lowest as 39.1
-- net AOV : 160.58
with cte as(
select product_category_name_english,sum(Round(price + freight_value,0)) as gross_revenue, count(order_id) as transaction_frequency from 
order_items o join products_cleaned p 
on p.product_id = o.product_id
join name on name.product_category_name = p.product_category_name
group by product_category_name_english
order by gross_revenue desc)
select gross_revenue, transaction_frequency , ROUND((gross_revenue)/(transaction_frequency),2) as AOV,product_category_name_english
from cte
group by product_category_name_english
order by AOV desc ;

SELECT
    ROUND(	
        SUM(price + freight_value)
        /
        COUNT(DISTINCT order_id),
        2
    ) AS AOV
FROM order_items;

-- KPI 6 : individual revenue contribution
-- health beauty, watches has highest revenue contriburion
 
WITH category_revenue AS (

SELECT
    product_category_name_english,
    SUM(price + freight_value) AS gross_revenue
FROM order_items o
JOIN products_cleaned p
    ON o.product_id = p.product_id
JOIN name n
    ON p.product_category_name = n.product_category_name
GROUP BY product_category_name_english

)

SELECT
    product_category_name_english,
    gross_revenue,

    ROUND(
        gross_revenue
        / SUM(gross_revenue) OVER ()
        * 100,
        2
    ) AS revenue_contribution_pct

FROM category_revenue
ORDER BY gross_revenue DESC;

-- KPI 7 : Cumulative Revenue Share %

WITH category_revenue AS (

SELECT
    product_category_name_english,
    SUM(price + freight_value) AS gross_revenue
FROM order_items o
JOIN products_cleaned p
    ON o.product_id = p.product_id
JOIN name n
    ON p.product_category_name = n.product_category_name
GROUP BY product_category_name_english

)

SELECT

    product_category_name_english,

    gross_revenue,

    ROUND(
        gross_revenue
        / SUM(gross_revenue) OVER ()
        * 100,
        2
    ) AS revenue_contribution_pct,

    ROUND(
        SUM(gross_revenue) OVER (
            ORDER BY gross_revenue DESC
        )
        /
        SUM(gross_revenue) OVER ()
        * 100,
        2
    ) AS cumulative_revenue_pct

FROM category_revenue

ORDER BY gross_revenue DESC;



drop table pareto_analysis;


CREATE TABLE Pareto_dashboard as
WITH category_revenue AS (
    SELECT
        n.product_category_name_english,
        COUNT(DISTINCT oi.order_id) AS order_velocity,
        SUM(oi.price + oi.freight_value) AS gross_revenue,
        SUM(oi.price + oi.freight_value) /
        COUNT(DISTINCT oi.order_id) AS AOV
    FROM order_items oi
    JOIN products_cleaned p
        ON oi.product_id = p.product_id
    JOIN name n
        ON p.product_category_name = n.product_category_name
    GROUP BY n.product_category_name_english
)

SELECT
    *,
    ROUND(
        gross_revenue /
        SUM(gross_revenue) OVER() * 100,
        2
    ) AS revenue_pct,

    ROUND(
        SUM(gross_revenue) OVER(
            ORDER BY gross_revenue DESC
        ) /
        SUM(gross_revenue) OVER() * 100,
        2
    ) AS cumulative_pct

FROM category_revenue
ORDER BY gross_revenue DESC;


select * from Pareto_dashboard


-- END