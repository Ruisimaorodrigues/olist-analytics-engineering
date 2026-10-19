{{ config(materialized='table') }}

with geolocation as (
    select
        zip_code_prefix,
        city,
        state,
        avg(latitude) as latitude,
        avg(longitude) as longitude
    from {{ ref('stg_geolocation') }}
    group by zip_code_prefix, city, state
)

select
    {{ dbt_utils.generate_surrogate_key(['zip_code_prefix', 'city', 'state']) }} as geolocation_key,
    zip_code_prefix,
    city,
    state,
    latitude,
    longitude
from geolocation