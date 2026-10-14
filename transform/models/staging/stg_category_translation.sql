{{ config(materialized='view') }}

with source as (
    select * from read_csv_auto('C:/Users/ruisi/Downloads/Olist dataset/product_category_name_translation.csv', header=true)
),

renamed as (
    select
        product_category_name as category_pt,
        product_category_name_english as category_en
    from source
)

select * from renamed