-- KPI: Average Time Between First and Second Order
-- Business question:
-- For customers who did come back, how long did it take them to make a second purchase?

WITH customer_orders AS (
    SELECT
        c.customer_unique_id,
        o.order_purchase_timestamp,
        ROW_NUMBER() OVER (
            PARTITION BY c.customer_unique_id 
            ORDER BY o.order_purchase_timestamp
        ) AS order_rank
    FROM olist_orders o
    JOIN olist_customers c ON o.customer_id = c.customer_id
    WHERE o.order_status = 'delivered'
),
first_and_second AS (
    SELECT
        customer_unique_id,
        MAX(CASE WHEN order_rank = 1 THEN order_purchase_timestamp END) AS first_order,
        MAX(CASE WHEN order_rank = 2 THEN order_purchase_timestamp END) AS second_order
    FROM customer_orders
    WHERE order_rank <= 2
    GROUP BY customer_unique_id
    HAVING COUNT(*) = 2
)
SELECT
    COUNT(*) AS repeat_customers,
    ROUND(AVG(
        EXTRACT(EPOCH FROM (second_order - first_order)) / 86400
    )::numeric, 2) AS avg_days_between_orders
FROM first_and_second;
