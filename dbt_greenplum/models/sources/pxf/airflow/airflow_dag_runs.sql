{{
    config(
        materialized = "table",
    )
}}

select *
from {{ source('pxf_airflow', 'dag_run') }}