CREATE OR REPLACE TABLE
`ga4-bigquery-export-485911.analytics_388296684.fact_sessions_daily` AS

WITH base_sessions AS (
  SELECT
    user_pseudo_id,
    PARSE_DATE('%Y%m%d', event_date) AS date,

    REGEXP_EXTRACT(
      (SELECT value.string_value
       FROM UNNEST(event_params)
       WHERE key = 'page_location'),
      r'\.com(/[^?]*)'
    ) AS landing_page,

    LOWER(
      COALESCE(
        (SELECT value.string_value FROM UNNEST(event_params) WHERE key = 'source'),
        'direct'
      )
    ) AS source,

    LOWER(
      COALESCE(
        (SELECT value.string_value FROM UNNEST(event_params) WHERE key = 'medium'),
        '(none)'
      )
    ) AS medium,

    LOWER(
      COALESCE(
        (SELECT value.string_value FROM UNNEST(event_params) WHERE key = 'campaign'),
        '(not set)'
      )
    ) AS campaign,

    LOWER(TRIM(device.category)) AS device_category,
    geo.country AS country

  FROM `ga4-bigquery-export-485911.analytics_388296684.events_*`
  WHERE event_name = 'session_start'
),

first_seen AS (
  SELECT
    user_pseudo_id,
    MIN(date) AS first_date
  FROM base_sessions
  WHERE user_pseudo_id IS NOT NULL
  GROUP BY user_pseudo_id
)

SELECT
  s.date,
  s.landing_page,
  s.source,
  s.medium,
  s.campaign,
  s.device_category,
  s.country,
  CONCAT(s.source, '|', s.medium) AS channel_key,

  COUNT(*) AS sessions,

  COUNTIF(
    s.user_pseudo_id IS NOT NULL
    AND f.first_date IS NOT NULL
    AND s.date > f.first_date
  ) AS returning_sessions

FROM base_sessions s
LEFT JOIN first_seen f
  ON s.user_pseudo_id = f.user_pseudo_id

GROUP BY
  s.date, s.landing_page, s.source, s.medium, s.campaign,
  s.device_category, s.country, channel_key;
