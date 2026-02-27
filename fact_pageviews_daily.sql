CREATE OR REPLACE TABLE
`ga4-bigquery-export-485911.analytics_388296684.fact_pageviews_daily` AS

SELECT
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
  geo.country AS country,

  CONCAT(
    LOWER(COALESCE((SELECT value.string_value FROM UNNEST(event_params) WHERE key = 'source'), 'direct')),
    '|',
    LOWER(COALESCE((SELECT value.string_value FROM UNNEST(event_params) WHERE key = 'medium'), '(none)'))
  ) AS channel_key,

  COUNT(*) AS page_views

FROM `ga4-bigquery-export-485911.analytics_388296684.events_*`
WHERE event_name = 'page_view'

GROUP BY
  date, landing_page, source, medium, campaign, device_category, country, channel_key;
