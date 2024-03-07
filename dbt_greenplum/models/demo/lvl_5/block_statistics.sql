{{
    config(
        materialized = "table",
        distributed_replicated = true,
    )
}}

with tt as (
    select block_hash, block_number
        , count(1) as cnt_token_transfers
        , count(distinct token_address) as dist_tokens
    from {{ ref('ethereum_token_transfers_part') }} tt
    group by block_hash, block_number
), tr as (
    select block_hash, block_number
        , count(1) as cnt_transactins
    from {{ ref('ethereum_transactions') }}
    group by block_hash, block_number
)
select bl."hash", bl.number as block_number
    , cnt_token_transfers
    , dist_tokens
    , cnt_transactins
from {{ ref('ethereum_blocks_inc') }} bl
    left join tt on bl."hash" = tt.block_hash
    left join tr on bl."hash" = tr.block_hash