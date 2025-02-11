{{
    config(
        materialized = 'table'
    )
}}

select *
from {{ source('psql', 'dag_run') }}