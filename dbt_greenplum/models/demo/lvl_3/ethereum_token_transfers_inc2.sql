{{
    config(
        materialized = "incremental",
        distributed_by = 'block_hash',

    )
}}


select *
from {{ source('raw_eth_data', 'eth_token_transfers') }}
where 1=1
{% if is_incremental() %}
    and filename_key not in ( select distinct filename_key from {{ this }} )
{% endif %}
    -- dont take the last one
    and filename_key not in ( select max(filename_key)
                                from {{ source('raw_eth_data', 'eth_token_transfers') }}
                                )