-- KPI: Monthly Cohort Retention
-- Business question:
-- Of customers who first purchased in a given month, how many came back in subsequent months?

WITH first_purchase AS (
    SELECT
        c.customer_unique_id,
        DATE_TRUNC('month', MIN(o.order_purchase_timestamp)) AS cohort_month
    FROM olist_orders o
    JOIN olist_customers c ON o.customer_id = c.customer_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
),
customer_activity AS (
    SELECT
        c.customer_unique_id,
        DATE_TRUNC('month', o.order_purchase_timestamp) AS activity_month
    FROM olist_orders o
    JOIN olist_customers c ON o.customer_id = c.customer_id
    WHERE o.order_status = 'delivered'
),
cohort_data AS (
    SELECT
        f.cohort_month,
        EXTRACT(MONTH FROM AGE(a.activity_month, f.cohort_month)) AS month_number,
        COUNT(DISTINCT f.customer_unique_id) AS customers
    FROM first_purchase f
    JOIN customer_activity a ON f.customer_unique_id = a.customer_unique_id
    GROUP BY f.cohort_month, month_number
)
SELECT
    cohort_month,
    month_number,
    customers,
    FIRST_VALUE(customers) OVER (
        PARTITION BY cohort_month ORDER BY month_number
    ) AS cohort_size,
    ROUND(
        customers * 100.0 / FIRST_VALUE(customers) OVER (
            PARTITION BY cohort_month ORDER BY month_number
        ),
    2) AS retention_pct
FROM cohort_data
WHERE month_number >= 0
ORDER BY cohort_month, month_number;