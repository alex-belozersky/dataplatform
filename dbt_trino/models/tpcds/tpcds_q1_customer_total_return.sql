{{
    config(
        materialized = 'table',
    )
}}
   SELECT
     "sr_customer_sk" "ctr_customer_sk"
   , "sr_store_sk" "ctr_store_sk"
   , "sum"("sr_return_amt") "ctr_total_return"
   FROM
     {{ source('tpcds', 'store_returns') }} -- store_returns
   , {{ source('tpcds', 'date_dim') }} -- date_dim
   WHERE ("sr_returned_date_sk" = "d_date_sk")
      AND ("d_year" = 2000)
   GROUP BY "sr_customer_sk", "sr_store_sk"
