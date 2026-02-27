CREATE OR REPLACE TABLE
`ga4-bigquery-export-485911.analytics_388296684.dim_landing_page` AS

SELECT
  landing_page
FROM `ga4-bigquery-export-485911.analytics_388296684.fact_sessions_daily`
WHERE landing_page IS NOT NULL
GROUP BY landing_page;
