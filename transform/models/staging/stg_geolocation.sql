{{ config(materialized='view') }}

with source as (
    select * from read_csv_auto('C:/Users/ruisi/Downloads/Olist dataset/olist_geolocation_dataset.csv', header=true)
),

renamed as (
    select
        geolocation_zip_code_prefix as zip_code_prefix,
        geolocation_lat as latitude,
        geolocation_lng as longitude,
        geolocation_city as city,
        geolocation_state as state
    from source
)

select * from renamed