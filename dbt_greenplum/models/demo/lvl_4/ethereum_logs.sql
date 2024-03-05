{% set raw_partition %}
   PARTITION BY RANGE (block_timestamp)
   (
       START ('2015-06-01'::timestamp) INCLUSIVE
       END ('2026-01-01'::timestamp) EXCLUSIVE
       EVERY (INTERVAL '1 month'),
       DEFAULT PARTITION default_part
   );
{% endset %}

{% set fields_string %}
	log_index int8 NULL,
	transaction_hash text NULL,
	transaction_index int8 NULL,
	address text NULL,
	"data" text NULL,
	topics text NULL,
	block_timestamp timestamp NULL,
	block_number int8 NULL,
	block_hash text null,
	filename_key text null
{% endset %}

{{
    config(
        materialized = "incremental",
        distributed_by = 'block_hash',
        pre_hook="set statement_mem='2040000 kB' ",
        post_hook=["ANALYSE {{this}}"
            , "GRANT SELECT on {{this}} to student"
            ],
        fields_string=fields_string,
        raw_partition=raw_partition,
    )
}}



select *
from {{ source('raw_eth_data', 'eth_logs') }}
where 1=1
{% if is_incremental() %}
    and filename_key not in ( select distinct filename_key from {{ this }} )
{% endif %}
    -- dont take the last one
    and filename_key not in ( select max(filename_key)
                                from {{ source('raw_eth_data', 'eth_logs') }}
                                )