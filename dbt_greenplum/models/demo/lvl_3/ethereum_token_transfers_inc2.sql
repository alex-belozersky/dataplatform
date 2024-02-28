{{
    config(
        materialized = "incremental",
        distributed_by = 'block_hash',
        pre_hook="set statement_mem='2040000 kB' ",
        post_hook=["ANALYSE {{this}}"
            , "GRANT SELECT on {{this}} to student"],
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