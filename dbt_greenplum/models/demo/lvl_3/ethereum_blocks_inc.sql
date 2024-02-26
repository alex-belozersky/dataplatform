{{
    config(
        materialized = "incremental",
        distributed_by = 'hash',
    )
}}

select *
from {{ source('raw_eth_data', 'eth_blocks') }}
where 1=1

{% if is_incremental() %}
    and filename_key not in ( select distinct filename_key from {{ this }} )
{% endif %}