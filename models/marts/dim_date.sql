{{ config(materialized='table') }}

with date_spine as (
    {{
        dbt_utils.date_spine(
            datepart = 'day',
            start_date = "cast('2018-01-01' as date)",
            end_date = "cast('2019-01-01' as date)"
        )
    }}
)

select
    date_day                            as date_key,
    extract(year        from date_day)  as year,
    extract(quarter     from date_day)  as quarter,
    extract(month       from date_day)  as month,
    extract(day         from date_day)  as day,
    extract(dayofweek   from date_day)  as day_of_week,
    format_date('%Y-%m', date_day)           as year_month,
    format_date('%A', date_day)              as day_name,
    extract(dayofweek   from date_day) in (1, 7)    as is_weekend,
    date_trunc(date_day, year)                      as year_start_date,
    date_trunc(date_day, quarter)                   as quarter_start_date,
    date_trunc(date_day, month)                     as month_start_date,
    extract(year from date_day) - 1911              as roc_year             
from date_spine