{{
    config(
        materialized = "incremental",

    )
}}

--- You cant use gp_toolkit.gp_resgroup_status because of an error
--- Database Error in model resgroup_per_segment (models/gp_monitoring/resgroup_per_segment.sql)
--    Cannot execute the pg_resgroup_get_status function in entrydb, this query is not currently supported by GPDB.  (entry db 10.0.0.6:5432 pid=16413)
--    HINT:  Call the function in subquery wrapped with unnest(array()). For example:
--    insert into tst_json
--    select * from unnest(array(
--        select cpu_usage
--        from pg_resgroup_get_status(NULL::oid)
--    ));
--    compiled Code at target/run/dbt_gp/models/gp_monitoring/resgroup_per_segment.sql
--

with mem as (
    select
         ge.key::int as sgm_id
        , (ge.value->>'used')::int as mem_used_total
        , (ge.value->>'available')::int  as mem_available_total
        , (ge.value->>'quota_used')::int  as mem_used_quota
        , (ge.value->>'quota_available')::int  as mem_available_quota
        , (ge.value->>'shared_used')::int  as mem_used_shared
        , (ge.value->>'shared_available')::int  as mem_availebale_shared
    from unnest(array(
        select memory_usage
        from pg_resgroup_get_status(6437)
    )) u cross join json_each(u) ge
)
select current_timestamp as timest
    , hostname
	, role
	, s.preferred_role
	, mem.*
from mem
	join {{ source('pg_catalog','gp_segment_configuration') }} s on mem.sgm_id = s.content
		and role='p'