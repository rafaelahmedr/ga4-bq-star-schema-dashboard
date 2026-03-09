CREATE OR REPLACE VIEW
`ga4-bigquery-export-485911.analytics_388296684.dim_domain` AS

SELECT DISTINCT
  host,

  CASE
    WHEN STARTS_WITH(host, 'www.cotes') THEN 'Main Domain'
    ELSE 'Sub-Domain'
  END AS domain_type

FROM `ga4-bigquery-export-485911.analytics_388296684.fact_sessions_daily`
WHERE host IS NOT NULL;
