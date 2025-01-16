{{
    config(
        materialized = "incremental",

    )
}}

select current_timestamp as timest
    , *
from {{ source('gp_toolkit', 'gp_workfile_usage_per_segment') }}
