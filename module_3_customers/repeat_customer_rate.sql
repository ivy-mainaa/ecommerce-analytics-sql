-- KPI: Repeat Customer Rate
-- Business question:
-- What percentage of customers have made more than one purchase?

WITH customer_order_counts AS (
    SELECT
        c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS total_orders
    FROM olist_orders o
    JOIN olist_customers c ON o.customer_id = c.customer_id
    GROUP BY c.customer_unique_id
)
SELECT
    COUNT(*) AS total_customers,
    COUNT(*) FILTER (WHERE total_orders > 1) AS repeat_customers,
    ROUND(
        COUNT(*) FILTER (WHERE total_orders > 1) * 100.0 / COUNT(*),
    2) AS repeat_customer_rate_pct
FROM customer_order_counts;