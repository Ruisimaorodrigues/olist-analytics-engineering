{{ config(materialized='view') }}

with order_items as (
    select * from {{ ref('stg_order_items') }}
),

products as (
    select
        p.product_id,
        p.product_category_name,
        p.product_weight_g,
        p.product_length_cm,
        p.product_height_cm,
        p.product_width_cm,
        t.category_en
    from {{ ref('stg_products') }} p
    left join {{ ref('stg_category_translation') }} t
        on p.product_category_name = t.category_pt
),

sellers as (
    select * from {{ ref('stg_sellers') }}
)

select
    {{ dbt_utils.generate_surrogate_key(['oi.order_id', 'oi.order_item_id']) }} as order_item_key,
    oi.order_id,
    oi.order_item_id,
    oi.product_id,
    oi.seller_id,
    oi.shipping_limit_at,
    oi.price,
    oi.freight_value,
    p.product_category_name,
    p.category_en,
    p.product_weight_g,
    s.seller_city,
    s.seller_state
from order_items oi
left join products p on oi.product_id = p.product_id
left join sellers s on oi.seller_id = s.seller_id