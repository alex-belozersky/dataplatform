{{
    config(
        materialized = "table",
        distributed_by = 'hash',
    )
}}

select distinct *
from {{ source('raw_eth_data', 'eth_blocks') }}