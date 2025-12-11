
{{
    config(
        materialized = 'table',
    )
}}

SELECT "c_customer_id"
FROM
  customer_total_return ctr1
, {{ source('tpcds', 'store') }} --store
, {{ source('tpcds', 'customer') }} --customer
WHERE ("ctr1"."ctr_total_return" > (
      SELECT ("avg"("ctr_total_return") * DECIMAL '1.2')
      FROM
        {{ ref('tpcds_q1_customer_total_return') }}  ctr2
      WHERE ("ctr1"."ctr_store_sk" = "ctr2"."ctr_store_sk")
   ))
   AND ("s_store_sk" = "ctr1"."ctr_store_sk")
   AND ("s_state" = 'TN')
   AND ("ctr1"."ctr_customer_sk" = "c_customer_sk")
ORDER BY "c_customer_id" ASC
LIMIT 100