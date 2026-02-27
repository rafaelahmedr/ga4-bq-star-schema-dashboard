# Power BI Setup (Star Schema)

## Load tables from BigQuery
Load:
- fact_sessions_daily
- fact_pageviews_daily
- dim_date
- dim_channel
- dim_device
- dim_country
- dim_landing_page

## Relationships (Model view)
Create ONLY these (all Active, Single direction, 1:*):
- dim_date[date] → fact_sessions_daily[date]
- dim_date[date] → fact_pageviews_daily[date]

- dim_channel[channel_key] → fact_sessions_daily[channel_key]
- dim_channel[channel_key] → fact_pageviews_daily[channel_key]

- dim_device[device_category] → fact_sessions_daily[device_category]
- dim_device[device_category] → fact_pageviews_daily[device_category]

- dim_country[country] → fact_sessions_daily[country]
- dim_country[country] → fact_pageviews_daily[country]

- dim_landing_page[landing_page] → fact_sessions_daily[landing_page]
- dim_landing_page[landing_page] → fact_pageviews_daily[landing_page]

Do NOT create relationships on source alone or medium alone.
Do NOT use many-to-many.
Do NOT connect fact-to-fact.

## Slicers
Use ONLY dimension fields:
- dim_date[date] or dim_date[year_month]
- dim_channel[channel_group]
- dim_device[device_category]
- dim_country[country]
- dim_landing_page[landing_page]

## Measures
Create measures from measures.dax (make sure to follow the order)
Then build visuals using measures, not columns.
