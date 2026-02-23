-- KPI 1: Monthly Order Volume
-- Business question:
-- How many delivered orders are placed each month?

SELECT
    DATE_TRUNC('month', order_purchase_timestamp) AS order_month,
    COUNT(DISTINCT order_id) AS total_orders
FROM olist_orders
WHERE order_status = 'delivered'
GROUP BY order_month
ORDER BY order_month;
