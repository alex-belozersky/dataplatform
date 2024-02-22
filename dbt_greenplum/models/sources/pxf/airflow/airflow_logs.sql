{{
    config(
        materialized = "table",
    )
}}

select
    id,
	dttm,
	dag_id,
	task_id,
	map_index,
	"event",
	execution_date,
	"owner",
	extra
from {{ source('pxf_airflow', 'log') }}