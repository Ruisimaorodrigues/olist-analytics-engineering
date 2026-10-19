{{ config(materialized='table') }}

with reviews as (
    select * from {{ ref('stg_reviews') }}
)

select
    {{ dbt_utils.generate_surrogate_key(['review_id', 'order_id']) }} as review_record_key,
    review_id,
    order_id,
    review_score,
    review_comment_title,
    review_comment_message,
    review_creation_at,
    review_answer_at
from reviews