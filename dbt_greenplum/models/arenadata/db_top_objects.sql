{{
    config(
        materialized = "table",
        distributed_by = 'obj_name',
    )
}}

--- Место занимаемое объектами в БД
--- Различная служебная информация (pg_catalog, AO Visimaps) с множеством мелких служебных объектах схлопнуты как отдельные строки
--- Партиционированные таблицы схлопнуты до родительских
--- Гранулярность: Hostname, obj (родительская таблица со схемой)

select hostname, obj_type, obj_name
	, sum(file_size) as sz
	, pg_size_pretty(sum(file_size))  as szp
from (
	select t.*
		, case when obj_type in ('User Index', 'User Table') then 'User'
			else 'System' end as obj_owner
		, case when obj_type in ('User Index', 'User Table') then "schema"||'.'||"table"
			else obj_type end as obj_name
	from (
		select
			oid,
			coalesce(table_parent_schema, table_schema) as "schema",
			coalesce(table_parent_table, table_name) as "table",
			"type",
			storage,
			table_database,
			hostname,
			content as segment_id,
			case when table_schema='pg_aoseg' then 'AO visimap Table'
				when table_schema='pg_toast' then 'TOAST'
				when table_schema='pg_catalog' then 'Catalog'
				when type='i' then 'User Index'
				when type='r' then 'User Table'
				when type='S' then 'User Sequence'
				when oid is null then 'Orphanned file'
				end as obj_type,
			file_size
		from {{source('arenadata_toolkit', 'db_files_current')}} --arenadata_toolkit.db_files_current dfc
	) t
) tt
group by hostname, obj_type, obj_name
order by hostname, sz desc