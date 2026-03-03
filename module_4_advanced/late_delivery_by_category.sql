-- KPI: Late Delivery Rate by Product Category
-- Business question:
-- Which product categories have the highest late delivery rates?

SELECT
    t.product_category_name_english AS category,
    COUNT(DISTINCT o.order_id) AS total_orders,
    COUNT(DISTINCT o.order_id) FILTER (
        WHERE o.order_delivered_customer_date > o.order_estimated_delivery_date
    ) AS late_orders,
    ROUND(
        COUNT(DISTINCT o.order_id) FILTER (
            WHERE o.order_delivered_customer_date > o.order_estimated_delivery_date
        ) * 100.0 / COUNT(DISTINCT o.order_id),
    2) AS late_delivery_rate_pct,
    ROUND(AVG(
        EXTRACT(EPOCH FROM (
            o.order_delivered_customer_date - o.order_estimated_delivery_date
        )) / 86400
    )::numeric, 2) AS avg_days_late
FROM olist_orders o
JOIN olist_order_items i ON o.order_id = i.order_id
JOIN olist_products p ON i.product_id = p.product_id
JOIN olist_category_name_translation t 
    ON p.product_category_name = t.product_category_name
WHERE o.order_status = 'delivered'
    AND o.order_delivered_customer_date IS NOT NULL
GROUP BY category
HAVING COUNT(DISTINCT o.order_id) > 100
ORDER BY late_delivery_rate_pct DESC
LIMIT 10;
