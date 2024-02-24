{{
    config(
        materialized = "table",

    )
}}

select dag_id
    , count(1) as total_runs
    , max(dttm) as max_timest
from {{ ref('airflow_logs') }}
group by dag_id