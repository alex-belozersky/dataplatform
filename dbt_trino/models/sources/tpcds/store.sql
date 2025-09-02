{{
    config(
        materialized = 'table'
    )
}}

select *
from {{ source('tpcds', 'store') }}