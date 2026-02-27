# GA4 → BigQuery → Power BI Traffic Model (Star Schema)

This project models Google Analytics 4 export data in BigQuery and builds a slicer-friendly Power BI report using a star schema.

## Why this exists
While building a GA4 reporting view, page views looked unusually high even though sessions matched expected totals.  
Root cause: a grain mismatch (joining aggregated events to session-level rows) caused page views to be counted multiple times.

This repo shows the corrected approach:
- Separate fact tables (sessions, page views)
- Shared dimension tables (date, channel, device, country, landing page)
- Validation queries to ensure numbers match raw GA4 events

## Architecture
- `fact_sessions_daily`: sessions + returning sessions at daily grain
- `fact_pageviews_daily`: page views at daily grain
- Dimensions: date, channel, device, country, landing page

## How to run
1. Run SQL scripts in `/sql` in order (first facts, then dimensions)
2. Run `/sql/99_validation_queries.sql` and confirm totals match
3. Import tables into Power BI and follow `/powerbi/README_powerbi_setup.md`

## Key Lessons
- Sessions and page views are different grains and should not be mixed incorrectly
- Always aggregate before joining (MUST)
- Use a composite key for channel dimensions (source|medium) to avoid many-to-many relationship

## Screenshots
See `/docs` for the model diagram and dashboard examples.
