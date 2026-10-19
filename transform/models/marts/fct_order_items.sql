{{ config(materialized='table') }}

with order_items as (
    select * from {{ ref('int_orders_items_enriched') }}
)

select
    order_item_key,
    order_id,
    order_item_id,
    product_id,
    seller_id,
    shipping_limit_at,
    price,
    freight_value,
    product_category_name,
    category_en,
    product_weight_g,
    seller_city,
    seller_state
from order_items