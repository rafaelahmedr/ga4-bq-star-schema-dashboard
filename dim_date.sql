CREATE OR REPLACE TABLE
`ga4-bigquery-export-485911.analytics_388296684.dim_date` AS

SELECT DISTINCT
  date,
  EXTRACT(YEAR FROM date) AS year,
  EXTRACT(MONTH FROM date) AS month_number,
  FORMAT_DATE('%B', date) AS month_name,
  FORMAT_DATE('%Y-%m', date) AS year_month,
  EXTRACT(WEEK FROM date) AS week_number,
  EXTRACT(QUARTER FROM date) AS quarter
FROM `ga4-bigquery-export-485911.analytics_388296684.fact_sessions_daily`;
