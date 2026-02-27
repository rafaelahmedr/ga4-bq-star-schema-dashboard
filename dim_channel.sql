CREATE OR REPLACE TABLE
`ga4-bigquery-export-485911.analytics_388296684.dim_channel` AS

SELECT
  source,
  medium,
  CONCAT(source, '|', medium) AS channel_key,

  CASE
    WHEN REGEXP_CONTAINS(source, r'(chatgpt|openai|claude|gemini|bard|perplexity)')
      THEN 'AI Platforms'

    WHEN medium IN ('cpc','ppc','paid_search') THEN 'Paid Search'
    WHEN medium = 'organic' THEN 'Organic Search'
    WHEN medium = 'paid_social' THEN 'Paid Social'
    WHEN medium IN ('social','social-network') THEN 'Organic Social'
    WHEN medium IN ('email','hs_email') THEN 'Email'
    WHEN medium = 'referral' THEN 'Referral'
    WHEN source = 'direct' OR medium = '(none)' THEN 'Direct'
    ELSE 'Other'
  END AS channel_group

FROM (
  SELECT DISTINCT
    LOWER(TRIM(COALESCE(source, 'direct'))) AS source,
    LOWER(TRIM(COALESCE(medium, '(none)'))) AS medium
  FROM `ga4-bigquery-export-485911.analytics_388296684.fact_sessions_daily`
);
