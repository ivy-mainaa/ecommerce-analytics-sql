-- KPI 2: On-Time Delivery Rate
-- Business question:
-- What percentage of delivered orders arrive on or before the estimated delivery date?

SELECT
    ROUND(
        COUNT(*) FILTER (
            WHERE order_delivered_customer_date <= order_estimated_delivery_date
        ) * 100.0 / COUNT(*),
        2
    ) AS on_time_delivery_rate_pct
FROM olist_orders
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NOT NULL;
