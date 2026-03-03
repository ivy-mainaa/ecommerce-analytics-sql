-- KPI: Cancellation Rate by Month
-- Business question:
-- Is the cancellation rate getting better or worse over time?

WITH monthly_orders AS (
    SELECT
        DATE_TRUNC('month', order_purchase_timestamp) AS order_month,
        COUNT(*) AS total_orders,
        COUNT(*) FILTER (WHERE order_status = 'canceled') AS canceled_orders
    FROM olist_orders
    GROUP BY order_month
)
SELECT
    order_month,
    total_orders,
    canceled_orders,
    ROUND(
        canceled_orders * 100.0 / total_orders,
    2) AS cancellation_rate_pct,
    ROUND(AVG(canceled_orders * 100.0 / total_orders) OVER (
        ORDER BY order_month
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ), 2) AS rolling_3mo_avg
FROM monthly_orders
ORDER BY order_month;
