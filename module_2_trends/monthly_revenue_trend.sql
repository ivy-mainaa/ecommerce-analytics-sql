-- KPI: Monthly Revenue Trend with MoM Growth Rate
-- Business question:
-- How is revenue trending month over month?

WITH monthly_revenue AS (
    SELECT
        DATE_TRUNC('month', o.order_purchase_timestamp) AS order_month,
        ROUND(SUM(p.payment_value)::numeric, 2) AS total_revenue
    FROM olist_orders o
    JOIN olist_order_payments p ON o.order_id = p.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY order_month
)
SELECT
    order_month,
    total_revenue,
    LAG(total_revenue) OVER (ORDER BY order_month) AS prev_month_revenue,
    ROUND(
        (total_revenue - LAG(total_revenue) OVER (ORDER BY order_month))
        / LAG(total_revenue) OVER (ORDER BY order_month) * 100,
    2) AS mom_growth_pct
FROM monthly_revenue
ORDER BY order_month;