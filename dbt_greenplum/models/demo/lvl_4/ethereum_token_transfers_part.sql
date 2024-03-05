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
    token_address text NULL,
	from_address text NULL,
	to_address text NULL,
	value text NULL,
	transaction_hash text NULL,
	log_index int8 NULL,
	block_timestamp timestamp NULL,
	block_number int8 NULL,
	block_hash text NULL,
	filename_key text NULL
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
from {{ source('raw_eth_data', 'eth_token_transfers') }}
where 1=1
{% if is_incremental() %}
    and filename_key not in ( select distinct filename_key from {{ this }} )
{% endif %}
    -- dont take the last one
    and filename_key not in ( select max(filename_key)
                                from {{ source('raw_eth_data', 'eth_token_transfers') }}
                                )