-- KPI: Revenue Concentration - Top 10% of Customers
-- Business question:
-- How much of total revenue comes from the top 10% of customers?

WITH customer_revenue AS (
    SELECT
        c.customer_unique_id,
        ROUND(SUM(p.payment_value)::numeric, 2) AS total_spent
    FROM olist_orders o
    JOIN olist_customers c ON o.customer_id = c.customer_id
    JOIN olist_order_payments p ON o.order_id = p.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
),
percentiles AS (
    SELECT
        customer_unique_id,
        total_spent,
        NTILE(10) OVER (ORDER BY total_spent DESC) AS spending_decile
    FROM customer_revenue
)
SELECT
    COUNT(*) AS total_customers,
    ROUND(SUM(total_spent)::numeric, 2) AS total_revenue,
    ROUND(SUM(total_spent) FILTER (WHERE spending_decile = 1)::numeric, 2) AS top_10_pct_revenue,
    ROUND(
        SUM(total_spent) FILTER (WHERE spending_decile = 1) * 100.0 
        / SUM(total_spent),
    2) AS top_10_pct_revenue_share
FROM percentiles;
