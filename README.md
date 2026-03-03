E-Commerce Analysis — SQL
I used PostgreSQL to analyze 100k+ orders from Olist, a Brazilian e-commerce marketplace, to answer real business questions about revenue, customer behavior, and operations. The dataset spans 2016–2018 across 8 relational tables.

Findings
A few things stood out that I wouldn't have expected going in:

Revenue grew 20x over two years, but average order value barely moved (~$150 the whole time). All the growth came from more orders, not bigger ones.
Only 3% of customers ever came back for a second purchase. The business is almost entirely dependent on constantly acquiring new customers, which is expensive and risky long-term.
The customers who did return took about 81 days on average to do so. That's a big window where a well-timed email or promotion could make a real difference.
The top 10% of customers drove 38% of revenue, but most of them were one-time high-value buyers, not loyal repeat customers.
Cancellation rates are actually healthy, under 1% consistently from 2017 onwards, with a few anomalies at the edges of the dataset from data cutoff issues.
Audio and fashion categories had the highest late delivery rates (~13%), but interestingly most orders in those categories still arrived early, with the late ones are outliers dragging the average.


Project Structure
ecommerce-analytics-sql/
├── module_1_kpis/
│   ├── kpi_avg_delivery_time.sql
│   ├── kpi_cancellation_rate.sql
│   ├── kpi_monthly_orders.sql
│   └── kpi_on_time_delivery.sql
├── module_2_trends/
│   ├── monthly_revenue_trend.sql
│   ├── avg_order_value.sql
│   └── top_product_categories.sql
├── module_3_customers/
│   ├── repeat_customer_rate.sql
│   ├── revenue_concentration.sql
│   └── time_between_orders.sql
└── module_4_advanced/
    ├── cohort_retention.sql
    ├── late_delivery_by_category.sql
    └── cancellation_rate_by_month.sql

Module Breakdown
Module 1 : Core KPIs
The baseline stuff: average delivery time, cancellation rate, on-time delivery rate, and monthly order volume. Nothing fancy here but it sets up the story for everything else.
Module 2 : Revenue & Trends
Month-over-month revenue with growth rates, average order value over time, and top categories by revenue. This is where I first noticed the volume vs. AOV pattern; revenue scaling while AOV stays flat tells you a lot about how the business is growing.
Module 3 : Customer Behavior
Repeat purchase rate, revenue concentration by customer decile, and average time between first and second orders. The 3% repeat rate was the most surprising finding in the whole project and ties directly into the cohort analysis below.
Module 4 : Advanced
Cohort retention by first purchase month, late delivery rates broken down by product category, and cancellation rate over time with a 3-month rolling average to smooth out noise. The cohort analysis confirmed what module 3 suggested which is that retention is basically flat across every cohort, which points to a systemic issue rather than a seasonal one.

How to Run It
1. Clone the repo
bashgit clone https://github.com/ivy-mainaa/ecommerce-analytics-sql.git
2. Get the data
Download the Olist dataset from Kaggle and load the CSVs into PostgreSQL using pgAdmin or psql.
3. Create the database
sqlCREATE DATABASE ecommerce_analytics;
4. Run the queries
Each module folder has standalone .sql files. Run them in order or jump to whatever's relevant.

Stack

PostgreSQL 16
pgAdmin
Dataset: Olist Brazilian E-Commerce (~100k orders, 2016–2018)

SQL Concepts Used
Window functions (LAG, ROW_NUMBER, NTILE, FIRST_VALUE), CTEs, cohort analysis, multi-table JOINs, date functions, conditional aggregation with FILTER, rolling averages 