{{ config(materialized='table') }}

with orders as (
    select * from {{ ref('int_orders_enriched') }}
)

select
    order_key,
    order_id,
    customer_id,
    order_status,
    ordered_at,
    delivered_at,
    estimated_delivery_at,
    customer_city,
    customer_state,
    total_items,
    total_items_value,
    total_freight_value,
    total_payment_value,
    delivery_days,
    delivered_on_time
from orders