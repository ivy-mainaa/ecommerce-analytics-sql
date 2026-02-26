-- KPI: Cancellation Rate
-- Percentage of total orders that were canceled

SELECT
  ROUND(
    COUNT(*) FILTER (WHERE order_status = 'canceled') * 100.0 / COUNT(*),
    2
  ) AS cancellation_rate_pct
FROM olist_orders;
