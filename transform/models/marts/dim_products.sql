{{ config(materialized='table') }}

with products as (
    select * from {{ ref('stg_products') }}
),

translations as (
    select * from {{ ref('stg_category_translation') }}
)

select
    {{ dbt_utils.generate_surrogate_key(['product_id']) }} as product_key,
    p.product_id,
    p.product_category_name as category_pt,
    coalesce(t.category_en, p.product_category_name) as category_en,
    p.product_weight_g,
    p.product_length_cm,
    p.product_height_cm,
    p.product_width_cm
from products p
left join translations t on p.product_category_name = t.category_pt