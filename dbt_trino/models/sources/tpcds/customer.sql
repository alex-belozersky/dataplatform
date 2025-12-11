{{
    config(
        materialized = 'incremental',
        unique_key='c_customer_sk',
        incremental_strategy='merge',
    )
}}

select *
from {{ source('tpcds', 'customer') }}