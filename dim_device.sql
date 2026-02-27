CREATE OR REPLACE TABLE
`ga4-bigquery-export-485911.analytics_388296684.dim_device` AS

SELECT
  LOWER(TRIM(device_category)) AS device_category
FROM `ga4-bigquery-export-485911.analytics_388296684.fact_sessions_daily`
WHERE device_category IS NOT NULL
GROUP BY device_category;
