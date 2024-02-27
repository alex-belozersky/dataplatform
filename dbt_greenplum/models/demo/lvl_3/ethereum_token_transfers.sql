{{
    config(
        materialized = "table",
        distributed_by = 'block_hash',
    )
}}

select distinct *
from {{ source('raw_eth_data', 'eth_token_transfers') }}