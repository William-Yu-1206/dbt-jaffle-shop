{{ config(materialized='table') }}

with date_spine as (
    {{
        dbt_utils.date_spine(
            datepart = 'day',
            start_date = "cast('2017-01-01' as date)",
            end_date = "cast('2019-01-01' as date)"
        )
    }}
),

base as (
  select
    date(date_day) as date_key
  from date_spine
)

select 
  date_key,
  
  -- 年月日
  extract(year from date_key)                   as year,
  extract(quarter from date_key)                as quarter,
  extract(month from date_key)                  as month,
  extract(day from date_key)                    as day,
  format_date('%Y-%m', date_key)                as year_month,
  date_diff(
    date_key, 
    date_trunc(date_key, isoweek), -- isoweek_start_date
    day
  ) + 1 as day_of_week,
  format_date('%A', date_key)                   as day_name,
  extract(dayofweek from date_key) in (1, 7)    as is_weekend,

  -- iso
  extract(isoyear from date_key)                as iso_year,
  extract(isoweek from date_key)                as iso_week,
  format_date('%G-W%V', date_key)               as iso_year_week,

  -- start_date
  date_trunc(date_key, year)                    as year_start_date,
  date_trunc(date_key, quarter)                 as quarter_start_date,
  date_trunc(date_key, month)                   as month_start_date,
  date_trunc(date_key, isoweek)                 as isoweek_start_date,

  -- 台灣在地化
  extract(year from date_key) - 1911            as roc_year

from base