CREATE OR REPLACE TABLE
`ga4-bigquery-export-485911.analytics_388296684.dim_country` AS

SELECT
  country
FROM `ga4-bigquery-export-485911.analytics_388296684.fact_sessions_daily`
WHERE country IS NOT NULL
GROUP BY country;
