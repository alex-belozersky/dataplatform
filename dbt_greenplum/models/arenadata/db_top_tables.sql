{{
    config(
        materialized = "table",
    )
}}

select
	coalesce(table_parent_table, table_name) as tbl
	, coalesce(table_parent_schema , table_schema) as scm
	, pg_size_pretty(sum(file_size)) as sz
from {{source('arenadata_toolkit', 'db_files_current')}} --arenadata_toolkit.db_files_current dfc
group by tbl, scm
order by sum(file_size) desc
limit 100