with orders as (
    select * from {{ ref('stg_orders') }}
),

payments as (
    select * from {{ ref('stg_payments') }}
),

payments_by_orders as (
  select 
    order_id,
    sum(amount) as amount
  from payments
  group by 1
)

select 
  o.order_id,
  o.customer_id,
  o.order_date,
  o.order_status,
  coalesce(p.amount, 0) as amount
from orders o
left join payments_by_orders p
  on o.order_id = p.order_id
