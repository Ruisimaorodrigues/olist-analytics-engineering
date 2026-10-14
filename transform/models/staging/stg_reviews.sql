{{ config(materialized='view') }}

with source as (
    select * from read_csv_auto('C:/Users/ruisi/Downloads/Olist dataset/olist_order_reviews_dataset.csv', header=true)
),

renamed as (
    select
        review_id,
        order_id,
        review_score,
        review_comment_title,
        review_comment_message,
        review_creation_date::timestamp as review_creation_at,
        review_answer_timestamp::timestamp as review_answer_at
    from source
)

select * from renamed