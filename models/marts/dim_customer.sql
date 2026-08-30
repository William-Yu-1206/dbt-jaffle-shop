with customers as (
    select * from {{ ref('stg_customers') }}
),

orders as (
    select * from {{ ref('stg_orders') }}
),

payments as (
    select * from {{ ref('stg_payments') }}
),

payments_by_orders as (
    select
        order_id,
        sum(amount) as total_amount
    from payments
    group by 1
),

customer_orders as (
    select
    o.customer_id,
    count(*) as total_orders,
    min(o.order_date) as first_order_date,
    max(o.order_date) as most_recent_order_date,
    sum(p.total_amount) as total_amount
    from orders o
    left join payments_by_orders p
    on o.order_id = p.order_id
    group by 1
)


select
    {{ dbt_utils.generate_surrogate_key(['c.customer_id']) }} as customer_key,
    c.customer_id,
    c.first_name,
    c.last_name,
    coalesce(o.total_orders, 0) as total_orders,
    coalesce(o.total_amount, 0) as LTV,
    o.first_order_date,
    o.most_recent_order_date
from customers c
left join customer_orders o
  on c.customer_id = o.customer_id