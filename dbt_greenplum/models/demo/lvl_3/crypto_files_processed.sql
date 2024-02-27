{{
    config(
        materialized = "table",
        distributed_replicated=true,
    )
}}

select 'ethereum' as chain
    , 'blocks' as dataset, filename_key
    , count(1) as rws
from {{ ref('ethereum_blocks_inc') }} b
group by chain, dataset, filename_key

union all
select 'ethereum' as chain
    , 'token_transfers' as dataset, filename_key
    , count(1) as rws
from {{ ref('ethereum_token_transfers_inc2') }} b
group by chain, dataset, filename_key