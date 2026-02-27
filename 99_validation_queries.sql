-- A) Sessions fact must match raw session_start count
SELECT
  (SELECT SUM(sessions)
   FROM `ga4-bigquery-export-485911.analytics_388296684.fact_sessions_daily`) AS fact_sessions,
  (SELECT COUNT(*)
   FROM `ga4-bigquery-export-485911.analytics_388296684.events_*`
   WHERE event_name = 'session_start') AS raw_session_start;

-- B) Pageviews fact must match raw page_view count
SELECT
  (SELECT SUM(page_views)
   FROM `ga4-bigquery-export-485911.analytics_388296684.fact_pageviews_daily`) AS fact_page_views,
  (SELECT COUNT(*)
   FROM `ga4-bigquery-export-485911.analytics_388296684.events_*`
   WHERE event_name = 'page_view') AS raw_page_view;

-- C) Channel dim uniqueness check (must return 0 rows)
SELECT
  channel_key,
  COUNT(*) AS c
FROM `ga4-bigquery-export-485911.analytics_388296684.dim_channel`
GROUP BY channel_key
HAVING COUNT(*) > 1;

-- D) Medium = (none) inspection (sessions)
SELECT
  source,
  SUM(sessions) AS sessions
FROM `ga4-bigquery-export-485911.analytics_388296684.fact_sessions_daily`
WHERE medium = '(none)'
GROUP BY source
ORDER BY sessions DESC;

-- E) KPI check (totals)
SELECT
  (SELECT SUM(sessions)
   FROM `ga4-bigquery-export-485911.analytics_388296684.fact_sessions_daily`) AS total_sessions,
  (SELECT SUM(returning_sessions)
   FROM `ga4-bigquery-export-485911.analytics_388296684.fact_sessions_daily`) AS returning_sessions,
  SAFE_DIVIDE(
    (SELECT SUM(returning_sessions)
     FROM `ga4-bigquery-export-485911.analytics_388296684.fact_sessions_daily`),
    (SELECT SUM(sessions)
     FROM `ga4-bigquery-export-485911.analytics_388296684.fact_sessions_daily`)
  ) AS returning_pct,
  (SELECT SUM(page_views)
   FROM `ga4-bigquery-export-485911.analytics_388296684.fact_pageviews_daily`) AS total_page_views,
  SAFE_DIVIDE(
    (SELECT SUM(page_views)
     FROM `ga4-bigquery-export-485911.analytics_388296684.fact_pageviews_daily`),
    (SELECT SUM(sessions)
     FROM `ga4-bigquery-export-485911.analytics_388296684.fact_sessions_daily`)
  ) AS views_per_session;
