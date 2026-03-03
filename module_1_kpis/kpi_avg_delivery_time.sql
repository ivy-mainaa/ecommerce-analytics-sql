-- KPI: Average Delivery Time (Days)
-- Business question:
-- On average, how many days does it take from purchase to delivery?

SELECT
  ROUND(
    AVG(
      EXTRACT(EPOCH FROM (order_delivered_customer_date - order_purchase_timestamp)) / 86400
    )::numeric,
    2
  ) AS avg_delivery_days
FROM olist_orders
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NOT NULL;
