# Data Validation & Model Integrity Checks

This document validates that the GA4 → BigQuery → Power BI model produces accurate and non-inflated results.

---

# 1. Root Problem Identified

During development, page views appeared significantly higher than expected.

Sessions matched GA4 and Funnel totals, but:
- Page Views were inflated
- Views per Session was incorrect

## Root Cause

A grain mismatch:

- Session-level data (1 row per session_start)
- Aggregated page_view data
- Joined together on partial keys

This caused page views to be counted multiple times.

---

# 2. Correct Modeling Approach

The solution was to:

- Separate session data and page view data
- Create two independent fact tables:
  - fact_sessions_daily
  - fact_pageviews_daily
- Use shared dimensions for filtering

This avoids cross-grain duplication.

---

# 3. Session Validation

## Validate fact_sessions_daily matches raw GA4 export

```sql
SELECT
  (SELECT SUM(sessions)
   FROM fact_sessions_daily) AS fact_sessions,

  (SELECT COUNT(*)
   FROM events_*
   WHERE event_name = 'session_start') AS raw_session_start;
