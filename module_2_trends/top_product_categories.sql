-- KPI: Average Order Value Over Time
-- Business question:
-- Is the average amount customers spend per order increasing or decreasing over time?

SELECT
    DATE_TRUNC('month', o.order_purchase_timestamp) AS order_month,
    ROUND(AVG(p.payment_value)::numeric, 2) AS avg_order_value,
    COUNT(DISTINCT o.order_id) AS total_orders
FROM olist_orders o
JOIN olist_order_payments p ON o.order_id = p.order_id
WHERE o.order_status = 'delivered'
GROUP BY order_month
ORDER BY order_month;
