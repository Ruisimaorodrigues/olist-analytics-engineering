-- Falha se a diferença de revenue entre fct_orders e stg_payments for > 0.01
with fct_revenue as (
    select round(sum(total_payment_value), 2) as total
    from {{ ref('fct_orders') }}
),

staging_revenue as (
    select round(sum(p.payment_value), 2) as total
    from {{ ref('stg_payments') }} p
    join {{ ref('stg_orders') }} o on p.order_id = o.order_id
    where o.order_status = 'delivered'
)

select 1
from fct_revenue f
cross join staging_revenue s
where abs(f.total - s.total) > 0.01